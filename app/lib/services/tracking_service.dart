import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'dart:math';
import 'dart:async';
import '../config/supabase_config.dart';
import '../providers/settings_provider.dart';
import 'logger.dart';

/// Data class that represents a tracking event to be sent to Supabase
class TrackingEvent {
  final String id;
  final String userId; // Anonymous user ID
  final String eventType;
  final String eventName;
  final Map<String, dynamic>? properties;
  final DateTime timestamp;
  final String? screenName;
  final String? sessionId;
  final String? deviceInfo;
  final String? appVersion;
  final String? buildNumber;
  final String? platform;

  TrackingEvent({
    required this.id,
    required this.userId,
    required this.eventType,
    required this.eventName,
    this.properties,
    required this.timestamp,
    this.screenName,
    this.sessionId,
    this.deviceInfo,
    this.appVersion,
    this.buildNumber,
    this.platform,
  });

  /// Convert the TrackingEvent to a map for Supabase insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId, // This is an anonymous ID, not PII
      'event_type': eventType,
      'event_name': eventName,
      'properties': _serializeProperties(properties),
      'timestamp': timestamp.toIso8601String(),
      'screen_name': screenName,
      'session_id': sessionId,
      'device_info': deviceInfo,
      'app_version': appVersion,
      'build_number': buildNumber,
      'platform': platform,
    };
  }

  /// Create a TrackingEvent from a map (for reading from Supabase)
  static TrackingEvent fromMap(Map<String, dynamic> map) {
    return TrackingEvent(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      eventType: map['event_type'] ?? '',
      eventName: map['event_name'] ?? '',
      properties: _deserializeProperties(map['properties']),
      timestamp:
          DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      screenName: map['screen_name'],
      sessionId: map['session_id'],
      deviceInfo: map['device_info'],
      appVersion: map['app_version'],
      buildNumber: map['build_number'],
      platform: map['platform'],
    );
  }

  /// Serializes the properties map to a JSON string
  static String? _serializeProperties(Map<String, dynamic>? properties) {
    if (properties == null) return null;

    try {
      // Sanitize properties to remove sensitive data before serialization
      Map<String, dynamic> sanitizedProperties =
          AppLogger.sanitizeMap(properties);
      return _mapToJson(sanitizedProperties);
    } catch (e) {
      AppLogger.warning('Failed to serialize properties: $e');
      return null;
    }
  }

  /// Deserializes the properties JSON string back to a Map
  static Map<String, dynamic>? _deserializeProperties(String? properties) {
    if (properties == null) return null;

    try {
      // Simplified deserialization - in a real implementation you'd want a proper JSON parser
      return {
        'deserialized': properties
      }; // Placeholder for actual implementation
    } catch (e) {
      AppLogger.warning('Failed to deserialize properties: $e');
      return null;
    }
  }

  /// Converts a map to a JSON-like string representation
  static String _mapToJson(Map<String, dynamic> map) {
    final entries = <String>[];
    map.forEach((key, value) {
      String valueStr;
      if (value is Map<String, dynamic>) {
        valueStr = _mapToJson(value);
      } else if (value is List) {
        valueStr = _listToJson(value);
      } else {
        valueStr = value.toString();
      }
      entries.add('"$key": "$valueStr"');
    });
    return '{${entries.join(', ')}}';
  }

  /// Converts a list to a JSON-like string representation
  static String _listToJson(List list) {
    final items = <String>[];
    for (final item in list) {
      if (item is Map<String, dynamic>) {
        items.add(_mapToJson(item));
      } else {
        items.add(item.toString());
      }
    }
    return '[${items.join(', ')}]';
  }
}

/// Centralized tracking service that stores analytics events in Supabase
/// This service replaces the PostHog integration while maintaining the same interface
class TrackingService {
  static final TrackingService _instance = TrackingService._internal();
  factory TrackingService() => _instance;
  TrackingService._internal();

  static final Logger _logger = Logger('TrackingService');

  /// Initializes the tracking service.
  ///
  /// This should be called once when the app starts.
  Future<void> init() async {
    AppLogger.info('Initializing in-house tracking service...');
    // Ensure we have a persistent anonymous user ID
    await _ensurePersistentUserId();
    AppLogger.info('In-house tracking service initialized successfully');
  }

  /// Returns a [TrackingObserver] that can be used to automatically track screen views.
  /// For now, we'll return a placeholder - in a full implementation this would provide
  /// automatic screen tracking functionality
  TrackingObserver getObserver() => TrackingObserver();

  /// Tracks a screen view event.
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

    AppLogger.info('Tracking screen view: $screenName');
    try {
      final event = await _createTrackingEvent(
        context: context,
        eventType: 'screen_view',
        eventName: screenName,
        properties: {'screen_name': screenName},
        screenName: screenName,
      );

      await _sendEvent(event);
      AppLogger.info('Screen view tracked successfully: $screenName');
    } catch (e) {
      AppLogger.error('Failed to track screen view: $screenName', e);
    }
  }

  /// Tracks a custom event.
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

    AppLogger.info(
        'Tracking event: $eventName${properties != null ? ' with properties: $properties' : ''}');
    try {
      final event = await _createTrackingEvent(
        context: context,
        eventType: 'custom',
        eventName: eventName,
        properties: properties,
      );

      await _sendEvent(event);
      AppLogger.info('Event tracked successfully: $eventName');
    } catch (e) {
      AppLogger.error('Failed to track event: $eventName', e);
    }
  }

  /// Creates a tracking event with common properties
  Future<TrackingEvent> _createTrackingEvent({
    required BuildContext context,
    required String eventType,
    required String eventName,
    Map<String, Object>? properties,
    String? screenName,
  }) async {
    // Get user ID from settings or generate an anonymous ID
    Provider.of<SettingsProvider>(context, listen: false);
    final userId = await _getPersistentUserId();

    // Get app version and build number
    String appVersion = 'unknown';
    String buildNumber = 'unknown';

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    } catch (e) {
      AppLogger.warning('Could not retrieve app version info: $e');
    }

    // Get device information
    String? deviceInfo = '';
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        deviceInfo =
            'Android ${androidInfo.version.release} (${androidInfo.model})';
      } else if (Platform.isIOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        deviceInfo = 'iOS ${iosInfo.systemVersion} (${iosInfo.model})';
      }
    } catch (e) {
      AppLogger.warning('Could not retrieve device info: $e');
    }

    // Sanitize properties to remove any potential PII
    Map<String, dynamic>? sanitizedProperties = properties != null
        ? AppLogger.sanitizeMap(Map<String, dynamic>.from(properties))
        : null;

    return TrackingEvent(
      id: _generateEventId(),
      userId: userId,
      eventType: eventType,
      eventName: eventName,
      properties: sanitizedProperties ?? {},
      timestamp: DateTime.now(),
      screenName: screenName,
      sessionId: _getSessionId(),
      deviceInfo: deviceInfo,
      appVersion: appVersion,
      buildNumber: buildNumber,
      platform: _getPlatform(),
    );
  }

  /// Sends the tracking event to Supabase
  Future<void> _sendEvent(TrackingEvent event) async {
    try {
      final response = await SupabaseConfig.getClient()
          .from('tracking_events')
          .insert(event.toMap());

      if (response.error != null) {
        _logger.severe(
            'Failed to send tracking event to Supabase: ${response.error?.message}');
      } else {
        _logger.info('Tracking event sent successfully: ${event.eventName}');
      }
    } catch (e) {
      _logger.severe('Failed to send tracking event due to exception: $e');
    }
  }

  /// Generate a unique event ID
  String _generateEventId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(8)}';
  }

  /// Ensures we have a persistent anonymous user ID stored in shared preferences
  Future<void> _ensurePersistentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'tracking_anonymous_user_id';

    if (!prefs.containsKey(key)) {
      // Generate a new persistent ID and store it
      final newId =
          'anon_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(12)}';
      await prefs.setString(key, newId);
      AppLogger.info('Created new persistent anonymous user ID: $newId');
    }
  }

  /// Gets the persistent anonymous user ID
  Future<String> _getPersistentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'tracking_anonymous_user_id';

    // This should not be null since _ensurePersistentUserId is called during init
    String? storedId = prefs.getString(key);
    if (storedId == null) {
      // Fallback: generate a new ID if somehow none exists
      storedId = _generateAnonymousId();
      await prefs.setString(key, storedId);
    }
    return storedId;
  }

  /// Generate an anonymous user ID if needed (fallback method)
  String _generateAnonymousId() {
    return 'anon_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(12)}';
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

  /// Generate a random string of specified length
  String _generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  /// ===== COMPREHENSIVE FEATURE USAGE TRACKING =====

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
  static const String actionStarted = 'started';
  static const String actionFinished = 'finished';

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
    await trackFeatureUsage(context, feature, actionStarted,
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

  /// Specific app usage events - these are the primary tracked events
  /// All events contain no PII, only anonymous usage patterns

  /// Track when user starts a quiz (without question details)
  Future<void> trackQuizStart(BuildContext context,
      {String? category, int? difficulty}) async {
    final properties = <String, Object>{};
    if (category != null) properties['category'] = category;
    if (difficulty != null) properties['difficulty'] = difficulty;

    await trackFeatureUsage(context, featureQuizGameplay, actionStarted,
        additionalProperties: properties);
  }

  /// Track when user completes a quiz
  Future<void> trackQuizComplete(BuildContext context,
      {int? score, int? maxScore, int? questionsAnswered}) async {
    final properties = <String, Object>{};
    if (score != null) properties['score'] = score;
    if (maxScore != null) properties['max_score'] = maxScore;
    if (questionsAnswered != null) {
      properties['questions_answered'] = questionsAnswered;
    }

    await trackFeatureUsage(context, featureQuizGameplay, actionCompleted,
        additionalProperties: properties);
  }

  /// Track when user purchases/unlocks a theme
  Future<void> trackThemePurchase(
      BuildContext context, String themeName) async {
    await trackFeatureUsage(context, featureThemePurchases, actionPurchased,
        additionalProperties: {'theme_name': themeName});
  }

  /// Track when user changes theme
  Future<void> trackThemeChange(BuildContext context, String themeName) async {
    await trackFeatureUsage(context, featureThemeSelection, actionChanged,
        additionalProperties: {'theme_name': themeName});
  }

  /// Track when user starts a lesson
  Future<void> trackLessonStart(BuildContext context, String lessonId) async {
    await trackFeatureUsage(context, featureLessonSystem, actionStarted,
        additionalProperties: {'lesson_id': lessonId});
  }

  /// Track when user completes a lesson
  Future<void> trackLessonComplete(
      BuildContext context, String lessonId) async {
    await trackFeatureUsage(context, featureLessonSystem, actionCompleted,
        additionalProperties: {'lesson_id': lessonId});
  }

  /// Track when user uses skip feature
  Future<void> trackSkipUsed(BuildContext context) async {
    await trackFeatureUsage(context, featureSkipQuestion, actionUsed);
  }

  /// Track when user uses retry feature
  Future<void> trackRetryUsed(BuildContext context) async {
    await trackFeatureUsage(context, featureRetryWithPoints, actionUsed);
  }

  /// Track when user enables/disables analytics
  Future<void> trackAnalyticsToggle(BuildContext context, bool enabled) async {
    await trackFeatureUsage(context, featureAnalyticsSettings,
        enabled ? actionEnabled : actionDisabled);
  }

  /// Track when user changes language
  Future<void> trackLanguageChange(
      BuildContext context, String languageCode) async {
    await trackFeatureUsage(context, featureLanguageSettings, actionChanged,
        additionalProperties: {'language_code': languageCode});
  }

  /// Track when user accesses settings
  Future<void> trackSettingsAccess(BuildContext context) async {
    await trackFeatureUsage(context, featureSettings, actionAccessed);
  }

  /// Track when user starts onboarding
  Future<void> trackOnboardingStart(BuildContext context) async {
    await trackFeatureUsage(context, featureOnboarding, actionStarted);
  }

  /// Track when user completes onboarding
  Future<void> trackOnboardingComplete(BuildContext context) async {
    await trackFeatureUsage(context, featureOnboarding, actionCompleted);
  }

  /// Track when user makes a donation
  Future<void> trackDonationInitiated(BuildContext context) async {
    await trackFeatureUsage(context, featureDonationSystem, actionStarted);
  }

  /// Track when user completes a donation
  Future<void> trackDonationCompleted(BuildContext context) async {
    await trackFeatureUsage(context, featureDonationSystem, actionCompleted);
  }

  /// Track when user accesses satisfaction survey
  Future<void> trackSatisfactionSurveyAccess(BuildContext context) async {
    await trackFeatureUsage(
        context, featureSatisfactionSurveys, actionAccessed);
  }

  /// Track when user submits satisfaction survey
  Future<void> trackSatisfactionSurveySubmit(
      BuildContext context, int rating) async {
    await trackFeatureUsage(
        context, featureSatisfactionSurveys, actionCompleted,
        additionalProperties: {'rating': rating});
  }

  /// Track when user provides difficulty feedback
  Future<void> trackDifficultyFeedback(
      BuildContext context, String feedbackType,
      {int? difficultyRating}) async {
    final properties = <String, Object>{'feedback_type': feedbackType};
    if (difficultyRating != null) {
      properties['difficulty_rating'] = difficultyRating;
    }

    await trackFeatureUsage(context, featureDifficultyFeedback, actionUsed,
        additionalProperties: properties);
  }

  /// Track when user starts multiplayer game
  Future<void> trackMultiplayerGameStart(BuildContext context) async {
    await trackFeatureUsage(context, featureMultiplayerGame, actionStarted);
  }

  /// Track when user completes multiplayer game
  Future<void> trackMultiplayerGameComplete(BuildContext context,
      {int? placement, int? score}) async {
    final properties = <String, Object>{};
    if (placement != null) properties['placement'] = placement;
    if (score != null) properties['score'] = score;

    await trackFeatureUsage(context, featureMultiplayerGame, actionCompleted,
        additionalProperties: properties);
  }

  /// Track when user uses power-up
  Future<void> trackPowerUpUsed(
      BuildContext context, String powerUpType) async {
    await trackFeatureUsage(context, featurePowerUps, actionUsed,
        additionalProperties: {'power_up_type': powerUpType});
  }

  /// Track when user views promo cards
  Future<void> trackPromoCardViewed(
      BuildContext context, String cardType) async {
    await trackFeatureUsage(context, featurePromoCards, actionAccessed,
        additionalProperties: {'card_type': cardType});
  }

  /// Track when user starts using AI theme generator
  Future<void> trackAiThemeGeneratorStart(BuildContext context) async {
    await trackFeatureUsage(context, featureAiThemeGenerator, actionStarted);
  }

  /// Track when user completes using AI theme generator
  Future<void> trackAiThemeGeneratorComplete(BuildContext context,
      {bool success = true}) async {
    await trackFeatureUsage(context, featureAiThemeGenerator,
        success ? actionCompleted : actionAttempted,
        additionalProperties: {'success': success});
  }

  /// Track social feature usage
  Future<void> trackSocialFeatureUsed(
      BuildContext context, String socialAction) async {
    await trackFeatureUsage(context, featureSocialFeatures, actionUsed,
        additionalProperties: {'social_action': socialAction});
  }

  /// Track when user views question categories
  Future<void> trackCategoryView(BuildContext context, String category) async {
    await trackFeatureUsage(context, featureQuestionCategories, actionAccessed,
        additionalProperties: {'category': category});
  }

  /// Track when user views biblical references
  Future<void> trackBiblicalReferenceView(BuildContext context, String book,
      {int? chapter}) async {
    final properties = <String, Object>{'book': book};
    if (chapter != null) properties['chapter'] = chapter;

    await trackFeatureUsage(context, featureBiblicalReferences, actionAccessed,
        additionalProperties: properties);
  }

  /// Track when user uses progressive difficulty feature
  Future<void> trackProgressiveDifficultyUsed(
      BuildContext context, int level) async {
    await trackFeatureUsage(context, featureProgressiveDifficulty, actionUsed,
        additionalProperties: {'level': level});
  }

  /// Track when user engages with streak tracking
  Future<void> trackStreakFeatureUsed(BuildContext context) async {
    await trackFeatureUsage(context, featureStreakTracking, actionUsed);
  }

  /// Get comprehensive feature usage statistics (for reporting)
  Future<Map<String, dynamic>> getFeatureUsageStats() async {
    try {
      // Query the tracking_events table to get usage statistics
      final response = await SupabaseConfig.getClient()
          .from('tracking_events')
          .select('event_name, properties, timestamp')
          .gte('timestamp',
              DateTime.now().subtract(Duration(days: 30)).toIso8601String());

      // The response is actually a List<Map<String, dynamic>> rather than a response object
      // In the Supabase Dart client, some operations might return data directly
      final events = response as List;

      // Process the events to extract feature usage statistics
      final stats = <String, dynamic>{};
      final featureUsage = <String, int>{};
      final featureUsers = <String, Set<String>>{};

      for (final event in events) {
        final eventName = event['event_name'] as String;
        if (eventName == 'feature_usage') {
          final properties = event['properties'] as Map<String, dynamic>?;
          if (properties != null) {
            final feature = properties['feature'] as String;
            featureUsage[feature] = (featureUsage[feature] ?? 0) + 1;

            final userId = event['user_id'] as String;
            featureUsers.putIfAbsent(feature, () => <String>{}).add(userId);
          }
        }
      }

      // Create the stats structure
      stats['total_features_tracked'] = featureUsage.length;
      stats['most_used_features'] = featureUsage.entries
          .map((entry) => {
                'feature': entry.key,
                'usage_count': entry.value,
                'unique_users': featureUsers[entry.key]?.length ?? 0,
              })
          .toList()
        ..sort((a, b) =>
            (b['usage_count'] as int).compareTo(a['usage_count'] as int));

      final allFeatures = [
        featureQuizGameplay,
        featureLessonSystem,
        featureQuestionCategories,
        featureBiblicalReferences,
        featureSkipQuestion,
        featureRetryWithPoints,
        featureStreakTracking,
        featureProgressiveDifficulty,
        featurePowerUps,
        featureThemePurchases,
        featureAiThemeGenerator,
        featureSocialFeatures,
        featurePromoCards,
        featureSettings,
        featureThemeSelection,
        featureAnalyticsSettings,
        featureLanguageSettings,
        featureOnboarding,
        featureDonationSystem,
        featureSatisfactionSurveys,
        featureDifficultyFeedback,
        featureMultiplayerGame
      ];

      stats['unused_features'] = allFeatures
          .where((feature) => !featureUsage.containsKey(feature))
          .map((feature) => {
                'feature': feature,
                'days_since_last_use': 0,
              })
          .toList();

      stats['feature_retention'] = {
        'daily_active_features': 0, // Would be calculated from actual data
        'weekly_active_features': 0,
        'monthly_active_features': 0,
      };

      return stats;
    } catch (e) {
      // Check if this is a Supabase-related exception by checking message content
      if (e.toString().contains('Postgrest') ||
          e.toString().contains('supabase')) {
        AppLogger.error(
            'Failed to fetch feature usage stats: Supabase error - ${e.toString()}',
            e);
      } else {
        AppLogger.error(
            'Failed to fetch feature usage stats: ${e.toString()}', e);
      }
      return {};
    }
  }

  /// Generate a feature usage report for decision making
  Future<String> generateFeatureUsageReport() async {
    final stats = await getFeatureUsageStats();

    final buffer = StringBuffer();
    buffer.writeln('# Feature Usage Analytics Report');
    buffer.writeln('Generated on: ${DateTime.now().toIso8601String()}');
    buffer.writeln();

    buffer.writeln('## Most Used Features');
    final mostUsed = stats['most_used_features'] as List?;
    if (mostUsed != null) {
      for (var feature in mostUsed) {
        buffer.writeln(
            '- ${feature['feature']}: ${feature['usage_count']} uses by ${feature['unique_users']} users');
      }
    }
    buffer.writeln();

    buffer.writeln('## Unused or Rarely Used Features');
    final unused = stats['unused_features'] as List?;
    if (unused != null) {
      for (var feature in unused) {
        buffer.writeln(
            '- ${feature['feature']}: Last used ${feature['days_since_last_use']} days ago');
      }
    }
    buffer.writeln();

    buffer.writeln('## Recommendations');
    if (unused != null && unused.isNotEmpty) {
      buffer.writeln('- Consider removing or improving these unused features:');
      for (var feature in unused) {
        buffer.writeln('  - ${feature['feature']}');
      }
    }

    buffer.writeln('- Focus development efforts on most used features');
    buffer.writeln(
        '- Consider A/B testing improvements for moderately used features');

    return buffer.toString();
  }

  /// Get feature usage insights for a specific feature
  Future<Map<String, dynamic>> getFeatureInsights(String feature) async {
    try {
      // Query specific feature data
      final response = await SupabaseConfig.getClient()
          .from('tracking_events')
          .select('user_id, timestamp, properties')
          .ilike('properties', '%$feature%')
          .gte('timestamp',
              DateTime.now().subtract(Duration(days: 30)).toIso8601String());

      final events = response as List;
      final userIds = <String>{};
      var totalUsage = 0;

      for (final event in events) {
        final userId = event['user_id'] as String;
        userIds.add(userId);
        totalUsage++;
      }

      return {
        'feature': feature,
        'total_usage': totalUsage,
        'unique_users': userIds.length,
        'average_session_duration': 0, // Would need additional data
        'retention_rate': 0, // Would need additional calculations
        'conversion_rate': 0, // Would need additional data
        'recommendation': 'Monitor usage patterns',
      };
    } catch (e) {
      // Check if this is a Supabase-related exception by checking message content
      if (e.toString().contains('Postgrest') ||
          e.toString().contains('supabase')) {
        AppLogger.error(
            'Failed to fetch feature insights: Supabase error - ${e.toString()}',
            e);
      } else {
        AppLogger.error(
            'Error getting feature insights for $feature: ${e.toString()}', e);
      }
      return {};
    }
  }

  /// Create a feature usage analytics widget for display in settings
  Widget buildFeatureUsageWidget(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getFeatureUsageStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading analytics'));
        }

        final stats = snapshot.data ?? {};
        final mostUsed = stats['most_used_features'] as List? ?? [];
        final unused = stats['unused_features'] as List? ?? [];

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

  Widget _buildFeatureUsageItem(
      BuildContext context, String feature, String usage,
      {bool isWarning = false}) {
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

/// Observer class for automatic screen tracking, extending NavigatorObserver
class TrackingObserver extends NavigatorObserver {
  // In a full implementation, this would provide automatic screen tracking
  // For now, it's a placeholder to maintain interface compatibility
}
