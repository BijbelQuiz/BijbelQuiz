class AppUrls {
  // Base domains
  static const String baseDomain = 'https://bijbelquiz.thomasboom.com';
  static const String backendDomain = 'https://backend.bijbelquiz.thomasboom.com';

  // Homepage
  static final String homepage = baseDomain;

  // ===== API ENDPOINTS =====
  // Bible API
  static final String bibleApiBase = 'https://www.online-bijbel.nl/api.php';

  // AI API (proxied through our backend for security)
  static final String geminiApiBase = '$backendDomain/api/gemini';

  // ===== APP-SPECIFIC URLs =====
  // App pages
  static final String donateUrl = '$baseDomain/donate';
  static final String updateUrl = '$baseDomain/download';
  static final String satisfactionSurveyUrl =
      '$baseDomain/tevredenheidsrapport';
  static final String privacyUrl = '$baseDomain/privacy';
  static final String termsUrl = '$baseDomain/algemene-voorwaarden';
  static final String statusPageUrl = '$baseDomain/status';
  static const String statusJsonUrl =
      'https://status.bijbelquiz.thomasboom.com/status.json';

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
