import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bijbelquiz/providers/game_stats_provider.dart';

void main() {
  late GameStatsProvider provider;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    provider.dispose();
  });

  group('GameStatsProvider', () {
    test('should initialize with default values', () async {
      SharedPreferences.setMockInitialValues({});

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
      SharedPreferences.setMockInitialValues({
        'game_score': 100,
        'game_current_streak': 5,
        'game_longest_streak': 10,
        'game_incorrect_answers': 3,
      });

      provider = GameStatsProvider();

      // Wait for initialization
      await Future.delayed(Duration.zero);

      expect(provider.score, 100);
      expect(provider.currentStreak, 5);
      expect(provider.longestStreak, 10);
      expect(provider.incorrectAnswers, 3);
    });

    test('should update stats for correct answer', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      await provider.updateStats(isCorrect: true);

      expect(provider.score, 6); // 1 base point + 5 streak bonus for new longest streak
      expect(provider.currentStreak, 1);
      expect(provider.longestStreak, 1);
      expect(provider.incorrectAnswers, 0);
    });

    test('should update stats for incorrect answer', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      await provider.updateStats(isCorrect: false);

      expect(provider.score, 0);
      expect(provider.currentStreak, 0);
      expect(provider.longestStreak, 0);
      expect(provider.incorrectAnswers, 1);
    });

    test('should handle streak correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      // Build up a streak
      for (int i = 0; i < 5; i++) {
        await provider.updateStats(isCorrect: true);
      }

      expect(provider.currentStreak, 5);
      expect(provider.longestStreak, 5);
      expect(provider.score, 30); // 5 questions * (1 base + 5 streak bonus)

      // Break the streak
      await provider.updateStats(isCorrect: false);

      expect(provider.currentStreak, 0);
      expect(provider.longestStreak, 5); // Should remain 5
      expect(provider.incorrectAnswers, 1);
    });

    test('should handle longest streak correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      // Build first streak
      for (int i = 0; i < 3; i++) {
        await provider.updateStats(isCorrect: true);
      }

      expect(provider.longestStreak, 3);

      // Break streak and start new one
      await provider.updateStats(isCorrect: false);

      for (int i = 0; i < 5; i++) {
        await provider.updateStats(isCorrect: true);
      }

      expect(provider.currentStreak, 5);
      expect(provider.longestStreak, 5); // Should update to new longest
    });

    test('should reset stats correctly', () async {
      SharedPreferences.setMockInitialValues({
        'game_score': 100,
        'game_current_streak': 5,
        'game_longest_streak': 10,
        'game_incorrect_answers': 3,
      });

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      // Verify initial values
      expect(provider.score, 100);
      expect(provider.currentStreak, 5);
      expect(provider.longestStreak, 10);
      expect(provider.incorrectAnswers, 3);

      // Reset stats
      await provider.resetStats();

      expect(provider.score, 0);
      expect(provider.currentStreak, 0);
      expect(provider.longestStreak, 0);
      expect(provider.incorrectAnswers, 0);
    });

    test('should spend points for retry correctly', () async {
      SharedPreferences.setMockInitialValues({
        'game_score': 100,
      });

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      expect(provider.score, 100);

      // Should succeed with enough points
      final success = await provider.spendPointsForRetry();
      expect(success, true);
      expect(provider.score, 50); // 100 - 50
    });

    test('should fail to spend points for retry without enough points', () async {
      SharedPreferences.setMockInitialValues({
        'game_score': 30,
      });

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      expect(provider.score, 30);

      // Should fail with insufficient points
      final success = await provider.spendPointsForRetry();
      expect(success, false);
      expect(provider.score, 30); // Should remain unchanged
    });

    test('should spend stars correctly', () async {
      SharedPreferences.setMockInitialValues({
        'game_score': 100,
      });

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      expect(provider.score, 100);

      // Should succeed with enough stars
      final success = await provider.spendStars(50);
      expect(success, true);
      expect(provider.score, 50); // 100 - 50
    });

    test('should fail to spend stars without enough stars', () async {
      SharedPreferences.setMockInitialValues({
        'game_score': 30,
      });

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      expect(provider.score, 30);

      // Should fail with insufficient stars
      final success = await provider.spendStars(50);
      expect(success, false);
      expect(provider.score, 30); // Should remain unchanged
    });

    test('should add stars correctly', () async {
      SharedPreferences.setMockInitialValues({
        'game_score': 50,
      });

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      expect(provider.score, 50);

      // Should succeed
      final success = await provider.addStars(25);
      expect(success, true);
      expect(provider.score, 75); // 50 + 25
    });

    test('should export data correctly', () async {
      SharedPreferences.setMockInitialValues({
        'game_score': 100,
        'game_current_streak': 5,
        'game_longest_streak': 10,
        'game_incorrect_answers': 3,
      });

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      final data = provider.getExportData();

      expect(data['score'], 100);
      expect(data['currentStreak'], 5);
      expect(data['longestStreak'], 10);
      expect(data['incorrectAnswers'], 3);
    });

    test('should load import data correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      final importData = {
        'score': 200,
        'currentStreak': 8,
        'longestStreak': 15,
        'incorrectAnswers': 5,
      };

      await provider.loadImportData(importData);

      expect(provider.score, 200);
      expect(provider.currentStreak, 8);
      expect(provider.longestStreak, 15);
      expect(provider.incorrectAnswers, 5);
    });

    test('should handle powerup activation correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      // Initially no powerup
      expect(provider.activePowerup, null);
      expect(provider.isPowerupActive, false);

      // Activate question-based powerup
      provider.activatePowerup(multiplier: 2, questions: 3);

      expect(provider.isPowerupActive, true);
      expect(provider.activePowerup?.multiplier, 2);
      expect(provider.activePowerup?.questionsRemaining, 3);
      expect(provider.powerupMultiplier, 2);
      expect(provider.powerupQuestionsLeft, 3);
    });

    test('should handle powerup deactivation correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      // Activate powerup
      provider.activatePowerup(multiplier: 2, questions: 1);

      expect(provider.isPowerupActive, true);

      // Use the powerup (should deactivate after 1 question)
      await provider.updateStats(isCorrect: true);

      expect(provider.isPowerupActive, false);
      expect(provider.activePowerup, null);
    });

    test('should handle time-based powerup correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      // Activate time-based powerup
      provider.activatePowerup(
        multiplier: 3,
        time: const Duration(minutes: 1),
      );

      expect(provider.isPowerupActive, true);
      expect(provider.activePowerup?.multiplier, 3);
      expect(provider.activePowerup?.byQuestions, false);
      expect(provider.powerupTimeLeft, isNotNull);
    });

    test('should clear powerup correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      // Activate powerup
      provider.activatePowerup(multiplier: 2, questions: 3);
      expect(provider.isPowerupActive, true);

      // Clear powerup
      provider.clearPowerup();
      expect(provider.isPowerupActive, false);
      expect(provider.activePowerup, null);
    });

    test('should handle multiple correct answers with powerup', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      // Activate powerup for 3 questions
      provider.activatePowerup(multiplier: 2, questions: 3);

      // Answer 3 questions correctly with powerup
      for (int i = 0; i < 3; i++) {
        await provider.updateStats(isCorrect: true);
      }

      // Should have earned 2 points per question (1 base + 1 bonus from powerup)
      expect(provider.score, 21); // 3 questions * (1 base + 5 streak bonus + 1 powerup bonus)
      expect(provider.isPowerupActive, false); // Should be deactivated
    });

    test('should handle mixed correct and incorrect answers', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      // Answer some correctly
      await provider.updateStats(isCorrect: true);
      await provider.updateStats(isCorrect: true);
      await provider.updateStats(isCorrect: true);

      expect(provider.currentStreak, 3);
      expect(provider.score, 18); // 3 questions * (1 base + 5 streak bonus)

      // Answer incorrectly
      await provider.updateStats(isCorrect: false);

      expect(provider.currentStreak, 0);
      expect(provider.incorrectAnswers, 1);
      expect(provider.score, 18); // Score should remain the same

      // Start new streak
      await provider.updateStats(isCorrect: true);

      expect(provider.currentStreak, 1);
      expect(provider.score, 19); // 18 (from previous streak) + 1 base + 0 streak bonus (new streak)
    });

    test('should handle loading states correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();

      // Should be loading initially
      expect(provider.isLoading, true);

      // Wait for loading to complete
      await Future.delayed(Duration.zero);

      // Should not be loading anymore
      expect(provider.isLoading, false);
    });

    test('should handle error states correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();

      // Initially no error
      expect(provider.error, null);

      // Wait for initialization
      await Future.delayed(Duration.zero);

      // Should still have no error
      expect(provider.error, null);
    });

    test('should handle edge case of zero scores', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      // Try to spend points when score is 0
      final success = await provider.spendPointsForRetry();
      expect(success, false);
      expect(provider.score, 0);

      // Try to spend stars when score is 0
      final starSuccess = await provider.spendStars(10);
      expect(starSuccess, false);
      expect(provider.score, 0);
    });

    test('should handle large score values correctly', () async {
      SharedPreferences.setMockInitialValues({
        'game_score': 999999,
      });

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      expect(provider.score, 999999);

      // Add more points
      await provider.updateStats(isCorrect: true);
      expect(provider.score, 1000005); // 999999 + 1 base + 5 streak bonus

      // Should be able to spend points
      final success = await provider.spendPointsForRetry();
      expect(success, true);
      expect(provider.score, 999955); // 1000005 - 50
    });

    test('should handle import data with missing fields', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      // Import data with missing fields
      final importData = {
        'score': 100,
        // Missing other fields
      };

      await provider.loadImportData(importData);

      expect(provider.score, 100);
      expect(provider.currentStreak, 0); // Should default to 0
      expect(provider.longestStreak, 0); // Should default to 0
      expect(provider.incorrectAnswers, 0); // Should default to 0
    });

    test('should handle import data with null values', () async {
      SharedPreferences.setMockInitialValues({});

      provider = GameStatsProvider();
      await Future.delayed(Duration.zero);

      // Import data with null values
      final importData = {
        'score': null,
        'currentStreak': null,
        'longestStreak': null,
        'incorrectAnswers': null,
      };

      await provider.loadImportData(importData);

      expect(provider.score, 0); // Should default to 0
      expect(provider.currentStreak, 0); // Should default to 0
      expect(provider.longestStreak, 0); // Should default to 0
      expect(provider.incorrectAnswers, 0); // Should default to 0
    });
  });
}