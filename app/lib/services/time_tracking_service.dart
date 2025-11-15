import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../services/logger.dart';
import '../utils/bijbelquiz_gen_utils.dart';

/// Service to track time spent using the app for year-end statistics
class TimeTrackingService {
  static const String _totalTimeKey = 'total_time_spent_seconds';
  static const String _sessionStartTimeKey = 'session_start_time';
  static const String _lastSessionDateKey = 'last_session_date';
  static const String _genShownThisPeriodKey = 'gen_shown_this_period';

  SharedPreferences? _prefs;
  DateTime? _sessionStartTime;
  int _totalTimeSpent = 0; // in seconds
  Timer? _timer;
  static TimeTrackingService? _instance;
  bool _genShownThisPeriod = false;

  TimeTrackingService._privateConstructor();

  static TimeTrackingService get instance {
    _instance ??= TimeTrackingService._privateConstructor();
    return _instance!;
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _totalTimeSpent = _prefs?.getInt(_totalTimeKey) ?? 0;
    _loadSessionData();

    // Start tracking if we have an active session from before
    if (_sessionStartTime != null) {
      _startTracking();
    }
  }

  void _loadSessionData() {
    // Load session start time if exists
    final sessionStartMs = _prefs?.getInt(_sessionStartTimeKey);
    if (sessionStartMs != null) {
      _sessionStartTime = DateTime.fromMillisecondsSinceEpoch(sessionStartMs);
    }

    // Load last session date to check if it's a new day
    final lastSessionDateStr = _prefs?.getString(_lastSessionDateKey);
    if (lastSessionDateStr != null) {
      // We can use this for daily statistics if needed in the future
    }

    // Load whether Gen was shown during the current period
    _genShownThisPeriod = _prefs?.getBool(_genShownThisPeriodKey) ?? false;
  }

  /// Start a new session, but only if not already in a session
  void startSession() {
    // Prevent starting a new session if one is already active
    if (_sessionStartTime != null) {
      AppLogger.info('Session already active, not starting a new one');
      return;
    }

    _sessionStartTime = DateTime.now();
    _prefs?.setInt(
        _sessionStartTimeKey, _sessionStartTime!.millisecondsSinceEpoch);

    // Update last session date
    _prefs?.setString(
        _lastSessionDateKey, DateTime.now().toIso8601String().split('T')[0]);

    // Check if we're entering a new Gen period and reset the flag if needed
    _checkAndResetGenShownFlagForNewPeriod();

    _startTracking();
    AppLogger.info('Time tracking session started at $_sessionStartTime');
  }

  /// Check if we're in a new Gen period and reset the flag if needed
  void _checkAndResetGenShownFlagForNewPeriod() {
    if (_prefs != null) {
      // Get the year associated with the flag from shared preferences
      final lastGenYear = _prefs?.getInt('gen_year') ?? 0;
      final currentGenYear = BijbelQuizGenPeriod.getStatsYear();

      // If we're now in a different Gen year, reset the flag
      if (currentGenYear != lastGenYear) {
        _genShownThisPeriod = false;
        _prefs?.setBool(_genShownThisPeriodKey, false);
        _prefs?.setInt('gen_year', currentGenYear);
        AppLogger.info('Reset Gen shown flag for new period: $currentGenYear');
      }
    }
  }

  /// End the current session and save the time
  void endSession() {
    if (_sessionStartTime != null) {
      final sessionDuration = DateTime.now().difference(_sessionStartTime!);
      final sessionDurationSeconds = sessionDuration.inSeconds;

      // Only add significant session time (ignore sessions less than 10 seconds)
      if (sessionDurationSeconds >= 10) {
        _totalTimeSpent += sessionDurationSeconds;
        _prefs?.setInt(_totalTimeKey, _totalTimeSpent);
        AppLogger.info(
            'Valid session ended. Added ${sessionDurationSeconds}s. Total time now: $_totalTimeSpent seconds');
      } else {
        AppLogger.info(
            'Short session (${sessionDurationSeconds}s) ignored to prevent noise in tracking');
      }

      // Clear session start time
      _prefs?.remove(_sessionStartTimeKey);
      _sessionStartTime = null;

      _stopTracking();
    }
  }

  /// Start the internal timer to periodically save progress
  void _startTracking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_sessionStartTime != null) {
        final currentSessionTime =
            DateTime.now().difference(_sessionStartTime!);
        final totalWithCurrent = _totalTimeSpent + currentSessionTime.inSeconds;
        _prefs?.setInt(_totalTimeKey, totalWithCurrent);
      }
    });
  }

  /// Stop the internal timer
  void _stopTracking() {
    _timer?.cancel();
    _timer = null;
  }

  /// Get total time spent in seconds
  int getTotalTimeSpent() {
    if (_sessionStartTime != null) {
      final currentSessionTime = DateTime.now().difference(_sessionStartTime!);
      return _totalTimeSpent + currentSessionTime.inSeconds;
    }
    return _totalTimeSpent;
  }

  /// Get total time spent as a formatted string (HH:MM:SS)
  String getTotalTimeSpentFormatted() {
    final totalSeconds = getTotalTimeSpent();
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get total time spent in hours (rounded)
  double getTotalTimeSpentInHours() {
    return getTotalTimeSpent() / 3600.0;
  }

  /// Get total time spent in minutes (rounded)
  int getTotalTimeSpentInMinutes() {
    return getTotalTimeSpent() ~/ 60;
  }

  /// Reset all time tracking data (for testing purposes)
  Future<void> resetTimeTracking() async {
    _totalTimeSpent = 0;
    _prefs?.setInt(_totalTimeKey, 0);
    _prefs?.remove(_sessionStartTimeKey);
    _prefs?.remove(_lastSessionDateKey);
    _sessionStartTime = null;
    _stopTracking();
    AppLogger.info('Time tracking data reset');
  }

  /// Check if there's an ongoing session that needs to be resumed
  bool hasOngoingSession() {
    return _sessionStartTime != null;
  }

  /// Check if the BijbelQuiz Gen has been shown during the current period
  bool hasGenBeenShownThisPeriod() {
    return _genShownThisPeriod;
  }

  /// Mark that the BijbelQuiz Gen has been shown during the current period
  void markGenAsShownThisPeriod() {
    _genShownThisPeriod = true;
    _prefs?.setBool(_genShownThisPeriodKey, true);
  }

  /// Clean up resources
  void dispose() {
    _stopTracking();
  }
}
