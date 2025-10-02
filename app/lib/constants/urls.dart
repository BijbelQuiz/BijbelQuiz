import '../config/app_config.dart';

class AppUrls {
  // Base domain
  static String get baseDomain => AppConfig.baseDomain;
  static String get baseDomainAPI => AppConfig.baseDomainAPI;

  // Homepage
  static final String homepage = baseDomain;

  // API endpoints
  static final String emergencyApi = '$baseDomainAPI/emergency.ts';
  static final String bibleApiBase = 'https://www.online-bijbel.nl/api.php';

  // Bible API Endpoints
  static final String bibleBooksListApi = '$bibleApiBase?p=boekenlijst';

  // Other API Endpoints
  static final String stripeWebhookApi = '$baseDomainAPI/stripe/webhook';

  // App-specific URLs
  static final String donateUrl = '$baseDomain/donate';
  static final String updateUrl = '$baseDomain/download.html';
  static final String satisfactionSurveyUrl = '$baseDomain/tevredenheidsrapport';

  // Social media URLs (redirect through our own domain)
  static String get mastodonUrl => '$baseDomain/mastodon';
  static String get kweblerUrl => '$baseDomain/kwebler';
  static String get discordUrl => '$baseDomain/discord';
  static String get signalUrl => '$baseDomain/signal-group';
  static String get signalContactUrl => '$baseDomain/signal-contact';
  static String get pixelfedUrl => '$baseDomain/pixelfed';

  // Contact
  static String get contactEmail => AppConfig.contactEmail;
  static String get contactEmailUrl => '$baseDomain/email';
}