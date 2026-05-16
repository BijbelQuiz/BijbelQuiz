import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import 'logger.dart';
import 'connection_service.dart';
import '../utils/automatic_error_reporter.dart';

import 'sync/sync_types_v2.dart';
import 'sync/sync_queue_v2.dart';

/// Version 2 of the Sync Service with atomic operations and optimistic locking
///
/// Key improvements over v1:
/// - Atomic database operations with versioning
/// - Optimistic locking to prevent lost updates
/// - Server-side conflict resolution
/// - Reliable queue with exponential backoff
/// - Simplified state management
class SyncServiceV2 {
  static final SyncServiceV2 _instance = SyncServiceV2._internal();
  static SyncServiceV2 get instance => _instance;

  // Configuration
  static const String _syncStateKey = 'sync_state_v2';
  static const String _syncDataPrefix = 'sync_data_v2_';

  // Supabase
  SupabaseClient? _client;
  late final ConnectionService _connectionService;

  // State
  String? _currentUserId;
  RealtimeChannel? _channel;
  bool _isInitialized = false;
  bool _isProcessingQueue = false;

  // Sync queue
  final SyncQueue _queue = SyncQueue();

  // Data key states
  final Map<String, DataKeySyncState> _dataKeyStates = {};

  // Listeners for data changes
  final Map<String, List<Function(Map<String, dynamic>)>> _dataListeners = {};

  // Error callbacks
  final Map<String, Function(String, SyncError)> _errorCallbacks = {};
  final Map<String, Function(String)> _successCallbacks = {};

  // Debounce timers for auto-sync
  final Map<String, Timer> _debounceTimers = {};

  // Configuration
  SyncConfig _config = SyncConfig.defaultConfig;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _currentUserId != null;
  bool get isAvailable => _client != null;
  String? get currentUserId => _currentUserId;
  SyncQueue get queue => _queue;
  SyncConfig get config => _config;
  ConnectionService get connectionService => _connectionService;

  /// Get the current sync state for a data key
  DataKeySyncState getDataKeyState(String key) {
    return _dataKeyStates[key] ?? DataKeySyncState(key: key);
  }

  factory SyncServiceV2() => _instance;

  SyncServiceV2._internal() {
    _connectionService = ConnectionService();
  }

  /// Initialize the sync service
  Future<void> initialize({SyncConfig? config}) async {
    if (_isInitialized) return;

    if (config != null) {
      _config = config;
    }

    _client = SupabaseConfig.maybeClient;

    await _connectionService.initialize();
    await _queue.initialize();
    await _loadSyncState();

    if (_client == null) {
      _isInitialized = true;
      AppLogger.warning(
          'SyncServiceV2 initialized in local-only mode: Supabase unavailable');
      return;
    }

    _setupAuthListener();
    _setupConnectionListener();
    _setupQueueListener();

    _isInitialized = true;
    AppLogger.info('SyncServiceV2 initialized');
  }

  /// Configure the sync service
  void configure(SyncConfig config) {
    _config = config;
    AppLogger.info('SyncServiceV2 configured: ${config.toString()}');
  }

  /// Register callbacks for a data type
  void registerCallbacks(
    String dataType, {
    Function(String, SyncError)? onSyncError,
    Function(String)? onSyncSuccess,
  }) {
    if (onSyncError != null) {
      _errorCallbacks[dataType] = onSyncError;
    }
    if (onSyncSuccess != null) {
      _successCallbacks[dataType] = onSyncSuccess;
    }
  }

  /// Unregister callbacks for a data type
  void unregisterCallbacks(String dataType) {
    _errorCallbacks.remove(dataType);
    _successCallbacks.remove(dataType);
  }

  /// Add a listener for data changes
  void addListener(String key, Function(Map<String, dynamic>) callback) {
    _dataListeners.putIfAbsent(key, () => []);
    if (!_dataListeners[key]!.contains(callback)) {
      _dataListeners[key]!.add(callback);
    }
  }

  /// Remove a listener for data changes
  void removeListener(String key, Function(Map<String, dynamic>) callback) {
    _dataListeners[key]?.remove(callback);
    if (_dataListeners[key]?.isEmpty ?? false) {
      _dataListeners.remove(key);
    }
  }

  /// Sync data to the server
  ///
  /// If [immediate] is true, sync immediately (bypassing debounce).
  /// If [priority] is high or critical, sync immediately.
  Future<void> syncData(
    String key,
    Map<String, dynamic> data, {
    bool immediate = false,
    SyncItemPriority priority = SyncItemPriority.normal,
  }) async {
    if (!_isInitialized) {
      throw StateError('SyncServiceV2 not initialized');
    }

    // Update local state first
    await _updateLocalData(key, data);

    // Update data key state
    _dataKeyStates[key] = DataKeySyncState(
      key: key,
      state: SyncOperationState.preparing,
      version: _dataKeyStates[key]?.version ?? 0,
      lastModifiedAt: DateTime.now(),
    );
    await _saveSyncState();

    // Cancel any existing debounce timer
    _debounceTimers[key]?.cancel();

    // Determine if we should sync immediately
    final shouldSyncImmediately = immediate ||
        priority == SyncItemPriority.critical ||
        priority == SyncItemPriority.high ||
        !_config.autoSync;

    if (shouldSyncImmediately) {
      // Add to queue and process immediately
      await _queue.enqueue(
        key: key,
        data: data,
        expectedVersion: _dataKeyStates[key]?.version ?? 0,
        priority: priority,
      );
      await _processQueue();
    } else {
      // Debounce rapid changes
      _debounceTimers[key] = Timer(_config.debounceDuration, () async {
        // Remove timer from map when it fires
        _debounceTimers.remove(key);
        await _queue.enqueue(
          key: key,
          data: data,
          expectedVersion: _dataKeyStates[key]?.version ?? 0,
          priority: priority,
        );
        await _processQueue();
      });
    }
  }

  /// Force immediate sync of specific data
  Future<void> syncDataImmediate(
    String key,
    Map<String, dynamic> data, {
    SyncItemPriority priority = SyncItemPriority.high,
  }) async {
    return syncData(key, data, immediate: true, priority: priority);
  }

  /// Fetch all sync data from the server
  Future<Map<String, SyncDataEntry>?> fetchAllData() async {
    final client = _client;
    if (client == null) {
      AppLogger.warning('Cannot fetch data: Supabase unavailable');
      return null;
    }

    if (_currentUserId == null) {
      AppLogger.warning('Cannot fetch data: not authenticated');
      return null;
    }

    try {
      AppLogger.info('Fetching all sync data for user: $_currentUserId');

      final response = await client.rpc(
        'get_user_sync_data',
        params: {'p_user_id': _currentUserId},
      );

      if (response == null) {
        return {};
      }

      final List<dynamic> data = response as List<dynamic>;
      final result = <String, SyncDataEntry>{};

      for (final entry in data) {
        final syncEntry = SyncDataEntry.fromJson(entry as Map<String, dynamic>);
        result[syncEntry.key] = syncEntry;

        // Update local version tracking
        final currentState = _dataKeyStates[syncEntry.key];
        if (currentState == null || syncEntry.version > currentState.version) {
          _dataKeyStates[syncEntry.key] = DataKeySyncState(
            key: syncEntry.key,
            state: SyncOperationState.completed,
            version: syncEntry.version,
            lastSyncAt: DateTime.now(),
          );
        }
      }

      await _saveSyncState();
      AppLogger.info(
          'Fetched ${result.length} data keys: ${result.keys.toList()}');

      return result;
    } catch (e) {
      AppLogger.error('Failed to fetch sync data', e);
      _reportError('fetch', e);
      return null;
    }
  }

  /// Get the current local data for a key
  Future<Map<String, dynamic>?> getLocalData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('$_syncDataPrefix$key');
      if (data != null) {
        return json.decode(data) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      AppLogger.error('Failed to get local data for $key', e);
      return null;
    }
  }

  /// Get sync status for all devices
  Future<List<DeviceSyncMetadata>?> getDeviceSyncStatus() async {
    final client = _client;
    if (client == null) return null;
    if (_currentUserId == null) return null;

    try {
      final response = await client.rpc(
        'get_user_sync_status',
        params: {'p_user_id': _currentUserId},
      );

      if (response == null) return [];

      final List<dynamic> data = response as List<dynamic>;
      return data
          .map((e) => DeviceSyncMetadata.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.error('Failed to get device sync status', e);
      return null;
    }
  }

  /// Clear all sync data (useful for logout)
  Future<void> clearAllData() async {
    _currentUserId = null;
    _dataKeyStates.clear();
    _dataListeners.clear();
    _errorCallbacks.clear();
    _successCallbacks.clear();

    await _queue.clear();
    await _saveSyncState();

    // Clear local data
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_syncDataPrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }

    _stopRealtimeSubscription();

    AppLogger.info('All sync data cleared');
  }

  /// Called when app resumes
  Future<void> onAppResume() async {
    AppLogger.info('App resumed - processing sync queue');
    if (_currentUserId != null && _connectionService.isConnected) {
      await _processQueue();
    }
  }

  /// Called when app pauses
  Future<void> onAppPause() async {
    AppLogger.info('App paused - saving sync state');
    await _saveSyncState();
  }

  /// Alias for [onAppResume] - called when app resumes (deprecated API compatibility)
  Future<void> syncOnAppResume() async {
    await onAppResume();
  }

  /// Alias for [onAppPause] - called when app pauses (deprecated API compatibility)
  Future<void> syncOnAppPause() async {
    await onAppPause();
  }

  /// Retry all failed items
  Future<void> retryFailed() async {
    final failed = _queue.failedItems;
    for (final item in failed) {
      await _queue.enqueue(
        key: item.key,
        data: item.data,
        expectedVersion: item.expectedVersion,
        priority: SyncItemPriority.high,
      );
    }
    await _processQueue();
  }

  /// Get comprehensive sync statistics
  Map<String, dynamic> getStats() {
    final queueStats = _queue.getStats();
    final dataKeyStats =
        _dataKeyStates.map((key, state) => MapEntry(key, state.toJson()));

    return {
      'initialized': _isInitialized,
      'authenticated': isAuthenticated,
      'userId': _currentUserId,
      'queue': queueStats,
      'dataKeys': dataKeyStats,
      'connected': _connectionService.isConnected,
    };
  }

  // ============ Private Methods ============

  /// Update local data storage
  Future<void> _updateLocalData(String key, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_syncDataPrefix$key', json.encode(data));
    } catch (e) {
      AppLogger.error('Failed to save local data for $key', e);
    }
  }

  /// Setup auth state listener
  void _setupAuthListener() {
    final client = _client;
    if (client == null) return;

    client.auth.onAuthStateChange.listen(
      (event) async {
        try {
          final user = event.session?.user;

          if (user != null && user.id != _currentUserId) {
            // New user logged in
            _currentUserId = user.id;
            AppLogger.info('User logged in: ${user.id}');

            // Load sync state for this user
            await _loadSyncState();

            // Setup realtime subscription
            if (_config.enableRealtime) {
              _startRealtimeSubscription();
            }

            // Process any pending items
            await _processQueue();
          } else if (user == null && _currentUserId != null) {
            // User logged out
            AppLogger.info('User logged out');
            await clearAllData();
          }
        } catch (e, stack) {
          AppLogger.error('Error handling auth state change', e, stack);
        }
      },
      onError: (e, stack) {
        AppLogger.error('Auth state stream error', e, stack);
      },
    );
  }

  /// Setup connection listener
  void _setupConnectionListener() {
    _connectionService.setConnectionStatusCallback((isConnected, type) {
      if (isConnected && _currentUserId != null) {
        AppLogger.info('Connection restored - processing queue');
        _processQueue().catchError((e, stack) {
          AppLogger.error('Failed to process queue on reconnect', e, stack);
        });
      }
    });
  }

  /// Setup queue listener
  void _setupQueueListener() {
    _queue.onQueueChange.listen(
      (item) {
        // Queue state changed, could update UI here
      },
      onError: (e, stack) {
        AppLogger.error('Queue stream error', e, stack);
      },
    );
  }

  /// Process the sync queue
  Future<void> _processQueue() async {
    // Atomic check-and-set to prevent race conditions
    final wasProcessing = _isProcessingQueue;
    _isProcessingQueue = true;
    if (wasProcessing) return;

    if (_currentUserId == null) {
      _isProcessingQueue = false;
      return;
    }
    if (!_connectionService.isConnected) {
      _isProcessingQueue = false;
      return;
    }

    try {
      int processedCount = 0;
      const maxIterations = 100; // Prevent infinite loops

      while (processedCount < maxIterations) {
        final item = _queue.getNextReadyItem();
        if (item == null) break;

        await _processQueueItem(item);
        processedCount++;
      }

      if (processedCount >= maxIterations) {
        AppLogger.warning('Queue processing reached max iterations (100)');
      }
    } finally {
      _isProcessingQueue = false;
    }
  }

  /// Process a single queue item
  Future<void> _processQueueItem(SyncQueueItem item) async {
    final client = _client;
    if (client == null) {
      await _queue.markFailed(item.id, 'Supabase unavailable');
      return;
    }

    try {
      // Update state
      _dataKeyStates[item.key] = DataKeySyncState(
        key: item.key,
        state: SyncOperationState.syncing,
        version: item.expectedVersion,
        lastModifiedAt: DateTime.now(),
      );
      await _saveSyncState();

      // Get device ID
      final deviceId = await _queue.deviceId;

      // Call atomic upsert function
      final response = await client.rpc(
        'atomic_sync_upsert',
        params: {
          'p_user_id': _currentUserId,
          'p_data_key': item.key,
          'p_data': item.data,
          'p_expected_version': item.expectedVersion,
          'p_device_id': deviceId,
        },
      );

      if (response == null) {
        throw Exception('Null response from atomic_sync_upsert');
      }

      final result = SyncResult.fromJson(response as Map<String, dynamic>);

      if (result.success) {
        // Success!
        await _queue.markSuccess(item.id, result.newVersion);

        // Update state
        _dataKeyStates[item.key] = DataKeySyncState(
          key: item.key,
          state: SyncOperationState.completed,
          version: result.newVersion,
          lastSyncAt: DateTime.now(),
          lastModifiedAt: DateTime.now(),
        );
        await _saveSyncState();

        // Notify listeners
        _notifyListeners(item.key, result.data ?? item.data);

        // Call success callback (wrapped in try-catch to prevent propagation)
        try {
          _successCallbacks[item.key]?.call(item.key);
        } catch (e, stack) {
          AppLogger.error('Error in sync success callback', e, stack);
        }

        AppLogger.info(
            'Sync successful for ${item.key}: ${result.action}, version ${result.newVersion}');
      } else {
        // Server reported failure
        throw Exception(result.error ?? 'Unknown server error');
      }
    } on SocketException catch (e) {
      // Network error - retry later
      await _queue.markFailed(item.id, 'Network error: ${e.message}');
      _handleError(item.key, SyncErrorType.network, 'Network error', e.message);
    } on PostgrestException catch (e) {
      // Database/Supabase error
      final errorType = _categorizeError(e.message);
      await _queue.markFailed(item.id, 'Database error: ${e.message}');
      _handleError(item.key, errorType, 'Database error', e.message);
    } catch (e) {
      // Unknown error
      await _queue.markFailed(item.id, 'Error: ${e.toString()}');
      _handleError(item.key, SyncErrorType.unknown, 'Sync error', e.toString());
    }
  }

  /// Categorize an error
  SyncErrorType _categorizeError(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('jwt') ||
        lower.contains('auth') ||
        lower.contains('unauthorized')) {
      return SyncErrorType.auth;
    }
    if (lower.contains('network') ||
        lower.contains('connection') ||
        lower.contains('timeout')) {
      return SyncErrorType.network;
    }
    if (lower.contains('constraint') ||
        lower.contains('validation') ||
        lower.contains('invalid')) {
      return SyncErrorType.validation;
    }
    if (lower.contains('500') || lower.contains('server error')) {
      return SyncErrorType.server;
    }

    return SyncErrorType.unknown;
  }

  /// Handle an error
  void _handleError(
      String key, SyncErrorType type, String message, String? details) {
    final error = SyncError(type: type, message: message, details: details);

    // Call error callback (wrapped in try-catch to prevent propagation)
    try {
      _errorCallbacks[key]?.call(key, error);
    } catch (e, stack) {
      AppLogger.error('Error in sync error callback', e, stack);
    }

    if (type == SyncErrorType.auth) {
      // Auth errors are serious - report them
      _reportError(key, Exception('Auth error: $message - $details'));
    }

    AppLogger.error('Sync error for $key: $error');
  }

  /// Report an error to the error tracking system
  Future<void> _reportError(String operation, dynamic error) async {
    try {
      await AutomaticErrorReporter.reportStorageError(
        message: 'Sync V2 error during $operation',
        operation: 'sync_v2_$operation',
        additionalInfo: {
          'userId': _currentUserId,
          'error': error.toString(),
        },
      );
    } catch (e) {
      // Don't let error reporting fail the sync
    }
  }

  /// Notify listeners of data changes
  void _notifyListeners(String key, Map<String, dynamic> data) {
    final listeners = _dataListeners[key];
    if (listeners != null) {
      for (final listener in listeners) {
        try {
          listener(data);
        } catch (e) {
          AppLogger.error('Error in sync listener for $key', e);
        }
      }
    }
  }

  /// Start realtime subscription
  void _startRealtimeSubscription() {
    if (_currentUserId == null) return;
    if (_channel != null) return;
    final client = _client;
    if (client == null) return;

    AppLogger.info('Starting realtime subscription for user: $_currentUserId');

    _channel = client
        .channel('user_sync_v2_$_currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'user_sync_data_v2',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: _currentUserId,
          ),
          callback: (payload) {
            _handleRealtimeUpdate(payload);
          },
        )
        .subscribe((status, error) {
      if (status == RealtimeSubscribeStatus.subscribed) {
        AppLogger.info('Realtime subscription active');
      } else if (error != null) {
        AppLogger.error('Realtime subscription error', error);
      }
    });
  }

  /// Stop realtime subscription
  void _stopRealtimeSubscription() {
    if (_channel != null) {
      _channel!.unsubscribe();
      _channel = null;
      AppLogger.info('Realtime subscription stopped');
    }
  }

  /// Handle realtime update
  void _handleRealtimeUpdate(PostgresChangePayload payload) {
    // Fire and forget - handle asynchronously
    _handleRealtimeUpdateAsync(payload).catchError((e, stack) {
      AppLogger.error('Error handling realtime update', e, stack);
    });
  }

  /// Async implementation of realtime update handling
  Future<void> _handleRealtimeUpdateAsync(PostgresChangePayload payload) async {
    try {
      final newRecord = payload.newRecord;
      final dataKey = newRecord['data_key'] as String?;
      final data = newRecord['data'] as Map<String, dynamic>?;
      final version = newRecord['version'] as int?;

      if (dataKey == null || data == null || version == null) return;

      // Check if this is an update from another device
      final currentState = _dataKeyStates[dataKey];
      if (currentState != null && version <= currentState.version) {
        // Our version is same or newer, ignore
        return;
      }

      // Update our state
      _dataKeyStates[dataKey] = DataKeySyncState(
        key: dataKey,
        state: SyncOperationState.completed,
        version: version,
        lastSyncAt: DateTime.now(),
      );
      await _saveSyncState();

      // Save to local storage
      await _updateLocalData(dataKey, data);

      // Notify listeners
      _notifyListeners(dataKey, data);

      AppLogger.info('Realtime update received for $dataKey, version $version');
    } catch (e, stack) {
      AppLogger.error('Error handling realtime update', e, stack);
    }
  }

  /// Load sync state from persistent storage
  Future<void> _loadSyncState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateJson = prefs.getString('$_syncStateKey$_currentUserId');

      if (stateJson != null) {
        final state = json.decode(stateJson) as Map<String, dynamic>;

        _dataKeyStates.clear();
        final dataKeys = state['dataKeys'] as Map<String, dynamic>?;
        if (dataKeys != null) {
          for (final entry in dataKeys.entries) {
            _dataKeyStates[entry.key] = DataKeySyncState.fromJson(
              entry.value as Map<String, dynamic>,
            );
          }
        }
      }
    } catch (e) {
      AppLogger.error('Failed to load sync state', e);
    }
  }

  /// Save sync state to persistent storage
  Future<void> _saveSyncState() async {
    if (_currentUserId == null) {
      AppLogger.warning('Cannot save sync state: no current user');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final state = {
        'dataKeys': _dataKeyStates.map((k, v) => MapEntry(k, v.toJson())),
        'timestamp': DateTime.now().toIso8601String(),
      };
      await prefs.setString(
          '$_syncStateKey$_currentUserId', json.encode(state));
    } catch (e, stack) {
      AppLogger.error('Failed to save sync state', e, stack);
    }
  }

  /// Get the current user's profile
  /// Returns null if not authenticated or profile doesn't exist
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final client = _client;
    if (client == null) return null;
    if (_currentUserId == null) return null;

    try {
      final response = await client
          .from('user_profiles')
          .select()
          .eq('user_id', _currentUserId!)
          .maybeSingle();

      return response;
    } catch (e) {
      AppLogger.error('Failed to get current user profile', e);
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _stopRealtimeSubscription();
    _queue.dispose();
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
    _isInitialized = false;
  }
}
