import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import 'logger.dart';

class SyncService {
  static const String _tableName = 'user_sync_data';
  late final SupabaseClient _client;
  String? _currentUserId;
  RealtimeChannel? _channel;
  final Map<String, Function(Map<String, dynamic>)> _listeners = {};

  SyncService() {
    _client = SupabaseConfig.client;
  }

  /// Initializes the service
  Future<void> initialize() async {
    _setupAuthListener();
  }

  /// Sets up auth state listener to handle user login/logout
  void _setupAuthListener() {
    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      final user = event.session?.user;
      if (user != null) {
        _currentUserId = user.id;
        _startListening();
        AppLogger.info('User logged in, starting sync for user: ${user.id}');
      } else {
        _currentUserId = null;
        _stopListening();
        AppLogger.info('User logged out, stopping sync');
      }
    });
  }

  /// Syncs data to the current user's data
  Future<void> syncData(String key, Map<String, dynamic> data) async {
    if (_currentUserId == null) {
      AppLogger.warning('Cannot sync data: no user logged in');
      return;
    }

    try {
      // Get current user data or create new record
      final userDataResponse = await _client
          .from(_tableName)
          .select('data')
          .eq('user_id', _currentUserId!)
          .maybeSingle();

      final currentData = Map<String, dynamic>.from(
          userDataResponse?['data'] as Map<String, dynamic>? ?? {});

      // Update the data for this key
      currentData[key] = {
        'value': data,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Upsert the user data
      await _client.from(_tableName).upsert({
        'user_id': _currentUserId,
        'data': currentData,
        'updated_at': DateTime.now().toIso8601String(),
      });

      AppLogger.debug('Synced data for key: $key for user: $_currentUserId');
    } catch (e) {
      AppLogger.error('Failed to sync data for key: $key', e);
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
    if (_currentUserId == null) return;

    // Unsubscribe from any existing channel
    _stopListening();

    _channel = _client
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
            final newRecord = payload.newRecord as Map<String, dynamic>? ?? {};
            final newData = newRecord['data'] as Map<String, dynamic>? ?? {};
            _notifyListeners(newData);
          },
        )
        .subscribe();
  }

  /// Stops listening for updates
  void _stopListening() {
    if (_channel != null) {
      _channel!.unsubscribe();
      _channel = null;
    }
  }

  /// Notifies all listeners of data changes
  void _notifyListeners(Map<String, dynamic> data) {
    data.forEach((key, value) {
      final listener = _listeners[key];
      if (listener != null && value is Map<String, dynamic>) {
        listener(value['value'] as Map<String, dynamic>);
      }
    });
  }

  /// Gets the current user's data
  Future<Map<String, dynamic>?> getUserData() async {
    if (_currentUserId == null) return null;

    try {
      final response = await _client
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

  /// Gets the current user's profile, creating it if it doesn't exist
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    if (_currentUserId == null) return null;

    try {
      // First try to get existing profile
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('user_id', _currentUserId!)
          .maybeSingle();

      if (response != null) {
        return response;
      }

      // Profile doesn't exist, create a default one
      AppLogger.info('User profile not found, creating default profile for user: $_currentUserId');

      final user = Supabase.instance.client.auth.currentUser;
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

      await _client.from('user_profiles').insert(newProfile);

      AppLogger.info('Created default user profile for user: $_currentUserId');
      return newProfile;
    } catch (e) {
      AppLogger.error('Failed to get current user profile', e);
      return null;
    }
  }

  /// Searches for users by username (excluding deleted users)
  Future<List<Map<String, dynamic>>?> searchUsers(String query) async {
    if (query.isEmpty || query.length < 2) {
      return <Map<String, dynamic>>[];
    }

    try {
      final response = await _client
          .from('user_profiles')
          .select('user_id, username, display_name')
          .ilike('username', '%$query%')
          .filter('deleted_at', 'is', null)  // Exclude deleted users
          .limit(20);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      AppLogger.error('Failed to search users: $query', e);
      return <Map<String, dynamic>>[];
    }
  }

  /// Follows a user by their user ID
  Future<bool> followUser(String targetUserId) async {
    if (_currentUserId == null) return false;
    if (_currentUserId == targetUserId) return false; // Can't follow yourself

    try {
      await _client.from('user_relationships').insert({
        'follower_user_id': _currentUserId,
        'followed_user_id': targetUserId,
      });
      AppLogger.debug('Successfully followed user: $targetUserId');
      return true;
    } catch (e) {
      // Check if it's a duplicate key error (already following)
      if (e.toString().contains('duplicate key')) {
        AppLogger.debug('Already following user: $targetUserId');
        return true;
      }
      AppLogger.error('Failed to follow user: $targetUserId', e);
      return false;
    }
  }

  /// Unfollows a user by their user ID
  Future<bool> unfollowUser(String targetUserId) async {
    if (_currentUserId == null) return false;

    try {
      await _client
          .from('user_relationships')
          .delete()
          .eq('follower_user_id', _currentUserId!)
          .eq('followed_user_id', targetUserId);
      AppLogger.debug('Successfully unfollowed user: $targetUserId');
      return true;
    } catch (e) {
      AppLogger.error('Failed to unfollow user: $targetUserId', e);
      return false;
    }
  }

  /// Checks if current user is following another user
  Future<bool> isFollowingUser(String targetUserId) async {
    if (_currentUserId == null) return false;

    try {
      final response = await _client
          .from('user_relationships')
          .select()
          .eq('follower_user_id', _currentUserId!)
          .eq('followed_user_id', targetUserId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      AppLogger.error('Failed to check if following user: $targetUserId', e);
      return false;
    }
  }

  /// Gets the list of users that the current user is following
  Future<List<String>?> getFollowingList() async {
    if (_currentUserId == null) return <String>[];

    try {
      final response = await _client
          .from('user_relationships')
          .select('followed_user_id')
          .eq('follower_user_id', _currentUserId!);

      return List<String>.from(response.map((item) => item['followed_user_id']));
    } catch (e) {
      AppLogger.error('Failed to get following list', e);
      return <String>[];
    }
  }

  /// Gets the list of users following the current user
  Future<List<String>?> getFollowersList() async {
    if (_currentUserId == null) return <String>[];

    try {
      final response = await _client
          .from('user_relationships')
          .select('follower_user_id')
          .eq('followed_user_id', _currentUserId!);

      return List<String>.from(response.map((item) => item['follower_user_id']));
    } catch (e) {
      AppLogger.error('Failed to get followers list', e);
      return <String>[];
    }
  }

  /// Gets username for a user ID (excluding deleted users)
  Future<String?> getUsernameByUserId(String userId) async {
    try {
      final response = await _client
          .from('user_profiles')
          .select('username')
          .eq('user_id', userId)
          .filter('deleted_at', 'is', null)  // Exclude deleted users
          .maybeSingle();

      return response?['username'] as String?;
    } catch (e) {
      AppLogger.error('Failed to get username for user: $userId', e);
      return null;
    }
  }

  /// Gets user profile by user ID (excluding deleted users)
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .filter('deleted_at', 'is', null)  // Exclude deleted users
          .maybeSingle();

      return response;
    } catch (e) {
      AppLogger.error('Failed to get user profile for: $userId', e);
      return null;
    }
  }

  /// Gets game stats for a specific user
  Future<Map<String, dynamic>?> getGameStatsForUser(String userId) async {
    try {
      final response = await _client
          .from('user_sync_data')
          .select('data')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      final data = response['data'] as Map<String, dynamic>?;
      return data?['game_stats']?['value'] as Map<String, dynamic>?;
    } catch (e) {
      AppLogger.error('Failed to get game stats for user: $userId', e);
      return null;
    }
  }

  // Legacy methods for backwards compatibility - these now do nothing or return defaults

  Future<bool> joinRoom(String code) async => false;
  Future<void> leaveRoom() async {}
  Future<List<String>?> getDevicesInRoom() async => null;
  Future<bool> removeDevice(String deviceId) async => false;
  Future<bool> setUsername(String username) async => false;
  Future<String?> getUsername([String? deviceId]) async => null;
  Future<String?> getUsernameForDevice(String deviceId) async => null;
  Future<Map<String, String>?> getAllUsernames() async => null;
  Future<bool> isUsernameTaken(String username) async => false;
  Future<Map<String, String>?> getAllUsernamesGlobally() async => null;
  Future<String?> getUsernameByDeviceId(String deviceId) async => null;
  void addUsernameListener(Function(String?) callback) {}
  void addFollowingListener(Function(List<String>) callback) {}
  void addFollowersListener(Function(List<String>) callback) {}
  Future<Map<String, dynamic>?> getGameStatsForDevice(String deviceId) async => null;
  Future<List<Map<String, dynamic>>?> getAllGameStats() async => null;
  Future<String> getCurrentDeviceId() async => '';
  bool get isInRoom => false;
  String? get currentRoomId => null;
}