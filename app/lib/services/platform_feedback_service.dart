import 'dart:io';
import 'package:flutter/foundation.dart';
import 'logger.dart';

/// A service for managing platform-specific visual feedback durations
/// to ensure consistent user experience across Android and Linux platforms.
class PlatformFeedbackService {
  // Default visual feedback durations (milliseconds)
  static const int _normalFeedbackDuration = 750;
  static const int _slowFeedbackDuration = 1500;
  
  
  /// Platform-specific timing adjustments to normalize visual feedback
  static const Map<String, double> _platformMultipliers = {
    'android': 1.0,    // Android baseline
    'linux': 0.85,    // Linux tends to show feedback longer, so reduce it
    'web': 1.0,       // Web baseline
    'ios': 1.0,       // iOS baseline
    'macos': 0.9,     // macOS similar to Linux
    'windows': 1.0,   // Windows baseline
  };
  
  late String _currentPlatform;
  // Runtime-configurable durations (in ms)
  int _normalDurationMs = _normalFeedbackDuration;
  int _slowDurationMs = _slowFeedbackDuration;
  late double _platformMultiplier;
  
  /// Initialize the platform feedback service
  Future<void> initialize() async {
    _detectPlatform();
    AppLogger.info('PlatformFeedbackService initialized for $_currentPlatform with multiplier $_platformMultiplier');
  }
  
  /// Detect the current platform and set appropriate multiplier
  void _detectPlatform() {
    if (kIsWeb) {
      _currentPlatform = 'web';
    } else {
      _currentPlatform = Platform.operatingSystem.toLowerCase();
    }
    
    _platformMultiplier = _platformMultipliers[_currentPlatform] ?? 1.0;
    
    AppLogger.info('Platform detected: $_currentPlatform, feedback multiplier: $_platformMultiplier');
  }
  
  /// Get the standardized feedback duration for the current platform
  /// 
  /// This method ensures that red/green color feedback appears for exactly
  /// the same perceived duration across all platforms by applying platform-specific
  /// timing adjustments.
  /// Return the visual feedback duration adjusted for the current platform.
  /// This duration is *independent* of audio, slow-mode settings or other
  /// animation speeds.  It can be configured via [setFeedbackDuration].
  Duration getStandardizedFeedbackDuration({bool slowMode = false}) {
    final baseDuration = slowMode ? _slowDurationMs : _normalDurationMs;
    final adjustedDuration = (baseDuration * _platformMultiplier).round();
    
    AppLogger.debug('Feedback duration: base=${slowMode ? _slowDurationMs : _normalDurationMs}, adjusted=$adjustedDuration (platform: $_currentPlatform)');
    
    return Duration(milliseconds: adjustedDuration);
  }
  
  /// Allows changing the base visual feedback duration globally (e.g. for
  /// tests).  The supplied [duration] should be positive.
  /// Override the feedback durations at runtime, e.g. in tests.
  /// If [slowDuration] is omitted, it defaults to double the [normalDuration].
  void setFeedbackDurations({required Duration normalDuration, Duration? slowDuration}) {
    assert(!normalDuration.isNegative && normalDuration.inMilliseconds > 0);
    _normalDurationMs = normalDuration.inMilliseconds;
    _slowDurationMs = slowDuration?.inMilliseconds ?? (normalDuration.inMilliseconds * 2);
  }
  
  /// Get platform-specific transition pause duration
  /// 
  /// Some platforms may need slightly different transition timing
  /// to maintain smooth visual flow.
  Duration getTransitionPauseDuration() {
    const basePause = 300; // milliseconds
    final adjustedPause = (basePause * _platformMultiplier).round();
    
    return Duration(milliseconds: adjustedPause);
  }
  
  /// Get information about current platform settings
  Map<String, dynamic> getPlatformInfo() {
    return {
      'platform': _currentPlatform,
      'multiplier': _platformMultiplier,
      'standardDuration': getStandardizedFeedbackDuration().inMilliseconds,
      'slowModeDuration': getStandardizedFeedbackDuration(slowMode: true).inMilliseconds,
    };
  }
  
  /// Check if the current platform tends to show feedback longer
  bool get platformShowsLongerFeedback => _platformMultiplier < 1.0;
  
  /// Check if the current platform tends to show feedback shorter
  bool get platformShowsShorterFeedback => _platformMultiplier > 1.0;
}