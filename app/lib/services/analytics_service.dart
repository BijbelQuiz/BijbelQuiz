import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import '../providers/settings_provider.dart';
import 'logger.dart';
import 'tracking_service.dart';

/// A service that provides an interface to the in-house tracking service.
///
/// This service is a singleton and can be accessed using `Provider.of<AnalyticsService>(context)`.
class AnalyticsService {
  final TrackingService _trackingService = TrackingService();

  /// Initializes the in-house tracking service.
  ///
  /// This should be called once when the app starts.
  Future<void> init() async {
    AppLogger.info('Initializing in-house tracking service...');
    try {
      await _trackingService.init();
      AppLogger.info('In-house tracking service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize in-house tracking service', e);
      rethrow;
    }
  }

  /// Returns a [TrackingObserver] that can be used to automatically track screen views.
  TrackingObserver getObserver() => _trackingService.getObserver();

  /// Tracks a screen view.
  ///
  /// This should be called when a screen is displayed.
  /// The [screenName] is the name of the screen.
  Future<void> screen(BuildContext context, String screenName) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    // Skip tracking if analytics are disabled in settings
    if (!settings.analyticsEnabled) {
      AppLogger.info(
          'Analytics disabled in settings, skipping screen tracking for: $screenName');
      return;
    }

    // Skip tracking in debug mode
    if (kDebugMode) {
      AppLogger.info('Skipping screen tracking in debug mode: $screenName');
      return;
    }

    AppLogger.info('Tracking screen view: $screenName');
    try {
      await _trackingService.screen(context, screenName);
      AppLogger.info('Screen view tracked successfully: $screenName');
    } catch (e) {
      AppLogger.error('Failed to track screen view: $screenName', e);
    }
  }

  /// Tracks an event.
  ///
  /// The [eventName] is the name of the event.
  /// The [properties] are any additional data to send with the event.
  Future<void> capture(BuildContext context, String eventName,
      {Map<String, Object>? properties}) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    // Skip tracking if analytics are disabled in settings
    if (!settings.analyticsEnabled) {
      AppLogger.info(
          'Analytics disabled in settings, skipping event tracking for: $eventName');
      return;
    }

    // Skip tracking in debug mode
    if (kDebugMode) {
      AppLogger.info('Skipping event tracking in debug mode: $eventName');
      return;
    }

    AppLogger.info(
        'Tracking event: $eventName${properties != null ? ' with properties: $properties' : ''}');
    try {
      await _trackingService.capture(context, eventName,
          properties: properties);
      AppLogger.info('Event tracked successfully: $eventName');
    } catch (e) {
      AppLogger.error('Failed to track event: $eventName', e);
    }
  }

  // ===== COMPREHENSIVE FEATURE USAGE TRACKING =====

  /// Standardized feature names for consistent tracking
  static const String featureQuizGameplay = 'quiz_gameplay';
  static const String featureLessonSystem = 'lesson_system';
  static const String featureQuestionCategories = 'question_categories';
  static const String featureBiblicalReferences = 'biblical_references';
  static const String featureSkipQuestion = 'skip_question';
  static const String featureRetryWithPoints = 'retry_with_points';
  static const String featureStreakTracking = 'streak_tracking';
  static const String featureProgressiveDifficulty = 'progressive_difficulty';
  static const String featurePowerUps = 'power_ups';
  static const String featureThemePurchases = 'theme_purchases';
  static const String featureAiThemeGenerator = 'ai_theme_generator';
  static const String featureSocialFeatures = 'social_features';
  static const String featurePromoCards = 'promo_cards';
  static const String featureSettings = 'settings';
  static const String featureThemeSelection = 'theme_selection';
  static const String featureAnalyticsSettings = 'analytics_settings';
  static const String featureLanguageSettings = 'language_settings';
  static const String featureOnboarding = 'onboarding';
  static const String featureDonationSystem = 'donation_system';
  static const String featureSatisfactionSurveys = 'satisfaction_surveys';
  static const String featureDifficultyFeedback = 'difficulty_feedback';
  static const String featureMultiplayerGame = 'multiplayer_game';

  /// Standardized action names for consistent tracking
  static const String actionAccessed = 'accessed';
  static const String actionUsed = 'used';
  static const String actionPurchased = 'purchased';
  static const String actionUnlocked = 'unlocked';
  static const String actionAttempted = 'attempted';
  static const String actionCompleted = 'completed';
  static const String actionDismissed = 'dismissed';
  static const String actionEnabled = 'enabled';
  static const String actionDisabled = 'disabled';
  static const String actionChanged = 'changed';

  /// Enhanced feature usage tracking with standardized features and actions
  /// This is the primary method for tracking which features users interact with
  Future<void> trackFeatureUsage(
      BuildContext context, String feature, String action,
      {Map<String, Object>? additionalProperties}) async {
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
  Future<void> trackFeatureStart(BuildContext context, String feature,
      {Map<String, Object>? additionalProperties}) async {
    await trackFeatureUsage(context, feature, actionAccessed,
        additionalProperties: additionalProperties);
  }

  /// Track when a user successfully uses a feature
  Future<void> trackFeatureSuccess(BuildContext context, String feature,
      {Map<String, Object>? additionalProperties}) async {
    await trackFeatureUsage(context, feature, actionUsed,
        additionalProperties: additionalProperties);
  }

  /// Track when a user attempts but fails to use a feature
  Future<void> trackFeatureAttempt(BuildContext context, String feature,
      {Map<String, Object>? additionalProperties}) async {
    await trackFeatureUsage(context, feature, actionAttempted,
        additionalProperties: additionalProperties);
  }

  /// Track when a user purchases/unlocks a feature
  Future<void> trackFeaturePurchase(BuildContext context, String feature,
      {Map<String, Object>? additionalProperties}) async {
    await trackFeatureUsage(context, feature, actionPurchased,
        additionalProperties: additionalProperties);
  }

  /// Track when a user completes a feature or flow
  Future<void> trackFeatureCompletion(BuildContext context, String feature,
      {Map<String, Object>? additionalProperties}) async {
    await trackFeatureUsage(context, feature, actionCompleted,
        additionalProperties: additionalProperties);
  }

  /// Track when a user dismisses or cancels a feature
  Future<void> trackFeatureDismissal(BuildContext context, String feature,
      {Map<String, Object>? additionalProperties}) async {
    await trackFeatureUsage(context, feature, actionDismissed,
        additionalProperties: additionalProperties);
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
  Future<Map<String, dynamic>> getFeatureUsageStats(
      BuildContext context) async {
    return _trackingService.getFeatureUsageStats();
  }

  /// Generate a feature usage report for decision making
  Future<String> generateFeatureUsageReport(BuildContext context) async {
    return _trackingService.generateFeatureUsageReport();
  }

  /// Get feature usage insights for a specific feature
  Future<Map<String, dynamic>> getFeatureInsights(
      BuildContext context, String feature) async {
    return _trackingService.getFeatureInsights(feature);
  }

  /// Create a feature usage analytics widget for display in settings
  Widget buildFeatureUsageWidget(BuildContext context) {
    return _trackingService.buildFeatureUsageWidget(context);
  }
}
