import '../config/app_config.dart';

class AppUrls {
  // Base domains
  static String get baseDomain => AppConfig.baseDomain;
  static String get baseDomainAPI => AppConfig.baseDomainAPI;

  // Homepage
  static final String homepage = baseDomain;

  // ===== API ENDPOINTS =====
  // Bible API
  static final String bibleApiBase = 'https://www.online-bijbel.nl/api.php';

  // Analytics API
  static final String posthogHost = 'https://us.i.posthog.com';

  // AI API
  static final String geminiApiBase = 'https://generativelanguage.googleapis.com/v1beta';

  // ===== APP-SPECIFIC URLs =====
  // App pages
  static final String donateUrl = '$baseDomain/donate';
  static final String updateUrl = '$baseDomain/download';
  static final String satisfactionSurveyUrl = '$baseDomain/tevredenheidsrapport';
  static final String privacyUrl = '$baseDomain/privacy';
  static final String statusPageUrl = 'https://oneuptime.com/status-page/df067f1b-2beb-42d2-9ddd-719e9ce51238';

  // ===== SOCIAL MEDIA URLs (redirect through our own domain) =====
  static String get mastodonUrl => '$baseDomain/mastodon';
  static String get kweblerUrl => '$baseDomain/kwebler';
  static String get discordUrl => '$baseDomain/discord';
  static String get signalUrl => '$baseDomain/signal-group';
  static String get signalContactUrl => '$baseDomain/signal-contact';
  static String get pixelfedUrl => '$baseDomain/pixelfed';
  static String get blueskyUrl => '$baseDomain/bluesky';

  // ===== CONTACT =====
  static String get contactEmail => AppConfig.contactEmail;
  static String get contactEmailUrl => '$baseDomain/email';
}