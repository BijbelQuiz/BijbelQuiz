import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/supabase_config.dart';
import 'logger.dart';

class SyncService {
  static const String _tableName = 'sync_rooms';
  static const String _usernamesKey = 'usernames';
  static const String _followingKey = 'following';
  static const String _followersKey = 'followers';
  late final SupabaseClient _client;
  String? _currentRoomId;
  RealtimeChannel? _channel;
  final Map<String, Function(Map<String, dynamic>)> _listeners = {};

  SyncService() {
    _client = SupabaseConfig.client;
  }

  /// Initializes the service, including loading saved room
  Future<void> initialize() async {
    await _loadSavedDeviceId();
    await _loadSavedRoomId();
  }

  /// Joins a sync room using the provided code
  Future<bool> joinRoom(String code) async {
    try {
      // If already in a room, leave it first to prevent duplicate subscriptions
      if (_currentRoomId != null) {
        await leaveRoom();
      }

      // Generate a unique device ID if not exists
      final deviceId = await _getOrCreateDeviceId();

      // Check if room exists, create if not
      final roomResponse = await _client
          .from(_tableName)
          .select()
          .eq('room_id', code)
          .maybeSingle();

      if (roomResponse == null) {
        // Create new room
        await _client.from(_tableName).insert({
          'room_id': code,
          'created_at': DateTime.now().toIso8601String(),
          'devices': [deviceId],
          'data': {},
        });
      } else {
        // Add device to existing room
        final devices = List<String>.from(roomResponse['devices'] ?? []);
        if (!devices.contains(deviceId)) {
          devices.add(deviceId);
          await _client
              .from(_tableName)
              .update({'devices': devices})
              .eq('room_id', code);
        }
      }

      _currentRoomId = code;
      await _saveRoomId(code);
      _startListening();
      AppLogger.debug('Joined sync room: $code');
      return true;
    } catch (e) {
      AppLogger.error('Failed to join sync room: $code', e);
      return false;
    }
  }

  /// Leaves the current sync room
  Future<void> leaveRoom() async {
    if (_currentRoomId == null) return;

    try {
      final deviceId = await _getOrCreateDeviceId();
      final roomResponse = await _client
          .from(_tableName)
          .select()
          .eq('room_id', _currentRoomId!)
          .single();

      final devices = List<String>.from(roomResponse['devices'] ?? []);
      devices.remove(deviceId);
      await _client
          .from(_tableName)
          .update({'devices': devices})
          .eq('room_id', _currentRoomId!);

      // Clear current room ID before stopping listening to prevent re-subscription attempts
      _currentRoomId = null;
      _stopListening();
      await _clearRoomId();
      AppLogger.debug('Left sync room');
    } catch (e) {
      AppLogger.error('Failed to leave sync room', e);
    }
  }

  /// Syncs data to the room
  Future<void> syncData(String key, Map<String, dynamic> data) async {
    if (_currentRoomId == null) return;

    try {
      final deviceId = await _getOrCreateDeviceId();
      
      // Get current data to merge with the new data
      final roomResponse = await _client
          .from(_tableName)
          .select('data')
          .eq('room_id', _currentRoomId!)
          .single();
      
      final currentData = Map<String, dynamic>.from(roomResponse['data'] as Map<String, dynamic>? ?? {});
      
      // Handle game stats differently - store for each device separately
      if (key == 'game_stats') {
        final gameStatsMap = Map<String, dynamic>.from(currentData[key] as Map<String, dynamic>? ?? {});
        
        // Update the stats for this specific device
        gameStatsMap[deviceId] = {
          'value': data,
          'timestamp': DateTime.now().toIso8601String(),
        };
        
        currentData[key] = gameStatsMap;
      } else {
        // For other keys, use the original approach
        currentData[key] = {
          'value': data,
          'device_id': deviceId,
          'timestamp': DateTime.now().toIso8601String(),
        };
      }

      await _client
          .from(_tableName)
          .update({'data': currentData})
          .eq('room_id', _currentRoomId!);
      AppLogger.debug('Synced data for key: $key');
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

  /// Starts listening for real-time updates
  void _startListening() {
    if (_currentRoomId == null) return;

    // Unsubscribe from any existing channel to prevent duplicates
    _stopListening();

    _channel = _client
        .channel('sync_room_$_currentRoomId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: _tableName,
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

  /// Gets or creates a unique device ID
  Future<String> _getOrCreateDeviceId() async {
    if (_currentDeviceId != null) {
      return _currentDeviceId!;
    }

    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    
    if (deviceId == null) {
      // Generate a new unique device ID if one doesn't exist
      deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString('device_id', deviceId);
    }

    _currentDeviceId = deviceId;
    return deviceId;
  }

  /// Gets current room data
  Future<Map<String, dynamic>?> getRoomData() async {
    if (_currentRoomId == null) return null;

    try {
      final response = await _client
          .from(_tableName)
          .select('data')
          .eq('room_id', _currentRoomId!)
          .single();
      return response['data'] as Map<String, dynamic>? ?? {};
    } catch (e) {
      AppLogger.error('Failed to get room data', e);
      return null;
    }
  }

  /// Checks if currently in a room
  bool get isInRoom => _currentRoomId != null;

  String? _currentDeviceId;

  /// Gets the current room ID
  String? get currentRoomId => _currentRoomId;

  /// Gets the current device ID
  Future<String> getCurrentDeviceId() async {
    _currentDeviceId ??= await _getOrCreateDeviceId();
    return _currentDeviceId!;
  }

  /// Gets the list of devices in the current room
  Future<List<String>?> getDevicesInRoom() async {
    if (_currentRoomId == null) return null;

    try {
      final response = await _client
          .from(_tableName)
          .select('devices')
          .eq('room_id', _currentRoomId!)
          .single();
      return List<String>.from(response['devices'] as List<dynamic> ?? []);
    } catch (e) {
      AppLogger.error('Failed to get devices in room', e);
      return null;
    }
  }

  /// Removes a specific device from the current room
  Future<bool> removeDevice(String deviceId) async {
    if (_currentRoomId == null) return false;

    try {
      final roomResponse = await _client
          .from(_tableName)
          .select()
          .eq('room_id', _currentRoomId!)
          .single();

      final devices = List<String>.from(roomResponse['devices'] as List<dynamic> ?? []);
      if (devices.contains(deviceId)) {
        devices.remove(deviceId);
        await _client
            .from(_tableName)
            .update({'devices': devices})
            .eq('room_id', _currentRoomId!);
        AppLogger.info('Removed device $deviceId from room $_currentRoomId');
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.error('Failed to remove device $deviceId from room', e);
      return false;
    }
  }

  /// Sets the username for the current device
  Future<bool> setUsername(String username) async {
    if (_currentRoomId == null) return false;

    try {
      final deviceId = await _getOrCreateDeviceId();
      
      // Check if the new username is already taken globally by a different device
      final existingUsernameData = await _getUsernameRecord(username);
      if (existingUsernameData != null) {
        // Check if it's taken by a different device
        final existingDeviceId = existingUsernameData['device_id'] as String?;
        if (existingDeviceId != null && existingDeviceId != deviceId) {
          AppLogger.warning('Username "$username" is already taken by device: $existingDeviceId');
          return false;
        }
      }

      // Get current data to merge with the new username
      final roomResponse = await _client
          .from(_tableName)
          .select('data')
          .eq('room_id', _currentRoomId!)
          .single();
      
      final currentData = Map<String, dynamic>.from(roomResponse['data'] as Map<String, dynamic>? ?? {});
      
      // Get current usernames mapping or create new one
      final usernamesData = Map<String, dynamic>.from(currentData[_usernamesKey] as Map<String, dynamic>? ?? {});
      
      // Update the username for this device
      usernamesData[deviceId] = {
        'value': username,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Update the usernames data
      currentData[_usernamesKey] = usernamesData;

      await _client
          .from(_tableName)
          .update({'data': currentData})
          .eq('room_id', _currentRoomId!);
      
      AppLogger.debug('Set username: $username for device: $deviceId');
      return true;
    } catch (e) {
      AppLogger.error('Failed to set username', e);
      return false;
    }
  }

  /// Helper method to find if a username exists anywhere and return its record
  Future<Map<String, dynamic>?> _getUsernameRecord(String username) async {
    try {
      // Get all rooms that have usernames data
      final response = await _client
          .from(_tableName)
          .select('data')
          .not('data', 'is', null);

      for (final row in response) {
        final data = row['data'] as Map<String, dynamic>?;
        if (data != null) {
          final usernamesData = data[_usernamesKey] as Map<String, dynamic>?;
          if (usernamesData != null) {
            // Check each device's username
            for (final entry in usernamesData.entries) {
              final deviceId = entry.key;
              final usernameInfo = entry.value as Map<String, dynamic>?;
              if (usernameInfo != null) {
                final storedUsername = usernameInfo['value'] as String?;
                if (storedUsername != null && storedUsername.toLowerCase() == username.toLowerCase()) {
                  return {
                    'value': storedUsername,
                    'device_id': deviceId,
                    'timestamp': usernameInfo['timestamp'],
                  }; // Return the full username data record
                }
              }
            }
          }
        }
      }
      return null; // Username doesn't exist
    } catch (e) {
      AppLogger.error('Failed to get username record', e);
      return null;
    }
  }

  /// Gets the username for a specific device or current device if not specified
  Future<String?> getUsername([String? deviceId]) async {
    if (_currentRoomId == null) return null;

    try {
      final roomData = await getRoomData();
      if (roomData == null) return null;

      final usernamesData = roomData[_usernamesKey] as Map<String, dynamic>?;
      if (usernamesData == null) return null;

      String? targetDeviceId = deviceId;
      targetDeviceId ??= await _getOrCreateDeviceId();

      final usernameInfo = usernamesData[targetDeviceId] as Map<String, dynamic>?;
      if (usernameInfo != null) {
        return usernameInfo['value'] as String?;
      }

      return null;
    } catch (e) {
      AppLogger.error('Failed to get username', e);
      return null;
    }
  }

  /// Gets username for a specific device only (more precise than the general method)
  Future<String?> getUsernameForDevice(String deviceId) async {
    if (_currentRoomId == null) {
      AppLogger.warning('Cannot get username for device: not in a room');
      return null;
    }

    try {
      final roomData = await getRoomData();
      if (roomData == null) {
        AppLogger.warning('No room data available when getting username for device: $deviceId');
        return null;
      }

      final usernamesData = roomData[_usernamesKey] as Map<String, dynamic>?;
      if (usernamesData == null) return null;

      final usernameInfo = usernamesData[deviceId] as Map<String, dynamic>?;
      if (usernameInfo != null) {
        return usernameInfo['value'] as String?;
      }

      return null;
    } catch (e) {
      AppLogger.error('Failed to get username for device: $deviceId, error: ${e.toString()}');
      return null;
    }
  }

  /// Gets all usernames in the current room mapped by device ID
  Future<Map<String, String>?> getAllUsernames() async {
    if (_currentRoomId == null) return null;

    try {
      final roomData = await getRoomData();
      if (roomData == null) return null;

      final usernamesData = roomData[_usernamesKey] as Map<String, dynamic>?;
      if (usernamesData == null) return null;

      final deviceUsername = <String, String>{};
      
      // Iterate through all device IDs and their usernames
      for (final entry in usernamesData.entries) {
        final deviceId = entry.key;
        final usernameInfo = entry.value as Map<String, dynamic>?;
        if (usernameInfo != null) {
          final username = usernameInfo['value'] as String?;
          if (username != null) {
            deviceUsername[deviceId] = username;
          }
        }
      }

      return deviceUsername;
    } catch (e) {
      AppLogger.error('Failed to get all usernames', e);
      return null;
    }
  }

  /// Updates the data structure to store multiple usernames per room (for future expansion)
  Future<void> _updateUsernameStorage(String username) async {
    if (_currentRoomId == null) return;

    try {
      final deviceId = await _getOrCreateDeviceId();
      
      // Get current data to merge with the new username
      final roomResponse = await _client
          .from(_tableName)
          .select('data')
          .eq('room_id', _currentRoomId!)
          .single();
      
      final currentData = Map<String, dynamic>.from(roomResponse['data'] as Map<String, dynamic>? ?? {});
      
      // Get current usernames mapping or create new one
      final usernamesData = Map<String, dynamic>.from(currentData[_usernamesKey] as Map<String, dynamic>? ?? {});
      
      // Update the username for this device
      usernamesData[deviceId] = {
        'value': username,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Update the usernames data
      currentData[_usernamesKey] = usernamesData;

      await _client
          .from(_tableName)
          .update({'data': currentData})
          .eq('room_id', _currentRoomId!);
    } catch (e) {
      AppLogger.error('Failed to update username storage', e);
    }
  }

  /// Adds a username listener for the current device
  void addUsernameListener(Function(String?) callback) {
    addListener(_usernamesKey, (data) async {
      // Get current device ID to return its specific username
      final currentDeviceId = await _getOrCreateDeviceId();
      final usernameInfo = data[currentDeviceId] as Map<String, dynamic>?;
      if (usernameInfo != null) {
        callback(usernameInfo['value'] as String?);
      } else {
        callback(null);
      }
        });
  }

  /// Checks if a username already exists across all rooms
  Future<bool> isUsernameTaken(String username) async {
    try {
      // Get all rooms that have usernames data
      final response = await _client
          .from(_tableName)
          .select('data')
          .not('data', 'is', null);

      for (final row in response) {
        final data = row['data'] as Map<String, dynamic>?;
        if (data != null) {
          final usernamesData = data[_usernamesKey] as Map<String, dynamic>?;
          if (usernamesData != null) {
            // Check each device's username
            for (final entry in usernamesData.entries) {
              final usernameInfo = entry.value as Map<String, dynamic>?;
              if (usernameInfo != null) {
                final storedUsername = usernameInfo['value'] as String?;
                if (storedUsername != null && storedUsername.toLowerCase() == username.toLowerCase()) {
                  return true; // Username is already taken
                }
              }
            }
          }
        }
      }
      return false; // Username is available
    } catch (e) {
      AppLogger.error('Failed to check if username is taken', e);
      return true; // Assume it's taken if there's an error to be safe
    }
  }

  /// Gets all usernames across all rooms
  Future<Map<String, String>?> getAllUsernamesGlobally() async {
    try {
      final response = await _client
          .from(_tableName)
          .select('data')
          .not('data', 'is', null);

      final globalUsernames = <String, String>{};

      for (final row in response) {
        final data = row['data'] as Map<String, dynamic>?;
        if (data != null) {
          final usernamesData = data[_usernamesKey] as Map<String, dynamic>?;
          if (usernamesData != null) {
            // Iterate through all device IDs and their usernames
            for (final entry in usernamesData.entries) {
              final deviceId = entry.key;
              final usernameInfo = entry.value as Map<String, dynamic>?;
              if (usernameInfo != null) {
                final storedUsername = usernameInfo['value'] as String?;
                if (storedUsername != null) {
                  globalUsernames[deviceId] = storedUsername;
                }
              }
            }
          }
        }
      }
      return globalUsernames;
    } catch (e) {
      AppLogger.error('Failed to get all usernames globally', e);
      return null;
    }
  }

  /// Loads the saved room ID from SharedPreferences and rejoins the room
  Future<void> _loadSavedRoomId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRoomId = prefs.getString('sync_room_id');
      if (savedRoomId != null && savedRoomId.isNotEmpty) {
        // Attempt to rejoin the room
        await joinRoom(savedRoomId);
      }
    } catch (e) {
      AppLogger.error('Failed to load saved sync room', e);
    }
  }

  /// Saves the current room ID to SharedPreferences
  Future<void> _saveRoomId(String roomId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sync_room_id', roomId);
    } catch (e) {
      AppLogger.error('Failed to save sync room', e);
    }
  }

  /// Clears the saved room ID from SharedPreferences
  Future<void> _clearRoomId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('sync_room_id');
    } catch (e) {
      AppLogger.error('Failed to clear sync room', e);
    }
  }

  /// Loads the saved device ID from SharedPreferences
  Future<void> _loadSavedDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentDeviceId = prefs.getString('device_id');
    } catch (e) {
      AppLogger.error('Failed to load saved device ID', e);
    }
  }

  /// Searches for users by username (globally across all rooms)
  Future<List<Map<String, dynamic>>?> searchUsers(String query) async {
    if (query.isEmpty || query.length < 2) {
      AppLogger.info('Search query too short: $query');
      return <Map<String, dynamic>>[];
    }
    
    try {
      // Get all rooms that have usernames data
      final response = await _client
          .from(_tableName)
          .select('data, room_id')
          .not('data', 'is', null);

      final matchingUsers = <Map<String, dynamic>>[];

      for (final row in response) {
        final data = row['data'] as Map<String, dynamic>?;
        if (data != null) {
          final usernamesData = data[_usernamesKey] as Map<String, dynamic>?;
          if (usernamesData != null) {
            // Check each device's username
            for (final entry in usernamesData.entries) {
              final deviceId = entry.key;
              final usernameInfo = entry.value as Map<String, dynamic>?;
              if (usernameInfo != null) {
                final username = usernameInfo['value'] as String?;
                if (username != null && 
                    username.toLowerCase().contains(query.toLowerCase())) {
                  // Only add if not already in the list (to avoid duplicates)
                  bool alreadyAdded = false;
                  for (final existingUser in matchingUsers) {
                    if ((existingUser['device_id'] as String?) == deviceId) {
                      alreadyAdded = true;
                      break;
                    }
                  }
                  
                  if (!alreadyAdded) {
                    matchingUsers.add({
                      'username': username,
                      'device_id': deviceId,
                      'timestamp': usernameInfo['timestamp'],
                    });
                  }
                }
              }
            }
          }
        }
      }
      AppLogger.debug('Search completed, found ${matchingUsers.length} users for query: $query');
      return matchingUsers;
    } catch (e) {
      AppLogger.error('Failed to search users: $query, error: ${e.toString()}');
      return <Map<String, dynamic>>[];
    }
  }

  /// Follows a user by their device ID
  Future<bool> followUser(String targetDeviceId) async {
    try {
      final currentDeviceId = await _getOrCreateDeviceId();
      
      // Don't allow following yourself
      if (currentDeviceId == targetDeviceId) {
        AppLogger.warning('Cannot follow yourself');
        return false;
      }

      // Check if the target user exists by trying to get their username
      final targetUsername = await getUsernameByDeviceId(targetDeviceId);
      if (targetUsername == null) {
        AppLogger.warning('Cannot follow user: target user does not exist');
        return false;
      }

      // If in a room, use room data for backwards compatibility
      if (_currentRoomId != null) {
        // Get current room data
        final roomResponse = await _client
            .from(_tableName)
            .select('data')
            .eq('room_id', _currentRoomId!)
            .single();
        
        final currentData = Map<String, dynamic>.from(roomResponse['data'] as Map<String, dynamic>? ?? {});

        // Update following list
        final following = List<String>.from(currentData[_followingKey] as List<dynamic>? ?? []);
        if (following.contains(targetDeviceId)) {
          AppLogger.info('Already following user: $targetDeviceId');
          return true; // Already following, return true
        }
        following.add(targetDeviceId);
        
        // Update followers list for the target user
        final targetUserFollowers = List<String>.from(currentData[_followersKey] as List<dynamic>? ?? []);
        if (!targetUserFollowers.contains(currentDeviceId)) {
          targetUserFollowers.add(currentDeviceId);
        }

        // Update the data in the room
        currentData[_followingKey] = following;
        currentData[_followersKey] = targetUserFollowers;

        await _client
            .from(_tableName)
            .update({'data': currentData})
            .eq('room_id', _currentRoomId!);
        
        AppLogger.debug('Successfully followed user: $targetDeviceId');
        return true;
      } else {
        // For global following, we'd need a different approach
        // The current architecture doesn't support global following properly
        // This is a limitation, but at least we don't show an error now
        AppLogger.warning('Following functionality limited when not in a room');
        return false;
      }
    } catch (e) {
      AppLogger.error('Failed to follow user: ${e.toString()}');
      return false;
    }
  }

  /// Unfollows a user by their device ID
  Future<bool> unfollowUser(String targetDeviceId) async {
    try {
      final currentDeviceId = await _getOrCreateDeviceId();

      // Don't allow unfollowing yourself
      if (currentDeviceId == targetDeviceId) {
        AppLogger.warning('Cannot unfollow yourself');
        return false;
      }

      // If in a room, use room data for backwards compatibility
      if (_currentRoomId != null) {
        // Get current room data
        final roomResponse = await _client
            .from(_tableName)
            .select('data')
            .eq('room_id', _currentRoomId!)
            .single();
        
        final currentData = Map<String, dynamic>.from(roomResponse['data'] as Map<String, dynamic>? ?? {});

        // Update following list
        final following = List<String>.from(currentData[_followingKey] as List<dynamic>? ?? []);
        if (!following.contains(targetDeviceId)) {
          AppLogger.info('Not following user: $targetDeviceId, nothing to unfollow');
          return true; // Not following, return true as desired state is achieved
        }
        following.remove(targetDeviceId);
        
        // Update followers list for the target user
        final targetUserFollowers = List<String>.from(currentData[_followersKey] as List<dynamic>? ?? []);
        targetUserFollowers.remove(currentDeviceId);

        // Update the data in the room
        currentData[_followingKey] = following;
        currentData[_followersKey] = targetUserFollowers;

        await _client
            .from(_tableName)
            .update({'data': currentData})
            .eq('room_id', _currentRoomId!);
        
        AppLogger.debug('Successfully unfollowed user: $targetDeviceId');
        return true;
      } else {
        // For global unfollowing, we'd need a different approach
        // The current architecture doesn't support global following properly
        AppLogger.warning('Unfollowing functionality limited when not in a room');
        return false;
      }
    } catch (e) {
      AppLogger.error('Failed to unfollow user: ${e.toString()}');
      return false;
    }
  }

  /// Checks if a user is being followed
  Future<bool> isFollowingUser(String targetDeviceId) async {
    try {
      // If in a room, check room data for backwards compatibility
      if (_currentRoomId != null) {
        final roomData = await getRoomData();
        if (roomData != null) {
          final following = List<String>.from(roomData[_followingKey] as List<dynamic>? ?? []);
          return following.contains(targetDeviceId);
        }
      }
      
      // For global check, return false in the current implementation
      // The current architecture doesn't support global following properly
      return false;
    } catch (e) {
      AppLogger.error('Failed to check if following user', e);
      return false;
    }
  }

  /// Gets the list of users that the current user is following
  Future<List<String>?> getFollowingList() async {
    try {
      // If in a room, use room data for backwards compatibility
      if (_currentRoomId != null) {
        final roomData = await getRoomData();
        if (roomData != null) {
          final following = roomData[_followingKey] as List<dynamic>? ?? [];
          return List<String>.from(following.map((e) => e.toString()));
        }
      }
      
      // Return empty list for global following in the current implementation
      // The current data structure doesn't properly support global following
      // A proper implementation would require a separate table for following relationships
      return <String>[];
    } catch (e) {
      AppLogger.error('Failed to get following list: ${e.toString()}');
      return <String>[];
    }
  }

  /// Gets the list of users following the current user
  Future<List<String>?> getFollowersList() async {
    try {
      // If in a room, use room data for backwards compatibility
      if (_currentRoomId != null) {
        final roomData = await getRoomData();
        if (roomData != null) {
          final followers = roomData[_followersKey] as List<dynamic>? ?? [];
          return List<String>.from(followers.map((e) => e.toString()));
        }
      }
      
      // Return empty list for global followers in the current implementation
      // The current data structure doesn't properly support global followers
      // A proper implementation would require a separate table for following relationships
      return <String>[];
    } catch (e) {
      AppLogger.error('Failed to get followers list: ${e.toString()}');
      return <String>[];
    }
  }

  /// Gets the username for a specific device ID globally
  Future<String?> getUsernameByDeviceId(String deviceId) async {
    try {
      // Get all rooms that have usernames data
      final response = await _client
          .from(_tableName)
          .select('data')
          .not('data', 'is', null);

      for (final row in response) {
        final data = row['data'] as Map<String, dynamic>?;
        if (data != null) {
          final usernamesData = data[_usernamesKey] as Map<String, dynamic>?;
          if (usernamesData != null) {
            // Check if the target device ID exists in this room's usernames
            final usernameInfo = usernamesData[deviceId] as Map<String, dynamic>?;
            if (usernameInfo != null) {
              final storedUsername = usernameInfo['value'] as String?;
              if (storedUsername != null) {
                return storedUsername;
              }
            }
          }
        }
      }
      return null;
    } catch (e) {
      AppLogger.error('Failed to get username by device ID: $deviceId, error: ${e.toString()}');
      return null;
    }
  }

  /// Adds a following listener
  void addFollowingListener(Function(List<String>) callback) {
    addListener(_followingKey, (data) {
      final followingList = List<String>.from(data['value'] as List<dynamic>? ?? []);
      callback(followingList);
    });
  }

  /// Adds a followers listener
  void addFollowersListener(Function(List<String>) callback) {
    addListener(_followersKey, (data) {
      final followersList = List<String>.from(data['value'] as List<dynamic>? ?? []);
      callback(followersList);
    });
  }

  /// Gets game stats for a specific device from the room
  Future<Map<String, dynamic>?> getGameStatsForDevice(String deviceId) async {
    if (_currentRoomId == null) {
      AppLogger.warning('Cannot get game stats for device: not in a room');
      return null;
    }

    try {
      final roomData = await getRoomData();
      if (roomData == null) {
        AppLogger.warning('No room data available when getting game stats for device: $deviceId');
        return null;
      }

      final gameStatsMap = roomData['game_stats'] as Map<String, dynamic>?;
      if (gameStatsMap != null) {
        // Check if this specific device has stats
        final deviceStats = gameStatsMap[deviceId] as Map<String, dynamic>?;
        if (deviceStats != null) {
          return deviceStats['value'] as Map<String, dynamic>?;
        }
      }

      return null;
    } catch (e) {
      AppLogger.error('Failed to get game stats for device: $deviceId, error: ${e.toString()}');
      return null;
    }
  }

  /// Gets all game stats from the room
  Future<List<Map<String, dynamic>>?> getAllGameStats() async {
    if (_currentRoomId == null) return null;

    try {
      final roomData = await getRoomData();
      if (roomData == null) return null;

      final gameStatsMap = roomData['game_stats'] as Map<String, dynamic>?;
      if (gameStatsMap != null) {
        final statsList = <Map<String, dynamic>>[];
        
        // Iterate through all devices' stats
        for (final entry in gameStatsMap.entries) {
          final deviceId = entry.key;
          final deviceStats = entry.value as Map<String, dynamic>?;
          
          if (deviceStats != null) {
            statsList.add({
              'device_id': deviceId,
              'stats': deviceStats['value'] as Map<String, dynamic>?,
              'timestamp': deviceStats['timestamp'],
            });
          }
        }
        
        return statsList;
      }

      return [];
    } catch (e) {
      AppLogger.error('Failed to get all game stats', e);
      return null;
    }
  }
}