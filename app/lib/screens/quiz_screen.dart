import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_state.dart';
import '../models/quiz_question.dart';
import '../services/sound_service.dart';
import '../services/question_cache_service.dart';
import '../services/performance_service.dart';
import '../services/connection_service.dart';
import '../services/platform_feedback_service.dart';
import '../services/time_tracking_service.dart';
import '../providers/settings_provider.dart';
import '../providers/game_stats_provider.dart';
import '../models/lesson.dart';
import '../providers/lesson_progress_provider.dart';
import 'lesson_complete_screen.dart';

import '../widgets/biblical_reference_dialog.dart';
import '../widgets/quiz_error_display.dart';
import '../error/error_handler.dart';
import '../error/error_types.dart';
import '../widgets/quiz_bottom_bar.dart';
import '../widgets/question_widget.dart';
import '../widgets/metrics_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../utils/responsive_utils.dart';
import '../widgets/common_widgets.dart';
import '../utils/quiz_action_price_helper.dart';
import 'dart:async';
import 'dart:math';
import '../widgets/quiz_skeleton.dart';
import '../widgets/top_snackbar.dart';
import 'package:bijbelquiz/l10n/app_localizations.dart';
import '../services/logger.dart';

// New extracted services
import '../services/quiz_timer_manager.dart';
import '../services/quiz_animation_controller.dart';
import '../services/progressive_question_selector.dart';
import '../services/quiz_answer_handler.dart';
import '../utils/automatic_error_reporter.dart';

/// The main quiz screen that displays questions and handles user interactions
/// with performance optimizations for low-end devices and poor connections.
class QuizScreen extends StatefulWidget {
  final Lesson? lesson;
  final int? sessionLimit; // when set, run in lesson mode with capped questions

  const QuizScreen({super.key, this.lesson, this.sessionLimit});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int currentQuestionIndex = 0;
  String? _lastLanguage;

  // Quiz state
  late QuizState _quizState;

  // Loading and error states
  bool _isLoading = true;
  String? _error;

  // Lesson session counters
  int _sessionAnswered = 0;
  int _sessionCorrect = 0;
  int _sessionCurrentStreakLocal = 0;
  int _sessionBestStreak = 0;

  // Lesson session mode (cap session to N questions with completion screen)
  bool get _lessonMode => widget.lesson != null && widget.sessionLimit != null;

  // Previous values for comparison
  int _previousScore = 0;
  int _previousStreak = 0;
  int _previousLongestStreak = 0;
  int _previousTime = 20;

  // Track if we've initialized previous values after loading
  bool _initializedStats = false;
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

  // New extracted managers
  late QuizTimerManager _timerManager;
  late QuizAnimationController _animationController;
  late ProgressiveQuestionSelector _questionSelector;
  late QuizAnswerHandler _answerHandler;

  // Vertical transition animation for question changes
  late AnimationController _verticalTransitionController;
  late Animation<Offset> _verticalSlideAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppLogger.info('QuizScreen loaded');

    // Log performance metrics periodically and track performance
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        final metrics = _performanceService.getPerformanceMetrics();
        AppLogger.info('QuizScreen performance metrics: $metrics');
      }
    });

    // Initialize services
    _performanceService = PerformanceService();
    _connectionService = ConnectionService();
    _platformFeedbackService = PlatformFeedbackService();
    _questionCacheService = QuestionCacheService(_connectionService);

    _initializeServices();
    _initializeManagers();
    _initializeQuiz();

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
    if (gameStats.score == 0 &&
        gameStats.currentStreak == 0 &&
        gameStats.incorrectAnswers == 0) {
      // Check if this is a fresh reset (not just initialization)
      if (_questionSelector.allQuestionsLoaded &&
          _questionSelector.usedQuestions.isNotEmpty) {
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

  /// Initialize the new extracted managers
  void _initializeManagers() {
    // Managers removed as they are not currently used

    _timerManager = QuizTimerManager(
      performanceService: _performanceService,
      vsync: this,
      onTimeTick: _onTimeTick,
      onTimeUp: _showTimeUpDialog,
    );

    _animationController = QuizAnimationController(
      performanceService: _performanceService,
      vsync: this,
    );

    _questionSelector = ProgressiveQuestionSelector(
      questionCacheService: _questionCacheService,
    );
    _questionSelector.setStateCallback(setState);
    _questionSelector.setMounted(mounted);

    _answerHandler = QuizAnswerHandler(
      soundService: _soundService,
      platformFeedbackService: _platformFeedbackService,
    );

    // Initialize vertical transition animation
    _verticalTransitionController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _verticalSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _verticalTransitionController,
      curve: Curves.easeOutCubic,
    ));
    // Start at end position so questions are visible
    _verticalTransitionController.value = 1.0;
  }

  @override
  void dispose() {
    // Update question selector mounted state
    _questionSelector.setMounted(false);

    // Dispose new managers
    _timerManager.dispose();
    _animationController.dispose();
    _verticalTransitionController.dispose();

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

    // Ensure we always clean up the observer and reset state
    WidgetsBinding.instance.removeObserver(this);
    _hasLoggedScreenView = false;

    // Call super.dispose() last
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _timerManager.handleAppLifecycleState(state, context);
    if (state == AppLifecycleState.resumed) {
      // Trigger animations for stats updates if penalty was applied
      _animationController.triggerAllStatsAnimations();
    }
  }

  // Live timer tick: update timeRemaining once per second using controller value
  // PERFORMANCE OPTIMIZATION: Only update when the second actually changes
  void _onTimeTick() {
    if (!mounted) return;
    final duration = _timerManager.timeAnimationController.duration;
    if (duration == null) return;

    final elapsedMs =
        (_timerManager.timeAnimationController.value * duration.inMilliseconds)
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

      // Trigger animation when time reaches critical threshold (5 seconds)
      if (remainingSeconds == 5) {
        _animationController.triggerTimeAnimation();
      }
    }
  }

  Future<void> _showTimeUpDialog() async {
    if (ModalRoute.of(context)?.isCurrent != true) return;

    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);

    // Get dynamic retry price from database
    final priceHelper = QuizActionPriceHelper();
    final retryPrice = await priceHelper.getRetryQuestionPrice();
    final hasEnoughPoints = gameStats.score >= retryPrice;

    OverlayEntry? tooltipEntry;

    void showInsufficientPointsTooltip(
        BuildContext context, RenderBox buttonBox) {
      tooltipEntry?.remove();

      final RenderBox overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      final buttonPosition =
          buttonBox.localToGlobal(Offset.zero, ancestor: overlay);

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
                AppLocalizations.of(context)!.notEnoughPoints,
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
        Overlay.of(context).insert(tooltipEntry!);
      }

      Future.delayed(const Duration(seconds: 2), () {
        tooltipEntry?.remove();
        tooltipEntry = null;
      });
    }

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.timeUp,
            style: Theme.of(dialogContext).textTheme.headlineSmall,
          ),
          content: Text(
            AppLocalizations.of(context)!.timeUpMessage,
            style: Theme.of(dialogContext).textTheme.bodyLarge,
          ),
          actions: [
            Builder(
                builder: (ctx) => TextButton(
                onPressed: hasEnoughPoints
                    ? () {
                        gameStats
                            .spendPointsForRetry(amount: retryPrice)
                            .then((success) {
                          if (!dialogContext.mounted) return;
                          if (success) {
                            Navigator.of(dialogContext).pop();
                                  'current_score': localGameStats.score,
                                });

                            Navigator.of(dialogContext).pop();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {
                                  final optimalTimerDuration =
                                      _performanceService
                                          .getOptimalTimerDuration(Duration(
                                              seconds: settings
                                                  .gameSpeedTimerDuration));
                                  _quizState = _quizState.copyWith(
                                    timeRemaining:
                                        optimalTimerDuration.inSeconds,
                                  );
                                });
                                if (mounted) {
                                  _timerManager.startTimer(
                                      context: dialogContext, reset: true);
                                  _animationController.triggerTimeAnimation();
                                }
                              }
                            });
                          }
                        });
                      }
                    : () {
                        // Create a local function to handle the tooltip display
                        void showTooltip() {
                          if (ctx.mounted) {
                            try {
                              final RenderBox buttonBox =
                                  ctx.findRenderObject() as RenderBox;
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
                      AppLocalizations.of(context)!.retry,
                      style: TextStyle(
                        color: hasEnoughPoints
                            ? Theme.of(dialogContext).colorScheme.primary
                            : Theme.of(dialogContext).colorScheme.outline,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.star,
                      size: 16,
                      color: hasEnoughPoints
                          ? Theme.of(dialogContext).colorScheme.primary
                          : Theme.of(dialogContext).colorScheme.outline,
                    ),
                    Text(
                      ' $retryPrice',
                      style: TextStyle(
                        color: hasEnoughPoints
                            ? Theme.of(dialogContext).colorScheme.primary
                            : Theme.of(dialogContext).colorScheme.outline,
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
                // For time up scenario, we call handleNextQuestion which will record the result
                _handleNextQuestion(false, _quizState.currentDifficulty);
              },
              child: Text(
                AppLocalizations.of(context)!.next,
                style: TextStyle(
                  color: Theme.of(dialogContext).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (tooltipEntry != null && mounted) {
      Overlay.of(context).insert(tooltipEntry!);
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
      AppLogger.info(
          'Language changed from $_lastLanguage to $language, resetting question pool');
      _resetQuestionPool();
    }
    _lastLanguage = language;
  }

  /// Reset the question pool for a new language or session
  void _resetQuestionPool() {
    _questionSelector.resetQuestionPool();
    // Reinitialize quiz with new language
    _initializeQuiz();
  }

  /// Reset the question pool for a new game session
  void _resetForNewGame() {
    AppLogger.info('Resetting question pool for new game session');
    _questionSelector.resetForNewGame();
  }

  /// Initialize animations with performance optimizations
  Future<void> _initializeQuiz() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final language = settings.language;

      // Load questions - if in lesson mode with a specific category, load category questions
      // Otherwise load questions in batches for better performance
      if (!_questionSelector.allQuestionsLoaded) {
        if (_lessonMode &&
            widget.lesson?.category != null &&
            widget.lesson!.category != 'Algemeen') {
          // Load questions for specific category
          _questionSelector.allQuestions = await _questionCacheService
              .getQuestionsByCategory(language, widget.lesson!.category);
          AppLogger.info(
              'Loaded category questions for language: $language, category: ${widget.lesson!.category}, count: ${_questionSelector.allQuestions.length}');
        } else {
          // Load ALL questions for this language up-front to guarantee
          // no duplicates are served within a session. If the device/network
          // allows, this ensures the full question pool is available and we
          // never have to repeat before exhausting the entire DB.
          _questionSelector.allQuestions =
              await _questionCacheService.getQuestions(
            language,
            startIndex: 0,
            // Passing no count loads all remaining questions from the cache/service
          );
          AppLogger.info(
              'Loaded full set of questions for language: $language, count: ${_questionSelector.allQuestions.length}');
        }
        _questionSelector.allQuestions.shuffle(Random());
        _questionSelector.allQuestionsLoaded = true;
      }

      if (!mounted) return;

      if (_questionSelector.allQuestions.isEmpty) {
        throw Exception(AppLocalizations.of(context)!.errorNoQuestions);
      }

      // Initialize quiz state with PQU (Progressive Question Up-selection)
      final isSlowMode = settings.slowMode;
      final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
          Duration(seconds: settings.gameSpeedTimerDuration));

      if (!mounted) return;
      // Select the first question; the selector ensures no duplicates and handles
      // exhaustion by widening scope and then resetting when necessary.
      final QuizQuestion firstQuestion =
          _questionSelector.pickNextQuestion(0.0, context);

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
      if (!mounted) return;
      _timerManager.startTimer(context: context, reset: true);
      _animationController.triggerTimeAnimation();

      // Quiz initialization completed successfully
    } catch (e) {
      if (!mounted) return;

      // Use the new error handling system
      final appError = ErrorHandler().fromException(
        e,
        type: AppErrorType.dataLoading,
        userMessage: AppLocalizations.of(context)!.errorLoadQuestions,
        contextData: {
          'lesson_mode': _lessonMode,
          'error_type': e.runtimeType.toString(),
        },
      );

      setState(() {
        _error = appError.userMessage;
      });

      // The error is now logged by the ErrorHandler, but we can add additional logging if needed
      AppLogger.error('Failed to load questions in QuizScreen', e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Mark today's streak as active since a lesson was completed
  Future<void> _markStreakActive() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const activeDaysKey = 'daily_active_days_v1';
      final list = prefs.getStringList(activeDaysKey) ?? <String>[];
      final activeDays = list.toSet();

      // Mark today as used (lesson completion counts as using BijbelQuiz)
      final today = DateTime.now();
      final todayStr =
          '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      if (!activeDays.contains(todayStr)) {
        activeDays.add(todayStr);
        await prefs.setStringList(activeDaysKey, activeDays.toList());
      }
    } catch (e) {
      // Ignore streak errors silently
      AppLogger.warning('Failed to mark streak as active: $e');
    }
  }

  void _handleAnswer(int selectedIndex) {
    _answerHandler.handleAnswer(
      selectedIndex: selectedIndex,
      quizState: _quizState,
      updateQuizState: (newState) {
        setState(() {
          _quizState = newState;
        });
      },
      handleNextQuestion: _handleNextQuestion,
      context: context,
    );
  }

  Future<void> _handleNextQuestion(bool isCorrect, double newDifficulty) async {
    final localContext = context;
    final gameStats =
        Provider.of<GameStatsProvider>(localContext, listen: false);
    final settings = Provider.of<SettingsProvider>(localContext, listen: false);
    final timeTrackingService =
        Provider.of<TimeTrackingService>(localContext, listen: false);

    // Update game stats first
    await gameStats.updateStats(isCorrect: isCorrect);
    // Trigger animations for stats updates
    _animationController.triggerAllStatsAnimations();

    // Record that a question was answered for time tracking
    timeTrackingService.recordQuestionAnswered();

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
    final transitionPause =
        _platformFeedbackService.getTransitionPauseDuration();
    await Future.delayed(transitionPause);
    if (!mounted) return;

    // Phase 4: Transition to next question
    if (!mounted) return;
    AppLogger.info('Transitioning to next question');
    // Record the answer result so the question selector knows if the previous question was answered correctly
    _questionSelector.recordAnswerResult(
        _quizState.question.question, isCorrect);

    // Calculate new difficulty
    final calculatedNewDifficulty = _questionSelector.calculateNextDifficulty(
      currentDifficulty: _quizState.currentDifficulty,
      isCorrect: isCorrect,
      streak: gameStats.currentStreak,
      timeRemaining: _quizState.timeRemaining,
      totalQuestions: gameStats.score + gameStats.incorrectAnswers,
      correctAnswers: gameStats.score,
      incorrectAnswers: gameStats.incorrectAnswers,
      context: context,
    );

    // Compute next question; selector enforces uniqueness and auto-resets as needed
    final QuizQuestion nextQuestion =
        _questionSelector.pickNextQuestion(calculatedNewDifficulty, context);

    // Trigger vertical scroll animation
    currentQuestionIndex++;
    if (!mounted) return;
    setState(() {
      _verticalSlideAnimation = Tween<Offset>(
        begin: const Offset(0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _verticalTransitionController,
        curve: Curves.easeOutCubic,
      ));
      _verticalTransitionController.forward(from: 0);

      final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
          Duration(seconds: settings.gameSpeedTimerDuration));
      _quizState = QuizState(
        question: nextQuestion,
        timeRemaining: optimalTimerDuration.inSeconds,
        currentDifficulty: calculatedNewDifficulty,
      );
      _timerManager.startTimer(context: context, reset: true);
      _animationController.triggerTimeAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final size = MediaQuery.of(context).size;
    double width = size.width;

    // If the screen is extremely small, show only the not supported message
    if (width < 260) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context)!.screenSizeNotSupported,
              style: textTheme.bodyLarge?.copyWith(color: colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final settings = Provider.of<SettingsProvider>(context);
    final gameStats = Provider.of<GameStatsProvider>(context);
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final isSmallPhone = context.isSmallPhone;

    // PERFORMANCE OPTIMIZATION: Reduce debug logging frequency
    if (kDebugMode &&
        (_isLoading != _lastLoadingState ||
            gameStats.isLoading != _lastGameStatsLoadingState)) {
      AppLogger.info(
          'QuizScreen build: _isLoading=$_isLoading, gameStats.isLoading=${gameStats.isLoading}');
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
        questionId: _quizState.question.id,
        onSkipPressed: _handleSkip,
        onUnlockPressed: _handleUnlockBiblicalReference,
        onFlagPressed: _handleFlag,
        isDesktop: isDesktop,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content area with question card
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      isDesktop ? 800 : (isTablet ? 600 : double.infinity),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsiveHorizontalPadding(
                        isDesktop ? 32 : (isTablet ? 24 : 16)),
                    vertical: context.responsiveVerticalPadding(20),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Spacer to push content below the overlay metrics
                          SizedBox(height: isDesktop ? 80 : 70),
                          // Question card below metrics with vertical scroll animation
                          Semantics(
                            label: 'Question: ${_quizState.question.question}',
                            child: SlideTransition(
                              position: _verticalSlideAnimation,
                              child: QuestionWidget(
                                question: _quizState.question,
                                selectedAnswerIndex:
                                    _quizState.selectedAnswerIndex,
                                isAnswering: _quizState.isAnswering,
                                isTransitioning: _quizState.isTransitioning,
                                onAnswerSelected: _handleAnswer,
                                language: settings.language,
                                performanceService: _performanceService,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Overlay metrics widget - fixed at top center
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsiveHorizontalPadding(
                        isDesktop ? 32 : (isTablet ? 24 : 16)),
                  ),
                  child: MetricsWidget(
                    scoreAnimation: _animationController.scoreAnimation,
                    streakAnimation: _animationController.streakAnimation,
                    longestStreakAnimation:
                        _animationController.longestStreakAnimation,
                    timeAnimation: _animationController.timeAnimation,
                    timeColorAnimation: _timerManager.timeColorAnimation,
                    previousScore: _previousScore,
                    previousStreak: _previousStreak,
                    previousLongestStreak: _previousLongestStreak,
                    previousTime: _previousTime,
                    isDesktop: isDesktop,
                    isTablet: isTablet,
                    isSmallPhone: isSmallPhone,
                  ),
                ),
              ),
            ),
          ],
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

  Future<void> _completeLessonSession() async {
    // Mark today's streak as active since lesson was completed
    await _markStreakActive();

    // Lesson completion tracking completed
    // Stop any timers
    _timerManager.timeAnimationController.stop();

    final lesson = widget.lesson!;
    final total = widget.sessionLimit ?? _sessionAnswered;
    final correct = _sessionCorrect;
    final bestStreak = _sessionBestStreak;
    final stars =
        LessonProgressProvider().computeStars(correct: correct, total: total);

    // Persist lesson progress - this must happen after await, so use mounted check
    if (!mounted) return;
    final progress =
        Provider.of<LessonProgressProvider>(context, listen: false);
    await progress.markCompleted(
        lesson: lesson, correct: correct, total: total);

    // Trigger sync after lesson completion
    await progress.triggerSync();

    // Show full-screen completion screen - capture context before navigation
    if (!mounted) return;
    final quizContext = context;
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
  Future<void> _handleFlag() async {
    final question = _quizState.question;
    final questionId = question.id;

    try {
      // Report the issue to the Supabase database
      final gameStatsProvider =
          Provider.of<GameStatsProvider>(context, listen: false);
      await AutomaticErrorReporter.reportQuestionError(
        message: 'User reported issue with question',
        userMessage: AppLocalizations.of(context)!.questionReportedByUser,
        questionId: questionId,
        questionText: question.question,
        additionalInfo: {
          'correct_answer': question.correctAnswer,
          'incorrect_answers': question.incorrectAnswers,
          'category': question.category,
          'difficulty': question.difficulty,
          'current_streak': gameStatsProvider.currentStreak,
          'score': gameStatsProvider.score,
        },
      );

      // Show success feedback to user
      if (mounted) {
        showTopSnackBar(
          context,
          AppLocalizations.of(context)!.questionReportedSuccessfully,
          style: TopSnackBarStyle.success,
        );
      }
    } catch (e) {
      // If reporting fails, show error to user
      if (mounted) {
        showTopSnackBar(
          context,
          AppLocalizations.of(context)!.errorReportingQuestion,
          style: TopSnackBarStyle.error,
        );
      }
    }
  }

  Future<void> _handleSkip() async {
    final question = _quizState.question;
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDev = kDebugMode;

    // Fetch the price from the database
    final priceHelper = QuizActionPriceHelper();
    final amount = await priceHelper.getSkipQuestionPrice();

    final success = isDev
        ? true
        : await gameStats.spendStarsWithTransaction(
            amount: amount,
            reason: 'Vraag overslaan',
            metadata: {
              'question_category': question.category,
              'question_difficulty': question.difficulty,
              'time_remaining': _quizState.timeRemaining,
            },
          );
    if (success) {
      _timerManager.timeAnimationController.stop();
      setState(() {
        _quizState = _quizState.copyWith(
          selectedAnswerIndex: null,
          isTransitioning: true,
        );
      });
      await Future.delayed(_performanceService
          .getOptimalAnimationDuration(const Duration(milliseconds: 300)));
      if (!mounted) return;
      final newDifficulty = _quizState.currentDifficulty;
      setState(() {
        // Record that the current question was not answered correctly (since it was skipped)
        _questionSelector.recordAnswerResult(
            _quizState.question.question, false);
        final nextQuestion =
            _questionSelector.pickNextQuestion(newDifficulty, context);
        final optimalTimerDuration =
            _performanceService.getOptimalTimerDuration(
                Duration(seconds: settings.gameSpeedTimerDuration));
        _quizState = QuizState(
          question: nextQuestion,
          timeRemaining: optimalTimerDuration.inSeconds,
          currentDifficulty: newDifficulty,
        );
        _timerManager.startTimer(context: context, reset: true);
        _animationController.triggerTimeAnimation();
      });

    } else {
      if (mounted) {
        showTopSnackBar(
            context, AppLocalizations.of(context)!.notEnoughStarsForSkip,
            style: TopSnackBarStyle.warning);
      }
    }
  }

  Future<void> _handleUnlockBiblicalReference() async {
    final question = _quizState.question;
    final localContext = context;
    final gameStats =
        Provider.of<GameStatsProvider>(localContext, listen: false);
    final isDev = kDebugMode;

    // First check if the reference can be parsed
    final parsed =
        _parseBiblicalReference(_quizState.question.biblicalReference!);
    if (parsed == null) {
      // Report this error automatically since it indicates issues with question data
      await AutomaticErrorReporter.reportBiblicalReferenceError(
        message: 'Could not parse biblical reference',
        userMessage:
            AppLocalizations.of(context)!.invalidBiblicalReferenceInQuestion,
        reference: question.biblicalReference ?? 'null',
        questionId: question.id,
        additionalInfo: {
          'question_id': question.id,
          'question_text': question.question,
        },
      );

      if (mounted) {
        showTopSnackBar(
            context, AppLocalizations.of(context)!.invalidBiblicalReference,
            style: TopSnackBarStyle.error);
      }
      return;
    }

    // Fetch the price from the database
    final priceHelper = QuizActionPriceHelper();
    final amount = await priceHelper.getUnlockBiblicalReferencePrice();

    // Spend stars for unlocking the biblical reference (free in debug mode)
    final success = isDev
        ? true
        : await gameStats.spendStarsWithTransaction(
            amount: amount,
            reason: 'Bijbelse referentie ontgrendelen',
            metadata: {
              'question_category': question.category,
              'question_difficulty': question.difficulty,
              'biblical_reference': question.biblicalReference ?? 'none',
              'time_remaining': _quizState.timeRemaining,
            },
          );
    if (success) {
      // Pause the timer
      if (mounted) {
        _timerManager.pauseTimer();
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
              _timerManager.resumeTimer();
            }
          });
        }
      });

    } else {
      // Not enough stars - this is a user state issue, not an error to report automatically
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showTopSnackBar(context, AppLocalizations.of(context)!.notEnoughStars,
              style: TopSnackBarStyle.warning);
        }
      });
    }
  }
}
