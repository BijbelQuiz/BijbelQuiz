import 'package:flutter/material.dart';
import '../services/performance_service.dart';

/// Manages quiz-related animations for score, streak, and longest streak
class QuizAnimationController {
  // Animation controllers
  late AnimationController _scoreAnimationController;
  late AnimationController _streakAnimationController;
  late AnimationController _longestStreakAnimationController;

  // Animations
  late Animation<double> _scoreAnimation;
  late Animation<double> _streakAnimation;
  late Animation<double> _longestStreakAnimation;

  final PerformanceService _performanceService;
  final TickerProvider _vsync;

  QuizAnimationController({
    required PerformanceService performanceService,
    required TickerProvider vsync,
  }) : _performanceService = performanceService,
       _vsync = vsync {
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Get optimal durations based on device capabilities
    final optimalDuration = _performanceService.getOptimalAnimationDuration(
      const Duration(milliseconds: 800)
    );

    // Initialize animation controllers
    _scoreAnimationController = AnimationController(
      duration: optimalDuration,
      vsync: _vsync,
      debugLabel: 'score_animation',
    );

    _streakAnimationController = AnimationController(
      duration: optimalDuration,
      vsync: _vsync,
      debugLabel: 'streak_animation',
    );

    _longestStreakAnimationController = AnimationController(
      duration: optimalDuration,
      vsync: _vsync,
      debugLabel: 'longest_streak_animation',
    );

    // Use a responsive curve for better feel on high refresh rate displays
    const animationCurve = Curves.easeOutQuart;

    // Initialize animations
    _scoreAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scoreAnimationController,
        curve: animationCurve,
      ),
    );

    _streakAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _streakAnimationController,
        curve: animationCurve,
      ),
    );

    _longestStreakAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _longestStreakAnimationController,
        curve: animationCurve,
      ),
    );
  }

  // Getters for animations
  Animation<double> get scoreAnimation => _scoreAnimation;
  Animation<double> get streakAnimation => _streakAnimation;
  Animation<double> get longestStreakAnimation => _longestStreakAnimation;

  // Getters for controllers
  AnimationController get scoreAnimationController => _scoreAnimationController;
  AnimationController get streakAnimationController => _streakAnimationController;
  AnimationController get longestStreakAnimationController => _longestStreakAnimationController;

  // Methods to trigger animations
  void triggerScoreAnimation() {
    _scoreAnimationController.forward(from: 0.0);
  }

  void triggerStreakAnimation() {
    _streakAnimationController.forward(from: 0.0);
  }

  void triggerLongestStreakAnimation() {
    _longestStreakAnimationController.forward(from: 0.0);
  }

  void triggerAllStatsAnimations() {
    triggerScoreAnimation();
    triggerStreakAnimation();
    triggerLongestStreakAnimation();
  }

  void dispose() {
    // Dispose animation controllers safely
    if (_scoreAnimationController.isAnimating) {
      _scoreAnimationController.stop();
    }
    _scoreAnimationController.dispose();

    if (_streakAnimationController.isAnimating) {
      _streakAnimationController.stop();
    }
    _streakAnimationController.dispose();

    if (_longestStreakAnimationController.isAnimating) {
      _longestStreakAnimationController.stop();
    }
    _longestStreakAnimationController.dispose();
  }
}