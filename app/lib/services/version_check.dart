import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bijbelquiz/services/logger.dart';

bool get _isLinux => !kIsWeb && Platform.isLinux;

class VersionInfo {
  final String latestVersion;
  final String? linuxVersion;
  final String? androidVersion;
  final String? webVersion;

  VersionInfo({
    required this.latestVersion,
    this.linuxVersion,
    this.androidVersion,
    this.webVersion,
  });

  factory VersionInfo.fromMetaTags(Map<String, String> metaTags) {
    return VersionInfo(
      latestVersion: metaTags['app-version'] ?? '',
      linuxVersion: metaTags['app-version-linux'],
      androidVersion: metaTags['app-version-android'],
      webVersion: metaTags['app-version-web'],
    );
  }

  bool isUpdateAvailable(String currentVersion, String platform) {
    String? targetVersion;
    switch (platform) {
      case 'linux':
        targetVersion = linuxVersion;
      case 'android':
        targetVersion = androidVersion;
      case 'web':
        targetVersion = webVersion;
      default:
        targetVersion = latestVersion;
    }

    // If no valid target version exists, no update is available
    if (targetVersion == null || targetVersion.isEmpty) {
      return false;
    }

    final result = _compareVersions(currentVersion, targetVersion);
    final isUpdateAvailable = result < 0;
    AppLogger.debug(
        'Version check: current=$currentVersion, target=$targetVersion, comparison=$result, update=$isUpdateAvailable');
    return isUpdateAvailable;
  }

  int _compareVersions(String a, String b) {
    final aParts = a.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final bParts = b.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    for (int i = 0; i < max(aParts.length, bParts.length); i++) {
      final aVal = i < aParts.length ? aParts[i] : 0;
      final bVal = i < bParts.length ? bParts[i] : 0;
      if (aVal < bVal) return -1;
      if (aVal > bVal) return 1;
    }
    return 0;
  }
}

class VersionCheckService {
  static const String _baseUrl = 'https://bijbelquiz.thomasboom.com';
  static const String _downloadPath = '/download.html';
  static const String _prefKeyUpdateDismissed = 'update_notification_dismissed';

  Future<VersionInfo?> checkForUpdates() async {
    try {
      AppLogger.debug('Fetching version info from $_baseUrl$_downloadPath');
      final response = await http
          .get(Uri.parse('$_baseUrl$_downloadPath'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        AppLogger.error('Version check failed: HTTP ${response.statusCode}');
        return null;
      }

      final metaTags = _parseMetaTags(response.body);
      AppLogger.debug('Parsed meta tags: $metaTags');

      if (metaTags.isEmpty) {
        AppLogger.warning('No version meta tags found');
        return null;
      }

      return VersionInfo.fromMetaTags(metaTags);
    } catch (e) {
      AppLogger.error('Version check error', e);
      return null;
    }
  }

  Map<String, String> _parseMetaTags(String html) {
    final Map<String, String> tags = {};
    // Match any <meta ...> tag (case-insensitive, multiline)
    final metaRegex = RegExp(
      r'<meta\s+([^>]+)>',
      caseSensitive: false,
      multiLine: true,
    );
    final matches = metaRegex.allMatches(html);

    // Regex to extract name attribute (supports single/double quotes)
    // Using non-raw string to properly escape quotes
    final nameRegex = RegExp(
      'name\\s*=\\s*["\'](app-version[^"\']*)["\']',
      caseSensitive: false,
    );
    // Regex to extract content attribute (supports single/double quotes)
    final contentRegex = RegExp(
      'content\\s*=\\s*["\']([^"\']*)["\']',
      caseSensitive: false,
    );

    for (final match in matches) {
      final tagContent = match.group(1) ?? '';

      final nameMatch = nameRegex.firstMatch(tagContent);
      final contentMatch = contentRegex.firstMatch(tagContent);

      if (nameMatch != null && contentMatch != null) {
        final name = nameMatch.group(1)!;
        final content = contentMatch.group(1)!;
        tags[name] = content;
      }
    }
    return tags;
  }

  Future<bool> shouldShowUpdateNotification(String platform) async {
    AppLogger.debug(
        'Checking for updates on platform: $platform, isLinux: $_isLinux, kIsWeb: $kIsWeb');

    if (!kIsWeb && !_isLinux) {
      AppLogger.debug('Skipping update check - not Linux or web');
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final dismissedVersion = prefs.getString(_prefKeyUpdateDismissed);

    final versionInfo = await checkForUpdates();
    if (versionInfo == null) return false;

    final packageInfo = await PackageInfo.fromPlatform();
    AppLogger.debug('Current app version: ${packageInfo.version}');

    final isUpdate =
        versionInfo.isUpdateAvailable(packageInfo.version, platform);
    AppLogger.debug('Update available: $isUpdate');

    if (isUpdate && dismissedVersion != packageInfo.version) {
      return true;
    }

    return false;
  }

  Future<void> dismissUpdateNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();
    await prefs.setString(_prefKeyUpdateDismissed, packageInfo.version);
  }
}
