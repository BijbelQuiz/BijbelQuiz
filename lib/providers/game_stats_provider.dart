import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import './settings_provider.dart';
import '../services/logger.dart';

/// Manages the app's game statistics including score and streaks
class GameStatsProvider extends ChangeNotifier {
  static const String _scoreKey = 'game_score';
  static const String _currentStreakKey = 'game_current_streak';
  static const String _longestStreakKey = 'game_longest_streak';
  static const String _incorrectAnswersKey = 'game_incorrect_answers';
  
  SharedPreferences? _prefs;
  int _score = 0;
  int _currentStreak = 0;
  int _longestStreak = 0;
  int _incorrectAnswers = 0;
  bool _isLoading = true;
  String? _error;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  void Function(String message)? onError;

  Powerup? _activePowerup;
  DateTime? _powerupActivatedAt;

  Powerup? get activePowerup => _activePowerup;
  bool get isPowerupActive => _activePowerup != null;
  int? get powerupMultiplier => _activePowerup?.multiplier;
  int? get powerupQuestionsLeft => _activePowerup?.questionsRemaining;
  Duration? get powerupTimeLeft {
    if (_activePowerup == null || !_activePowerup!.byQuestions) {
      if (_powerupActivatedAt != null && _activePowerup?.timeRemaining != null) {
        final elapsed = DateTime.now().difference(_powerupActivatedAt!);
        final left = _activePowerup!.timeRemaining! - elapsed;
        return left > Duration.zero ? left : Duration.zero;
      }
    }
    return null;
  }

  void activatePowerup({required int multiplier, int? questions, Duration? time}) {
    if (questions != null) {
      _activePowerup = Powerup(multiplier: multiplier, questionsRemaining: questions, byQuestions: true);
      _powerupActivatedAt = null;
    } else if (time != null) {
      _activePowerup = Powerup(multiplier: multiplier, timeRemaining: time, byQuestions: false);
      _powerupActivatedAt = DateTime.now();
    }
    notifyListeners();
  }

  void _decrementPowerup() {
    if (_activePowerup == null) return;
    if (_activePowerup!.byQuestions) {
      final left = (_activePowerup!.questionsRemaining ?? 1) - 1;
      if (left > 0) {
        _activePowerup = _activePowerup!.copyWith(questionsRemaining: left);
      } else {
        _activePowerup = null;
      }
      notifyListeners();
    } else {
      // Time-based: check if expired
      if (powerupTimeLeft != null && powerupTimeLeft! <= Duration.zero) {
        _activePowerup = null;
        _powerupActivatedAt = null;
        notifyListeners();
      }
    }
  }

  void clearPowerup() {
    _activePowerup = null;
    _powerupActivatedAt = null;
    notifyListeners();
  }

  GameStatsProvider() {
    _loadStats();
  }

  /// The current game score
  int get score => _score;
  
  /// The current streak of correct answers
  int get currentStreak => _currentStreak;
  
  /// The longest streak achieved
  int get longestStreak => _longestStreak;

  /// The number of incorrect answers
  int get incorrectAnswers => _incorrectAnswers;
  
  /// Whether stats are currently being loaded
  bool get isLoading => _isLoading;
  
  /// Any error that occurred while loading stats
  String? get error => _error;

  /// Loads game stats from persistent storage
  Future<void> _loadStats() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _prefs = await SharedPreferences.getInstance();
      _score = _prefs?.getInt(_scoreKey) ?? 0;
      _currentStreak = _prefs?.getInt(_currentStreakKey) ?? 0;
      _longestStreak = _prefs?.getInt(_longestStreakKey) ?? 0;
      _incorrectAnswers = _prefs?.getInt(_incorrectAnswersKey) ?? 0;
      AppLogger.info('Game stats loaded: score=$_score, streak=$_currentStreak, longest=$_longestStreak, incorrect=$_incorrectAnswers');
    } catch (e) {
      _error = 'Failed to load game stats: ${e.toString()}';
      onError?.call(_error!);
      AppLogger.error(_error!, e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates the game stats when a question is answered
  Future<void> updateStats({required bool isCorrect}) async {
    try {
      int pointsToAdd = 1;
      if (isCorrect) {
        // Powerup logic
        if (_activePowerup != null) {
          // Check if time-based powerup expired
          if (!_activePowerup!.byQuestions && powerupTimeLeft != null && powerupTimeLeft! <= Duration.zero) {
            clearPowerup();
          }
          if (_activePowerup != null) {
            pointsToAdd = _activePowerup!.multiplier;
            if (_activePowerup!.byQuestions) {
              _decrementPowerup();
            }
          }
        }
        _score += pointsToAdd;
        _currentStreak++;
        if (_currentStreak > _longestStreak) {
          _longestStreak = _currentStreak;
          pointsToAdd += 5;
          _score += 5;
          await _prefs?.setInt(_longestStreakKey, _longestStreak);
        }
        // Play click sound for each point earned
        for (int i = 0; i < pointsToAdd; i++) {
          await _playClickSound();
          // Add a small delay between sounds
          if (i < pointsToAdd - 1) {
            await Future.delayed(const Duration(milliseconds: 100));
          }
        }
        AppLogger.info('Stats updated: correct, score=$_score, streak=$_currentStreak, longest=$_longestStreak');
      } else {
        _currentStreak = 0;
        _incorrectAnswers++;
        await _prefs?.setInt(_incorrectAnswersKey, _incorrectAnswers);
        AppLogger.info('Stats updated: incorrect, score=$_score, streak=$_currentStreak, incorrect=$_incorrectAnswers');
      }
      await _prefs?.setInt(_scoreKey, _score);
      await _prefs?.setInt(_currentStreakKey, _currentStreak);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save game stats: ${e.toString()}';
      notifyListeners();
      AppLogger.error(_error!, e);
      rethrow;
    }
  }

  /// Resets all game stats to zero
  Future<void> resetStats() async {
    try {
      _score = 0;
      _currentStreak = 0;
      _longestStreak = 0;
      _incorrectAnswers = 0;
      
      await _prefs?.setInt(_scoreKey, _score);
      await _prefs?.setInt(_currentStreakKey, _currentStreak);
      await _prefs?.setInt(_longestStreakKey, _longestStreak);
      await _prefs?.setInt(_incorrectAnswersKey, _incorrectAnswers);
      notifyListeners();
      AppLogger.info('Game stats reset');
    } catch (e) {
      _error = 'Failed to reset game stats: ${e.toString()}';
      onError?.call(_error!);
      notifyListeners();
      AppLogger.error(_error!, e);
      rethrow;
    }
  }

  /// Plays the click sound when a point is added
  Future<void> _playClickSound() async {
    try {
      final context = navigatorKey.currentContext;
      if (context != null) {
        final settings = Provider.of<SettingsProvider>(context, listen: false);
        if (settings.mute) return;
        await _playSystemSound('assets/sounds/click.mp3');
        AppLogger.debug('Played click sound');
      }
    } catch (e) {
      AppLogger.error('Error playing click sound', e);
    }
  }

  /// Plays a sound using system audio commands
  Future<void> _playSystemSound(String assetPath) async {
    if (!Platform.isLinux) {
      AppLogger.warning('System audio only supported on Linux');
      return;
    }

    try {
      final isMp3 = assetPath.toLowerCase().endsWith('.mp3');
      // For MP3, use mpg123 or ffplay only
      final players = isMp3
          ? [
              {'name': 'mpg123', 'args': ['-q', assetPath]},
              {'name': 'ffplay', 'args': ['-nodisp', '-autoexit', '-loglevel', 'error', assetPath]},
            ]
          : [
              // For WAV/PCM, you could add aplay/paplay here if you add WAV assets
            ];
      bool played = false;
      for (final player in players) {
        try {
          final result = await Process.run('which', [player['name'] as String]);
          if (result.exitCode == 0) {
            AppLogger.info('Trying to play sound with: ${player['name']} ${player['args']}');
            final soundResult = await Process.run(
              player['name'] as String,
              player['args'] as List<String>,
            ).timeout(const Duration(seconds: 2));
            if (soundResult.exitCode == 0) {
              AppLogger.info('Sound played successfully with: ${player['name']}');
              played = true;
              break;
            } else {
              AppLogger.error('Player ${player['name']} failed: exit code ${soundResult.exitCode}, stderr: ${soundResult.stderr}');
            }
          } else {
            AppLogger.debug('Player not found: ${player['name']}');
          }
        } catch (e) {
          AppLogger.error('Exception trying player ${player['name']}', e);
          continue; // Try next player
        }
      }
      if (!played) {
        AppLogger.warning('No suitable player found or all failed for sound: $assetPath');
        await _playBeep();
      }
    } catch (e) {
      AppLogger.error('Error playing system sound', e);
      await _playBeep();
    }
  }

  /// Plays a simple beep sound as fallback
  Future<void> _playBeep() async {
    try {
      // Try to play a beep using the terminal bell
      await Process.run('echo', ['-e', '\x07']);
      AppLogger.debug('Played beep sound');
    } catch (e) {
      AppLogger.error('Error playing beep', e);
    }
  }

  /// Attempts to spend points for a retry
  /// Returns true if successful, false if not enough points
  Future<bool> spendPointsForRetry() async {
    try {
      if (_score >= 50) {
        _score -= 50;
        await _prefs?.setInt(_scoreKey, _score);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to spend points: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Spends stars for a feature (e.g., skip question). Returns true if successful, false if not enough stars.
  Future<bool> spendStars(int amount) async {
    if (_score >= amount) {
      _score -= amount;
      await _prefs?.setInt(_scoreKey, _score);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  /// Gets all game stats data for export
  Map<String, dynamic> getExportData() {
    return {
      'score': _score,
      'currentStreak': _currentStreak,
      'longestStreak': _longestStreak,
      'incorrectAnswers': _incorrectAnswers,
    };
  }

  /// Loads game stats data from import
  Future<void> loadImportData(Map<String, dynamic> data) async {
    _score = data['score'] ?? 0;
    _currentStreak = data['currentStreak'] ?? 0;
    _longestStreak = data['longestStreak'] ?? 0;
    _incorrectAnswers = data['incorrectAnswers'] ?? 0;

    await _prefs?.setInt(_scoreKey, _score);
    await _prefs?.setInt(_currentStreakKey, _currentStreak);
    await _prefs?.setInt(_longestStreakKey, _longestStreak);
    await _prefs?.setInt(_incorrectAnswersKey, _incorrectAnswers);
    notifyListeners();
  }
}

// Powerup model
class Powerup {
  final int multiplier; // 2, 3, or 5
  final int? questionsRemaining; // null if time-based
  final Duration? timeRemaining; // null if question-based
  final bool byQuestions; // true: by questions, false: by time

  Powerup({
    required this.multiplier,
    this.questionsRemaining,
    this.timeRemaining,
    required this.byQuestions,
  });

  Powerup copyWith({
    int? multiplier,
    int? questionsRemaining,
    Duration? timeRemaining,
    bool? byQuestions,
  }) {
    return Powerup(
      multiplier: multiplier ?? this.multiplier,
      questionsRemaining: questionsRemaining ?? this.questionsRemaining,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      byQuestions: byQuestions ?? this.byQuestions,
    );
  }
} 