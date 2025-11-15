class AppUrls {
  // Base domains
  static const String baseDomain = 'https://bijbelquiz.app';
  static const String baseDomainAPI = 'https://backend.bijbelquiz.app/api';

  // Homepage
  static final String homepage = baseDomain;

  // ===== API ENDPOINTS =====
  // Bible API
  static final String bibleApiBase = 'https://www.online-bijbel.nl/api.php';

  // AI API
  static final String geminiApiBase =
      'https://generativelanguage.googleapis.com/v1beta';

  // ===== APP-SPECIFIC URLs =====
  // App pages
  static final String donateUrl = '$baseDomain/donate';
  static final String updateUrl = '$baseDomain/download';
  static final String satisfactionSurveyUrl =
      '$baseDomain/tevredenheidsrapport';
  static final String privacyUrl = '$baseDomain/privacy';
  static final String termsUrl = '$baseDomain/algemene-voorwaarden';
  static final String statusPageUrl = '$baseDomain/status';

  // ===== SOCIAL MEDIA URLs (redirect through our own domain) =====
  static String get mastodonUrl => '$baseDomain/mastodon';
  static String get kweblerUrl => '$baseDomain/kwebler';
  static String get discordUrl => '$baseDomain/discord';
  static String get signalUrl => '$baseDomain/signal-group';
  static String get signalContactUrl => '$baseDomain/signal-contact';
  static String get pixelfedUrl => '$baseDomain/pixelfed';
  static String get blueskyUrl => '$baseDomain/bluesky';
  static String get nookiUrl => '$baseDomain/nooki';

  // ===== CONTACT =====
  static const String contactEmail = 'thomasnowprod@proton.me';
  static String get contactEmailUrl => '$baseDomain/email';
}
