import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:bijbelquiz/providers/game_stats_provider.dart';
import 'package:bijbelquiz/providers/settings_provider.dart';

// Generate mocks
@GenerateMocks([SharedPreferences])
import 'game_stats_provider_test.mocks.dart';

void main() {
  late MockSharedPreferences mockPrefs;
  late GameStatsProvider provider;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    provider.dispose();
  });

  group('GameStatsProvider', () {
    test('should initialize with default values', () async {
      when(mockPrefs.getInt('game_score')).thenReturn(null);
      when(mockPrefs.getInt('game_current_streak')).thenReturn(null);
      when(mockPrefs.getInt('game_longest_streak')).thenReturn(null);
      when(mockPrefs.getInt('game_incorrect_answers')).thenReturn(null);

      provider = GameStatsProvider();

      // Wait for initialization
      await Future.delayed(Duration.zero);

      expect(provider.score, 0);
      expect(provider.currentStreak, 0);
      expect(provider.longestStreak, 0);
      expect(provider.incorrectAnswers, 0);
      expect(provider.isLoading, false);
      expect(provider.error, null);
    });

    test('should load stats from SharedPreferences', () async {
      when(mockPrefs.getInt('game_score')).thenReturn(150);
      when(mockPrefs.getInt('game_current_streak')).thenReturn(5);
      when(mockPrefs.getInt('game_longest_streak')).thenReturn(12);
      when(mockPrefs.getInt('game_incorrect_answers')).thenReturn(8);

      provider = GameStatsProvider();

      // Wait for initialization
      await Future.delayed(Duration.zero);

      expect(provider.score, 150);
      expect(provider.currentStreak, 5);
      expect(provider.longestStreak, 12);
      expect(provider.incorrectAnswers, 8);
    });

    test('should update stats correctly for correct answer', () async {
      when(mockPrefs.getInt(any)).thenReturn(0);
      when(mockPrefs.setInt(any, any)).thenAnswer((_) async => true);

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      await provider.updateStats(isCorrect: true);

      expect(provider.score, 1);
      expect(provider.currentStreak, 1);
      expect(provider.longestStreak, 1);
      expect(provider.incorrectAnswers, 0);

      verify(mockPrefs.setInt('game_score', 1)).called(1);
      verify(mockPrefs.setInt('game_current_streak', 1)).called(1);
      verify(mockPrefs.setInt('game_longest_streak', 1)).called(1);
    });

    test('should update stats correctly for incorrect answer', () async {
      when(mockPrefs.getInt(any)).thenReturn(0);
      when(mockPrefs.setInt(any, any)).thenAnswer((_) async => true);

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      await provider.updateStats(isCorrect: false);

      expect(provider.score, 0);
      expect(provider.currentStreak, 0);
      expect(provider.longestStreak, 0);
      expect(provider.incorrectAnswers, 1);

      verify(mockPrefs.setInt('game_current_streak', 0)).called(1);
      verify(mockPrefs.setInt('game_incorrect_answers', 1)).called(1);
    });

    test('should update longest streak when current exceeds it', () async {
      when(mockPrefs.getInt('game_score')).thenReturn(0);
      when(mockPrefs.getInt('game_current_streak')).thenReturn(4);
      when(mockPrefs.getInt('game_longest_streak')).thenReturn(4);
      when(mockPrefs.getInt('game_incorrect_answers')).thenReturn(0);
      when(mockPrefs.setInt(any, any)).thenAnswer((_) async => true);

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      await provider.updateStats(isCorrect: true);

      expect(provider.score, 6); // 1 + 5 bonus for new longest streak
      expect(provider.currentStreak, 5);
      expect(provider.longestStreak, 5);

      verify(mockPrefs.setInt('game_longest_streak', 5)).called(1);
    });

    test('should reset stats correctly', () async {
      when(mockPrefs.getInt(any)).thenReturn(10);
      when(mockPrefs.setInt(any, any)).thenAnswer((_) async => true);

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      await provider.resetStats();

      expect(provider.score, 0);
      expect(provider.currentStreak, 0);
      expect(provider.longestStreak, 0);
      expect(provider.incorrectAnswers, 0);

      verify(mockPrefs.setInt('game_score', 0)).called(1);
      verify(mockPrefs.setInt('game_current_streak', 0)).called(1);
      verify(mockPrefs.setInt('game_longest_streak', 0)).called(1);
      verify(mockPrefs.setInt('game_incorrect_answers', 0)).called(1);
    });

    test('should spend points for retry successfully', () async {
      when(mockPrefs.getInt('game_score')).thenReturn(100);
      when(mockPrefs.setInt(any, any)).thenAnswer((_) async => true);

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      final result = await provider.spendPointsForRetry();

      expect(result, true);
      expect(provider.score, 50);

      verify(mockPrefs.setInt('game_score', 50)).called(1);
    });

    test('should fail to spend points for retry when insufficient', () async {
      when(mockPrefs.getInt('game_score')).thenReturn(40);
      when(mockPrefs.setInt(any, any)).thenAnswer((_) async => true);

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      final result = await provider.spendPointsForRetry();

      expect(result, false);
      expect(provider.score, 40);

      verifyNever(mockPrefs.setInt(any, any));
    });

    test('should spend stars successfully', () async {
      when(mockPrefs.getInt('game_score')).thenReturn(100);
      when(mockPrefs.setInt(any, any)).thenAnswer((_) async => true);

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      final result = await provider.spendStars(25);

      expect(result, true);
      expect(provider.score, 75);

      verify(mockPrefs.setInt('game_score', 75)).called(1);
    });

    test('should fail to spend stars when insufficient', () async {
      when(mockPrefs.getInt('game_score')).thenReturn(20);
      when(mockPrefs.setInt(any, any)).thenAnswer((_) async => true);

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      final result = await provider.spendStars(50);

      expect(result, false);
      expect(provider.score, 20);

      verifyNever(mockPrefs.setInt(any, any));
    });

    test('should export data correctly', () async {
      when(mockPrefs.getInt('game_score')).thenReturn(150);
      when(mockPrefs.getInt('game_current_streak')).thenReturn(5);
      when(mockPrefs.getInt('game_longest_streak')).thenReturn(12);
      when(mockPrefs.getInt('game_incorrect_answers')).thenReturn(8);

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      final data = provider.getExportData();

      expect(data['score'], 150);
      expect(data['currentStreak'], 5);
      expect(data['longestStreak'], 12);
      expect(data['incorrectAnswers'], 8);
    });

    test('should load import data correctly', () async {
      when(mockPrefs.setInt(any, any)).thenAnswer((_) async => true);

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      final importData = {
        'score': 200,
        'currentStreak': 8,
        'longestStreak': 15,
        'incorrectAnswers': 12,
      };

      await provider.loadImportData(importData);

      expect(provider.score, 200);
      expect(provider.currentStreak, 8);
      expect(provider.longestStreak, 15);
      expect(provider.incorrectAnswers, 12);

      verify(mockPrefs.setInt('game_score', 200)).called(1);
      verify(mockPrefs.setInt('game_current_streak', 8)).called(1);
      verify(mockPrefs.setInt('game_longest_streak', 15)).called(1);
      verify(mockPrefs.setInt('game_incorrect_answers', 12)).called(1);
    });
  });

  group('Powerup functionality', () {
    test('should activate question-based powerup', () {
      provider = GameStatsProvider();

      provider.activatePowerup(multiplier: 2, questions: 5);

      expect(provider.activePowerup, isNotNull);
      expect(provider.powerupMultiplier, 2);
      expect(provider.powerupQuestionsLeft, 5);
      expect(provider.isPowerupActive, true);
    });

    test('should activate time-based powerup', () {
      provider = GameStatsProvider();

      provider.activatePowerup(multiplier: 3, time: Duration(minutes: 5));

      expect(provider.activePowerup, isNotNull);
      expect(provider.powerupMultiplier, 3);
      expect(provider.powerupTimeLeft, isNotNull);
      expect(provider.isPowerupActive, true);
    });

    test('should clear powerup', () {
      provider = GameStatsProvider();
      provider.activatePowerup(multiplier: 2, questions: 5);

      provider.clearPowerup();

      expect(provider.activePowerup, isNull);
      expect(provider.isPowerupActive, false);
    });

    test('should decrement question-based powerup', () {
      provider = GameStatsProvider();
      provider.activatePowerup(multiplier: 2, questions: 3);

      provider._decrementPowerup();

      expect(provider.powerupQuestionsLeft, 2);

      provider._decrementPowerup();
      provider._decrementPowerup();

      expect(provider.activePowerup, isNull);
    });

    test('should handle powerup multiplier in score calculation', () async {
      when(mockPrefs.getInt(any)).thenReturn(0);
      when(mockPrefs.setInt(any, any)).thenAnswer((_) async => true);

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      provider.activatePowerup(multiplier: 3, questions: 2);

      await provider.updateStats(isCorrect: true);

      expect(provider.score, 3); // 1 * 3 multiplier
      expect(provider.powerupQuestionsLeft, 1);

      // Test decrement by answering another question
      await provider.updateStats(isCorrect: true);
      expect(provider.score, 6); // 3 + 3
      expect(provider.powerupQuestionsLeft, 0);

      // Test that powerup is cleared after questions are used up
      await provider.updateStats(isCorrect: true);
      expect(provider.activePowerup, isNull);
    });
  });
}