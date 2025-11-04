import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;
import '../providers/settings_provider.dart';
import '../constants/urls.dart';
import 'logger.dart';
import '../widgets/common_widgets.dart';

/// A service that provides an interface to the PostHog analytics service.
///
/// This service is a singleton and can be accessed using `Provider.of<AnalyticsService>(context)`.
class AnalyticsService {
  /// Initializes the PostHog SDK.
  ///
  /// This should be called once when the app starts.
  Future<void> init() async {
    // Skip initialization in debug mode
    if (kDebugMode) {
      AppLogger.info('Skipping PostHog initialization in debug mode');
      return;
    }

    AppLogger.info('Initializing PostHog analytics SDK...');
    try {
      final config = PostHogConfig(
        'phc_WWdBwDKbzwCJ2iRbnWFI8m6lgnVFQCmMouRIaNBV2WF',
      );
      config.host = AppUrls.posthogHost;
      await Posthog().setup(config);
      AppLogger.info('PostHog analytics SDK initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize PostHog analytics SDK', e);
      rethrow;
    }
  }

  /// Returns a [PosthogObserver] that can be used to automatically track screen views.
  PosthogObserver getObserver() => PosthogObserver();

  /// Tracks a screen view.
  ///
  /// This should be called when a screen is displayed.
  /// The [screenName] is the name of the screen.
  Future<void> screen(BuildContext context, String screenName) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    // Skip tracking if analytics are disabled in settings
    if (!settings.analyticsEnabled) {
      AppLogger.info('Analytics disabled in settings, skipping screen tracking for: $screenName');
      return;
    }

    // Skip tracking in debug mode
    if (kDebugMode) {
      AppLogger.info('Skipping screen tracking in debug mode: $screenName');
      return;
    }

    AppLogger.info('Tracking screen view: $screenName');
    try {
      await Posthog().screen(screenName: screenName);
      AppLogger.info('Screen view tracked successfully: $screenName');
    } catch (e) {
      AppLogger.error('Failed to track screen view: $screenName', e);
    }
  }

  /// Tracks an event.
  ///
  /// The [eventName] is the name of the event.
  /// The [properties] are any additional data to send with the event.
  Future<void> capture(BuildContext context, String eventName, {Map<String, Object>? properties}) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    // Skip tracking if analytics are disabled in settings
    if (!settings.analyticsEnabled) {
      AppLogger.info('Analytics disabled in settings, skipping event tracking for: $eventName');
      return;
    }

    // Skip tracking in debug mode
    if (kDebugMode) {
      AppLogger.info('Skipping event tracking in debug mode: $eventName');
      return;
    }

    AppLogger.info('Tracking event: $eventName${properties != null ? ' with properties: $properties' : ''}');
    try {
      await Posthog().capture(eventName: eventName, properties: properties);
      AppLogger.info('Event tracked successfully: $eventName');
    } catch (e) {
      AppLogger.error('Failed to track event: $eventName', e);
    }
  }

  // ===== COMPREHENSIVE FEATURE USAGE TRACKING =====

  /// Standardized feature names for consistent tracking
  static const String FEATURE_QUIZ_GAMEPLAY = 'quiz_gameplay';
  static const String FEATURE_LESSON_SYSTEM = 'lesson_system';
  static const String FEATURE_QUESTION_CATEGORIES = 'question_categories';
  static const String FEATURE_BIBLICAL_REFERENCES = 'biblical_references';
  static const String FEATURE_SKIP_QUESTION = 'skip_question';
  static const String FEATURE_RETRY_WITH_POINTS = 'retry_with_points';
  static const String FEATURE_STREAK_TRACKING = 'streak_tracking';
  static const String FEATURE_PROGRESSIVE_DIFFICULTY = 'progressive_difficulty';
  static const String FEATURE_POWER_UPS = 'power_ups';
  static const String FEATURE_THEME_PURCHASES = 'theme_purchases';
  static const String FEATURE_AI_THEME_GENERATOR = 'ai_theme_generator';
  static const String FEATURE_SOCIAL_FEATURES = 'social_features';
  static const String FEATURE_PROMO_CARDS = 'promo_cards';
  static const String FEATURE_SETTINGS = 'settings';
  static const String FEATURE_THEME_SELECTION = 'theme_selection';
  static const String FEATURE_ANALYTICS_SETTINGS = 'analytics_settings';
  static const String FEATURE_LANGUAGE_SETTINGS = 'language_settings';
  static const String FEATURE_ONBOARDING = 'onboarding';
  static const String FEATURE_DONATION_SYSTEM = 'donation_system';
  static const String FEATURE_SATISFACTION_SURVEYS = 'satisfaction_surveys';
  static const String FEATURE_DIFFICULTY_FEEDBACK = 'difficulty_feedback';
  static const String FEATURE_MULTIPLAYER_GAME = 'multiplayer_game';

  /// Standardized action names for consistent tracking
  static const String ACTION_ACCESSED = 'accessed';
  static const String ACTION_USED = 'used';
  static const String ACTION_PURCHASED = 'purchased';
  static const String ACTION_UNLOCKED = 'unlocked';
  static const String ACTION_ATTEMPTED = 'attempted';
  static const String ACTION_COMPLETED = 'completed';
  static const String ACTION_DISMISSED = 'dismissed';
  static const String ACTION_ENABLED = 'enabled';
  static const String ACTION_DISABLED = 'disabled';
  static const String ACTION_CHANGED = 'changed';

  /// Enhanced feature usage tracking with standardized features and actions
  /// This is the primary method for tracking which features users interact with
  Future<void> trackFeatureUsage(BuildContext context, String feature, String action, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'feature': feature,
      'action': action,
      'timestamp': DateTime.now().toIso8601String(),
      'session_id': _getSessionId(),
      'platform': _getPlatform(),
    });

    await capture(context, 'feature_usage', properties: properties);
  }

  /// Track when a user starts using a feature (for engagement metrics)
  Future<void> trackFeatureStart(BuildContext context, String feature, {Map<String, Object>? additionalProperties}) async {
    await trackFeatureUsage(context, feature, ACTION_ACCESSED, additionalProperties: additionalProperties);
  }

  /// Track when a user successfully uses a feature
  Future<void> trackFeatureSuccess(BuildContext context, String feature, {Map<String, Object>? additionalProperties}) async {
    await trackFeatureUsage(context, feature, ACTION_USED, additionalProperties: additionalProperties);
  }

  /// Track when a user attempts but fails to use a feature
  Future<void> trackFeatureAttempt(BuildContext context, String feature, {Map<String, Object>? additionalProperties}) async {
    await trackFeatureUsage(context, feature, ACTION_ATTEMPTED, additionalProperties: additionalProperties);
  }

  /// Track when a user purchases/unlocks a feature
  Future<void> trackFeaturePurchase(BuildContext context, String feature, {Map<String, Object>? additionalProperties}) async {
    await trackFeatureUsage(context, feature, ACTION_PURCHASED, additionalProperties: additionalProperties);
  }

  /// Track when a user completes a feature or flow
  Future<void> trackFeatureCompletion(BuildContext context, String feature, {Map<String, Object>? additionalProperties}) async {
    await trackFeatureUsage(context, feature, ACTION_COMPLETED, additionalProperties: additionalProperties);
  }

  /// Track when a user dismisses or cancels a feature
  Future<void> trackFeatureDismissal(BuildContext context, String feature, {Map<String, Object>? additionalProperties}) async {
    await trackFeatureUsage(context, feature, ACTION_DISMISSED, additionalProperties: additionalProperties);
  }

  /// Get or create a session ID for tracking user sessions
  String _getSessionId() {
    // In a real implementation, you'd want to persist this across app restarts
    // For now, we'll use a simple timestamp-based session ID
    return 'session_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Get the current platform
  String _getPlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'web';
  }

  /// Get comprehensive feature usage statistics (for reporting)
  Future<Map<String, dynamic>> getFeatureUsageStats(BuildContext context) async {
    // In a real implementation, this would query your analytics backend
    // For now, we'll return a structure that shows what data would be available
    return {
      'total_features_tracked': 20,
      'most_used_features': [
        {'feature': FEATURE_QUIZ_GAMEPLAY, 'usage_count': 0, 'unique_users': 0},
        {'feature': FEATURE_LESSON_SYSTEM, 'usage_count': 0, 'unique_users': 0},
        {'feature': FEATURE_THEME_PURCHASES, 'usage_count': 0, 'unique_users': 0},
      ],
      'unused_features': [
        {'feature': FEATURE_SOCIAL_FEATURES, 'days_since_last_use': 0},
        {'feature': FEATURE_AI_THEME_GENERATOR, 'days_since_last_use': 0},
      ],
      'feature_retention': {
        'daily_active_features': 0,
        'weekly_active_features': 0,
        'monthly_active_features': 0,
      }
    };
  }

  /// Generate a feature usage report for decision making
  Future<String> generateFeatureUsageReport(BuildContext context) async {
    final stats = await getFeatureUsageStats(context);

    final buffer = StringBuffer();
    buffer.writeln('# Feature Usage Analytics Report');
    buffer.writeln('Generated on: ${DateTime.now().toIso8601String()}');
    buffer.writeln();

    buffer.writeln('## Most Used Features');
    final mostUsed = stats['most_used_features'] as List;
    for (var feature in mostUsed) {
      buffer.writeln('- ${feature['feature']}: ${feature['usage_count']} uses by ${feature['unique_users']} users');
    }
    buffer.writeln();

    buffer.writeln('## Unused or Rarely Used Features');
    final unused = stats['unused_features'] as List;
    for (var feature in unused) {
      buffer.writeln('- ${feature['feature']}: Last used ${feature['days_since_last_use']} days ago');
    }
    buffer.writeln();

    buffer.writeln('## Recommendations');
    if (unused.isNotEmpty) {
      buffer.writeln('- Consider removing or improving these unused features:');
      for (var feature in unused) {
        buffer.writeln('  - ${feature['feature']}');
      }
    }

    buffer.writeln('- Focus development efforts on most used features');
    buffer.writeln('- Consider A/B testing improvements for moderately used features');

    return buffer.toString();
  }

  /// Get feature usage insights for a specific feature
  Future<Map<String, dynamic>> getFeatureInsights(BuildContext context, String feature) async {
    // In a real implementation, this would provide detailed insights
    return {
      'feature': feature,
      'total_usage': 0,
      'unique_users': 0,
      'average_session_duration': 0,
      'retention_rate': 0,
      'conversion_rate': 0,
      'recommendation': 'Monitor usage patterns',
    };
  }

  /// Create a feature usage analytics widget for display in settings
  Widget buildFeatureUsageWidget(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getFeatureUsageStats(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading analytics'));
        }

        final stats = snapshot.data!;
        final mostUsed = stats['most_used_features'] as List;
        final unused = stats['unused_features'] as List;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feature Usage Analytics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Most Used Features',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...mostUsed.map((feature) => _buildFeatureUsageItem(
              context,
              feature['feature'] as String,
              '${feature['usage_count']} uses',
            )),
            const SizedBox(height: 16),
            Text(
              'Features Needing Attention',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...unused.map((feature) => _buildFeatureUsageItem(
              context,
              feature['feature'] as String,
              'Last used ${feature['days_since_last_use']} days ago',
              isWarning: true,
            )),
          ],
        );
      },
    );
  }

  Widget _buildFeatureUsageItem(BuildContext context, String feature, String usage, {bool isWarning = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isWarning
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isWarning
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              feature,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            usage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isWarning
                  ? Theme.of(context).colorScheme.onErrorContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
