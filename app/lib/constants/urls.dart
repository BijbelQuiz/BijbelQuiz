import '../config/app_config.dart';

class AppUrls {
  // Base domain
  static String get baseDomain => AppConfig.baseDomain;
  static String get baseDomainAPI => AppConfig.baseDomainAPI;

  // Homepage
  static final String homepage = baseDomain;

  // API endpoints
  static final String emergencyApi = '$baseDomainAPI/emergency.ts';

  // App-specific URLs
  static final String donateUrl = '$baseDomain/donate.html';
  static final String updateUrl = '$baseDomain/download.html';

  // Social media URLs (redirect through our own domain)
  static String get mastodonUrl => '$baseDomain/r/mastodon';
  static String get kweblerUrl => '$baseDomain/r/kwebler';
  static String get discordUrl => '$baseDomain/r/discord';
  static String get signalUrl => '$baseDomain/r/signal';

  // Contact
  static String get contactEmail => AppConfig.contactEmail;
}