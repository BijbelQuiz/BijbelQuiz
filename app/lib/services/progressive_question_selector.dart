import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_question.dart';
import '../providers/game_stats_provider.dart';
import '../services/question_cache_service.dart';
import '../services/question_loading_service.dart';

/// Manages the Progressive Question Up-selection (PQU) algorithm
/// for dynamic difficulty adjustment and question selection
class ProgressiveQuestionSelector {
  final QuestionLoadingService _questionLoadingService;

  // Track used questions to avoid repetition
  final Set<String> _usedQuestions = {};
  final List<String> _recentlyUsedQuestions = [];
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

  Set<String> get usedQuestions => _usedQuestions;
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
  /// 5. Selecting questions within ±1 difficulty level of target
  /// 6. Filtering out recently used questions to prevent repetition
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

    // PHASE 3: Constrain difficulty to valid range
    // Internal difficulty scale: [0..2] maps to JSON levels [1..5]
    targetDifficulty = targetDifficulty.clamp(0.0, 2.0);

    // PHASE 4: Map internal difficulty to JSON difficulty levels
    // Formula: level = 1 + (normalized_difficulty * 2)
    // Examples: 0.0 -> 1, 1.0 -> 3, 2.0 -> 5
    final int targetLevel = (1 + (targetDifficulty * 2).round()).clamp(1, 5);

    // PHASE 5: Select available questions (not used in current session)
    List<QuizQuestion> availableQuestions =
        allQuestions.where((q) => !_usedQuestions.contains(q.question)).toList();

    // PHASE 6: Handle question pool exhaustion
    // When all questions are used, reset and reshuffle for continued gameplay
    if (availableQuestions.isEmpty) {
      _usedQuestions.clear();
      _recentlyUsedQuestions.clear();
      allQuestions.shuffle(Random()); // Randomize order for variety
      availableQuestions = List<QuizQuestion>.from(allQuestions);

      // Load additional questions in background if running low
      if (_setState != null) {
        _questionLoadingService.loadMoreQuestionsAdvanced(
          context: context,
          questions: allQuestions,
          setState: _setState!,
          mounted: _mounted,
        );
      }
    }

    // PHASE 7: Filter questions by difficulty (prefer close matches)
    // First preference: questions within ±1 difficulty level of target
    List<QuizQuestion> eligibleQuestions = availableQuestions.where((q) {
      final int qLevel = int.tryParse(q.difficulty.toString()) ?? 3;
      return (qLevel - targetLevel).abs() <= 1;
    }).toList();

    // Second preference: exact difficulty level match
    if (eligibleQuestions.isEmpty) {
      eligibleQuestions = availableQuestions.where((q) {
        final int qLevel = int.tryParse(q.difficulty.toString()) ?? 3;
        return qLevel == targetLevel;
      }).toList();
    }

    // Final fallback: any available question
    if (eligibleQuestions.isEmpty) {
      eligibleQuestions = availableQuestions;
    }

    // PHASE 8: Apply anti-repetition filter
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
      _usedQuestions.clear();
      _recentlyUsedQuestions.clear();
      filteredQuestions = eligibleQuestions;
    }

    // PHASE 9: Random selection from eligible questions
    final random = Random();
    final selectedQuestion = filteredQuestions[random.nextInt(filteredQuestions.length)];

    // PHASE 10: Update usage tracking
    _usedQuestions.add(selectedQuestion.question);
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
  /// - Random variation (prevents difficulty stagnation)
  ///
  /// @param currentDifficulty Current normalized difficulty [0..2]
  /// @param isCorrect Whether the last answer was correct
  /// @param streak Current consecutive correct answers streak
  /// @param timeRemaining Seconds left when answer was given
  /// @param totalQuestions Total questions answered in session
  /// @param correctAnswers Number of correct answers in session
  /// @param incorrectAnswers Number of incorrect answers in session
  /// @return New normalized difficulty level [0..2]
  double calculateNextDifficulty({
    required double currentDifficulty,
    required bool isCorrect,
    required int streak,
    required int timeRemaining,
    required int totalQuestions,
    required int correctAnswers,
    required int incorrectAnswers,
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

    // PHASE 4: Constrain to valid difficulty range
    return targetDifficulty.clamp(0.0, 2.0);
  }



  /// Reset question pool for new game or language change
  void resetQuestionPool() {
    _usedQuestions.clear();
    _recentlyUsedQuestions.clear();
    allQuestionsLoaded = false;
    allQuestions.clear();
  }

  /// Reset for new game session
  void resetForNewGame() {
    _usedQuestions.clear();
    _recentlyUsedQuestions.clear();
    allQuestions.shuffle(Random());
  }
}