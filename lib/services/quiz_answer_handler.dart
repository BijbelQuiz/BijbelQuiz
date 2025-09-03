import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_question.dart';
import '../models/quiz_state.dart';
import '../providers/game_stats_provider.dart';
import '../providers/settings_provider.dart';
import '../services/sound_service.dart';
import '../services/platform_feedback_service.dart';
import '../services/logger.dart';

/// Callback for updating quiz state
typedef UpdateQuizStateCallback = void Function(QuizState newState);

/// Callback for triggering animations
typedef TriggerAnimationsCallback = void Function();

/// Callback for handling next question transition
typedef HandleNextQuestionCallback = Future<void> Function(bool isCorrect, double newDifficulty);

/// Handles quiz answer processing, sound feedback, and state transitions
class QuizAnswerHandler {
  final SoundService _soundService;
  final PlatformFeedbackService _platformFeedbackService;

  QuizAnswerHandler({
    required SoundService soundService,
    required PlatformFeedbackService platformFeedbackService,
  }) : _soundService = soundService,
       _platformFeedbackService = platformFeedbackService;

  /// Handle user answer selection
  void handleAnswer({
    required int selectedIndex,
    required QuizState quizState,
    required UpdateQuizStateCallback updateQuizState,
    required HandleNextQuestionCallback handleNextQuestion,
  }) {
    if (quizState.isAnswering) return;

    // Set isAnswering: true immediately to prevent double triggering
    updateQuizState(quizState.copyWith(
      selectedAnswerIndex: selectedIndex,
      isAnswering: true,
    ));

    if (quizState.question.type == QuestionType.mc || quizState.question.type == QuestionType.fitb) {
      final selectedAnswer = quizState.question.allOptions[selectedIndex];
      final isCorrect = selectedAnswer == quizState.question.correctAnswer;

      // Handle the answer sequence
      _handleAnswerSequence(
        isCorrect: isCorrect,
        quizState: quizState,
        updateQuizState: updateQuizState,
        handleNextQuestion: handleNextQuestion,
      );
    } else if (quizState.question.type == QuestionType.tf) {
      // For true/false: index 0 = 'Goed', index 1 = 'Fout'
      // Determine if the answer is correct by comparing indices rather than text
      final lcCorrect = quizState.question.correctAnswer.toLowerCase();
      final correctIndex = (lcCorrect == 'waar' || lcCorrect == 'true' || lcCorrect == 'goed') ? 0 : 1;
      final isCorrect = selectedIndex == correctIndex;

      // Handle the answer sequence
      _handleAnswerSequence(
        isCorrect: isCorrect,
        quizState: quizState,
        updateQuizState: updateQuizState,
        handleNextQuestion: handleNextQuestion,
      );
    } else {
      // For other types, do nothing for now
    }
  }

  Future<void> _handleAnswerSequence({
    required bool isCorrect,
    required QuizState quizState,
    required UpdateQuizStateCallback updateQuizState,
    required HandleNextQuestionCallback handleNextQuestion,
  }) async {
    AppLogger.info('Answer selected: ${isCorrect ? 'correct' : 'incorrect'} for question');

    // Start sound playing in background (don't await to prevent blocking)
    if (isCorrect) {
      _playCorrectAnswerSound().catchError((e) {
        // Ignore sound errors to prevent affecting visual feedback timing
        AppLogger.warning('Sound playback error (correct): $e');
      });
    } else {
      _playIncorrectAnswerSound().catchError((e) {
        // Ignore sound errors to prevent affecting visual feedback timing
        AppLogger.warning('Sound playback error (incorrect): $e');
      });
    }

    // Use platform-standardized feedback duration for consistent cross-platform experience
    // This timing is independent of sound playback duration
    final feedbackDuration = _platformFeedbackService.getStandardizedFeedbackDuration(
      slowMode: false // Will be passed from settings
    );

    // Phase 1: Show feedback (wait for standardized feedback duration)
    // This ensures consistent visual feedback timing regardless of sound file duration
    await Future.delayed(feedbackDuration);

    // Phase 2: Clear feedback and prepare for transition
    updateQuizState(quizState.copyWith(
      selectedAnswerIndex: null,
      isTransitioning: true,
    ));

    // Phase 3: Brief pause before transition (platform-optimized)
    final transitionPause = _platformFeedbackService.getTransitionPauseDuration();
    await Future.delayed(transitionPause);

    // Phase 4: Transition to next question
    await handleNextQuestion(isCorrect, quizState.currentDifficulty);
  }

  Future<void> _playCorrectAnswerSound() async {
    try {
      await _soundService.playCorrect();
    } catch (e) {
      debugPrint('Error playing correct sound: $e');
    }
  }

  Future<void> _playIncorrectAnswerSound() async {
    try {
      await _soundService.playIncorrect();
    } catch (e) {
      debugPrint('Error playing incorrect sound: $e');
    }
  }

  /// Process answer result and update stats
  Future<void> processAnswerResult({
    required bool isCorrect,
    required QuizState quizState,
    required BuildContext context,
    required TriggerAnimationsCallback triggerAnimations,
    required UpdateQuizStateCallback updateQuizState,
  }) async {
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    // Update stats using the provider
    gameStats.updateStats(isCorrect: isCorrect);
    // Trigger animations for stats updates
    triggerAnimations();

    // Calculate new difficulty (this will be handled by ProgressiveQuestionSelector)
    // For now, just return the current difficulty
    final newDifficulty = quizState.currentDifficulty;

    // Update quiz state with new question and difficulty
    // This will be called after picking next question
  }
}