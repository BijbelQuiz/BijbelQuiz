import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/game_stats_provider.dart';
import '../services/performance_service.dart';

/// Callback for time tick updates
typedef TimeTickCallback = void Function();

/// Callback for showing time up dialog
typedef ShowTimeUpDialogCallback = Future<void> Function();

/// Manages quiz timer functionality including pause/resume, restart, and time-up handling
class QuizTimerManager {
  Timer? _timer;
  bool _isTimerPaused = false;
  DateTime? _lastActiveTime;
  static const _gracePeriod = Duration(seconds: 3);

  // Animation controllers for timer
  late AnimationController _timeAnimationController;
  late Animation<double> _timeAnimation;
  late Animation<Color?> _timeColorAnimation;

  final PerformanceService _performanceService;
  final TickerProvider _vsync;
  final TimeTickCallback? onTimeTick;
  final ShowTimeUpDialogCallback? onTimeUp;

  QuizTimerManager({
    required PerformanceService performanceService,
    required TickerProvider vsync,
    this.onTimeTick,
    this.onTimeUp,
  }) : _performanceService = performanceService,
       _vsync = vsync {
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Get optimal durations based on device capabilities
    final fastDuration = _performanceService.getOptimalAnimationDuration(
      const Duration(milliseconds: 300)
    );

    // Initialize animation controller
    _timeAnimationController = AnimationController(
      duration: fastDuration,
      vsync: _vsync,
      debugLabel: 'time_animation',
    );

    // Initialize animations
    _timeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _timeAnimationController,
        curve: Curves.linear,
      ),
    );

    // Add color animation for timer
    _timeColorAnimation = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(
      CurvedAnimation(
        parent: _timeAnimationController,
        curve: Curves.easeInOutQuad,
      ),
    );

    // Attach listeners
    _timeAnimationController.addListener(_onTimeTick);
    _timeAnimationController.addStatusListener(_onTimeStatus);
  }

  Animation<double> get timeAnimation => _timeAnimation;
  Animation<Color?> get timeColorAnimation => _timeColorAnimation;

  void _onTimeTick() {
    if (onTimeTick != null) {
      onTimeTick!();
    }
  }

  void _onTimeStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && onTimeUp != null) {
      onTimeUp!();
    }
  }

  void pauseTimer() {
    if (!_isTimerPaused) {
      _timeAnimationController.stop();
      _isTimerPaused = true;
    }
  }

  void resumeTimer() {
    if (_isTimerPaused) {
      _timeAnimationController.forward();
      _isTimerPaused = false;
    }
  }

  void restartTimer(BuildContext context, int currentTimeRemaining) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final baseTimerDuration = settings.slowMode ? 35 : 20;
    final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
      Duration(seconds: baseTimerDuration)
    );

    _timer?.cancel();
    _timeAnimationController.duration = optimalTimerDuration;

    // Calculate remaining time more efficiently
    final remainingSeconds = currentTimeRemaining.clamp(0, baseTimerDuration);
    final progress = 1.0 - (remainingSeconds / baseTimerDuration);

    _timeAnimationController.value = progress;
    _timeAnimationController.forward();

    _timer = Timer(Duration(seconds: remainingSeconds), () {
      if (_timeAnimationController.status != AnimationStatus.completed) {
        _timeAnimationController.animateTo(1.0, duration: Duration.zero);
      }
    });
  }

  void startTimer({required BuildContext context, bool reset = false, int? timeRemaining}) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final baseTimerDuration = settings.slowMode ? 35 : 20;
    final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
      Duration(seconds: baseTimerDuration)
    );

    _timer?.cancel();
    _timeAnimationController.duration = optimalTimerDuration;

    if (reset) {
      _timeAnimationController.reset();
    } else if (timeRemaining != null) {
      // Set specific progress if timeRemaining is provided
      final progress = 1.0 - (timeRemaining / baseTimerDuration);
      _timeAnimationController.value = progress.clamp(0.0, 1.0);
    }

    _timeAnimationController.forward();

    _timer = Timer(optimalTimerDuration, () {
      if (_timeAnimationController.status != AnimationStatus.completed) {
        _timeAnimationController.animateTo(1.0, duration: Duration.zero);
      }
    });
  }

  void handleAppLifecycleState(AppLifecycleState state, BuildContext context) {
    if (state == AppLifecycleState.paused) {
      _lastActiveTime = DateTime.now();
      pauseTimer();
    } else if (state == AppLifecycleState.resumed) {
      if (_lastActiveTime != null) {
        final timeSinceLastActive = DateTime.now().difference(_lastActiveTime!);
        if (timeSinceLastActive > _gracePeriod) {
          final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
          gameStats.updateStats(isCorrect: false);
          // Trigger animations - handled by caller
        }
      }
      resumeTimer();
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;

    if (_timeAnimationController.isAnimating) {
      _timeAnimationController.removeListener(_onTimeTick);
      _timeAnimationController.removeStatusListener(_onTimeStatus);
      _timeAnimationController.stop();
    }
    _timeAnimationController.dispose();
  }

  // Getters for external access
  bool get isTimerPaused => _isTimerPaused;
  AnimationController get timeAnimationController => _timeAnimationController;
}