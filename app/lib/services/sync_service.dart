import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import 'logger.dart';
import 'connection_service.dart';
import '../utils/automatic_error_reporter.dart';

import 'sync/conflict_resolver.dart';
import 'sync_service_v2.dart';

/// DEPRECATED: Use [SyncServiceV2] instead.
///
/// This is the old sync service that has race conditions and data loss issues.
/// It is kept temporarily for backward compatibility during migration.
/// All providers have been updated to use SyncServiceV2.
@Deprecated('Use SyncServiceV2 instead')
class SyncService {
  static final SyncService _instance = SyncService._internal();
  static SyncService get instance => _instance;

  static const String _tableName = 'user_sync_data';
  static const String _queueKey = 'sync_service_queue';

  SupabaseClient? _client;
  late final ConnectionService _connectionService;

  String? _currentUserId;
  RealtimeChannel? _channel;
  final Map<String, Function(Map<String, dynamic>)> _listeners = {};
  bool _isListening = false;
  bool _isInitialized = false;

  // Concurrency protection
  final Map<String, bool> _syncInProgress =
      {}; // Track ongoing sync operations per key
  final Map<String, bool> _realtimeUpdateInProgress =
      {}; // Track real-time updates per key

  // Offline queue
  final Map<String, Map<String, dynamic>> _pendingSyncs = {};
  Timer? _queueProcessingTimer;

  // Error handling callbacks - now supports multiple listeners
  final Map<String, Function(String, String)> _errorCallbacks = {};
  final Map<String, Function(String)> _successCallbacks = {};

  // Profile creation concurrency protection
  final Map<String, bool> _profileCreationInProgress = {};

  /// Public getter for connection status
  bool get isConnected => _connectionService.isConnected;

  factory SyncService() {
    return _instance;
  }

  SyncService._internal() {
    _connectionService = ConnectionService();
  }

  /// Initializes the service
  Future<void> initialize() async {
    if (_isInitialized) return;

    _client = SupabaseConfig.maybeClient;

    await _connectionService.initialize();
    if (_client == null) {
      await _loadQueue();
      _isInitialized = true;
      AppLogger.warning(
          'SyncService initialized in local-only mode: Supabase unavailable');
      return;
    }

    _setupAuthListener();
    _setupConnectionListener();
    await _loadQueue();
    _isInitialized = true;
    AppLogger.info('SyncService initialized (Singleton)');
  }

  /// Registers callbacks for a specific data type
  void registerCallbacks(
    String dataType, {
    Function(String, String)? onSyncError,
    Function(String)? onSyncSuccess,
  }) {
    if (onSyncError != null) {
      _errorCallbacks[dataType] = onSyncError;
    }
    if (onSyncSuccess != null) {
      _successCallbacks[dataType] = onSyncSuccess;
    }
  }

  /// Called when app resumes
  Future<void> syncOnAppResume() async {
    AppLogger.info('App resumed - triggering sync check');
    if (_currentUserId != null && _connectionService.isConnected) {
      await fetchAllData();
      _processQueue();
    }
  }

  /// Called when app pauses
  Future<void> syncOnAppPause() async {
    AppLogger.info('App paused - ensuring queue is saved');
    await _saveQueue();
  }

  /// Syncs data to the server.
  /// If online, attempts immediate sync.
  /// If offline or fails, adds to queue for later retry.
  Future<void> syncData(String key, Map<String, dynamic> data) async {
    // Always add to pending queue first to ensure we have the latest version
    _pendingSyncs[key] = data;
    await _saveQueue();

    if (_connectionService.isConnected && _currentUserId != null) {
      // Try to sync immediately
      _processQueue();
    } else {
      AppLogger.info('Offline or not logged in, added $key to sync queue');
    }
  }

  /// Syncs data to the server immediately (Legacy method, use syncData instead)
  Future<void> syncDataImmediate(String key, Map<String, dynamic> data) async {
    await syncData(key, data);
  }

  /// Sets up auth state listener to handle user login/logout
  void _setupAuthListener() {
    final client = _client;
    if (client == null) return;

    client.auth.onAuthStateChange.listen((event) {
      final user = event.session?.user;
      if (user != null) {
        _currentUserId = user.id;
        _startListening();
        AppLogger.info('User logged in, starting sync for user: ${user.id}');
        // Process any pending items in the queue
        _processQueue();
      } else {
        // User logged out - perform complete session cleanup
        _performSessionCleanup();
        AppLogger.info('User logged out, complete session cleanup performed');
      }
    });
  }

  /// Sets up connection listener to retry syncs when online
  void _setupConnectionListener() {
    _connectionService.setConnectionStatusCallback((isConnected, type) {
      if (isConnected) {
        AppLogger.info('Connection restored, processing sync queue...');
        _processQueue();
      }
    });
  }

  /// Performs complete cleanup of user session data
  void _performSessionCleanup() {
    // Stop all sync operations
    _currentUserId = null;
    _stopListening();

    // Reset sync state
    _syncInProgress.clear();
    _realtimeUpdateInProgress.clear();

    // Clear profile creation in-progress flags
    _profileCreationInProgress.clear();

    // Clear all listeners to prevent cross-user contamination
    _listeners.clear();
    _isListening = false;

    // Clear pending syncs as they belong to the previous user
    _pendingSyncs.clear();
    _saveQueue(); // Persist empty queue

    AppLogger.info(
        'Complete session cleanup performed - all user data cleared');
  }

  /// Loads the pending sync queue from persistent storage
  Future<void> _loadQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getString(_queueKey);
      if (queueJson != null) {
        final decoded = json.decode(queueJson) as Map<String, dynamic>;
        _pendingSyncs.clear();
        decoded.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            _pendingSyncs[key] = value;
          }
        });
        AppLogger.info(
            'Loaded ${_pendingSyncs.length} pending syncs from storage');
      }
    } catch (e) {
      AppLogger.error('Failed to load sync queue', e);
    }
  }

  /// Saves the pending sync queue to persistent storage
  Future<void> _saveQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_pendingSyncs.isEmpty) {
        await prefs.remove(_queueKey);
      } else {
        await prefs.setString(_queueKey, json.encode(_pendingSyncs));
      }
    } catch (e) {
      AppLogger.error('Failed to save sync queue', e);
    }
  }

  /// Processes the pending sync queue
  Future<void> _processQueue() async {
    if (_pendingSyncs.isEmpty) return;
    if (_currentUserId == null || !_connectionService.isConnected) return;

    // Create a copy of keys to iterate safely
    final keysToSync = List<String>.from(_pendingSyncs.keys);

    for (final key in keysToSync) {
      final data = _pendingSyncs[key];
      if (data != null) {
        await _performSync(key, data);
      }
    }
  }

  /// Performs the actual sync operation with retry logic and error handling
  Future<void> _performSync(String key, Map<String, dynamic> data) async {
    final client = _client;
    if (client == null) {
      AppLogger.warning('Cannot sync data: Supabase unavailable');
      return;
    }

    if (_currentUserId == null) {
      AppLogger.warning('Cannot sync data: no user logged in');
      return;
    }

    // Check network connectivity first
    if (!_connectionService.isConnected) {
      AppLogger.warning('Cannot sync data: no network connection');
      if (_errorCallbacks.containsKey(key)) {
        _errorCallbacks[key]!(key, 'No network connection');
      }
      return;
    }

    // Concurrency protection: prevent multiple syncs for the same key
    if (_syncInProgress[key] == true) {
      AppLogger.debug('Sync already in progress for key: $key, skipping');
      return;
    }

    // Wait for any ongoing real-time updates for this key
    while (_realtimeUpdateInProgress[key] == true) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    _syncInProgress[key] = true;

    try {
      // Validate data integrity
      if (!_isValidSyncedData(key, data)) {
        AppLogger.error('Invalid $key data, skipping sync');
        if (_errorCallbacks.containsKey(key)) {
          _errorCallbacks[key]!(key, 'Invalid $key data');
        }
        await AutomaticErrorReporter.reportStorageError(
          message: 'Invalid sync data for key: $key',
          additionalInfo: {
            'key': key,
            'dataKeys': data.keys.toList(),
            'userId': _currentUserId,
          },
        );
        // Remove from queue as it's invalid
        _pendingSyncs.remove(key);
        await _saveQueue();
        return;
      }

      AppLogger.info(
          'Starting sync for key: $key, user: $_currentUserId, data keys: ${data.keys.toList()}');

      // Get current user data or create new record
      final userDataResponse = await client
          .from(_tableName)
          .select('data')
          .eq('user_id', _currentUserId!)
          .maybeSingle();

      final currentData = Map<String, dynamic>.from(
          userDataResponse?['data'] as Map<String, dynamic>? ?? {});

      // Always merge with existing data using ConflictResolver
      final existingEntry = currentData[key] as Map<String, dynamic>?;
      final now = DateTime.now();

      if (existingEntry != null) {
        final existingValue = existingEntry['value'] as Map<String, dynamic>;

        // Always merge using conflict resolver - it handles smart merging
        final resolver = ConflictResolverFactory.getResolver(key);
        final mergedData = resolver.resolve(existingValue, data);

        currentData[key] = {
          'value': mergedData,
          'timestamp': now.toIso8601String(),
        };
        AppLogger.info('Merged $key data with existing data');
      } else {
        // No existing data, just set it
        currentData[key] = {
          'value': data,
          'timestamp': now.toIso8601String(),
        };
        AppLogger.info('Set new data for key $key');
      }

      // Upsert the user data
      await client.from(_tableName).upsert({
        'user_id': _currentUserId,
        'data': currentData,
        'updated_at': now.toIso8601String(),
      });

      AppLogger.info(
          'Successfully synced data for key: $key for user: $_currentUserId');
      if (_successCallbacks.containsKey(key)) {
        _successCallbacks[key]!(key);
      }

      // Remove from pending queue on success
      _pendingSyncs.remove(key);
      await _saveQueue();
    } catch (e) {
      final isNetworkError = e.toString().toLowerCase().contains('network') ||
          e.toString().toLowerCase().contains('connection') ||
          e.toString().toLowerCase().contains('timeout');
      final isAuthError = e.toString().contains('JWT') ||
          e.toString().toLowerCase().contains('unauthorized') ||
          e.toString().toLowerCase().contains('expired');

      AppLogger.error('Failed to sync data for key: $key', e);

      if (isAuthError) {
        AppLogger.warning(
            'Auth error detected during sync, attempting to refresh session...');
        try {
          await client.auth.refreshSession();
          // Retry once after refresh
          AppLogger.info('Session refreshed, retrying sync for key: $key');
          // Don't call syncDataImmediate here to avoid infinite recursion,
          // just let the next queue process handle it or retry logic
          _syncInProgress[key] = false; // Reset flag before retry
          await _performSync(key, data);
          return;
        } catch (refreshError) {
          AppLogger.error('Failed to refresh session', refreshError);
        }
      }

      if (_errorCallbacks.containsKey(key)) {
        _errorCallbacks[key]!(key, 'Sync failed: ${e.toString()}');
      }

      // Report error with appropriate categorization
      if (isNetworkError) {
        await AutomaticErrorReporter.reportNetworkError(
          message: 'Sync network failure for key: $key',
          url: _tableName,
          statusCode: 0,
          additionalInfo: {
            'key': key,
            'error': e.toString(),
          },
        );
      } else {
        await AutomaticErrorReporter.reportStorageError(
          message: 'Sync failure for key: $key',
          additionalInfo: {
            'key': key,
            'error': e.toString(),
          },
        );
      }
    } finally {
      // Reset concurrency flag
      _syncInProgress[key] = false;
    }
  }

  /// Adds a listener for data changes
  void addListener(String key, Function(Map<String, dynamic>) callback) {
    _listeners[key] = callback;
  }

  /// Removes a listener
  void removeListener(String key) {
    _listeners.remove(key);
  }

  /// Starts listening for real-time updates for the current user
  void _startListening() {
    final client = _client;
    if (client == null) return;
    if (_currentUserId == null) return;
    if (_isListening) {
      AppLogger.debug('Already listening for real-time updates, skipping');
      return;
    }

    // Unsubscribe from any existing channel
    _stopListening();

    AppLogger.info(
        'Starting real-time sync listening for user: $_currentUserId');
    _isListening = true;

    _channel = client
        .channel('user_sync_$_currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: _tableName,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: _currentUserId,
          ),
          callback: (payload) {
            AppLogger.info(
                'Received real-time sync update for user: $_currentUserId');
            final newRecord = payload.newRecord as Map<String, dynamic>? ?? {};
            final newData = newRecord['data'] as Map<String, dynamic>? ?? {};
            AppLogger.debug(
                'Real-time update data keys: ${newData.keys.toList()}');
            _notifyListeners(newData);
          },
        )
        .subscribe((status, error) async {
      if (status == RealtimeSubscribeStatus.subscribed) {
        AppLogger.info(
            'Real-time sync channel subscribed successfully for user: $_currentUserId');
      } else if (status == RealtimeSubscribeStatus.closed) {
        AppLogger.info(
            'Real-time sync channel closed for user: $_currentUserId');
        // Attempt to reconnect if we are still authenticated
        if (_currentUserId != null) {
          AppLogger.info('Attempting to reconnect real-time sync channel...');
          // Add a small delay to avoid rapid loops
          Future.delayed(const Duration(seconds: 5), () {
            if (_currentUserId != null && _channel == null) {
              // Check if still relevant
              _startListening();
            }
          });
        }
      } else if (status == RealtimeSubscribeStatus.timedOut) {
        AppLogger.error(
            'Real-time sync channel timed out for user: $_currentUserId');
      } else if (status == RealtimeSubscribeStatus.channelError) {
        AppLogger.error(
            'Real-time sync channel error for user: $_currentUserId: $error');

        // Check for auth error in channel
        if (error.toString().contains('JWT') ||
            error.toString().contains('expired')) {
          AppLogger.warning(
              'JWT expired in realtime channel, attempting refresh...');
          try {
            await client.auth.refreshSession();
            // Re-subscribe after refresh
            _startListening();
          } catch (e) {
            AppLogger.error('Failed to refresh session for realtime', e);
          }
        }
      }
    });
  }

  /// Stops listening for updates
  void _stopListening() {
    if (_channel != null) {
      _channel!.unsubscribe();
      _channel = null;
    }
    _isListening = false;
  }

  /// Notifies all listeners of data changes
  Future<void> _notifyListeners(Map<String, dynamic> data) async {
    AppLogger.debug('Notifying listeners for ${data.length} data keys');

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      // Skip if sync is in progress for this key
      if (_syncInProgress[key] == true) {
        AppLogger.debug(
            'Skipping real-time notification for key $key - sync in progress');
        continue;
      }

      final listener = _listeners[key];
      if (listener != null && value is Map<String, dynamic>) {
        // Mark that real-time update is in progress
        _realtimeUpdateInProgress[key] = true;
        try {
          AppLogger.info('Notifying listener for key: $key');
          listener(value['value'] as Map<String, dynamic>);
        } finally {
          _realtimeUpdateInProgress[key] = false;
        }
      } else if (listener == null) {
        AppLogger.warning('No listener registered for key: $key');
      }
    }
  }

  /// Gets the current user's data
  Future<Map<String, dynamic>?> getUserData() async {
    final client = _client;
    if (client == null) return null;
    if (_currentUserId == null) return null;

    try {
      final response = await client
          .from(_tableName)
          .select('data')
          .eq('user_id', _currentUserId!)
          .single();
      return response['data'] as Map<String, dynamic>? ?? {};
    } catch (e) {
      AppLogger.error('Failed to get user data', e);
      return null;
    }
  }

  /// Checks if user is authenticated
  bool get isAuthenticated => _currentUserId != null;

  /// Gets the current user ID
  String? get currentUserId => _currentUserId;

  /// Fetches all user data from the server (for on-boot initialization)
  Future<Map<String, Map<String, dynamic>>?> fetchAllData() async {
    final client = _client;
    if (client == null) return null;
    if (_currentUserId == null) {
      AppLogger.warning('Cannot fetch data: no user logged in');
      return null;
    }

    try {
      AppLogger.info(
          'Fetching all user data from server for user: $_currentUserId');

      final response = await client
          .from(_tableName)
          .select('data')
          .eq('user_id', _currentUserId!)
          .maybeSingle();

      if (response == null) {
        AppLogger.info('No synced data found for user, starting fresh');
        return {};
      }

      final data = response['data'] as Map<String, dynamic>? ?? {};
      final result = <String, Map<String, dynamic>>{};

      // Extract the value from each key's stored format
      for (final entry in data.entries) {
        if (entry.value is Map<String, dynamic>) {
          final valueMap = entry.value as Map<String, dynamic>;
          if (valueMap.containsKey('value')) {
            result[entry.key] = valueMap['value'] as Map<String, dynamic>;
          }
        }
      }

      AppLogger.info(
          'Fetched data for ${result.length} keys: ${result.keys.toList()}');
      return result;
    } catch (e) {
      AppLogger.error('Failed to fetch user data', e);
      await AutomaticErrorReporter.reportNetworkError(
        message: 'Failed to fetch user data on boot',
        url: _tableName,
        statusCode: 0,
        additionalInfo: {
          'userId': _currentUserId,
          'error': e.toString(),
        },
      );
      return null;
    }
  }

  /// Validates synced data before applying
  bool _isValidSyncedData(String key, Map<String, dynamic> data) {
    // Basic validation - we rely on ConflictResolvers to handle data integrity during merge
    // but we can do some high-level checks here.
    if (data.isEmpty && key != 'settings') {
      return false; // Settings can be empty?
    }

    // We could delegate to specific validators if needed, but for now we trust the source
    // as we are moving towards a more robust conflict resolution strategy.
    return true;
  }

  /// Disposes the service
  void dispose() {
    _stopListening();
    _queueProcessingTimer?.cancel();
  }

  /// Gets the current user's profile, creating it if it doesn't exist
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final client = _client;
    if (client == null) return null;
    if (_currentUserId == null) return null;

    // Concurrency protection: if profile creation is already in progress for this user,
    // return null to avoid race condition (will retry on next call)
    if (_profileCreationInProgress[_currentUserId!] == true) {
      AppLogger.debug(
          'Profile creation already in progress for user: $_currentUserId, skipping');
      return null;
    }

    try {
      // Mark profile creation as in progress
      _profileCreationInProgress[_currentUserId!] = true;

      // First try to get existing profile
      final response = await client
          .from('user_profiles')
          .select()
          .eq('user_id', _currentUserId!)
          .maybeSingle();

      if (response != null) {
        return response;
      }

      // Profile doesn't exist, create a default one
      AppLogger.info(
          'User profile not found, creating default profile for user: $_currentUserId');

      final user = client.auth.currentUser;
      if (user == null) return null;

      // Extract username from email (before @) as fallback
      final emailUsername = user.email?.split('@').first ?? 'user';

      final newProfile = {
        'user_id': _currentUserId,
        'username': emailUsername,
        'display_name': emailUsername,
        'bio': null,
        'avatar_url': null,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await client.from('user_profiles').insert(newProfile);

      AppLogger.info('Created default user profile for user: $_currentUserId');
      return newProfile;
    } catch (e) {
      // Handle unique constraint violation - this means another concurrent request
      // already created the profile, which is actually fine
      if (e.toString().contains('23505') ||
          e.toString().contains('42501') ||
          e.toString().toLowerCase().contains('unique') ||
          e.toString().toLowerCase().contains('duplicate') ||
          e.toString().toLowerCase().contains('violates unique constraint')) {
        AppLogger.info(
            'Profile already created by concurrent request for user: $_currentUserId');
        // Try to fetch the profile that was created by the other request
        try {
          final response = await client
              .from('user_profiles')
              .select()
              .eq('user_id', _currentUserId!)
              .maybeSingle();
          return response;
        } catch (fetchError) {
          AppLogger.error(
              'Failed to fetch profile after concurrent creation', fetchError);
          return null;
        }
      }

      // Log other errors
      AppLogger.error('Failed to get current user profile', e);
      return null;
    } finally {
      // Always clear the in-progress flag
      if (_currentUserId != null) {
        _profileCreationInProgress[_currentUserId!] = false;
      }
    }
  }
}
