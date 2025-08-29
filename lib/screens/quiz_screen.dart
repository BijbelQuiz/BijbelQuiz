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

import '../widgets/metric_item.dart';
import '../widgets/question_card.dart';
import '../widgets/biblical_reference_dialog.dart';
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

  // PQU: Progressive Question Up-selection algorithm
  // Picks the next question based on the current normalized difficulty and the JSON difficulty levels [1..5]
  QuizQuestion _pquPickNextQuestion(double currentDifficulty) {
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    double targetDifficulty = currentDifficulty;
    final totalQuestions = gameStats.score + gameStats.incorrectAnswers;

    if (totalQuestions > 0) {
      final correctRatio = totalQuestions > 0 ? gameStats.score / totalQuestions : 0.0;
      // More responsive difficulty adjustment
      if (correctRatio > 0.9) {
        targetDifficulty += 0.05; // Increased from 0.02
      } else if (correctRatio > 0.75) {
        targetDifficulty += 0.03; // Increased from 0.01
      } else if (correctRatio < 0.3) {
        targetDifficulty -= 0.05; // Increased from 0.01
      } else if (correctRatio < 0.5) {
        targetDifficulty -= 0.03; // Increased from 0.01
      }
      // Dampen shifts in long sessions but less aggressively
      if (totalQuestions > 30) { // Reduced from 50
        targetDifficulty = currentDifficulty + (targetDifficulty - currentDifficulty) * 0.7; // Increased from 0.5
      }
    }

    // Clamp to [0,2] as normalized internal difficulty used by PQU
    targetDifficulty = targetDifficulty.clamp(0.0, 2.0);

    // Map normalized [0..2] to JSON difficulty levels [1..5]
    final int targetLevel = (1 + (targetDifficulty * 2).round()).clamp(1, 5);

    // Available questions not used in current pool
    List<QuizQuestion> availableQuestions =
        _allQuestions.where((q) => !_usedQuestions.contains(q.question)).toList();

    // If exhausted, reset pool and reshuffle for better distribution
    if (availableQuestions.isEmpty) {
      AppLogger.info('All questions used, resetting question pool');
      _usedQuestions.clear();
      _recentlyUsedQuestions.clear(); // Clear recent questions too
      // Reshuffle questions for better distribution across the database
      _allQuestions.shuffle(Random());
      availableQuestions = List<QuizQuestion>.from(_allQuestions);

      // PERFORMANCE OPTIMIZATION: If we're running low on questions, load more in background
      if (_allQuestions.length < 200 && !_lessonMode) {
        _loadMoreQuestionsInBackground();
      }
    }

    // Prefer questions within ±1 band of target level
    List<QuizQuestion> eligibleQuestions = availableQuestions.where((q) {
      final int qLevel = int.tryParse(q.difficulty.toString()) ?? 3;
      return (qLevel - targetLevel).abs() <= 1;
    }).toList();

    // If none, try exact level
    if (eligibleQuestions.isEmpty) {
      eligibleQuestions = availableQuestions.where((q) {
        final int qLevel = int.tryParse(q.difficulty.toString()) ?? 3;
        return qLevel == targetLevel;
      }).toList();
    }

    // Fallback to any available
    if (eligibleQuestions.isEmpty) {
      eligibleQuestions = availableQuestions;
    }

    // Filter out recently used questions (more recent first)
    List<QuizQuestion> filteredQuestions = eligibleQuestions.where((q) => 
        !_recentlyUsedQuestions.contains(q.question)).toList();
    
    // If all eligible questions are recent, use the full eligible list
    if (filteredQuestions.isEmpty && eligibleQuestions.isNotEmpty) {
      filteredQuestions = eligibleQuestions;
      // Clear the recent list to prevent getting stuck
      _recentlyUsedQuestions.clear();
    }

    // Random pick among eligible
    final random = Random();
    final selectedQuestion = filteredQuestions[random.nextInt(filteredQuestions.length)];

    // Mark as used
    _usedQuestions.add(selectedQuestion.question);
    
    // Add to recently used list (maintain limit)
    _recentlyUsedQuestions.add(selectedQuestion.question);
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

  // PQU: Progressive difficulty update function
  // Computes the next normalized difficulty [0..2] based on performance, streak, and speed
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

    // More responsive base adjustment
    if (isCorrect) {
      targetDifficulty += 0.08; // Increased from 0.05
      if (streak >= 3) targetDifficulty += 0.05 * (streak ~/ 3); // reward sustained streaks
      if (timeRemaining > 10) targetDifficulty += 0.05; // Increased from 0.03
    } else {
      targetDifficulty -= 0.1; // Increased from 0.07
      if (streak == 0) targetDifficulty -= 0.05; // Increased from 0.03
      if (timeRemaining < 5) targetDifficulty -= 0.03; // Slow & wrong
    }

    // More responsive long-term bias
    if (correctRatio > 0.85) {
      targetDifficulty += 0.05; // Increased from 0.03
    } else if (correctRatio < 0.5) {
      targetDifficulty -= 0.05; // Increased from 0.03
    }

    // Add some randomness to prevent getting stuck on the same difficulty level
    // This helps ensure we sample questions across the difficulty spectrum
    final random = Random();
    targetDifficulty += (random.nextDouble() - 0.5) * 0.15; // Increased from 0.1

    // Clamp to normalized domain
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
                        label: Text(strings.AppStrings.tryAgain),
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
              strings.AppStrings.appName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface.withAlpha((0.7 * 255).round()),
              ),
            ),
          ],
        ),
        bottom: _lessonMode
            ? PreferredSize(
                preferredSize: const Size.fromHeight(24),
                child: _LessonProgressBar(
                  current: _sessionAnswered,
                  total: widget.sessionLimit ?? 1,
                ),
              )
            : null,
        actions: const [],
      ),
      bottomNavigationBar: _QuizBottomBar(
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
                                color: Colors.black.withValues(alpha: 0.10), // subtle, small shadow
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
                                      label: strings.AppStrings.score,
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
                                      label: strings.AppStrings.streak,
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
                                      label: strings.AppStrings.best,
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
                                      label: strings.AppStrings.time,
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
            label: strings.AppStrings.score,
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
            label: strings.AppStrings.streak,
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
            label: strings.AppStrings.best,
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
      if (mounted) {
        await showDialog(
          context: localContext,
          builder: (BuildContext context) {
            return BiblicalReferenceDialog(
              reference: _quizState.question.biblicalReference!,
            );
          },
        );
      }

      // Resume the timer when dialog is closed
      if (mounted) {
        _resumeTimer();
      }
    } else {
      // Not enough stars
      if (mounted) {
        showTopSnackBar(localContext, strings.AppStrings.notEnoughStars, style: TopSnackBarStyle.warning);
      }
    }
  }
}

// Bottom bar widget for quiz actions
class _QuizBottomBar extends StatelessWidget {
  final QuizState quizState;
  final GameStatsProvider gameStats;
  final SettingsProvider settings;
  final VoidCallback onSkipPressed;
  final VoidCallback onUnlockPressed;
  final bool isDesktop;

  const _QuizBottomBar({
    required this.quizState,
    required this.gameStats,
    required this.settings,
    required this.onSkipPressed,
    required this.onUnlockPressed,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final canSkip = gameStats.score >= 35 && !quizState.isAnswering && !quizState.isTransitioning;
    final hasBiblicalReference = quizState.question.biblicalReference != null &&
                               quizState.question.biblicalReference!.isNotEmpty;
    final canUnlock = gameStats.score >= 10 &&
                     !quizState.isAnswering &&
                     !quizState.isTransitioning &&
                     hasBiblicalReference;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withAlpha((0.1 * 255).round()),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Skip button
            _buildActionButton(
              context: context,
              icon: Icons.skip_next_rounded,
              label: settings.language == 'en' ? strings.AppStrings.skip : strings.AppStrings.overslaan,
              cost: 35,
              canUse: canSkip,
              onPressed: onSkipPressed,
              isDesktop: isDesktop,
            ),

            // Unlock biblical reference button
            if (hasBiblicalReference)
              _buildActionButton(
                context: context,
                icon: Icons.book_rounded,
                label: strings.AppStrings.unlockBiblicalReference,
                cost: 10,
                canUse: canUnlock,
                onPressed: onUnlockPressed,
                isDesktop: isDesktop,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int cost,
    required bool canUse,
    required VoidCallback onPressed,
    required bool isDesktop,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = canUse ? colorScheme.primary : Colors.grey;

    return Container(
      constraints: BoxConstraints(
        minWidth: isDesktop ? 140 : 100,
        maxWidth: isDesktop ? 220 : 140,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canUse ? onPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: isDesktop ? 20 : 18,
                  color: textColor,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.star_rounded,
                  size: isDesktop ? 16 : 14,
                  color: textColor,
                ),
                const SizedBox(width: 2),
                Text(
                  cost.toString(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: isDesktop ? 14 : 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Lesson session progress bar for QuizScreen lesson mode
class _LessonProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const _LessonProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final value = total > 0 ? (current / total).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxW = constraints.maxWidth;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Track
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              // Animated fill
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                width: maxW * value,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      cs.primary,
                      cs.primary.withValues(alpha: 0.65),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                      spreadRadius: 0.5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),

              // Soft shimmer overlay on the filled part
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: value == 0.0 ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: FractionallySizedBox(
                      widthFactor: value,
                      alignment: Alignment.centerLeft,
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            begin: Alignment(-1.0, 0.0),
                            end: Alignment(1.0, 0.0),
                            colors: [
                              Colors.transparent,
                              Colors.white54,
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.srcATop,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.easeInOut,
                          width: maxW * value,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white.withValues(alpha: 0.10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Cap dot with glow
              if (value > 0.0)
                Positioned(
                  left: (maxW * value) - 6,
                  top: -2,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    scale: 1.0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: cs.primary.withValues(alpha: 0.6),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}