import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/supabase_config.dart';
import 'logger.dart';

class SyncService {
  static const String _tableName = 'sync_rooms';
  late final SupabaseClient _client;
  String? _currentRoomId;
  RealtimeChannel? _channel;
  final Map<String, Function(Map<String, dynamic>)> _listeners = {};

  SyncService() {
    _client = SupabaseConfig.client;
  }

  /// Initializes the service, including loading saved room
  Future<void> initialize() async {
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
      await _client.from(_tableName).update({
        'data': {
          key: {
            'value': data,
            'device_id': deviceId,
            'timestamp': DateTime.now().toIso8601String(),
          }
        },
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('room_id', _currentRoomId!);
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
    // For simplicity, use a UUID or device info
    // In a real app, you might use device_info_plus or similar
    return 'device_${DateTime.now().millisecondsSinceEpoch}';
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
    if (_currentDeviceId == null) {
      _currentDeviceId = await _getOrCreateDeviceId();
    }
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
}