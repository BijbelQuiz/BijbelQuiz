import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_question.dart';
import '../providers/game_stats_provider.dart';
import '../providers/settings_provider.dart';
import '../services/question_cache_service.dart';
import '../services/question_loading_service.dart';

/// Thrown when there are no more unique questions available in the current session
class NoMoreUniqueQuestionsException implements Exception {
  final String message;
  NoMoreUniqueQuestionsException([this.message = 'No more unique questions available in this session.']);
  @override
  String toString() => 'NoMoreUniqueQuestionsException: $message';
}

/// Manages the Progressive Question Up-selection (PQU) algorithm
/// for dynamic difficulty adjustment and question selection
/// 
/// The algorithm supports all difficulty levels (1-5 including 2 and 4)
/// using cumulative selection where users get questions from level 1 
/// up to their current target level.
class ProgressiveQuestionSelector {
  final QuestionLoadingService _questionLoadingService;

  // Track used questions to avoid repetition
  final Set<String> _correctlyAnsweredQuestions = {}; // Questions answered correctly (should not appear again)
  final Set<String> _shownQuestions = {}; // Questions that have been shown (regardless of answer correctness)
  final List<String> _recentlyUsedQuestions = []; // Recently used questions to prevent immediate repetition
  static const int _recentlyUsedLimit = 50;

  // All loaded questions - made public instead of using getters/setters
  List<QuizQuestion> allQuestions = [];
  bool allQuestionsLoaded = false;

  // State management for background loading
  bool _mounted = true;
  void Function(void Function())? _setState;

  ProgressiveQuestionSelector({
    required QuestionCacheService questionCacheService,
  }) : _questionLoadingService = QuestionLoadingService(questionCacheService);

  /// Set the state callback for background loading updates
  void setStateCallback(void Function(void Function()) setStateCallback) {
    _setState = setStateCallback;
  }

  /// Set mounted state for background operations
  void setMounted(bool mounted) {
    _mounted = mounted;
  }

  Set<String> get usedQuestions => _correctlyAnsweredQuestions;
  Set<String> get shownQuestions => _shownQuestions;
  List<String> get recentlyUsedQuestions => _recentlyUsedQuestions;

  

    /// PQU: Progressive Question Up-selection algorithm
  /// This algorithm dynamically adjusts question difficulty based on player performance
  /// to maintain an optimal challenge level and prevent boredom or frustration.
  ///
  /// The algorithm works by:
  /// 1. Analyzing recent performance (correct/incorrect ratio)
  /// 2. Adjusting target difficulty based on performance thresholds
  /// 3. Applying dampening for long sessions to prevent extreme swings
  /// 4. Mapping internal difficulty scale [0..2] to JSON levels [1..5]
  /// 5. Selecting questions from level 1 up to the target difficulty level (cumulative selection)
  /// 6. Filtering out recently used questions to prevent repetition
  /// 7. Applying user feedback preferences to adjust difficulty
  ///
  /// @param currentDifficulty The current normalized difficulty [0..2]
  /// @return The next question selected by the algorithm
  QuizQuestion pickNextQuestion(double currentDifficulty, BuildContext context) {
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    double targetDifficulty = currentDifficulty;
    final totalQuestions = gameStats.score + gameStats.incorrectAnswers;

    // PHASE 1: Calculate target difficulty based on recent performance
    if (totalQuestions > 0) {
      final correctRatio = gameStats.score / totalQuestions;

      // Performance-based difficulty adjustment
      // High performance (>90% correct): Increase difficulty significantly
      if (correctRatio > 0.9) {
        targetDifficulty += 0.05;
      }
      // Good performance (75-90% correct): Increase difficulty moderately
      else if (correctRatio > 0.75) {
        targetDifficulty += 0.03;
      }
      // Poor performance (<30% correct): Decrease difficulty significantly
      else if (correctRatio < 0.3) {
        targetDifficulty -= 0.05;
      }
      // Below average performance (30-50% correct): Decrease difficulty moderately
      else if (correctRatio < 0.5) {
        targetDifficulty -= 0.03;
      }

      // PHASE 2: Apply dampening for long gaming sessions
      // Prevents extreme difficulty swings after many questions
      // Reduces the adjustment magnitude as session length increases
      if (totalQuestions > 30) {
        final adjustment = targetDifficulty - currentDifficulty;
        targetDifficulty = currentDifficulty + (adjustment * 0.7);
      }
    }

    // PHASE 3: Apply user difficulty preference if available
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (settings.difficultyPreference != null) {
      switch (settings.difficultyPreference) {
        case 'too_hard':
          // User finds questions too hard, decrease difficulty slightly
          targetDifficulty = (targetDifficulty - 0.2).clamp(0.0, 2.0);
          break;
        case 'too_easy':
          // User finds questions too easy, increase difficulty slightly
          targetDifficulty = (targetDifficulty + 0.2).clamp(0.0, 2.0);
          break;
        case 'good':
          // User finds questions good, maintain current difficulty (no change needed)
          break;
      }
    }

    // PHASE 4: Constrain difficulty to valid range
    // Internal difficulty scale: [0..2] maps to JSON levels [1..5]
    targetDifficulty = targetDifficulty.clamp(0.0, 2.0);

    // PHASE 5: Map internal difficulty to JSON difficulty levels
    // Formula: level = 1 + (normalized_difficulty * 2).round()
    // Examples: 0.0 -> 1 (easiest), 0.5 -> 2 (easy), 1.0 -> 3 (medium), 1.5 -> 4 (hard), 2.0 -> 5 (hardest)
    final int targetLevel = (1 + (targetDifficulty * 2).round()).clamp(1, 5);

    // PHASE 6: Select available questions (not answered correctly in current session)
    // Questions that were answered incorrectly can be shown again
    List<QuizQuestion> availableQuestions =
        allQuestions.where((q) => !_correctlyAnsweredQuestions.contains(q.question)).toList();

    // PHASE 7: Handle question pool exhaustion (3-phase strategy)
    // 1) Use unique questions filtered by level (handled below in PHASE 8)
    // 2) If level-filter yields none, widen to any remaining unique questions (PHASE 8 fallbacks)
    // 3) If no unique questions remain in entire DB, reset used tracking and start over
    if (availableQuestions.isEmpty) {
      // Try to load more in background first
      if (_setState != null) {
        _questionLoadingService.loadMoreQuestionsAdvanced(
          context: context,
          questions: allQuestions,
          setState: _setState!,
          mounted: _mounted,
        );
      }
      // Recompute after background load attempt
      availableQuestions = allQuestions.where((q) => !_correctlyAnsweredQuestions.contains(q.question)).toList();
      if (availableQuestions.isEmpty) {
        // Phase 3: all unique questions exhausted -> reset session usage and start over
        _correctlyAnsweredQuestions.clear();
        _shownQuestions.clear();
        _recentlyUsedQuestions.clear();
        allQuestions.shuffle(Random());
        availableQuestions = List<QuizQuestion>.from(allQuestions);
      }
    }

    // PHASE 8: Filter questions by difficulty (cumulative level selection)
    // Users get questions from level 1 up to their current target level (inclusive)
    // For example: if user is at level 3, they get questions from levels 1, 2, and 3
    // For example: if user is at level 4, they get questions from levels 1, 2, 3, and 4
    // This ensures that users always see easier questions as they progress
    List<QuizQuestion> eligibleQuestions = availableQuestions.where((q) {
      // Parse question difficulty as integer (levels 1-5)
      final int qLevel = int.tryParse(q.difficulty.toString()) ?? 3;
      // Ensure level is within valid range [1-5]
      final int clampedLevel = qLevel.clamp(1, 5);
      return clampedLevel <= targetLevel;
    }).toList();

    // Fallback: if no questions available at or below target level, 
    // use questions at the next possible level(s)
    if (eligibleQuestions.isEmpty) {
      // Find questions at any level higher than target as a temporary fallback
      eligibleQuestions = availableQuestions.where((q) {
        final int qLevel = int.tryParse(q.difficulty.toString()) ?? 3;
        return qLevel > targetLevel;
      }).toList();
    }

    // Final fallback: if still empty, keep the entire remaining unique pool
    if (eligibleQuestions.isEmpty) {
      eligibleQuestions = availableQuestions;
    }

    // PHASE 9: Apply anti-repetition filter
    // Prevent showing recently used questions to maintain engagement
    List<QuizQuestion> filteredQuestions = eligibleQuestions.where((q) =>
        !_recentlyUsedQuestions.contains(q.question)).toList();

    // Emergency fallback: if all eligible questions are recent, clear recent list
    if (filteredQuestions.isEmpty && eligibleQuestions.isNotEmpty) {
      filteredQuestions = eligibleQuestions;
      _recentlyUsedQuestions.clear();
    }

    // Additional fallback: if we still have no questions after clearing recent list,
    // it means we have a logic error - reset everything
    if (filteredQuestions.isEmpty) {
      _correctlyAnsweredQuestions.clear();
      _shownQuestions.clear();
      _recentlyUsedQuestions.clear();
      filteredQuestions = eligibleQuestions;
    }

    // PHASE 10: Random selection from eligible questions
    final random = Random();
    final selectedQuestion = filteredQuestions[random.nextInt(filteredQuestions.length)];

    // PHASE 11: Update usage tracking
    // Add to shown questions but not necessarily to correctly answered questions
    // Questions are only added to _correctlyAnsweredQuestions if answered correctly later
    _shownQuestions.add(selectedQuestion.question);
    _recentlyUsedQuestions.add(selectedQuestion.question);

    // Maintain recent questions list size limit (FIFO eviction)
    if (_recentlyUsedQuestions.length > _recentlyUsedLimit) {
      _recentlyUsedQuestions.removeAt(0);
    }

    return selectedQuestion;
  }

  /// PQU: Progressive Difficulty Update Function
  /// Calculates the next difficulty level based on comprehensive performance metrics.
  ///
  /// This function considers multiple factors:
  /// - Answer correctness (primary factor)
  /// - Current streak length (reward/punish sustained performance)
  /// - Time remaining when answered (speed bonus/malus)
  /// - Overall session performance ratio (long-term adjustment)
  /// - User difficulty preference (feedback-based adjustment)
  /// - Random variation (prevents difficulty stagnation)
  ///
  /// @param currentDifficulty Current normalized difficulty [0..2]
  /// @param isCorrect Whether the last answer was correct
  /// @param streak Current consecutive correct answers streak
  /// @param timeRemaining Seconds left when answer was given
  /// @param totalQuestions Total questions answered in session
  /// @param correctAnswers Number of correct answers in session
  /// @param incorrectAnswers Number of incorrect answers in session
  /// @param context BuildContext to access SettingsProvider
  /// @return New normalized difficulty level [0..2]
  double calculateNextDifficulty({
    required double currentDifficulty,
    required bool isCorrect,
    required int streak,
    required int timeRemaining,
    required int totalQuestions,
    required int correctAnswers,
    required int incorrectAnswers,
    required BuildContext? context,
  }) {
    double targetDifficulty = currentDifficulty;
    final correctRatio = totalQuestions > 0 ? correctAnswers / totalQuestions : 0.5;

    // PHASE 1: Immediate performance-based adjustment
    if (isCorrect) {
      // Base reward for correct answer
      targetDifficulty += 0.08;

      // Streak bonus: reward sustained performance
      // Every 3 consecutive correct answers adds extra difficulty
      if (streak >= 3) {
        targetDifficulty += 0.05 * (streak ~/ 3);
      }

      // Speed bonus: reward quick correct answers
      if (timeRemaining > 10) {
        targetDifficulty += 0.05;
      }
    } else {
      // Penalty for incorrect answer
      targetDifficulty -= 0.1;

      // Extra penalty for breaking a streak
      if (streak == 0) {
        targetDifficulty -= 0.05;
      }

      // Extra penalty for slow incorrect answers
      if (timeRemaining < 5) {
        targetDifficulty -= 0.03;
      }
    }

    // PHASE 2: Long-term performance bias
    // Adjust based on overall session performance
    if (correctRatio > 0.85) {
      targetDifficulty += 0.05; // Consistently high performance
    } else if (correctRatio < 0.5) {
      targetDifficulty -= 0.05; // Consistently low performance
    }

    // PHASE 3: Anti-stagnation randomization
    // Add small random variation to prevent getting stuck at same difficulty
    // This ensures the algorithm explores different difficulty levels over time
    final random = Random();
    targetDifficulty += (random.nextDouble() - 0.5) * 0.15;

    // PHASE 4: Apply user difficulty preference if available
    if (context != null) {
      try {
        final settings = Provider.of<SettingsProvider>(context, listen: false);
        if (settings.difficultyPreference != null) {
          switch (settings.difficultyPreference) {
            case 'too_hard':
              // User finds questions too hard, decrease difficulty slightly
              targetDifficulty = (targetDifficulty - 0.2).clamp(0.0, 2.0);
              break;
            case 'too_easy':
              // User finds questions too easy, increase difficulty slightly
              targetDifficulty = (targetDifficulty + 0.2).clamp(0.0, 2.0);
              break;
            case 'good':
              // User finds questions good, maintain current difficulty (no change needed)
              break;
          }
        }
      } catch (e) {
        // If context is not valid (e.g., disposed), skip settings access
        // This can happen during app lifecycle changes
      }
    }

    // PHASE 5: Constrain to valid difficulty range
    return targetDifficulty.clamp(0.0, 2.0);
  }



  /// Reset question pool for new game or language change
  void resetQuestionPool() {
    _correctlyAnsweredQuestions.clear();
    _shownQuestions.clear();
    _recentlyUsedQuestions.clear();
    allQuestionsLoaded = false;
    allQuestions.clear();
  }

  /// Record the result of answering a question
  /// If the answer was correct, the question will not be shown again
  /// If the answer was incorrect, the question can be shown again
  void recordAnswerResult(String questionText, bool isCorrect) {
    if (isCorrect) {
      _correctlyAnsweredQuestions.add(questionText);
    } else {
      // If the answer was incorrect, remove from shown questions 
      // to allow it to potentially be shown again (though it will still be in recently used for a while)
      // We don't need to remove from shown set because availability is based on _correctlyAnsweredQuestions only
    }
  }

  /// Reset for new game session
  void resetForNewGame() {
    _correctlyAnsweredQuestions.clear();
    _shownQuestions.clear();
    _recentlyUsedQuestions.clear();
    allQuestions.shuffle(Random());
  }
}