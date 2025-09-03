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
import '../models/lesson.dart';
import '../providers/lesson_progress_provider.dart';
import 'lesson_complete_screen.dart';

import '../widgets/biblical_reference_dialog.dart';
import '../widgets/quiz_error_display.dart';
import '../widgets/quiz_bottom_bar.dart';
import '../widgets/question_widget.dart';
import '../widgets/metrics_widget.dart';
import '../widgets/app_bar_widget.dart';
import 'dart:async';
import '../services/logger.dart';
import 'dart:math';
import '../widgets/quiz_skeleton.dart';
import '../widgets/top_snackbar.dart';
import '../l10n/strings_nl.dart' as strings;

/// The main quiz screen that displays questions and handles user interactions
/// with performance optimizations for low-end devices and poor connections.
class QuizScreen extends StatefulWidget {
  final Lesson? lesson;
  final int? sessionLimit; // when set, run in lesson mode with capped questions

  const QuizScreen({super.key, this.lesson, this.sessionLimit});

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
  
  // Track recently used questions to prevent immediate repetitions
  static const int _recentlyUsedLimit = 50; // Prevent repetition among last 50 questions
  final List<String> _recentlyUsedQuestions = [];

  // Lesson session mode (cap session to N questions with completion screen)
  bool get _lessonMode => widget.lesson != null && widget.sessionLimit != null;
  int _sessionAnswered = 0;
  int _sessionCorrect = 0;
  int _sessionCurrentStreakLocal = 0;
  int _sessionBestStreak = 0;
  
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
        showTopSnackBar(context, message, style: TopSnackBarStyle.error);
      }
    };
  }

  /// Called when game stats change
  void _onGameStatsChanged() {
    if (!mounted) return;
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

    // Attach timer listeners once; they read controller.duration dynamically
    _timeAnimationController.addListener(_onTimeTick);
    _timeAnimationController.addStatusListener(_onTimeStatus);
  }

  // Monitor performance by tracking frame times
  void _monitorPerformance() {
    if (!mounted) return;

    // Update frame timing
    _performanceService.updateFrameTime();

    // PERFORMANCE OPTIMIZATION: Periodically optimize memory usage
    if (_performanceService.averageFrameRate < 30.0) {
      // If frame rate drops below 30fps, optimize memory
      _questionCacheService.optimizeMemoryUsage();
    }

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
      // PERFORMANCE OPTIMIZATION: Check if controllers are still mounted before disposing
      if (_timeAnimationController.isAnimating) {
        _timeAnimationController.removeListener(_onTimeTick);
        _timeAnimationController.removeStatusListener(_onTimeStatus);
        _timeAnimationController.stop();
      }
      _timeAnimationController.dispose();

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

      // Dispose services
      _performanceService.dispose();
      _connectionService.dispose();
      _soundService.dispose();

      // Remove game stats listener safely
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
      _timeAnimationController.stop(); // Pause color animation
      _isTimerPaused = true;
    }
  }

  void _resumeTimer() {
    if (_isTimerPaused) {
      _timeAnimationController.forward(); // Resume color animation
      _restartTimer();
      _isTimerPaused = false;
    }
  }

  /// Restart the timer without resetting the animation controller
  void _restartTimer() {
    if (!mounted) return;
    
    final localContext = context;
    final settings = Provider.of<SettingsProvider>(localContext, listen: false);
    final baseTimerDuration = settings.slowMode ? 35 : 20;
    final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
      Duration(seconds: baseTimerDuration)
    );
    
    // Update the animation controller duration
    _timeAnimationController.duration = optimalTimerDuration;
    
    // Cancel any existing timer
    _timer?.cancel();
    
    // Calculate remaining time based on current animation value
    final currentProgress = _timeAnimationController.value;
    final remainingDuration = Duration(
      milliseconds: (optimalTimerDuration.inMilliseconds * (1.0 - currentProgress)).round()
    );
    
    // Start the animation from current value
    _timeAnimationController.forward();
    
    // Fallback timer in case animation doesn't complete
    _timer = Timer(remainingDuration, () {
      if (mounted && _timeAnimationController.status != AnimationStatus.completed) {
        _timeAnimationController.animateTo(1.0, duration: Duration.zero);
      }
    });
  }

  // Live timer tick: update timeRemaining once per second using controller value
  // PERFORMANCE OPTIMIZATION: Only update when the second actually changes
  void _onTimeTick() {
    if (!mounted) return;
    final duration = _timeAnimationController.duration;
    if (duration == null) return;

    final elapsedMs = (_timeAnimationController.value * duration.inMilliseconds)
        .clamp(0.0, duration.inMilliseconds.toDouble())
        .toInt();
    final remainingMs = duration.inMilliseconds - elapsedMs;
    final remainingSeconds = (remainingMs / 1000).ceil();

    // Only trigger setState when the displayed second actually changes
    if (remainingSeconds != _quizState.timeRemaining) {
      setState(() {
        _previousTime = _quizState.timeRemaining;
        _quizState = _quizState.copyWith(timeRemaining: remainingSeconds);
      });
    }
  }

  // Handle completion to trigger haptics and dialog
  void _onTimeStatus(AnimationStatus status) {
    if (!mounted) return;
    if (status == AnimationStatus.completed) {
      _showTimeUpDialog();
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
    
    // Listeners are attached once in _initializeAnimations; they read the current duration
    
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
                strings.AppStrings.notEnoughPoints,
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
            strings.AppStrings.timeUp,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            strings.AppStrings.timeUpMessage,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            Builder(
              builder: (ctx) => TextButton(
                onPressed: hasEnoughPoints ? () {
                  gameStats.spendPointsForRetry().then((success) {
                    if (success && mounted) {
                      Navigator.of(dialogContext).pop();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
                              Duration(seconds: settings.slowMode ? 35 : 20)
                            );
                            _quizState = _quizState.copyWith(
                              timeRemaining: optimalTimerDuration.inSeconds,
                            );
                          });
                          if (mounted) {
                            _startTimer(reset: true);
                          }
                        }
                      });
                    }
                  });
                } : () {
                  // Create a local function to handle the tooltip display
                  void showTooltip() {
                    if (ctx.mounted) {
                      try {
                        final RenderBox buttonBox = ctx.findRenderObject() as RenderBox;
                        showInsufficientPointsTooltip(ctx, buttonBox);
                      } catch (e) {
                        // Ignore errors in finding render object
                      }
                    }
                  }

                  // Call the function immediately
                  showTooltip();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      strings.AppStrings.retry,
                      style: TextStyle(
                        color: hasEnoughPoints
                          ? Theme.of(localContext).colorScheme.primary
                          : Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.star,
                      size: 16,
                      color: hasEnoughPoints
                        ? Theme.of(localContext).colorScheme.primary
                        : Colors.grey,
                    ),
                    Text(
                      ' 50',
                      style: TextStyle(
                        color: hasEnoughPoints
                          ? Theme.of(localContext).colorScheme.primary
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
                strings.AppStrings.next,
                style: TextStyle(
                  color: Theme.of(localContext).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (tooltipEntry != null && localContext.mounted) {
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
    _recentlyUsedQuestions.clear();
    _allQuestionsLoaded = false;
    _allQuestions.clear();
    // Reinitialize quiz with new language
    _initializeQuiz();
  }

  /// Reset the question pool for a new game session
  void _resetForNewGame() {
    AppLogger.info('Resetting question pool for new game session');
    _usedQuestions.clear();
    _recentlyUsedQuestions.clear();
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

      // Load questions - if in lesson mode with a specific category, load category questions
      // Otherwise load questions in batches for better performance
      if (!_allQuestionsLoaded) {
        if (_lessonMode && widget.lesson?.category != null && widget.lesson!.category != 'Algemeen') {
          // Load questions for specific category
          _allQuestions = await _questionCacheService.getQuestionsByCategory(
            language,
            widget.lesson!.category
          );
          AppLogger.info('Loaded category questions for language: $language, category: ${widget.lesson!.category}, count: ${_allQuestions.length}');
        } else {
          // PERFORMANCE OPTIMIZATION: Load questions in smaller batches instead of all at once
          // Start with a reasonable batch size for initial gameplay
          const int initialBatchSize = 100; // Load first 100 questions for immediate play
          _allQuestions = await _questionCacheService.getQuestions(
            language,
            startIndex: 0,
            count: initialBatchSize
          );
          AppLogger.info('Loaded initial batch of questions for language: $language, count: ${_allQuestions.length}');
        }
        _allQuestions.shuffle(Random());
        _allQuestionsLoaded = true;
      }

      if (_allQuestions.isEmpty) {
        throw Exception(strings.AppStrings.errorNoQuestions);
      }

      // Initialize quiz state with PQU (Progressive Question Up-selection)
      final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
        Duration(seconds: settings.slowMode ? 35 : 20)
      );
      
      final firstQuestion = _pquPickNextQuestion(0.0);
      _quizState = QuizState(
        question: firstQuestion,
        timeRemaining: optimalTimerDuration.inSeconds,
        currentDifficulty: 0.0,
      );

      // Reset lesson session counters if in lesson mode
      if (_lessonMode) {
        _sessionAnswered = 0;
        _sessionCorrect = 0;
        _sessionCurrentStreakLocal = 0;
        _sessionBestStreak = 0;
      }

      // Start the timer (reset)
      _startTimer(reset: true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '${strings.AppStrings.errorLoadQuestions}: ${e.toString()}';
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

  /// PQU: Progressive Question Up-selection algorithm
  /// This algorithm dynamically adjusts question difficulty based on player performance
  /// to maintain an optimal challenge level and prevent boredom or frustration.
  ///
  /// The algorithm works by:
  /// 1. Analyzing recent performance (correct/incorrect ratio)
  /// 2. Adjusting target difficulty based on performance thresholds
  /// 3. Applying dampening for long sessions to prevent extreme swings
  /// 4. Mapping internal difficulty scale [0..2] to JSON levels [1..5]
  /// 5. Selecting questions within ±1 difficulty level of target
  /// 6. Filtering out recently used questions to prevent repetition
  ///
  /// @param currentDifficulty The current normalized difficulty [0..2]
  /// @return The next question selected by the algorithm
  QuizQuestion _pquPickNextQuestion(double currentDifficulty) {
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    double targetDifficulty = currentDifficulty;
    final totalQuestions = gameStats.score + gameStats.incorrectAnswers;

    // PHASE 1: Calculate target difficulty based on recent performance
    if (totalQuestions > 0) {
      final correctRatio = gameStats.score / totalQuestions;

      // Performance-based difficulty adjustment
      // High performance (>90% correct): Increase difficulty significantly
      if (correctRatio > 0.9) {
        targetDifficulty += 0.05;
      }
      // Good performance (75-90% correct): Increase difficulty moderately
      else if (correctRatio > 0.75) {
        targetDifficulty += 0.03;
      }
      // Poor performance (<30% correct): Decrease difficulty significantly
      else if (correctRatio < 0.3) {
        targetDifficulty -= 0.05;
      }
      // Below average performance (30-50% correct): Decrease difficulty moderately
      else if (correctRatio < 0.5) {
        targetDifficulty -= 0.03;
      }

      // PHASE 2: Apply dampening for long gaming sessions
      // Prevents extreme difficulty swings after many questions
      // Reduces the adjustment magnitude as session length increases
      if (totalQuestions > 30) {
        final adjustment = targetDifficulty - currentDifficulty;
        targetDifficulty = currentDifficulty + (adjustment * 0.7);
      }
    }

    // PHASE 3: Constrain difficulty to valid range
    // Internal difficulty scale: [0..2] maps to JSON levels [1..5]
    targetDifficulty = targetDifficulty.clamp(0.0, 2.0);

    // PHASE 4: Map internal difficulty to JSON difficulty levels
    // Formula: level = 1 + (normalized_difficulty * 2)
    // Examples: 0.0 -> 1, 1.0 -> 3, 2.0 -> 5
    final int targetLevel = (1 + (targetDifficulty * 2).round()).clamp(1, 5);

    // PHASE 5: Select available questions (not used in current session)
    List<QuizQuestion> availableQuestions =
        _allQuestions.where((q) => !_usedQuestions.contains(q.question)).toList();

    // PHASE 6: Handle question pool exhaustion
    // When all questions are used, reset and reshuffle for continued gameplay
    if (availableQuestions.isEmpty) {
      AppLogger.info('Question pool exhausted, resetting for continued play');
      _usedQuestions.clear();
      _recentlyUsedQuestions.clear();
      _allQuestions.shuffle(Random()); // Randomize order for variety
      availableQuestions = List<QuizQuestion>.from(_allQuestions);

      // Load additional questions in background if running low (non-lesson mode only)
      if (_allQuestions.length < 200 && !_lessonMode) {
        _loadMoreQuestionsInBackground();
      }
    }

    // PHASE 7: Filter questions by difficulty (prefer close matches)
    // First preference: questions within ±1 difficulty level of target
    List<QuizQuestion> eligibleQuestions = availableQuestions.where((q) {
      final int qLevel = int.tryParse(q.difficulty.toString()) ?? 3;
      return (qLevel - targetLevel).abs() <= 1;
    }).toList();

    // Second preference: exact difficulty level match
    if (eligibleQuestions.isEmpty) {
      eligibleQuestions = availableQuestions.where((q) {
        final int qLevel = int.tryParse(q.difficulty.toString()) ?? 3;
        return qLevel == targetLevel;
      }).toList();
    }

    // Final fallback: any available question
    if (eligibleQuestions.isEmpty) {
      eligibleQuestions = availableQuestions;
    }

    // PHASE 8: Apply anti-repetition filter
    // Prevent showing recently used questions to maintain engagement
    List<QuizQuestion> filteredQuestions = eligibleQuestions.where((q) =>
        !_recentlyUsedQuestions.contains(q.question)).toList();

    // Emergency fallback: if all eligible questions are recent, clear recent list
    if (filteredQuestions.isEmpty && eligibleQuestions.isNotEmpty) {
      filteredQuestions = eligibleQuestions;
      _recentlyUsedQuestions.clear();
    }

    // PHASE 9: Random selection from eligible questions
    final random = Random();
    final selectedQuestion = filteredQuestions[random.nextInt(filteredQuestions.length)];

    // PHASE 10: Update usage tracking
    _usedQuestions.add(selectedQuestion.question);
    _recentlyUsedQuestions.add(selectedQuestion.question);

    // Maintain recent questions list size limit (FIFO eviction)
    if (_recentlyUsedQuestions.length > _recentlyUsedLimit) {
      _recentlyUsedQuestions.removeAt(0);
    }

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

      // Handle the answer sequence
      _handleAnswerSequence(isCorrect);
    } else if (_quizState.question.type == QuestionType.tf) {
      // For true/false: index 0 = 'Goed', index 1 = 'Fout'
      // Determine if the answer is correct by comparing indices rather than text
      final lcCorrect = _quizState.question.correctAnswer.toLowerCase();
      final correctIndex = (lcCorrect == 'waar' || lcCorrect == 'true' || lcCorrect == 'goed') ? 0 : 1;
      final isCorrect = selectedIndex == correctIndex;

      // Handle the answer sequence
      _handleAnswerSequence(isCorrect);
    } else {
      // For other types, do nothing for now
    }
  }

  /// PQU: Progressive Difficulty Update Function
  /// Calculates the next difficulty level based on comprehensive performance metrics.
  ///
  /// This function considers multiple factors:
  /// - Answer correctness (primary factor)
  /// - Current streak length (reward/punish sustained performance)
  /// - Time remaining when answered (speed bonus/malus)
  /// - Overall session performance ratio (long-term adjustment)
  /// - Random variation (prevents difficulty stagnation)
  ///
  /// @param currentDifficulty Current normalized difficulty [0..2]
  /// @param isCorrect Whether the last answer was correct
  /// @param streak Current consecutive correct answers streak
  /// @param timeRemaining Seconds left when answer was given
  /// @param totalQuestions Total questions answered in session
  /// @param correctAnswers Number of correct answers in session
  /// @param incorrectAnswers Number of incorrect answers in session
  /// @return New normalized difficulty level [0..2]
  double _pquCalculateNextDifficulty({
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

    // PHASE 1: Immediate performance-based adjustment
    if (isCorrect) {
      // Base reward for correct answer
      targetDifficulty += 0.08;

      // Streak bonus: reward sustained performance
      // Every 3 consecutive correct answers adds extra difficulty
      if (streak >= 3) {
        targetDifficulty += 0.05 * (streak ~/ 3);
      }

      // Speed bonus: reward quick correct answers
      if (timeRemaining > 10) {
        targetDifficulty += 0.05;
      }
    } else {
      // Penalty for incorrect answer
      targetDifficulty -= 0.1;

      // Extra penalty for breaking a streak
      if (streak == 0) {
        targetDifficulty -= 0.05;
      }

      // Extra penalty for slow incorrect answers
      if (timeRemaining < 5) {
        targetDifficulty -= 0.03;
      }
    }

    // PHASE 2: Long-term performance bias
    // Adjust based on overall session performance
    if (correctRatio > 0.85) {
      targetDifficulty += 0.05; // Consistently high performance
    } else if (correctRatio < 0.5) {
      targetDifficulty -= 0.05; // Consistently low performance
    }

    // PHASE 3: Anti-stagnation randomization
    // Add small random variation to prevent getting stuck at same difficulty
    // This ensures the algorithm explores different difficulty levels over time
    final random = Random();
    targetDifficulty += (random.nextDouble() - 0.5) * 0.15;

    // PHASE 4: Constrain to valid difficulty range
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

    // Update lesson session counters
    if (_lessonMode) {
      _sessionAnswered += 1;
      if (isCorrect) {
        _sessionCorrect += 1;
        _sessionCurrentStreakLocal += 1;
      } else {
        _sessionCurrentStreakLocal = 0;
      }
      _sessionBestStreak = max(_sessionBestStreak, _sessionCurrentStreakLocal);
    }

    // If in lesson mode and session reached limit, show completion screen
    if (_lessonMode && _sessionAnswered >= (widget.sessionLimit ?? 0)) {
      await _completeLessonSession();
      return;
    }

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
    final newDifficulty = _pquCalculateNextDifficulty(
      currentDifficulty: _quizState.currentDifficulty,
      isCorrect: isCorrect,
      streak: gameStats.currentStreak,
      timeRemaining: _quizState.timeRemaining,
      totalQuestions: gameStats.score + gameStats.incorrectAnswers,
      correctAnswers: gameStats.score,
      incorrectAnswers: gameStats.incorrectAnswers,
    );
    setState(() {
      final nextQuestion = _pquPickNextQuestion(newDifficulty);
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
              strings.AppStrings.screenSizeNotSupported,
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

    // PERFORMANCE OPTIMIZATION: Reduce debug logging frequency
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

    // PERFORMANCE OPTIMIZATION: Early return for loading state to reduce nested conditionals
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
      return QuizErrorDisplay(
        error: _error!,
        onRetry: _initializeQuiz,
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBarWidget(
        lesson: widget.lesson,
        sessionAnswered: _sessionAnswered,
        sessionLimit: widget.sessionLimit,
        lessonMode: _lessonMode,
      ),
      bottomNavigationBar: QuizBottomBar(
        quizState: _quizState,
        gameStats: gameStats,
        settings: settings,
        onSkipPressed: _handleSkip,
        onUnlockPressed: _handleUnlockBiblicalReference,
        isDesktop: isDesktop,
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
                      MetricsWidget(
                        scoreAnimation: _scoreAnimation,
                        streakAnimation: _streakAnimation,
                        longestStreakAnimation: _longestStreakAnimation,
                        timeAnimation: _timeAnimation,
                        timeColorAnimation: _timeColorAnimation,
                        previousScore: _previousScore,
                        previousStreak: _previousStreak,
                        previousLongestStreak: _previousLongestStreak,
                        previousTime: _previousTime,
                        isDesktop: isDesktop,
                        isTablet: isTablet,
                        isSmallPhone: isSmallPhone,
                      ),
                      SizedBox(height: isDesktop ? 24 : 20),
                      // Question card below metrics
                      QuestionWidget(
                        question: _quizState.question,
                        selectedAnswerIndex: _quizState.selectedAnswerIndex,
                        isAnswering: _quizState.isAnswering,
                        isTransitioning: _quizState.isTransitioning,
                        onAnswerSelected: _handleAnswer,
                        language: settings.language,
                      ),
                      const SizedBox(height: 16),
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


  Map<String, dynamic>? _parseBiblicalReference(String reference) {
    try {
      // Handle different reference formats:
      // "Genesis 1:1" -> book: Genesis, chapter: 1, startVerse: 1
      // "Genesis 1:1-3" -> book: Genesis, chapter: 1, startVerse: 1, endVerse: 3
      // "Genesis 1" -> book: Genesis, chapter: 1
      
      // Remove extra spaces and split by space
      reference = reference.trim();
      final parts = reference.split(' ');
      
      if (parts.length < 2) return null;
      
      // Extract book name (everything except the last part)
      final book = parts.sublist(0, parts.length - 1).join(' ');
      final chapterAndVerses = parts.last;
      
      // Split chapter and verses by colon
      final chapterVerseParts = chapterAndVerses.split(':');
      
      if (chapterVerseParts.isEmpty) return null;
      
      final chapter = int.tryParse(chapterVerseParts[0]);
      if (chapter == null) return null;
      
      int? startVerse;
      int? endVerse;
      
      if (chapterVerseParts.length > 1) {
        // Has verse information
        final versePart = chapterVerseParts[1];
        if (versePart.contains('-')) {
          // Range of verses
          final verseRange = versePart.split('-');
          startVerse = int.tryParse(verseRange[0]);
          endVerse = int.tryParse(verseRange[1]);
        } else {
          // Single verse
          startVerse = int.tryParse(versePart);
        }
      }
      
      return {
        'book': book,
        'chapter': chapter,
        'startVerse': startVerse,
        'endVerse': endVerse,
      };
    } catch (e) {
      return null;
    }
  }
 

  /// Load more questions in the background when running low
  Future<void> _loadMoreQuestionsInBackground() async {
    if (_lessonMode) return; // Don't load more in lesson mode

    try {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final language = settings.language;

      // Load next batch of questions
      final nextBatchStartIndex = _allQuestions.length;
      const int batchSize = 50; // Load 50 more questions

      final newQuestions = await _questionCacheService.getQuestions(
        language,
        startIndex: nextBatchStartIndex,
        count: batchSize
      );

      if (newQuestions.isNotEmpty && mounted) {
        setState(() {
          // Add new questions and shuffle the combined list
          _allQuestions.addAll(newQuestions);
          _allQuestions.shuffle(Random());
          AppLogger.info('Loaded additional questions, total now: ${_allQuestions.length}');
        });
      }
    } catch (e) {
      AppLogger.error('Failed to load more questions in background', e);
    }
  }

  Future<void> _completeLessonSession() async {
    // Stop any timers
    _timer?.cancel();

    final lesson = widget.lesson!;
    final total = widget.sessionLimit ?? _sessionAnswered;
    final correct = _sessionCorrect;
    final bestStreak = _sessionBestStreak;
    final stars = LessonProgressProvider().computeStars(correct: correct, total: total);

    // Persist lesson progress
    final progress = Provider.of<LessonProgressProvider>(context, listen: false);
    await progress.markCompleted(lesson: lesson, correct: correct, total: total);

    // Show full-screen completion screen
    final quizContext = context;
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => LessonCompleteScreen(
          lesson: lesson,
          stars: stars,
          correct: correct,
          total: total,
          bestStreak: bestStreak,
          onRetry: () {
            // Pop completion screen, restart lesson session
            Navigator.of(ctx).pop();
            _initializeQuiz();
          },
          onExit: () {
            // Pop completion screen and then the quiz to go back to lessons
            Navigator.of(ctx).pop();
            Navigator.of(quizContext).pop();
          },
        ),
      ),
    );
  }

  // Callback methods for bottom bar buttons
  Future<void> _handleSkip() async {
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    final settings = Provider.of<SettingsProvider>(context, listen: false);

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
        final nextQuestion = _pquPickNextQuestion(newDifficulty);
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
      if (mounted) {
        showTopSnackBar(context, strings.AppStrings.notEnoughStarsForSkip, style: TopSnackBarStyle.warning);
      }
    }
  }

  Future<void> _handleUnlockBiblicalReference() async {
    final localContext = context;
    final gameStats = Provider.of<GameStatsProvider>(localContext, listen: false);

    // First check if the reference can be parsed
    final parsed = _parseBiblicalReference(_quizState.question.biblicalReference!);
    if (parsed == null) {
      if (mounted) {
        showTopSnackBar(localContext, strings.AppStrings.invalidBiblicalReference, style: TopSnackBarStyle.error);
      }
      return;
    }

    // Spend 10 stars for unlocking the biblical reference
    final success = await gameStats.spendStars(10);
    if (success) {
      // Pause the timer
      if (mounted) {
        _pauseTimer();
      }

      // Show the biblical reference dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showDialog(
            context: localContext,
            builder: (BuildContext context) {
              return BiblicalReferenceDialog(
                reference: _quizState.question.biblicalReference!,
              );
            },
          ).then((_) {
            // Resume the timer when dialog is closed
            if (mounted) {
              _resumeTimer();
            }
          });
        }
      });
    } else {
      // Not enough stars
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showTopSnackBar(localContext, strings.AppStrings.notEnoughStars, style: TopSnackBarStyle.warning);
        }
      });
    }
  }
}

