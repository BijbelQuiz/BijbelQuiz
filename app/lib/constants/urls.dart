import '../config/app_config.dart';

class AppUrls {
  // Base domain
  static String get baseDomain => AppConfig.baseDomain;
  static String get baseDomainAPI => AppConfig.baseDomainAPI;

  // Homepage
  static final String homepage = baseDomain;

  // API endpoints
  static final String emergencyApi = '$baseDomainAPI/emergency.ts';
  static final String scripturaApiBase = 'https://scriptura.bijbelquiz.app/api';

  // Scriptura API Endpoints
  static final String scripturaRandomApi = '$scripturaApiBase/random';
  static final String scripturaBooksApi = '$scripturaApiBase/books';
  static final String scripturaChaptersBaseApi = '$scripturaApiBase/chapters';
  static final String scripturaVersesBaseApi = '$scripturaApiBase/verses';
  static final String scripturaSearchBaseApi = '$scripturaApiBase/search';
  static final String scripturaDaytextBaseApi = '$scripturaApiBase/daytext';
  static final String scripturaSecureDataApi = '$scripturaApiBase/secure-data';
  static final String scripturaParseReferencePostApi = '$scripturaApiBase/parse/reference';
  static final String scripturaParseReferenceGetBaseApi = '$scripturaApiBase/parse/reference';
  static final String scripturaParseReferencesPostApi = '$scripturaApiBase/parse/references';
  static final String scripturaVersionsApi = '$scripturaApiBase/versions';
  static final String scripturaCommentaryBaseApi = '$scripturaApiBase/commentary';

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

  // Contact
  static String get contactEmail => AppConfig.contactEmail;
  static String get contactEmailUrl => '$baseDomain/email';
}