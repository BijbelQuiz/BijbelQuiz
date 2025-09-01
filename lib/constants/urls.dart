/// URL constants for the BijbelQuiz app
/// Central location for all URLs to make updates easier

class AppUrls {
  // Base domain
  static const String baseDomain = 'https://bijbelquiz.app';
  static const String baseDomainAPI = 'https://backend.bijbelquiz.app/api';

  // Homepage
  static const String homepage = baseDomain;

  // API endpoints
  static const String emergencyApi = baseDomainAPI + '/emergency.ts';

  // App-specific URLs
  static const String donateUrl = baseDomain + '/donate.html';
  static const String updateUrl = baseDomain + '/download.html';

  // Social media URLs
  static const String mastodonUrl = 'https://mastodon.social/@bijbelquiz';
  static const String kweblerUrl = 'https://kwebler.com/bijbelquiz';
  static const String discordUrl = 'https://discord.gg/bijbelquiz';
  static const String signalUrl = 'https://signal.group/bijbelquiz';

  // Contact
  static const String contactEmail = 'thomasnowprod@proton.me';
}