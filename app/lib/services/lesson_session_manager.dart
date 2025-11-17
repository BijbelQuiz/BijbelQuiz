import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lesson.dart';
import '../providers/lesson_progress_provider.dart';
import '../services/analytics_service.dart';

/// Manages lesson session state and logic
class LessonSessionManager {
  int _sessionAnswered = 0;
  int _sessionCorrect = 0;
  int _sessionCurrentStreakLocal = 0;
  int _sessionBestStreak = 0;

  // Getters for session stats
  int get sessionAnswered => _sessionAnswered;
  int get sessionCorrect => _sessionCorrect;
  int get sessionCurrentStreakLocal => _sessionCurrentStreakLocal;
  int get sessionBestStreak => _sessionBestStreak;

  /// Reset session counters for a new lesson
  void resetSession() {
    _sessionAnswered = 0;
    _sessionCorrect = 0;
    _sessionCurrentStreakLocal = 0;
    _sessionBestStreak = 0;
  }

  /// Update session stats after answering a question
  void updateSessionStats(bool isCorrect) {
    _sessionAnswered += 1;
    if (isCorrect) {
      _sessionCorrect += 1;
      _sessionCurrentStreakLocal += 1;
    } else {
      _sessionCurrentStreakLocal = 0;
    }
    _sessionBestStreak = _sessionBestStreak > _sessionCurrentStreakLocal
        ? _sessionBestStreak
        : _sessionCurrentStreakLocal;
  }

  /// Check if session is complete
  bool isSessionComplete(int? sessionLimit) {
    return sessionLimit != null && _sessionAnswered >= sessionLimit;
  }

  /// Calculate stars for lesson completion
  int calculateStars(int total) {
    if (total == 0) return 0;
    final accuracy = _sessionCorrect / total;
    if (accuracy >= 0.9) return 3; // 90%+ = 3 stars
    if (accuracy >= 0.7) return 2; // 70%+ = 2 stars
    if (accuracy >= 0.5) return 1; // 50%+ = 1 star
    return 0; // Less than 50% = 0 stars
  }

  /// Complete the lesson session
  Future<void> completeLessonSession({
    required BuildContext context,
    required Lesson lesson,
    required int sessionLimit,
  }) async {
    // Get providers before async gap
    final analytics = Provider.of<AnalyticsService>(context, listen: false);
    final progress = Provider.of<LessonProgressProvider>(context, listen: false);

    // Calculate stars
    final stars = calculateStars(sessionLimit);

    // Track lesson completion
    analytics.trackFeatureCompletion(
      context,
      AnalyticsService.featureLessonSystem,
      additionalProperties: {
        'lesson_id': lesson.id,
        'lesson_category': lesson.category,
        'questions_answered': _sessionAnswered,
        'questions_correct': _sessionCorrect,
        'accuracy_rate': sessionLimit > 0 ? (_sessionCorrect / sessionLimit) : 0,
        'best_streak': _sessionBestStreak,
        'stars': stars,
      },
    );

    // Mark today's streak as active
    await _markStreakActive();

    // Persist lesson progress
    await progress.markCompleted(
      lesson: lesson,
      correct: _sessionCorrect,
      total: sessionLimit,
    );
  }

  /// Mark today's streak as active
  Future<void> _markStreakActive() async {
    try {
      // This would need to be implemented with SharedPreferences
      // For now, just a placeholder
    } catch (e) {
      // Ignore streak errors silently
    }
  }
}