import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../services/question_cache_service.dart';
import '../services/logger.dart';
import 'dart:math';

/// Shared service for loading questions in background
class QuestionLoadingService {
  final QuestionCacheService _questionCacheService;

  QuestionLoadingService(this._questionCacheService);

  /// Load more questions in background (simple version for quiz screen)
  Future<void> loadMoreQuestionsInBackground({
    required BuildContext context,
    required bool lessonMode,
    required List questions,
    required void Function(void Function()) setState,
  }) async {
    if (lessonMode) return; // Don't load more in lesson mode

    try {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final language = settings.language;

      // Load next batch of questions
      final nextBatchStartIndex = questions.length;
      const int batchSize = 50; // Load 50 more questions

      final newQuestions = await _questionCacheService.getQuestions(
        language,
        startIndex: nextBatchStartIndex,
        count: batchSize
      );

      if (newQuestions.isNotEmpty) {
        setState(() {
          // Add new questions and shuffle the combined list
          questions.addAll(newQuestions);
          questions.shuffle(Random());
          AppLogger.info('Loaded additional questions, total now: ${questions.length}');
        });
      }
    } catch (e) {
      AppLogger.error('Failed to load more questions in background', e);
    }
  }

  /// Enhanced background loading with adaptive batching (no predictive loading)
  Future<void> loadMoreQuestionsAdvanced({
    required BuildContext context,
    required List questions,
    required void Function(void Function()) setState,
    required bool mounted,
  }) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final language = settings.language;

    try {
      // Load next sequential batch with adaptive sizing
      final nextBatchStartIndex = questions.length;
      final adaptiveBatchSize = _calculateAdaptiveBatchSize();

      final newQuestions = await _questionCacheService.getQuestions(
        language,
        startIndex: nextBatchStartIndex,
        count: adaptiveBatchSize
      );

      if (newQuestions.isNotEmpty) {
        setState(() {
          // Add new questions and shuffle the combined list
          questions.addAll(newQuestions);
          questions.shuffle(Random());
          AppLogger.info('Loaded additional questions, total now: ${questions.length}');
        });
      }

      // Continue loading in background if we still have room
      if (questions.length < 200 && mounted) { // Keep at least 200 questions loaded
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            // Skip recursive call to avoid context issues across async gaps
            // The loading service should be called from the widget when needed
          }
        });
      }
    } catch (e) {
      AppLogger.error('Failed to load more questions in background', e);
    }
  }

  /// Calculate adaptive batch size based on current memory usage
  int _calculateAdaptiveBatchSize() {
    const baseBatchSize = 30;

    // Get memory usage info from simplified cache
    final memoryInfo = _questionCacheService.getMemoryUsage();
    final cacheUtilization = double.tryParse(memoryInfo['memoryCache']['cacheUtilizationPercent'] as String) ?? 0.0;

    // Reduce batch size if memory usage is high
    if (cacheUtilization > 80.0) {
      return (baseBatchSize * 0.5).round(); // 50% reduction
    } else if (cacheUtilization > 60.0) {
      return (baseBatchSize * 0.75).round(); // 25% reduction
    }

    // Increase batch size if memory usage is low
    if (cacheUtilization < 30.0) {
      return (baseBatchSize * 1.5).round(); // 50% increase
    }

    return baseBatchSize;
  }
}