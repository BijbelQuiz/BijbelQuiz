import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../models/quiz_question.dart';
import '../models/quiz_state.dart';
import '../services/sound_service.dart';
import '../services/question_cache_service.dart';
import '../services/performance_service.dart';
import '../services/connection_service.dart';
import '../services/platform_feedback_service.dart';
import '../providers/settings_provider.dart';
import '../providers/game_stats_provider.dart';

import '../widgets/metric_item.dart';
import '../widgets/question_card.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'dart:async';
import '../settings_screen.dart';
import '../services/logger.dart';
import 'dart:math';
import '../widgets/quiz_skeleton.dart';

/// The main quiz screen that displays questions and handles user interactions
/// with performance optimizations for low-end devices and poor connections.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  int currentQuestionIndex = 0;
  bool _isLoading = true;
  String? _error;
  String? _lastLanguage;
  Timer? _timer;
  bool _isTimerPaused = false;
  DateTime? _lastActiveTime;
  static const _gracePeriod = Duration(seconds: 3);
  
  // Track used questions to avoid repetition
  final Set<String> _usedQuestions = {};
  List<QuizQuestion> _allQuestions = [];
  bool _allQuestionsLoaded = false;
  
  // Performance-optimized animation controllers
  late AnimationController _scoreAnimationController;
  late AnimationController _streakAnimationController;
  late AnimationController _longestStreakAnimationController;
  late AnimationController _timeAnimationController;
  
  // Animations for all stats
  late Animation<double> _scoreAnimation;
  late Animation<double> _streakAnimation;
  late Animation<double> _longestStreakAnimation;
  late Animation<double> _timeAnimation;
  late Animation<Color?> _timeColorAnimation;
  
  // Previous values for comparison
  int _previousScore = 0;
  int _previousStreak = 0;
  int _previousLongestStreak = 0;
  int _previousTime = 20;
  
  // Track if we've initialized previous values after loading
  bool _initializedStats = false;
  // New state management
  late QuizState _quizState;
  bool _hasLoggedScreenView = false;
  
  // Performance optimization: track loading states to reduce debug logging
  bool _lastLoadingState = true;
  bool _lastGameStatsLoadingState = true;
  
  // Performance and connection services
  late QuestionCacheService _questionCacheService;
  late PerformanceService _performanceService;
  late ConnectionService _connectionService;
  late PlatformFeedbackService _platformFeedbackService;
  final SoundService _soundService = SoundService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppLogger.info('QuizScreen loaded');
    
    // Initialize services
    _questionCacheService = QuestionCacheService();
    _performanceService = PerformanceService();
    _connectionService = ConnectionService();
    _platformFeedbackService = PlatformFeedbackService();
    
    _initializeServices();
    _initializeQuiz();
    _initializeAnimations();
    
    // Add frame callback to monitor performance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _monitorPerformance();
    });
    
    // Listen for game stats reset to reset question pool
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
      gameStats.addListener(_onGameStatsChanged);
    });
    
    // Attach error handler for sound service
    _soundService.onError = (message) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    };
  }

  /// Called when game stats change
  void _onGameStatsChanged() {
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    // If score and streak are both 0, it might be a new game
    if (gameStats.score == 0 && gameStats.currentStreak == 0 && gameStats.incorrectAnswers == 0) {
      // Check if this is a fresh reset (not just initialization)
      if (_allQuestionsLoaded && _usedQuestions.isNotEmpty) {
        _resetForNewGame();
      }
    }
  }

  /// Initialize all services with performance optimizations
  Future<void> _initializeServices() async {
    try {
      await Future.wait([
        _performanceService.initialize(),
        _connectionService.initialize(),
        _platformFeedbackService.initialize(),
        _soundService.initialize(),
      ]);
      AppLogger.info('QuizScreen services initialized');
      

    } catch (e) {
      AppLogger.error('Failed to initialize services in QuizScreen', e);
    }
  }

  /// Initialize animations with performance optimizations for high refresh rate displays
  void _initializeAnimations() {
    // Get optimal durations based on device capabilities and refresh rate
    final optimalDuration = _performanceService.getOptimalAnimationDuration(
      const Duration(milliseconds: 800)
    );
    final fastDuration = _performanceService.getOptimalAnimationDuration(
      const Duration(milliseconds: 300)
    );
    
    // Initialize animation controllers with vsync and optimal durations
    _scoreAnimationController = AnimationController(
      duration: optimalDuration,
      vsync: this,
      debugLabel: 'score_animation',
    );
    
    _streakAnimationController = AnimationController(
      duration: optimalDuration,
      vsync: this,
      debugLabel: 'streak_animation',
    );
    
    _longestStreakAnimationController = AnimationController(
      duration: optimalDuration,
      vsync: this,
      debugLabel: 'longest_streak_animation',
    );
    
    _timeAnimationController = AnimationController(
      duration: fastDuration,
      vsync: this,
      debugLabel: 'time_animation',
    );
    
    // Use a more responsive curve for better feel on high refresh rate displays
    const animationCurve = Curves.easeOutQuart;
    
    // Initialize all animations with optimized curves
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
    
    _timeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _timeAnimationController,
        curve: Curves.linear, // Use linear for time-based animations
      ),
    );
    
    // Add color animation for timer with optimized curve
    _timeColorAnimation = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(
      CurvedAnimation(
        parent: _timeAnimationController,
        curve: Curves.easeInOutQuad, // Smoother color transition
      ),
    );
  }

  // Monitor performance by tracking frame times
  void _monitorPerformance() {
    if (!mounted) return;
    
    // Update frame timing
    _performanceService.updateFrameTime();
    
    // Schedule next frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _monitorPerformance();
    });
  }

  @override
  void dispose() {
    // Cancel any active timers
    _timer?.cancel();
    _timer = null;
    
    // Remove status listeners and dispose animation controllers
    try {
      _timeAnimationController.removeStatusListener((_) {});
      _timeAnimationController.stop();
      _timeAnimationController.dispose();
      
      _scoreAnimationController.stop();
      _scoreAnimationController.dispose();
      
      _streakAnimationController.stop();
      _streakAnimationController.dispose();
      
      _longestStreakAnimationController.stop();
      _longestStreakAnimationController.dispose();
      
      // Dispose services
      _performanceService.dispose();
      _connectionService.dispose();
      _soundService.dispose();
      
      // Remove game stats listener
      try {
        final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
        gameStats.removeListener(_onGameStatsChanged);
      } catch (e) {
        // Ignore if context is no longer available
      }
    } catch (e) {
      AppLogger.error('Error during dispose', e);
    } finally {
      // Ensure we always clean up the observer and reset state
      WidgetsBinding.instance.removeObserver(this);
      _hasLoggedScreenView = false;
      
      // Call super.dispose() last
      super.dispose();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _lastActiveTime = DateTime.now();
      _pauseTimer();
    } else if (state == AppLifecycleState.resumed) {
      if (_lastActiveTime != null) {
        final timeSinceLastActive = DateTime.now().difference(_lastActiveTime!);
        if (timeSinceLastActive > _gracePeriod) {
          final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
          gameStats.updateStats(isCorrect: false);
          // Trigger animations for stats updates
          _scoreAnimationController.forward(from: 0.0);
          _streakAnimationController.forward(from: 0.0);
          _longestStreakAnimationController.forward(from: 0.0);
        }
      }
      _resumeTimer();
    }
  }

  void _pauseTimer() {
    if (!_isTimerPaused) {
      final localContext = context;
      _timeAnimationController.stop(); // Pause color animation
      _isTimerPaused = true;
    }
  }

  void _resumeTimer() {
    if (_isTimerPaused) {
      _timeAnimationController.forward(); // Resume color animation
      _startTimer(reset: false);
      _isTimerPaused = false;
    }
  }

  void _startTimer({bool reset = false}) {
    if (!mounted) return;
    
    final localContext = context;
    final settings = Provider.of<SettingsProvider>(localContext, listen: false);
    final baseTimerDuration = settings.slowMode ? 35 : 20;
    final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
      Duration(seconds: baseTimerDuration)
    );
    
    // Reset the timer state if needed
    if (reset) {
      setState(() {
        _quizState = _quizState.copyWith(timeRemaining: optimalTimerDuration.inSeconds);
      });
    }
    
    // Cancel any existing timer
    _timer?.cancel();
    
    // Set up the animation controller for smooth timer updates
    _timeAnimationController.duration = optimalTimerDuration;
    _timeAnimationController.reset();
    
    // Update the time remaining based on the animation value
    _timeAnimationController.addStatusListener((status) {
      if (!mounted) return;
      
      final elapsed = _timeAnimationController.value * optimalTimerDuration.inMilliseconds;
      final remainingMs = optimalTimerDuration.inMilliseconds - elapsed;
      final remainingSeconds = (remainingMs / 1000).ceil();
      
      setState(() {
        if (remainingSeconds < _quizState.timeRemaining) {
          _previousTime = _quizState.timeRemaining;
          _quizState = _quizState.copyWith(timeRemaining: remainingSeconds);
        }
      });
      
      // Handle timer completion
      if (status == AnimationStatus.completed) {
        if (mounted) {
          if (settings.hapticFeedback != 'disabled') {
            if (settings.hapticFeedback == 'medium') {
              HapticFeedback.heavyImpact();
            } else {
              HapticFeedback.mediumImpact();
            }
          }
          _showTimeUpDialog();
        }
      }
    });
    
    // Start the animation
    _timeAnimationController.forward();
    
    // Fallback timer in case animation doesn't complete
    _timer = Timer(optimalTimerDuration, () {
      if (mounted && _timeAnimationController.status != AnimationStatus.completed) {
        _timeAnimationController.animateTo(1.0, duration: Duration.zero);
      }
    });
  }

  Future<void> _showTimeUpDialog() async {
    final localContext = context;
    if (ModalRoute.of(localContext)?.isCurrent != true) return;
    
    final settings = Provider.of<SettingsProvider>(localContext, listen: false);
    final gameStats = Provider.of<GameStatsProvider>(localContext, listen: false);
    final hasEnoughPoints = gameStats.score >= 50;
    
    OverlayEntry? tooltipEntry;
    
    void showInsufficientPointsTooltip(BuildContext context, RenderBox buttonBox) {
      tooltipEntry?.remove();
      
      final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
      final buttonPosition = buttonBox.localToGlobal(Offset.zero, ancestor: overlay);
      
      tooltipEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: buttonPosition.dx,
          top: buttonPosition.dy + buttonBox.size.height + 4,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Onvoldoende punten',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      );
      
      if (tooltipEntry != null) {
        Overlay.of(localContext).insert(tooltipEntry!);
      }
      
      Future.delayed(const Duration(seconds: 2), () {
        tooltipEntry?.remove();
        tooltipEntry = null;
      });
    }
    
    await showDialog(
      context: localContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Tijd is om!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Je hebt niet op tijd geantwoord. Je reeks is gereset.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            Builder(
              builder: (context) => TextButton(
                onPressed: hasEnoughPoints ? () {
                  gameStats.spendPointsForRetry().then((success) {
                    if (success && mounted) {
                      Navigator.of(dialogContext).pop();
                      setState(() {
                        final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
                          Duration(seconds: settings.slowMode ? 35 : 20)
                        );
                        _quizState = _quizState.copyWith(
                          timeRemaining: optimalTimerDuration.inSeconds,
                        );
                      });
                      _startTimer(reset: true);
                    }
                  });
                } : () {
                  final RenderBox buttonBox = context.findRenderObject() as RenderBox;
                  showInsufficientPointsTooltip(context, buttonBox);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      settings.language == 'en' ? 'Try Again' : 'Opnieuw proberen',
                      style: TextStyle(
                        color: hasEnoughPoints 
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.star,
                      size: 16,
                      color: hasEnoughPoints 
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    ),
                    Text(
                      ' 50',
                      style: TextStyle(
                        color: hasEnoughPoints 
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                gameStats.updateStats(isCorrect: false);
                // Trigger animations for stats updates
                _scoreAnimationController.forward(from: 0.0);
                _streakAnimationController.forward(from: 0.0);
                _longestStreakAnimationController.forward(from: 0.0);
                _handleAnswerSequence(false);
              },
              child: Text(
                settings.language == 'en' ? 'Next Question' : 'Volgende Vraag',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
    
    if (tooltipEntry != null) {
      Overlay.of(localContext).insert(tooltipEntry!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final language = settings.language;
    
    // Telemetry logging
    void tryLogScreenView() {
      if (!_hasLoggedScreenView && ModalRoute.of(context)?.isCurrent == true) {
        
        _hasLoggedScreenView = true;
      } else if (!_hasLoggedScreenView && ModalRoute.of(context) != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => tryLogScreenView());
      }
    }
    tryLogScreenView();
    
    // Reset question pool if language changed
    if (_lastLanguage != null && _lastLanguage != language) {
      AppLogger.info('Language changed from $_lastLanguage to $language, resetting question pool');
      _resetQuestionPool();
    }
    _lastLanguage = language;
  }

  /// Reset the question pool for a new language or session
  void _resetQuestionPool() {
    _usedQuestions.clear();
    _allQuestionsLoaded = false;
    _allQuestions.clear();
    // Reinitialize quiz with new language
    _initializeQuiz();
  }

  /// Reset the question pool for a new game session
  void _resetForNewGame() {
    AppLogger.info('Resetting question pool for new game session');
    _usedQuestions.clear();
    _allQuestions.shuffle(Random()); // Reshuffle for variety
    // Don't clear _allQuestions or _allQuestionsLoaded since we want to keep the loaded questions
  }

  /// Initialize animations with performance optimizations
  Future<void> _initializeQuiz() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final language = settings.language;

      // Load all questions at once and shuffle them
      if (!_allQuestionsLoaded) {
        _allQuestions = await _questionCacheService.getQuestions(language);
        _allQuestions.shuffle(Random());
        _allQuestionsLoaded = true;
        AppLogger.info('Loaded all questions for language: $language, count: ${_allQuestions.length}');
      }

      if (_allQuestions.isEmpty) {
        throw Exception('No valid questions found');
      }

      // Initialize quiz state with the first question
      final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
        Duration(seconds: settings.slowMode ? 35 : 20)
      );

      _quizState = QuizState(
        question: _allQuestions[0],
        timeRemaining: optimalTimerDuration.inSeconds,
        currentDifficulty: 0.0,
      );

      // Mark the first question as used
      _usedQuestions.add(_allQuestions[0].question);

      // Start the timer (reset)
      _startTimer(reset: true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load questions: ${e.toString()}';
      });
      AppLogger.error('Failed to load questions in QuizScreen', e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Helper function to get the next question based on current difficulty
  QuizQuestion _getNextQuestion(double currentDifficulty) {
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    double targetDifficulty = currentDifficulty;
    final totalQuestions = gameStats.score + gameStats.incorrectAnswers;
    if (totalQuestions > 0) {
      final correctRatio = gameStats.score / totalQuestions;
      if (correctRatio > 0.8) {
        targetDifficulty += 0.02;
      } else if (correctRatio > 0.65) {
        targetDifficulty += 0.01;
      } else if (correctRatio < 0.4) {
        targetDifficulty -= 0.01;
      }
      if (totalQuestions > 50) {
        targetDifficulty = currentDifficulty + (targetDifficulty - currentDifficulty) * 0.5;
      }
    }
    targetDifficulty = targetDifficulty.clamp(0.0, 2.0);
    final difficultyOrder = {'MAKKELIJK': 0, 'GEMIDDELD': 1, 'MOEILIJK': 2};
    final targetLevel = (targetDifficulty * 2).round();
    
    // Get available questions (not used yet)
    final availableQuestions = _allQuestions.where((q) => !_usedQuestions.contains(q.question)).toList();
    
    // If all questions have been used, reset the used questions set
    if (availableQuestions.isEmpty) {
      AppLogger.info('All questions used, resetting question pool');
      _usedQuestions.clear();
      return _getNextQuestion(currentDifficulty); // Recursive call with fresh pool
    }
    
    // Filter by difficulty
    final eligibleQuestions = availableQuestions.where((q) {
      final questionLevel = difficultyOrder[q.difficulty] ?? 0;
      return (questionLevel - targetLevel).abs() <= 1;
    }).toList();
    
    // If no questions match difficulty, expand the range
    if (eligibleQuestions.isEmpty) {
      eligibleQuestions.addAll(availableQuestions.where((q) => (difficultyOrder[q.difficulty] ?? 0) == targetLevel));
    }
    
    // If still no questions, use any available question
    if (eligibleQuestions.isEmpty) {
      eligibleQuestions.addAll(availableQuestions);
    }
    
    // Select a random question from eligible ones
    final random = Random();
    final selectedQuestion = eligibleQuestions[random.nextInt(eligibleQuestions.length)];
    
    // Mark the selected question as used
    _usedQuestions.add(selectedQuestion.question);
    
    return selectedQuestion;
  }

  Future<void> _playCorrectAnswerSound() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (settings.mute) return;

    try {
      await _soundService.playCorrect();
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> _playIncorrectAnswerSound() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (settings.mute) return;

    try {
      await _soundService.playIncorrect();
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void _handleAnswer(int selectedIndex) {
    if (_quizState.isAnswering) return;

    // Set isAnswering: true immediately to prevent double triggering
    setState(() {
      _quizState = _quizState.copyWith(
        selectedAnswerIndex: selectedIndex,
        isAnswering: true,
      );
    });

    if (_quizState.question.type == QuestionType.mc || _quizState.question.type == QuestionType.fitb) {
      final selectedAnswer = _quizState.question.allOptions[selectedIndex];
      final isCorrect = selectedAnswer == _quizState.question.correctAnswer;
      final settings = Provider.of<SettingsProvider>(context, listen: false);

      // Add haptic feedback for answer selection
      if (settings.hapticFeedback != 'disabled') {
        if (settings.hapticFeedback == 'medium') {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.lightImpact();
        }
      }

      // Handle the answer sequence
      _handleAnswerSequence(isCorrect);
    } else if (_quizState.question.type == QuestionType.tf) {
      // For true/false: index 0 = true, index 1 = false
      final selectedAnswer = selectedIndex == 0 ? 'true' : 'false';
      final isCorrect = selectedAnswer.toLowerCase() == _quizState.question.correctAnswer.toLowerCase();
      final settings = Provider.of<SettingsProvider>(context, listen: false);

      // Add haptic feedback for answer selection
      if (settings.hapticFeedback != 'disabled') {
        if (settings.hapticFeedback == 'medium') {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.lightImpact();
        }
      }

      // Handle the answer sequence
      _handleAnswerSequence(isCorrect);
    } else {
      // For other types, do nothing for now
    }
  }

  // Helper function to calculate the next difficulty based on performance, streak, and answer speed
  double _calculateNextDifficulty({
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
    // Base adjustment
    if (isCorrect) {
      targetDifficulty += 0.05;
      if (streak >= 3) targetDifficulty += 0.05 * (streak ~/ 3); // More for longer streaks
      if (timeRemaining > 10) targetDifficulty += 0.03; // Reward fast answers
    } else {
      targetDifficulty -= 0.07;
      if (streak == 0) targetDifficulty -= 0.03; // Penalize breaking streak
      if (timeRemaining < 5) targetDifficulty -= 0.02; // Penalize slow, wrong answers
    }
    // Long-term performance
    if (correctRatio > 0.85) {
      targetDifficulty += 0.03;
    } else if (correctRatio < 0.5) {
      targetDifficulty -= 0.03;
    }
    // Clamp between 0 and 2
    return targetDifficulty.clamp(0.0, 2.0);
  }

  Future<void> _handleAnswerSequence(bool isCorrect) async {
    // Cancel current timer
    _timer?.cancel();
    _timeAnimationController.stop(); // Stop timer color animation during feedback
    AppLogger.info('Answer selected:  [1m [1m${isCorrect ? 'correct' : 'incorrect'}  [0m for question $currentQuestionIndex');
    final settings = Provider.of<SettingsProvider>(context, listen: false);

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
      // Apply haptic feedback immediately for incorrect answers
      if (settings.hapticFeedback != 'disabled') {
        if (settings.hapticFeedback == 'medium') {
          HapticFeedback.heavyImpact();
        } else {
          HapticFeedback.mediumImpact();
        }
      }
    }

    // Use platform-standardized feedback duration for consistent cross-platform experience
    // This timing is independent of sound playback duration
    final feedbackDuration = _platformFeedbackService.getStandardizedFeedbackDuration(
      slowMode: settings.slowMode
    );

    // Phase 1: Show feedback (wait for standardized feedback duration)
    // This ensures consistent visual feedback timing regardless of sound file duration
    await Future.delayed(feedbackDuration);
    if (!mounted) return;

    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    // Update stats using the provider
    gameStats.updateStats(isCorrect: isCorrect);
    // Trigger animations for stats updates
    _scoreAnimationController.forward(from: 0.0);
    _streakAnimationController.forward(from: 0.0);
    _longestStreakAnimationController.forward(from: 0.0);

    // Phase 2: Clear feedback and prepare for transition
    setState(() {
      _quizState = _quizState.copyWith(
        selectedAnswerIndex: null,
        isTransitioning: true,
      );
    });

    // Phase 3: Brief pause before transition (platform-optimized)
    final transitionPause = _platformFeedbackService.getTransitionPauseDuration();
    await Future.delayed(transitionPause);
    if (!mounted) return;

    // Phase 4: Transition to next question
    if (!mounted) return;
    AppLogger.info('Transitioning to next question');
    // Calculate new difficulty
    final newDifficulty = _calculateNextDifficulty(
      currentDifficulty: _quizState.currentDifficulty,
      isCorrect: isCorrect,
      streak: gameStats.currentStreak,
      timeRemaining: _quizState.timeRemaining,
      totalQuestions: gameStats.score + gameStats.incorrectAnswers,
      correctAnswers: gameStats.score,
      incorrectAnswers: gameStats.incorrectAnswers,
    );
    setState(() {
      final nextQuestion = _getNextQuestion(newDifficulty);
      final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
        Duration(seconds: settings.slowMode ? 35 : 20)
      );
      _quizState = QuizState(
        question: nextQuestion,
        timeRemaining: optimalTimerDuration.inSeconds,
        currentDifficulty: newDifficulty,
      );
      _startTimer(reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    double width = size.width;

    // If the screen is extremely small, show only the not supported message
    if (width < 260) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Schermgrootte niet ondersteund',
              style: TextStyle(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final settings = Provider.of<SettingsProvider>(context);
    final gameStats = Provider.of<GameStatsProvider>(context);
    final isDesktop = size.width > 800;
    final isTablet = size.width > 600 && size.width <= 800;
    final isSmallPhone = size.width < 350;

    // Only log in debug mode and when there are significant changes
    if (kDebugMode && (_isLoading != _lastLoadingState || gameStats.isLoading != _lastGameStatsLoadingState)) {
      AppLogger.info('QuizScreen build: _isLoading=$_isLoading, gameStats.isLoading=${gameStats.isLoading}');
      _lastLoadingState = _isLoading;
      _lastGameStatsLoadingState = gameStats.isLoading;
    }

    // After loading, initialize previous values to real stats to avoid 0 animation on boot
    if (!_isLoading && !gameStats.isLoading && !_initializedStats) {
      _previousScore = gameStats.score;
      _previousStreak = gameStats.currentStreak;
      _previousLongestStreak = gameStats.longestStreak;
      _previousTime = _quizState.timeRemaining;
      _initializedStats = true;
    }

    // FIX: Wait for BOTH questions and stats to load before showing quiz UI
    if (_isLoading || gameStats.isLoading) {
      // Determine metrics and answer count for skeleton
      int metricsCount = (isDesktop || isTablet) ? 4 : 2;
      // Default to MC (4 answers) for skeleton, but you could randomize or make this smarter
      int answerCount = 4;
      String questionType = 'mc';
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: Center(
          child: QuizSkeleton(
            isDesktop: isDesktop,
            isTablet: isTablet,
            isSmallPhone: isSmallPhone,
            metricsCount: metricsCount,
            answerCount: answerCount,
            questionType: questionType,
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colorScheme.outline.withAlpha((0.1 * 255).round()),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha((0.06 * 255).round()),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.error.withAlpha((0.1 * 255).round()),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _error!,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _initializeQuiz,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text('Opnieuw proberen'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.quiz_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'BijbelQuiz',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface.withAlpha((0.7 * 255).round()),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.store,
                color: colorScheme.onSurface.withAlpha((0.7 * 255).round()),
              ),
              tooltip: 'Winkel',
              onPressed: () {
                _pauseTimer();
                Navigator.of(context).pushNamed('/store').then((_) => _resumeTimer());
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.settings_rounded,
                color: colorScheme.onSurface.withAlpha((0.7 * 255).round()),
              ),
              onPressed: () async {
                _pauseTimer();
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      onOpenGuide: _pauseTimer,
                    ),
                  ),
                );
                _resumeTimer();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 800 : (isTablet ? 600 : double.infinity),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
                vertical: 20,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Compact metrics row above the question
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        switchInCurve: Curves.easeIn,
                        switchOutCurve: Curves.easeOut,
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                        child: Container(
                          key: ValueKey<String>(
                            isDesktop
                              ? 'desktop_metrics'
                              : isTablet
                                ? 'tablet_metrics'
                                : isSmallPhone
                                  ? 'smallPhone_metrics'
                                  : MediaQuery.of(context).size.width < 320
                                    ? 'verySmallPhone_metrics'
                                    : 'mobile_metrics',
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 16 : 12,
                            vertical: isDesktop ? 12 : 10,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: colorScheme.outline.withAlpha((0.1 * 255).round()),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.10), // subtle, small shadow
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: isDesktop || isTablet
                              ? Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 16,
                                  runSpacing: 12,
                                  children: [
                                    MetricItem(
                                      icon: Icons.star_rounded,
                                      value: gameStats.score.toString(),
                                      label: 'Score',
                                      colorScheme: colorScheme,
                                      color: colorScheme.primary,
                                      animation: _scoreAnimation,
                                      previousValue: _previousScore,
                                      onAnimationComplete: () {
                                        _previousScore = gameStats.score;
                                      },
                                      isSmallPhone: false,
                                      highlight: gameStats.isPowerupActive,
                                    ),
                                    MetricItem(
                                      icon: Icons.local_fire_department_rounded,
                                      value: gameStats.currentStreak.toString(),
                                      label: 'Reeks',
                                      colorScheme: colorScheme,
                                      color: const Color(0xFFF59E0B),
                                      animation: _streakAnimation,
                                      previousValue: _previousStreak,
                                      onAnimationComplete: () {
                                        _previousStreak = gameStats.currentStreak;
                                      },
                                      isSmallPhone: false,
                                    ),
                                    MetricItem(
                                      icon: Icons.emoji_events_rounded,
                                      value: gameStats.longestStreak.toString(),
                                      label: 'Beste',
                                      colorScheme: colorScheme,
                                      color: const Color(0xFFF59E0B),
                                      animation: _longestStreakAnimation,
                                      previousValue: _previousLongestStreak,
                                      onAnimationComplete: () {
                                        _previousLongestStreak = gameStats.longestStreak;
                                      },
                                      isSmallPhone: false,
                                    ),
                                    MetricItem(
                                      icon: Icons.timer_rounded,
                                      value: _quizState.timeRemaining.toString(),
                                      label: 'Tijd',
                                      colorScheme: colorScheme,
                                      color: _timeColorAnimation.value ?? const Color(0xFF10B981),
                                      animation: _timeAnimation,
                                      previousValue: _previousTime,
                                      onAnimationComplete: () {
                                        _previousTime = _quizState.timeRemaining;
                                      },
                                      isSmallPhone: false,
                                    ),
                                  ],
                                )
                              : _buildMobileMetricsRow(colorScheme, gameStats, isSmallPhone),
                        ),
                      ),
                      SizedBox(height: isDesktop ? 24 : 20),
                      // Question card below metrics
                      QuestionCard(
                        question: _quizState.question,
                        selectedAnswerIndex: _quizState.selectedAnswerIndex,
                        isAnswering: _quizState.isAnswering,
                        isTransitioning: _quizState.isTransitioning,
                        onAnswerSelected: _handleAnswer,
                        language: settings.language,
                      ),
                      const SizedBox(height: 16),
                      Builder(
                        builder: (context) {
                          final canSkip = gameStats.score >= 35 && !_quizState.isAnswering && !_quizState.isTransitioning;
                          final textColor = canSkip ? Theme.of(context).colorScheme.primary : Colors.grey;
                          return TextButton(
                            onPressed: canSkip
                                ? () async {
                                    final success = await gameStats.spendStars(35);
                                    if (success) {
                                      _timer?.cancel();
                                      setState(() {
                                        _quizState = _quizState.copyWith(
                                          selectedAnswerIndex: null,
                                          isTransitioning: true,
                                        );
                                      });
                                      await Future.delayed(_performanceService.getOptimalAnimationDuration(const Duration(milliseconds: 300)));
                                      if (!mounted) return;
                                      final newDifficulty = _quizState.currentDifficulty;
                                      setState(() {
                                        final nextQuestion = _getNextQuestion(newDifficulty);
                                        final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
                                          Duration(seconds: settings.slowMode ? 35 : 20)
                                        );
                                        _quizState = QuizState(
                                          question: nextQuestion,
                                          timeRemaining: optimalTimerDuration.inSeconds,
                                          currentDifficulty: newDifficulty,
                                        );
                                        _startTimer(reset: true);
                                      });
                                      
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Niet genoeg sterren om over te slaan!')),
                                      );
                                    }
                                  }
                                : null,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  settings.language == 'en' ? 'Skip' : 'Overslaan',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: textColor,
                                ),
                                Text(
                                  ' 35',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileMetricsRow(ColorScheme colorScheme, GameStatsProvider gameStats, bool isSmallPhone) {
    final size = MediaQuery.of(context).size;
    double width = size.width;

    // If the screen is extremely small, show a not supported message
    if (width < 260) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Schermgrootte niet ondersteund',
            style: TextStyle(
              color: colorScheme.error,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Determine scale factor based on width
    double scale;
    if (width < 320) {
      scale = 0.7;
    } else if (width < 380) {
      scale = 0.8;
    } else if (width < 440) {
      scale = 0.9;
    } else {
      scale = 1.0;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: MetricItem(
            icon: Icons.star_rounded,
            value: gameStats.score.toString(),
            label: 'Score',
            colorScheme: colorScheme,
            color: colorScheme.primary,
            animation: _scoreAnimation,
            previousValue: _previousScore,
            onAnimationComplete: () {
              _previousScore = gameStats.score;
            },
            isSmallPhone: false,
            highlight: gameStats.isPowerupActive,
            scale: scale,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: MetricItem(
            icon: Icons.local_fire_department_rounded,
            value: gameStats.currentStreak.toString(),
            label: 'Reeks',
            colorScheme: colorScheme,
            color: const Color(0xFFF59E0B),
            animation: _streakAnimation,
            previousValue: _previousStreak,
            onAnimationComplete: () {
              _previousStreak = gameStats.currentStreak;
            },
            isSmallPhone: false,
            scale: scale,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: MetricItem(
            icon: Icons.emoji_events_rounded,
            value: gameStats.longestStreak.toString(),
            label: 'Beste',
            colorScheme: colorScheme,
            color: const Color(0xFFF59E0B),
            animation: _longestStreakAnimation,
            previousValue: _previousLongestStreak,
            onAnimationComplete: () {
              _previousLongestStreak = gameStats.longestStreak;
            },
            isSmallPhone: false,
            scale: scale,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: MetricItem(
            icon: Icons.timer_rounded,
            value: _quizState.timeRemaining.toString(),
            label: 'Tijd',
            colorScheme: colorScheme,
            color: _timeColorAnimation.value ?? const Color(0xFF10B981),
            animation: _timeAnimation,
            previousValue: _previousTime,
            onAnimationComplete: () {
              _previousTime = _quizState.timeRemaining;
            },
            isSmallPhone: false,
            scale: scale,
          ),
        ),
      ],
    );
  }
} 