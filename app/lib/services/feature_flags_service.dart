import 'package:posthog_flutter/posthog_flutter.dart';
import 'logger.dart';

/// A service that provides an interface to PostHog feature flags.
/// This service allows remote control of app features for better user management and testing.
class FeatureFlagsService {
  /// Feature flag keys
  static const String socialFeaturesEnabled = 'social-features-enabled';
  static const String geminiColorGenerationEnabled = 'gemini-color-generation-enabled';
  static const String biblicalReferenceUnlockEnabled = 'biblical-reference-unlock-enabled';
  static const String analyticsEnabled = 'analytics-enabled';

  /// Default feature flag values (fallback when PostHog is not available)
  static const Map<String, bool> _defaultValues = {
    socialFeaturesEnabled: false, // Currently "coming soon"
    geminiColorGenerationEnabled: true,
    biblicalReferenceUnlockEnabled: true,
    analyticsEnabled: true,
  };

  /// Cache for feature flag values to avoid repeated async calls
  final Map<String, dynamic> _flagCache = {};
  bool _flagsLoaded = false;

  /// Initialize feature flags by loading from PostHog
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing feature flags...');
      await _loadAllFlags();
      _flagsLoaded = true;
      AppLogger.info('Feature flags initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize feature flags', e);
      // Continue with default values if PostHog fails
      _flagsLoaded = true;
    }
  }

  /// Load all feature flags from PostHog
  Future<void> _loadAllFlags() async {
    try {
      // Load boolean flags
      for (final flagKey in _defaultValues.keys) {
        _flagCache[flagKey] = await Posthog().isFeatureEnabled(flagKey);
      }
      AppLogger.info('Loaded ${_flagCache.length} feature flags from PostHog');
    } catch (e) {
      AppLogger.error('Failed to load feature flags from PostHog', e);
      // Use default values as fallback
      _flagCache.addAll(_defaultValues);
    }
  }

  /// Reload feature flags from PostHog (useful when user properties change)
  Future<void> reloadFlags() async {
    AppLogger.info('Reloading feature flags...');
    _flagCache.clear();
    await _loadAllFlags();
  }

  /// Check if a boolean feature flag is enabled
  Future<bool> isFeatureEnabled(String flagKey) async {
    // If flags haven't been loaded yet, load them
    if (!_flagsLoaded) {
      await initialize();
    }

    // Return cached value or default
    return _flagCache[flagKey] ?? _defaultValues[flagKey] ?? false;
  }

  /// Get a feature flag value (supports both boolean and string values)
  Future<dynamic> getFeatureFlag(String flagKey) async {
    // If flags haven't been loaded yet, load them
    if (!_flagsLoaded) {
      await initialize();
    }

    // Return cached value or default
    return _flagCache[flagKey] ?? _defaultValues[flagKey] ?? false;
  }

  /// Get the payload for a feature flag (if any)
  Future<dynamic> getFeatureFlagPayload(String flagKey) async {
    try {
      return await Posthog().getFeatureFlagPayload(flagKey);
    } catch (e) {
      AppLogger.error('Failed to get feature flag payload for $flagKey', e);
      return null;
    }
  }

  // Convenience methods for specific features

  /// Check if social features are enabled
  Future<bool> areSocialFeaturesEnabled() async {
    return await isFeatureEnabled(socialFeaturesEnabled);
  }

  /// Check if Gemini AI color generation is enabled
  Future<bool> isGeminiColorGenerationEnabled() async {
    return await isFeatureEnabled(geminiColorGenerationEnabled);
  }

  /// Check if biblical reference unlock is enabled
  Future<bool> isBiblicalReferenceUnlockEnabled() async {
    return await isFeatureEnabled(biblicalReferenceUnlockEnabled);
  }

  /// Check if analytics are enabled
  Future<bool> areAnalyticsEnabled() async {
    return await isFeatureEnabled(analyticsEnabled);
  }

  /// Get all current feature flag values (for debugging)
  Map<String, dynamic> getAllFlags() {
    return Map.from(_flagCache);
  }

  /// Reset the service (mainly for testing)
  void reset() {
    _flagCache.clear();
    _flagsLoaded = false;
  }
}