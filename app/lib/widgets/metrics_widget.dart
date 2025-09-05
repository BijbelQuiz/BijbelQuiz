import 'package:flutter/material.dart';
import 'quiz_metrics_display.dart';

/// A widget that displays the quiz metrics with animations
class MetricsWidget extends StatelessWidget {
  final Animation<double> scoreAnimation;
  final Animation<double> streakAnimation;
  final Animation<double> longestStreakAnimation;
  final Animation<double> timeAnimation;
  final Animation<Color?> timeColorAnimation;
  final int previousScore;
  final int previousStreak;
  final int previousLongestStreak;
  final int previousTime;
  final bool isDesktop;
  final bool isTablet;
  final bool isSmallPhone;

  const MetricsWidget({
    super.key,
    required this.scoreAnimation,
    required this.streakAnimation,
    required this.longestStreakAnimation,
    required this.timeAnimation,
    required this.timeColorAnimation,
    required this.previousScore,
    required this.previousStreak,
    required this.previousLongestStreak,
    required this.previousTime,
    required this.isDesktop,
    required this.isTablet,
    required this.isSmallPhone,
  });

  @override
  Widget build(BuildContext context) {
    return QuizMetricsDisplay(
      scoreAnimation: scoreAnimation,
      streakAnimation: streakAnimation,
      longestStreakAnimation: longestStreakAnimation,
      timeAnimation: timeAnimation,
      timeColorAnimation: timeColorAnimation,
      previousScore: previousScore,
      previousStreak: previousStreak,
      previousLongestStreak: previousLongestStreak,
      previousTime: previousTime,
      isDesktop: isDesktop,
      isTablet: isTablet,
      isSmallPhone: isSmallPhone,
    );
  }
}