import 'package:flutter/material.dart';
import '../services/performance_service.dart';

/// Manages quiz-related animations for score, streak, and longest streak using a single controller
class QuizAnimationController {
  // Single animation controller for all stats animations
  late AnimationController _statsAnimationController;

  // Animations using the same controller with different intervals
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

    // Initialize single animation controller
    _statsAnimationController = AnimationController(
      duration: optimalDuration,
      vsync: _vsync,
      debugLabel: 'stats_animation',
    );

    // Use a responsive curve for better feel on high refresh rate displays
    const animationCurve = Curves.easeOutQuart;

    // Initialize animations with staggered timing using Interval
    _scoreAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _statsAnimationController,
        curve: Interval(0.0, 0.6, curve: animationCurve), // First 60% of animation
      ),
    );

    _streakAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _statsAnimationController,
        curve: Interval(0.2, 0.8, curve: animationCurve), // 20% offset, 60% duration
      ),
    );

    _longestStreakAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _statsAnimationController,
        curve: Interval(0.4, 1.0, curve: animationCurve), // 40% offset, 60% duration
      ),
    );
  }

  // Getters for animations
  Animation<double> get scoreAnimation => _scoreAnimation;
  Animation<double> get streakAnimation => _streakAnimation;
  Animation<double> get longestStreakAnimation => _longestStreakAnimation;

  // Getter for the single controller
  AnimationController get statsAnimationController => _statsAnimationController;

  // Methods to trigger animations
  void triggerScoreAnimation() {
    _statsAnimationController.forward(from: 0.0);
  }

  void triggerStreakAnimation() {
    _statsAnimationController.forward(from: 0.0);
  }

  void triggerLongestStreakAnimation() {
    _statsAnimationController.forward(from: 0.0);
  }

  void triggerAllStatsAnimations() {
    _statsAnimationController.forward(from: 0.0);
  }

  void dispose() {
    // Dispose single animation controller safely
    if (_statsAnimationController.isAnimating) {
      _statsAnimationController.stop();
    }
    _statsAnimationController.dispose();
  }
}