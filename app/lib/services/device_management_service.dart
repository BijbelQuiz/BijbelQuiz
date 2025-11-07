import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../services/logger.dart';

/// Enhanced device management service for reliable device identification
class DeviceManagementService {
  static DeviceManagementService? _instance;
  static DeviceManagementService get instance => _instance ??= DeviceManagementService._();
  
  DeviceManagementService._();

  static const String _deviceInfoKey = 'device_info_v2';
  static const String _deviceIdKey = 'device_id_v2';
  static const String _deviceAliasesKey = 'device_aliases_v2';
  static const String _lastSeenKey = 'last_seen_v2';
  
  static const int DEVICE_NAME_MAX_LENGTH = 50;
  static const int MAX_DEVICE_ALIASES = 10;
  
  DeviceInfo? _currentDeviceInfo;
  String? _currentDeviceId;
  String? _currentDeviceAlias;
  final Map<String, String> _deviceAliases = {};
  DateTime? _lastSeen;

  /// Current device information
  DeviceInfo? get currentDeviceInfo => _currentDeviceInfo;
  
  /// Current device ID
  String? get currentDeviceId => _currentDeviceId;
  
  /// Current device alias (user-friendly name)
  String? get currentDeviceAlias => _currentDeviceAlias;
  
  /// Last time this device was active
  DateTime? get lastSeen => _lastSeen;

  /// Initialize the device management service
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing DeviceManagementService...');
      
      await _loadDeviceInfo();
      await _loadDeviceId();
      await _loadDeviceAliases();
      await _loadLastSeen();
      
      // If no device alias exists, create a default one
      if (_currentDeviceAlias == null) {
        await _generateDefaultDeviceAlias();
      }
      
      // Update last seen timestamp
      await _updateLastSeen();
      
      AppLogger.info('DeviceManagementService initialized: $_currentDeviceAlias ($_currentDeviceId)');
    } catch (e) {
      AppLogger.error('Failed to initialize DeviceManagementService', e);
    }
  }

  /// Gets comprehensive device information
  Future<DeviceInfo> getDeviceInfo() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return DeviceInfo(
          platform: 'android',
          model: androidInfo.model,
          brand: androidInfo.brand,
          device: androidInfo.device,
          version: androidInfo.version.release,
          sdkInt: androidInfo.version.sdkInt,
          appVersion: '1.0.0', // This would come from app info
          uniqueId: await _getOrCreateUniqueId(),
        );
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return DeviceInfo(
          platform: 'ios',
          model: iosInfo.model,
          brand: 'Apple',
          device: iosInfo.name,
          version: iosInfo.systemVersion,
          sdkInt: null, // iOS doesn't have SDK int
          appVersion: '1.0.0', // This would come from app info
          uniqueId: await _getOrCreateUniqueId(),
        );
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
        return DeviceInfo(
          platform: 'linux',
          model: linuxInfo.name ?? 'Unknown',
          brand: 'Linux',
          device: linuxInfo.name ?? 'Unknown',
          version: linuxInfo.version ?? 'Unknown',
          sdkInt: null,
          appVersion: '1.0.0',
          uniqueId: await _getOrCreateUniqueId(),
        );
      } else {
        // Fallback for other platforms
        return DeviceInfo(
          platform: 'unknown',
          model: 'Unknown',
          brand: 'Unknown',
          device: 'Unknown',
          version: 'Unknown',
          sdkInt: null,
          appVersion: '1.0.0',
          uniqueId: await _getOrCreateUniqueId(),
        );
      }
    } catch (e) {
      AppLogger.error('Failed to get device info', e);
      // Return fallback device info
      return DeviceInfo(
        platform: 'fallback',
        model: 'Fallback Device',
        brand: 'Unknown',
        device: 'Unknown',
        version: '1.0',
        sdkInt: null,
        appVersion: '1.0.0',
        uniqueId: await _getOrCreateUniqueId(),
      );
    }
  }

  /// Generates or retrieves a unique device ID
  Future<String> getUniqueDeviceId() async {
    return await _getOrCreateUniqueId();
  }

  /// Sets a custom device alias
  Future<bool> setDeviceAlias(String alias) async {
    try {
      if (alias.isEmpty || alias.length > DEVICE_NAME_MAX_LENGTH) {
        AppLogger.warning('Invalid device alias: $alias');
        return false;
      }
      
      // Check if alias is already used by another device
      if (await isAliasTaken(alias, excludeCurrentDevice: true)) {
        AppLogger.warning('Device alias already taken: $alias');
        return false;
      }
      
      _currentDeviceAlias = alias;
      await _saveDeviceAlias();
      
      // Update the aliases map
      if (_currentDeviceId != null) {
        _deviceAliases[_currentDeviceId!] = alias;
        await _saveDeviceAliases();
      }
      
      AppLogger.info('Device alias set: $alias');
      return true;
    } catch (e) {
      AppLogger.error('Failed to set device alias', e);
      return false;
    }
  }

  /// Gets all device aliases
  Map<String, String> getDeviceAliases() {
    return Map.from(_deviceAliases);
  }

  /// Checks if a device alias is taken
  Future<bool> isAliasTaken(String alias, {bool excludeCurrentDevice = false}) async {
    try {
      for (final entry in _deviceAliases.entries) {
        if (entry.value.toLowerCase() == alias.toLowerCase()) {
          if (excludeCurrentDevice && entry.key == _currentDeviceId) {
            continue; // Skip current device
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      AppLogger.error('Failed to check if alias is taken', e);
      return true; // Assume taken on error for safety
    }
  }

  /// Removes a device alias
  Future<void> removeDeviceAlias(String deviceId) async {
    try {
      _deviceAliases.remove(deviceId);
      await _saveDeviceAliases();
      AppLogger.info('Removed device alias for: $deviceId');
    } catch (e) {
      AppLogger.error('Failed to remove device alias', e);
    }
  }

  /// Gets device info for a specific device ID
  Future<DeviceInfo?> getDeviceInfoById(String deviceId) async {
    try {
      // This would typically query a server or local cache
      // For now, return a basic structure
      return DeviceInfo(
        platform: 'unknown',
        model: 'Unknown',
        brand: 'Unknown',
        device: 'Unknown',
        version: 'Unknown',
        sdkInt: null,
        appVersion: '1.0.0',
        uniqueId: deviceId,
      );
    } catch (e) {
      AppLogger.error('Failed to get device info for: $deviceId', e);
      return null;
    }
  }

  /// Updates the last seen timestamp for this device
  Future<void> updateLastSeen() async {
    await _updateLastSeen();
  }

  /// Gets the time since this device was last seen
  Duration? getTimeSinceLastSeen() {
    if (_lastSeen == null) return null;
    return DateTime.now().difference(_lastSeen!);
  }

  /// Private helper methods
  
  Future<void> _loadDeviceInfo() async {
    try {
      _currentDeviceInfo = await getDeviceInfo();
    } catch (e) {
      AppLogger.error('Failed to load device info', e);
    }
  }

  Future<void> _loadDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentDeviceId = prefs.getString(_deviceIdKey);
      
      if (_currentDeviceId == null) {
        await _createNewDeviceId();
      }
    } catch (e) {
      AppLogger.error('Failed to load device ID', e);
      // Create a temporary device ID
      _currentDeviceId = 'temp_device_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<void> _createNewDeviceId() async {
    try {
      final uuid = const Uuid();
      _currentDeviceId = 'bq_device_${uuid.v4()}';
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_deviceIdKey, _currentDeviceId!);
      
      AppLogger.info('Created new device ID: $_currentDeviceId');
    } catch (e) {
      AppLogger.error('Failed to create new device ID', e);
      _currentDeviceId = 'fallback_device_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<String> _getOrCreateUniqueId() async {
    if (_currentDeviceId != null) {
      return _currentDeviceId!;
    }
    
    await _loadDeviceId();
    return _currentDeviceId!;
  }

  Future<void> _loadDeviceAlias() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentDeviceAlias = prefs.getString('device_alias_v2');
    } catch (e) {
      AppLogger.error('Failed to load device alias', e);
    }
  }

  Future<void> _saveDeviceAlias() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentDeviceAlias != null) {
        await prefs.setString('device_alias_v2', _currentDeviceAlias!);
      }
    } catch (e) {
      AppLogger.error('Failed to save device alias', e);
    }
  }

  Future<void> _loadDeviceAliases() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final aliasesJson = prefs.getString(_deviceAliasesKey);
      
      if (aliasesJson != null && aliasesJson.isNotEmpty) {
        final Map<String, dynamic> aliasesMap = json.decode(aliasesJson);
        _deviceAliases.clear();
        aliasesMap.forEach((key, value) {
          _deviceAliases[key] = value.toString();
        });
      }
    } catch (e) {
      AppLogger.error('Failed to load device aliases', e);
    }
  }

  Future<void> _saveDeviceAliases() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_deviceAliasesKey, json.encode(_deviceAliases));
    } catch (e) {
      AppLogger.error('Failed to save device aliases', e);
    }
  }

  Future<void> _loadLastSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSeenMs = prefs.getInt(_lastSeenKey);
      if (lastSeenMs != null) {
        _lastSeen = DateTime.fromMillisecondsSinceEpoch(lastSeenMs);
      }
    } catch (e) {
      AppLogger.error('Failed to load last seen', e);
    }
  }

  Future<void> _updateLastSeen() async {
    try {
      _lastSeen = DateTime.now();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastSeenKey, _lastSeen!.millisecondsSinceEpoch);
    } catch (e) {
      AppLogger.error('Failed to update last seen', e);
    }
  }

  Future<void> _generateDefaultDeviceAlias() async {
    try {
      final deviceInfo = await getDeviceInfo();
      String alias;
      
      // Generate a user-friendly device name
      if (deviceInfo.platform == 'android' || deviceInfo.platform == 'ios') {
        alias = '${deviceInfo.brand} ${deviceInfo.model}';
      } else {
        final firstChar = deviceInfo.platform.isNotEmpty ? deviceInfo.platform[0].toUpperCase() : '';
        final restOfName = deviceInfo.platform.length > 1 ? deviceInfo.platform.substring(1) : '';
        alias = '$firstChar$restOfName Device';
      }
      
      // Ensure alias is not too long
      if (alias.length > DEVICE_NAME_MAX_LENGTH) {
        alias = alias.substring(0, DEVICE_NAME_MAX_LENGTH - 3) + '...';
      }
      
      // Add a number suffix if needed to make it unique
      String baseAlias = alias;
      int counter = 1;
      
      while (await isAliasTaken(alias, excludeCurrentDevice: true)) {
        alias = '$baseAlias ($counter)';
        counter++;
        
        if (alias.length > DEVICE_NAME_MAX_LENGTH) {
          // Fallback to platform + number
          alias = '${deviceInfo.platform} Device ($counter)';
          if (alias.length > DEVICE_NAME_MAX_LENGTH) {
            alias = '${deviceInfo.platform} ($counter)';
          }
        }
      }
      
      await setDeviceAlias(alias);
    } catch (e) {
      AppLogger.error('Failed to generate default device alias', e);
      _currentDeviceAlias = 'My Device';
    }
  }
}

/// Device information class
class DeviceInfo {
  final String platform;
  final String model;
  final String brand;
  final String device;
  final String version;
  final int? sdkInt;
  final String appVersion;
  final String uniqueId;

  DeviceInfo({
    required this.platform,
    required this.model,
    required this.brand,
    required this.device,
    required this.version,
    required this.sdkInt,
    required this.appVersion,
    required this.uniqueId,
  });

  /// Gets a user-friendly device name
  String get displayName {
    if (brand.isNotEmpty && model.isNotEmpty && brand.toLowerCase() != model.toLowerCase()) {
      return '$brand $model';
    }
    return model.isNotEmpty ? model : platform;
  }

  /// Gets device information as a map for serialization
  Map<String, dynamic> toMap() {
    return {
      'platform': platform,
      'model': model,
      'brand': brand,
      'device': device,
      'version': version,
      'sdkInt': sdkInt,
      'appVersion': appVersion,
      'uniqueId': uniqueId,
      'displayName': displayName,
    };
  }

  /// Creates device info from a map
  factory DeviceInfo.fromMap(Map<String, dynamic> map) {
    return DeviceInfo(
      platform: map['platform'] as String? ?? 'unknown',
      model: map['model'] as String? ?? 'Unknown',
      brand: map['brand'] as String? ?? 'Unknown',
      device: map['device'] as String? ?? 'Unknown',
      version: map['version'] as String? ?? 'Unknown',
      sdkInt: map['sdkInt'] as int?,
      appVersion: map['appVersion'] as String? ?? '1.0.0',
      uniqueId: map['uniqueId'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'DeviceInfo(platform: $platform, model: $model, brand: $brand, device: $device, version: $version, uniqueId: $uniqueId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeviceInfo && other.uniqueId == uniqueId;
  }

  @override
  int get hashCode => uniqueId.hashCode;
}