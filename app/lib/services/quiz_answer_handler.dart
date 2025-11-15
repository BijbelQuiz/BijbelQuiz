import 'dart:async';
import 'package:flutter/material.dart';

import '../models/quiz_question.dart';
import '../models/quiz_state.dart';
import '../services/sound_service.dart';
import '../services/platform_feedback_service.dart';
import '../services/logger.dart';
import '../services/quiz_sound_service.dart';

/// Callback for updating quiz state
typedef UpdateQuizStateCallback = void Function(QuizState newState);

/// Callback for triggering animations
typedef TriggerAnimationsCallback = void Function();

/// Callback for handling next question transition
typedef HandleNextQuestionCallback = Future<void> Function(
    bool isCorrect, double newDifficulty);

/// Handles quiz answer processing, sound feedback, and state transitions
class QuizAnswerHandler {
  final PlatformFeedbackService _platformFeedbackService;
  final QuizSoundService _quizSoundService;
  final bool _enableSounds;
  bool _isProcessingAnswer = false; // Additional protection against rapid calls

  QuizAnswerHandler({
    required SoundService soundService,
    required PlatformFeedbackService platformFeedbackService,
    bool enableSounds = true,
  })  : _platformFeedbackService = platformFeedbackService,
        _quizSoundService = QuizSoundService(soundService),
        _enableSounds = enableSounds;

  /// Handle user answer selection
  void handleAnswer({
    required int selectedIndex,
    required QuizState quizState,
    required UpdateQuizStateCallback updateQuizState,
    required HandleNextQuestionCallback handleNextQuestion,
    required BuildContext context,
  }) {
    // Triple-check race condition prevention
    if (quizState.isAnswering || _isProcessingAnswer) return;

    _isProcessingAnswer = true;

    try {
      // Set isAnswering: true immediately to prevent double triggering
      updateQuizState(quizState.copyWith(
        selectedAnswerIndex: selectedIndex,
        isAnswering: true,
      ));

      if (quizState.question.type == QuestionType.mc ||
          quizState.question.type == QuestionType.fitb) {
        final selectedAnswer = quizState.question.allOptions[selectedIndex];
        final isCorrect = selectedAnswer == quizState.question.correctAnswer;

        // Handle the answer sequence
        _handleAnswerSequence(
          isCorrect: isCorrect,
          quizState: quizState,
          updateQuizState: updateQuizState,
          handleNextQuestion: handleNextQuestion,
          context: context,
        );
      } else if (quizState.question.type == QuestionType.tf) {
        // For true/false: index 0 = 'Goed', index 1 = 'Fout'
        // Determine if the answer is correct by comparing indices rather than text
        final lcCorrect = quizState.question.correctAnswer.toLowerCase();
        final correctIndex =
            (lcCorrect == 'waar' || lcCorrect == 'true' || lcCorrect == 'goed')
                ? 0
                : 1;
        final isCorrect = selectedIndex == correctIndex;

        // Handle the answer sequence
        _handleAnswerSequence(
          isCorrect: isCorrect,
          quizState: quizState,
          updateQuizState: updateQuizState,
          handleNextQuestion: handleNextQuestion,
          context: context,
        );
      } else {
        // For other types, do nothing for now
      }
    } finally {
      // Note: We don't reset _isProcessingAnswer here because the answer sequence is still processing
      // It will be reset in the next question handler call
    }
  }

  Future<void> _handleAnswerSequence({
    required bool isCorrect,
    required QuizState quizState,
    required UpdateQuizStateCallback updateQuizState,
    required HandleNextQuestionCallback handleNextQuestion,
    required BuildContext context,
  }) async {
    AppLogger.info(
        'Answer selected: ${isCorrect ? 'correct' : 'incorrect'} for question');

    // Start sound playing in background (don't await to prevent blocking)
    if (_enableSounds) {
      if (isCorrect) {
        _quizSoundService.playCorrectAnswerSound(context).catchError((e) {
          // Ignore sound errors to prevent affecting visual feedback timing
          AppLogger.warning('Sound playback error (correct): $e');
        });
      } else {
        _quizSoundService.playIncorrectAnswerSound(context).catchError((e) {
          // Ignore sound errors to prevent affecting visual feedback timing
          AppLogger.warning('Sound playback error (incorrect): $e');
        });
      }
    }

    // Use platform-standardized feedback duration for consistent cross-platform experience
    // This timing is independent of sound playback duration
    final feedbackDuration =
        _platformFeedbackService.getStandardizedFeedbackDuration(
            slowMode: false // Will be passed from settings
            );

    // Phase 1: Show feedback (wait for standardized feedback duration)
    // This ensures consistent visual feedback timing regardless of sound file duration
    await Future.delayed(feedbackDuration);

    // Phase 2: Clear feedback and prepare for transition
    // First set isAnswering to false to allow UI to update properly,
    // then transition to next state in the next microtask
    updateQuizState(quizState.copyWith(
      isAnswering: false,
    ));

    // Small delay to ensure UI has time to process the feedback display
    await Future.microtask(() {});

    // Phase 3: Brief pause before transition (platform-optimized)
    final transitionPause =
        _platformFeedbackService.getTransitionPauseDuration();
    await Future.delayed(transitionPause);

    // Phase 4: Now clear the selectedAnswerIndex and set transitioning
    updateQuizState(quizState.copyWith(
      selectedAnswerIndex: null,
      isTransitioning: true,
    ));

    // Phase 5: Brief pause for transition animation
    await Future.delayed(const Duration(milliseconds: 200));

    // Phase 6: Transition to next question
    await handleNextQuestion(isCorrect, quizState.currentDifficulty);

    // Phase 7: Reset processing flag (now that the full sequence is complete)
    _isProcessingAnswer = false;
  }
}
