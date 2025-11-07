import 'dart:async';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/supabase_config.dart';
import 'logger.dart';

/// Centralized sync service that manages all sync operations across the app
/// Replaces individual SyncService instances in each provider
class CentralizedSyncService {
  static CentralizedSyncService? _instance;
  static CentralizedSyncService get instance => _instance ??= CentralizedSyncService._();
  
  CentralizedSyncService._();

  static const String _tableName = 'sync_rooms';
  static const String _usernamesKey = 'usernames';
  static const String _followingKey = 'following';
  static const String _followersKey = 'followers';
  static const String _syncQueueKey = 'sync_queue_v2';
  static const String _lastSyncTimestampKey = 'last_sync_timestamp';
  
  late final SupabaseClient _client;
  String? _currentRoomId;
  RealtimeChannel? _channel;
  
  // Sync state management
  bool _isInitialized = false;
  bool _isInRoom = false;
  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  
  // Event streams for real-time communication
  final StreamController<SyncEvent> _eventController = StreamController<SyncEvent>.broadcast();
  final Map<String, List<Function(Map<String, dynamic>)>> _listeners = {};
  
  // Sync queue for reliable operations
  final List<SyncOperation> _syncQueue = [];
  Timer? _syncQueueTimer;
  
  // Current device information
  String? _currentDeviceId;
  String? _currentUsername;

  /// Stream of sync events for UI and other components
  Stream<SyncEvent> get eventStream => _eventController.stream;
  
  /// Whether the service is currently in a sync room
  bool get isInRoom => _isInRoom;
  
  /// Whether the service is currently syncing
  bool get isSyncing => _isSyncing;
  
  /// Current room ID
  String? get currentRoomId => _currentRoomId;
  
  /// Current device ID
  Future<String> get currentDeviceId async {
    _currentDeviceId ??= await _getOrCreateUniqueDeviceId();
    return _currentDeviceId!;
  }
  
  /// Current username
  String? get currentUsername => _currentUsername;

  /// Initialize the centralized sync service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      AppLogger.info('Initializing CentralizedSyncService...');
      _client = SupabaseConfig.client;
      
      // Load saved room and device info
      await _loadSavedDeviceId();
      await _loadSavedRoomState();
      await _loadSyncQueue();
      
      _isInitialized = true;
      AppLogger.info('CentralizedSyncService initialized successfully');
      
      // Start processing the sync queue
      _startSyncQueueProcessor();
      
    } catch (e) {
      AppLogger.error('Failed to initialize CentralizedSyncService', e);
      rethrow;
    }
  }

  /// Joins a sync room with improved reliability
  Future<bool> joinRoom(String code) async {
    try {
      if (_isInRoom) {
        await leaveRoom();
      }
      
      final deviceId = await currentDeviceId;
      AppLogger.info('Joining room $code with device $deviceId');
      
      // Check if room exists, create if not
      final roomResponse = await _client
          .from(_tableName)
          .select()
          .eq('room_id', code)
          .maybeSingle();

      if (roomResponse == null) {
        // Create new room with enhanced metadata
        try {
          await _client.from(_tableName).insert({
            'room_id': code,
            'created_at': DateTime.now().toIso8601String(),
            'devices': [deviceId],
            'data': {},
            'metadata': {
              'version': '2.0',
              'created_by_device': deviceId,
              'room_type': 'bible_quiz',
            },
          });
        } catch (metadataError) {
          // Fallback to schema without metadata column
          if (metadataError.toString().contains('metadata')) {
            AppLogger.info('Falling back to schema without metadata column');
            await _client.from(_tableName).insert({
              'room_id': code,
              'created_at': DateTime.now().toIso8601String(),
              'devices': [deviceId],
              'data': {},
            });
          } else {
            rethrow;
          }
        }
        AppLogger.info('Created new room: $code');
      } else {
        // Add device to existing room
        final devices = List<String>.from(roomResponse['devices'] ?? []);
        if (!devices.contains(deviceId)) {
          devices.add(deviceId);
          try {
            await _client
                .from(_tableName)
                .update({
                  'devices': devices,
                  'updated_at': DateTime.now().toIso8601String(),
                })
                .eq('room_id', code);
          } catch (updateError) {
            // Fallback to schema without updated_at column
            if (updateError.toString().contains('updated_at')) {
              AppLogger.info('Falling back to schema without updated_at column');
              await _client
                  .from(_tableName)
                  .update({
                    'devices': devices,
                  })
                  .eq('room_id', code);
            } else {
              rethrow;
            }
          }
          AppLogger.info('Added device to existing room: $code');
        }
      }

      _currentRoomId = code;
      _isInRoom = true;
      await _saveRoomState();
      _startListening();
      
      _emitEvent(SyncEvent.roomJoined(code));
      return true;
      
    } catch (e) {
      AppLogger.error('Failed to join room: $code', e);
      _emitEvent(SyncEvent.error('join_failed', 'Failed to join room: $code'));
      return false;
    }
  }

  /// Leaves the current sync room
  Future<void> leaveRoom() async {
    if (!_isInRoom || _currentRoomId == null) return;
    
    try {
      final deviceId = await currentDeviceId;
      final roomId = _currentRoomId!;
      
      AppLogger.info('Leaving room: $roomId');
      
      final roomResponse = await _client
          .from(_tableName)
          .select()
          .eq('room_id', roomId)
          .single();

      final devices = List<String>.from(roomResponse['devices'] ?? []);
      devices.remove(deviceId);
      
      await _client
          .from(_tableName)
          .update({
            'devices': devices,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('room_id', roomId);

      // Clear state
      _currentRoomId = null;
      _isInRoom = false;
      _stopListening();
      await _clearRoomState();
      
      _emitEvent(SyncEvent.roomLeft());
      
    } catch (e) {
      AppLogger.error('Failed to leave room', e);
      _emitEvent(SyncEvent.error('leave_failed', 'Failed to leave room'));
    }
  }

  /// Syncs data to the room with queue-based reliability
  Future<void> syncData(String key, Map<String, dynamic> data) async {
    if (!_isInRoom) {
      AppLogger.warning('Cannot sync data: not in a room');
      return;
    }
    
    final operation = SyncOperation(
      type: SyncOperationType.dataSync,
      key: key,
      data: data,
      timestamp: DateTime.now(),
      deviceId: await currentDeviceId,
      roomId: _currentRoomId!,
    );
    
    _addToSyncQueue(operation);
  }

  /// Sets username for current device
  Future<bool> setUsername(String username) async {
    if (!_isInRoom) return false;
    
    try {
      final deviceId = await currentDeviceId;
      
      // Check if username is taken by another device
      if (await _isUsernameGloballyTaken(username, deviceId)) {
        AppLogger.warning('Username "$username" is already taken');
        return false;
      }
      
      // Get current room data
      final roomData = await _getRoomData();
      if (roomData == null) return false;
      
      final currentData = Map<String, dynamic>.from(roomData['data'] as Map<String, dynamic>? ?? {});
      final usernamesData = Map<String, dynamic>.from(currentData[_usernamesKey] as Map<String, dynamic>? ?? {});
      
      // Update username
      usernamesData[deviceId] = {
        'value': username,
        'timestamp': DateTime.now().toIso8601String(),
        'device_id': deviceId,
      };
      
      currentData[_usernamesKey] = usernamesData;
      
      // Queue the update
      final operation = SyncOperation(
        type: SyncOperationType.usernameUpdate,
        key: _usernamesKey,
        data: currentData,
        timestamp: DateTime.now(),
        deviceId: deviceId,
        roomId: _currentRoomId!,
      );
      
      _addToSyncQueue(operation);
      
      _currentUsername = username;
      _emitEvent(SyncEvent.usernameUpdated(username));
      return true;
      
    } catch (e) {
      AppLogger.error('Failed to set username: $username', e);
      return false;
    }
  }

  /// Gets username for current device
  Future<String?> getUsername() async {
    if (!_isInRoom) return null;
    
    try {
      final deviceId = await currentDeviceId;
      return await getUsernameForDevice(deviceId);
    } catch (e) {
      AppLogger.error('Failed to get username', e);
      return null;
    }
  }

  /// Gets username for a specific device
  Future<String?> getUsernameForDevice(String deviceId) async {
    if (!_isInRoom) return null;
    
    try {
      final roomData = await _getRoomData();
      
      if (roomData == null) return null;
      
      final usernamesData = roomData[_usernamesKey] as Map<String, dynamic>?;
      if (usernamesData == null) return null;
      
      final usernameInfo = usernamesData[deviceId] as Map<String, dynamic>?;
      return usernameInfo?['value'] as String?;
      
    } catch (e) {
      AppLogger.error('Failed to get username for device: $deviceId', e);
      return null;
    }
  }

  /// Gets devices in current room
  Future<List<String>?> getDevicesInRoom() async {
    if (!_isInRoom) return null;
    
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

  /// Removes a device from the current room
  Future<bool> removeDevice(String deviceId) async {
    if (!_isInRoom) return false;
    
    try {
      final roomId = _currentRoomId!;
      final roomResponse = await _client
          .from(_tableName)
          .select()
          .eq('room_id', roomId)
          .single();
      
      final devices = List<String>.from(roomResponse['devices'] as List<dynamic> ?? []);
      if (devices.contains(deviceId)) {
        devices.remove(deviceId);
        await _client
            .from(_tableName)
            .update({'devices': devices})
            .eq('room_id', roomId);
        
        _emitEvent(SyncEvent.deviceRemoved(deviceId));
        return true;
      }
      return false;
      
    } catch (e) {
      AppLogger.error('Failed to remove device: $deviceId', e);
      return false;
    }
  }

  /// Adds a data listener
  void addListener(String key, Function(Map<String, dynamic>) callback) {
    if (!_listeners.containsKey(key)) {
      _listeners[key] = [];
    }
    _listeners[key]!.add(callback);
  }

  /// Removes a data listener
  void removeListener(String key, Function(Map<String, dynamic>) callback) {
    _listeners[key]?.remove(callback);
  }

  /// Forces immediate sync of all pending data
  Future<void> forceSyncAll() async {
    if (_syncQueue.isEmpty) return;
    
    AppLogger.info('Forcing sync of ${_syncQueue.length} pending operations');
    _processSyncQueue();
  }

  /// Private helper methods
  
  void _emitEvent(SyncEvent event) {
    _eventController.add(event);
  }

  void _startListening() {
    if (_currentRoomId == null) return;
    
    _stopListening(); // Clean up any existing channel
    
    _channel = _client
        .channel('sync_room_$_currentRoomId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: _tableName,
          callback: (payload) => _handleDataUpdate(payload),
        )
        .subscribe();
        
    AppLogger.debug('Started listening for room updates: $_currentRoomId');
  }

  void _stopListening() {
    if (_channel != null) {
      _channel!.unsubscribe();
      _channel = null;
      AppLogger.debug('Stopped listening for room updates');
    }
  }

  void _handleDataUpdate(PostgresChangePayload payload) {
    try {
      final newRecord = payload.newRecord as Map<String, dynamic>? ?? {};
      final newData = newRecord['data'] as Map<String, dynamic>? ?? {};
      
      AppLogger.debug('Received room data update');
      
      // Notify listeners
      _notifyListeners(newData);
      
      // Update last sync time
      _lastSyncTime = DateTime.now();
      _saveLastSyncTime();
      
    } catch (e) {
      AppLogger.error('Error handling data update', e);
    }
  }

  void _notifyListeners(Map<String, dynamic> data) {
    data.forEach((key, value) {
      final listeners = _listeners[key];
      if (listeners != null && value is Map<String, dynamic>) {
        for (final listener in listeners) {
          try {
            final valueData = value['value'] as Map<String, dynamic>?;
            if (valueData != null) {
              listener(valueData);
            }
          } catch (e) {
            AppLogger.error('Error notifying listener for key: $key', e);
          }
        }
      }
    });
  }

  void _addToSyncQueue(SyncOperation operation) {
    _syncQueue.add(operation);
    _saveSyncQueue();
    
    AppLogger.debug('Added to sync queue: ${operation.type} for ${operation.key}');
    
    // Process queue immediately if not already processing
    if (!_isSyncing) {
      _processSyncQueue();
    }
  }

  void _startSyncQueueProcessor() {
    _syncQueueTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_syncQueue.isNotEmpty && !_isSyncing) {
        _processSyncQueue();
      }
    });
  }

  Future<void> _processSyncQueue() async {
    if (_isSyncing || _syncQueue.isEmpty) return;
    
    _isSyncing = true;
    final operations = List<SyncOperation>.from(_syncQueue);
    
    try {
      AppLogger.debug('Processing ${operations.length} sync operations');
      
      for (final operation in operations) {
        try {
          await _executeSyncOperation(operation);
          _syncQueue.remove(operation);
        } catch (e) {
          AppLogger.error('Failed to execute sync operation: ${operation.type}', e);
          // Keep failed operations in queue for retry
          operation.retryCount++;
          
          if (operation.retryCount >= 3) {
            AppLogger.error('Max retries reached for operation: ${operation.type}');
            _syncQueue.remove(operation);
          }
        }
      }
      
      _saveSyncQueue();
      
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _executeSyncOperation(SyncOperation operation) async {
    if (operation.roomId != _currentRoomId) {
      AppLogger.warning('Skipping operation for different room');
      return;
    }
    
    try {
      switch (operation.type) {
        case SyncOperationType.dataSync:
          await _syncDataToRoom(operation.key, operation.data, operation.deviceId);
          break;
        case SyncOperationType.usernameUpdate:
          await _updateUsernamesInRoom(operation.data);
          break;
        case SyncOperationType.deviceManagement:
          // Handle device management operations
          AppLogger.debug('Processing device management operation');
          break;
        default:
          AppLogger.warning('Unknown sync operation type: ${operation.type}');
          break;
      }
      
      _lastSyncTime = DateTime.now();
      _saveLastSyncTime();
      
      AppLogger.debug('Executed sync operation: ${operation.type}');
      
    } catch (e) {
      AppLogger.error('Failed to execute operation: ${operation.type}', e);
      rethrow;
    }
  }

  Future<void> _syncDataToRoom(String key, Map<String, dynamic> data, String deviceId) async {
    if (_currentRoomId == null) return;
    
    // Get current room data
    final roomResponse = await _client
        .from(_tableName)
        .select('data')
        .eq('room_id', _currentRoomId!)
        .single();
    
    final currentData = Map<String, dynamic>.from(roomResponse['data'] as Map<String, dynamic>? ?? {});
    
    // Handle game stats differently - store per device
    if (key == 'game_stats') {
      final gameStatsMap = Map<String, dynamic>.from(currentData[key] as Map<String, dynamic>? ?? {});
      
      gameStatsMap[deviceId] = {
        'value': data,
        'timestamp': DateTime.now().toIso8601String(),
        'device_id': deviceId,
      };
      
      currentData[key] = gameStatsMap;
    } else {
      // For other data types, use simple key-value storage
      currentData[key] = {
        'value': data,
        'device_id': deviceId,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
    
    await _client
        .from(_tableName)
        .update({
          'data': currentData,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('room_id', _currentRoomId!);
  }

  Future<void> _updateUsernamesInRoom(Map<String, dynamic> roomData) async {
    if (_currentRoomId == null) return;
    
    await _client
        .from(_tableName)
        .update({
          'data': roomData,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('room_id', _currentRoomId!);
  }

  Future<Map<String, dynamic>?> _getRoomData() async {
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

  Future<bool> _isUsernameGloballyTaken(String username, String deviceId) async {
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
            for (final entry in usernamesData.entries) {
              final usernameInfo = entry.value as Map<String, dynamic>?;
              if (usernameInfo != null) {
                final storedUsername = usernameInfo['value'] as String?;
                final entryDeviceId = usernameInfo['device_id'] as String?;
                if (storedUsername != null && 
                    storedUsername.toLowerCase() == username.toLowerCase() &&
                    entryDeviceId != deviceId) {
                  return true;
                }
              }
            }
          }
        }
      }
      return false;
    } catch (e) {
      AppLogger.error('Failed to check username availability', e);
      return true; // Assume taken on error
    }
  }

  // Device ID management with improved uniqueness
  Future<String> _getOrCreateUniqueDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id_v2');
    
    if (deviceId == null) {
      // Generate a more unique device ID using multiple sources
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final hash = (timestamp * 31 + (deviceId?.hashCode ?? 0)).toString();
      deviceId = 'bq_device_${timestamp}_${hash.substring(0, 8)}';
      await prefs.setString('device_id_v2', deviceId);
    }
    
    return deviceId;
  }

  // Persistence methods
  Future<void> _loadSavedDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentDeviceId = prefs.getString('device_id_v2');
    } catch (e) {
      AppLogger.error('Failed to load saved device ID', e);
    }
  }

  Future<void> _loadSavedRoomState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final roomId = prefs.getString('sync_room_id_v2');
      final lastSync = prefs.getString(_lastSyncTimestampKey);
      
      if (roomId != null && roomId.isNotEmpty) {
        _currentRoomId = roomId;
        if (lastSync != null) {
          _lastSyncTime = DateTime.parse(lastSync);
        }
      }
    } catch (e) {
      AppLogger.error('Failed to load saved room state', e);
    }
  }

  Future<void> _saveRoomState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentRoomId != null) {
        await prefs.setString('sync_room_id_v2', _currentRoomId!);
      }
    } catch (e) {
      AppLogger.error('Failed to save room state', e);
    }
  }

  Future<void> _clearRoomState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('sync_room_id_v2');
    } catch (e) {
      AppLogger.error('Failed to clear room state', e);
    }
  }

  Future<void> _saveLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_lastSyncTime != null) {
        await prefs.setString(_lastSyncTimestampKey, _lastSyncTime!.toIso8601String());
      }
    } catch (e) {
      AppLogger.error('Failed to save last sync time', e);
    }
  }

  Future<void> _loadSyncQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getString(_syncQueueKey);
      
      if (queueJson != null && queueJson.isNotEmpty) {
        final List<dynamic> queueList = json.decode(queueJson);
        _syncQueue.clear();
        
        for (final item in queueList) {
          try {
            final operation = SyncOperation.fromJson(Map<String, dynamic>.from(item));
            _syncQueue.add(operation);
          } catch (e) {
            AppLogger.error('Failed to parse sync operation from queue', e);
          }
        }
        
        AppLogger.debug('Loaded ${_syncQueue.length} operations from sync queue');
      }
    } catch (e) {
      AppLogger.error('Failed to load sync queue', e);
    }
  }

  Future<void> _saveSyncQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueList = _syncQueue.map((op) => op.toJson()).toList();
      await prefs.setString(_syncQueueKey, json.encode(queueList));
    } catch (e) {
      AppLogger.error('Failed to save sync queue', e);
    }
  }

  /// Cleanup resources
  void dispose() {
    _syncQueueTimer?.cancel();
    _channel?.unsubscribe();
    _eventController.close();
  }
}

/// Sync event types for real-time communication
class SyncEvent {
  final SyncEventType type;
  final String? message;
  final Map<String, dynamic>? data;
  
  SyncEvent._(this.type, {this.message, this.data});
  
  factory SyncEvent.roomJoined(String roomId) => SyncEvent._(
    SyncEventType.roomJoined,
    data: {'roomId': roomId},
  );
  
  factory SyncEvent.roomLeft() => SyncEvent._(SyncEventType.roomLeft);
  
  factory SyncEvent.usernameUpdated(String username) => SyncEvent._(
    SyncEventType.usernameUpdated,
    data: {'username': username},
  );
  
  factory SyncEvent.deviceRemoved(String deviceId) => SyncEvent._(
    SyncEventType.deviceRemoved,
    data: {'deviceId': deviceId},
  );
  
  factory SyncEvent.error(String code, String message) => SyncEvent._(
    SyncEventType.error,
    message: message,
    data: {'code': code},
  );
}

enum SyncEventType {
  roomJoined,
  roomLeft,
  usernameUpdated,
  deviceRemoved,
  error,
}

/// Sync operation for queue-based reliable syncing
class SyncOperation {
  final SyncOperationType type;
  final String key;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String deviceId;
  final String roomId;
  int retryCount = 0;
  
  SyncOperation({
    required this.type,
    required this.key,
    required this.data,
    required this.timestamp,
    required this.deviceId,
    required this.roomId,
  });
  
  Map<String, dynamic> toJson() => {
    'type': type.toString().split('.').last,
    'key': key,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'deviceId': deviceId,
    'roomId': roomId,
    'retryCount': retryCount,
  };
  
  static SyncOperation fromJson(Map<String, dynamic> json) => SyncOperation(
    type: SyncOperationType.values.firstWhere(
      (e) => e.toString().endsWith(json['type'] as String),
    ),
    key: json['key'] as String,
    data: Map<String, dynamic>.from(json['data'] as Map),
    timestamp: DateTime.parse(json['timestamp'] as String),
    deviceId: json['deviceId'] as String,
    roomId: json['roomId'] as String,
  )..retryCount = json['retryCount'] as int? ?? 0;
}

enum SyncOperationType {
  dataSync,
  usernameUpdate,
  deviceManagement,
}