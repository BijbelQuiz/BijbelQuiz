import '../config/app_config.dart';

class AppUrls {
  // Base domain
  static String get baseDomain => AppConfig.baseDomain;
  static String get baseDomainAPI => AppConfig.baseDomainAPI;

  // Homepage
  static final String homepage = baseDomain;

  // API endpoints
  static final String emergencyApi = '${baseDomainAPI}/emergency.ts';

  // App-specific URLs
  static final String donateUrl = '${baseDomain}/donate.html';
  static final String updateUrl = '${baseDomain}/download.html';

  // Social media URLs
  static String get mastodonUrl => AppConfig.mastodonUrl;
  static String get kweblerUrl => AppConfig.kweblerUrl;
  static String get discordUrl => AppConfig.discordUrl;
  static String get signalUrl => AppConfig.signalUrl;

  // Contact
  static String get contactEmail => AppConfig.contactEmail;
}