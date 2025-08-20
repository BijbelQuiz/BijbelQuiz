import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class UpdateService {
  static const String _apiBaseUrl = 'https://backendbijbelquiz.vercel.app/api/version';
  static const String _localApiBaseUrl = 'http://localhost:3001/api/version';
  
  // Expose the base URLs
  String get apiBaseUrl => _apiBaseUrl;
  String get localApiBaseUrl => _localApiBaseUrl;
  
  // Unified download page URL
  String get downloadPageUrl => 'https://bijbelquiz.vercel.app/download.html';
  
  // Singleton pattern
  static final UpdateService _instance = UpdateService._internal();
  factory UpdateService() => _instance;
  UpdateService._internal();

  /// Checks if an update is available
  Future<UpdateInfo?> checkForUpdate() async {
    try {
      // Check connectivity first
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // No internet connection
        return null;
      }

      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      
      // Determine platform
      final platform = _getPlatform();
      
      // Use local API in debug mode, production API in release mode
      final baseUrl = kDebugMode ? _localApiBaseUrl : _apiBaseUrl;
      
      // Make API request
      final uri = Uri.parse('$baseUrl?platform=$platform&currentVersion=$currentVersion');
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        final newVersion = data['version'] as String;
        final releaseNotes = data['releaseNotes'] as String;
        final downloadEndpoint = data['downloadEndpoint'] as String;
        
        // Compare versions
        if (_isVersionHigher(newVersion, currentVersion)) {
          return UpdateInfo(
            currentVersion: currentVersion,
            newVersion: newVersion,
            releaseNotes: releaseNotes,
            downloadEndpoint: downloadEndpoint,
            platform: platform,
          );
        }
      }
      
      return null;
    } catch (e) {
      // Silently fail - we don't want update checks to break the app
      return null;
    }
  }
  
  /// Gets the URL for the unified download page
  String getDownloadPageUrl({String? platform, String? currentVersion}) {
    final params = <String>[];
    if (platform != null) params.add('platform=$platform');
    if (currentVersion != null) params.add('current=$currentVersion');
    
    final queryString = params.isEmpty ? '' : '?${params.join('&')}';
    return 'https://bijbelquiz.vercel.app/download.html$queryString';
  }
  
  /// Gets the platform identifier
  String _getPlatform() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'android'; // default
  }
  
  /// Compares two version strings (e.g., "1.2.3" vs "1.2.4")
  bool _isVersionHigher(String newVersion, String currentVersion) {
    final newParts = newVersion.split('.').map(int.parse).toList();
    final currentParts = currentVersion.split('.').map(int.parse).toList();
    
    // Pad shorter version with zeros
    while (newParts.length < currentParts.length) {
      newParts.add(0);
    }
    while (currentParts.length < newParts.length) {
      currentParts.add(0);
    }
    
    // Compare each part
    for (int i = 0; i < newParts.length; i++) {
      if (newParts[i] > currentParts[i]) return true;
      if (newParts[i] < currentParts[i]) return false;
    }
    
    return false; // Versions are equal
  }
}

class UpdateInfo {
  final String currentVersion;
  final String newVersion;
  final String releaseNotes;
  final String downloadEndpoint;
  final String platform;
  
  UpdateInfo({
    required this.currentVersion,
    required this.newVersion,
    required this.releaseNotes,
    required this.downloadEndpoint,
    required this.platform,
  });
}