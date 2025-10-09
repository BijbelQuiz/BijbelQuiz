import 'package:flutter/material.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;
import '../providers/settings_provider.dart';
import '../constants/urls.dart';
import 'logger.dart';

/// A service that provides an interface to the PostHog analytics service.
///
/// This service is a singleton and can be accessed using `Provider.of<AnalyticsService>(context)`.
class AnalyticsService {
  /// Initializes the PostHog SDK.
  ///
  /// This should be called once when the app starts.
  Future<void> init() async {
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
    AppLogger.info('Tracking event: $eventName${properties != null ? ' with properties: $properties' : ''}');
    try {
      await Posthog().capture(eventName: eventName, properties: properties);
      AppLogger.info('Event tracked successfully: $eventName');
    } catch (e) {
      AppLogger.error('Failed to track event: $eventName', e);
    }
  }

  // ===== COMPREHENSIVE EVENT TRACKING METHODS =====

  /// Tracks app lifecycle events
  Future<void> trackAppLaunch(BuildContext context) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfo = DeviceInfoPlugin();

      Map<String, Object> properties = {
        'app_version': packageInfo.version,
        'build_number': packageInfo.buildNumber,
        'platform': Platform.operatingSystem,
        'timestamp': DateTime.now().toIso8601String(),
      };

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        properties.addAll({
          'android_version': androidInfo.version.release,
          'android_model': androidInfo.model,
        });
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        properties.addAll({
          'ios_version': iosInfo.systemVersion,
          'ios_model': iosInfo.model,
        });
      }

      await capture(context, 'app_launched', properties: properties);
    } catch (e) {
      AppLogger.error('Failed to track app launch', e);
    }
  }

  /// Tracks user engagement events
  Future<void> trackUserEngagement(BuildContext context, String action, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties['action'] = action;
    properties['timestamp'] = DateTime.now().toIso8601String();

    await capture(context, 'user_engagement', properties: properties);
  }

  /// Tracks performance metrics
  Future<void> trackPerformance(BuildContext context, String metric, Duration duration, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'metric': metric,
      'duration_ms': duration.inMilliseconds,
      'duration_seconds': duration.inSeconds,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'performance_metric', properties: properties);
  }

  /// Tracks quiz gameplay events
  Future<void> trackQuizEvent(BuildContext context, String event, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties['event'] = event;
    properties['timestamp'] = DateTime.now().toIso8601String();

    await capture(context, 'quiz_gameplay', properties: properties);
  }

  /// Tracks question interactions
  Future<void> trackQuestionInteraction(BuildContext context, String interaction, String questionType, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'interaction': interaction,
      'question_type': questionType,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'question_interaction', properties: properties);
  }

  /// Tracks scoring and points events
  Future<void> trackScoringEvent(BuildContext context, String event, int points, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'event': event,
      'points': points,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'scoring_event', properties: properties);
  }

  /// Tracks user preferences and settings changes
  Future<void> trackPreferenceChange(BuildContext context, String preference, String value, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'preference': preference,
      'value': value,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'preference_change', properties: properties);
  }

  /// Tracks social and community features
  Future<void> trackSocialEvent(BuildContext context, String event, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties['event'] = event;
    properties['timestamp'] = DateTime.now().toIso8601String();

    await capture(context, 'social_event', properties: properties);
  }

  /// Tracks technical events (connectivity, caching, etc.)
  Future<void> trackTechnicalEvent(BuildContext context, String event, String status, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'event': event,
      'status': status,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'technical_event', properties: properties);
  }

  /// Tracks business metrics (retention, conversion, etc.)
  Future<void> trackBusinessMetric(BuildContext context, String metric, double value, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'metric': metric,
      'value': value,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'business_metric', properties: properties);
  }

  /// Tracks error events with context
  Future<void> trackError(BuildContext context, String errorType, String errorMessage, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'error_type': errorType,
      'error_message': errorMessage,
      'platform': Platform.operatingSystem,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'error_occurred', properties: properties);
  }

  /// Tracks feature usage
  Future<void> trackFeatureUsage(BuildContext context, String feature, String action, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'feature': feature,
      'action': action,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'feature_usage', properties: properties);
  }

  /// Tracks session events
  Future<void> trackSessionEvent(BuildContext context, String event, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties['event'] = event;
    properties['timestamp'] = DateTime.now().toIso8601String();

    await capture(context, 'session_event', properties: properties);
  }

  // ===== UTILITY FUNCTIONS FOR COMMON EVENT PATTERNS =====

  /// Tracks user flow events (e.g., navigation, feature discovery)
  Future<void> trackUserFlow(BuildContext context, String flow, String step, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'flow': flow,
      'step': step,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'user_flow', properties: properties);
  }

  /// Tracks conversion funnel events
  Future<void> trackConversionFunnel(BuildContext context, String funnel, String step, bool success, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'funnel': funnel,
      'step': step,
      'success': success,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'conversion_funnel', properties: properties);
  }

  /// Tracks time-based events (e.g., time spent on screen)
  Future<void> trackTimeBasedEvent(BuildContext context, String event, Duration duration, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'event': event,
      'duration_ms': duration.inMilliseconds,
      'duration_seconds': duration.inSeconds,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'time_based_event', properties: properties);
  }

  /// Tracks user behavior patterns
  Future<void> trackUserBehavior(BuildContext context, String behavior, String category, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'behavior': behavior,
      'category': category,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'user_behavior', properties: properties);
  }

  /// Tracks content interaction events
  Future<void> trackContentInteraction(BuildContext context, String contentType, String interaction, String contentId, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'content_type': contentType,
      'interaction': interaction,
      'content_id': contentId,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'content_interaction', properties: properties);
  }

  /// Tracks search and discovery events
  Future<void> trackSearchEvent(BuildContext context, String searchType, String query, int resultsCount, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'search_type': searchType,
      'query': query,
      'results_count': resultsCount,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'search_event', properties: properties);
  }

  /// Tracks learning progress events
  Future<void> trackLearningProgress(BuildContext context, String activity, String progress, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'activity': activity,
      'progress': progress,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'learning_progress', properties: properties);
  }

  /// Tracks achievement and milestone events
  Future<void> trackAchievement(BuildContext context, String achievement, String milestone, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'achievement': achievement,
      'milestone': milestone,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'achievement', properties: properties);
  }

  /// Tracks feedback and rating events
  Future<void> trackFeedback(BuildContext context, String feedbackType, String feedbackValue, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'feedback_type': feedbackType,
      'feedback_value': feedbackValue,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'feedback', properties: properties);
  }

  /// Tracks accessibility events
  Future<void> trackAccessibilityEvent(BuildContext context, String event, String element, {Map<String, Object>? additionalProperties}) async {
    final properties = Map<String, Object>.from(additionalProperties ?? {});
    properties.addAll({
      'event': event,
      'element': element,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await capture(context, 'accessibility_event', properties: properties);
  }
}
