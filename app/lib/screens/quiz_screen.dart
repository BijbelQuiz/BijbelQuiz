import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
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
import '../utils/responsive_utils.dart';
import '../widgets/common_widgets.dart';
import 'dart:async';
import '../services/logger.dart';
import 'dart:math';
import '../widgets/quiz_skeleton.dart';
import '../widgets/top_snackbar.dart';
import '../l10n/strings_nl.dart' as strings;

// New extracted services
import '../services/quiz_timer_manager.dart';
import '../services/quiz_animation_controller.dart';
import '../services/progressive_question_selector.dart';
import '../services/quiz_answer_handler.dart';

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
  

  // Lesson session mode (cap session to N questions with completion screen)
  bool get _lessonMode => widget.lesson != null && widget.sessionLimit != null;
  int _sessionAnswered = 0;
  int _sessionCorrect = 0;
  int _sessionCurrentStreakLocal = 0;
  int _sessionBestStreak = 0;
  
  
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

  // New extracted managers
  late QuizTimerManager _timerManager;
  late QuizAnimationController _animationController;
  late ProgressiveQuestionSelector _questionSelector;
  late QuizAnswerHandler _answerHandler;

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
    _initializeManagers();
    _initializeQuiz();
    
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
      if (_questionSelector.allQuestionsLoaded && _questionSelector.usedQuestions.isNotEmpty) {
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
    // Update question selector mounted state
    _questionSelector.setMounted(false);

    // Dispose new managers
    _timerManager.dispose();
    _animationController.dispose();

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

    final elapsedMs = (_timerManager.timeAnimationController.value * duration.inMilliseconds)
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
                            _timerManager.startTimer(context: context, reset: true);
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
                _handleNextQuestion(false, _quizState.currentDifficulty);
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
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final language = settings.language;

      // Load questions - if in lesson mode with a specific category, load category questions
      // Otherwise load questions in batches for better performance
      if (!_questionSelector.allQuestionsLoaded) {
        if (_lessonMode && widget.lesson?.category != null && widget.lesson!.category != 'Algemeen') {
          // Load questions for specific category
          _questionSelector.allQuestions = await _questionCacheService.getQuestionsByCategory(
            language,
            widget.lesson!.category
          );
          AppLogger.info('Loaded category questions for language: $language, category: ${widget.lesson!.category}, count: ${_questionSelector.allQuestions.length}');
        } else {
          // PERFORMANCE OPTIMIZATION: Load questions in smaller batches instead of all at once
          // Start with a reasonable batch size for initial gameplay
          const int initialBatchSize = 100; // Load first 100 questions for immediate play
          _questionSelector.allQuestions = await _questionCacheService.getQuestions(
            language,
            startIndex: 0,
            count: initialBatchSize
          );
          AppLogger.info('Loaded initial batch of questions for language: $language, count: ${_questionSelector.allQuestions.length}');
        }
        _questionSelector.allQuestions.shuffle(Random());
        _questionSelector.allQuestionsLoaded = true;
      }

      if (_questionSelector.allQuestions.isEmpty) {
        throw Exception(strings.AppStrings.errorNoQuestions);
      }

      // Initialize quiz state with PQU (Progressive Question Up-selection)
      final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
        Duration(seconds: settings.slowMode ? 35 : 20)
      );

      final firstQuestion = _questionSelector.pickNextQuestion(0.0, context);
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
      _timerManager.startTimer(context: context, reset: true);
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
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    // Update game stats first
    await gameStats.updateStats(isCorrect: isCorrect);
    // Trigger animations for stats updates
    _animationController.triggerAllStatsAnimations();

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
    final calculatedNewDifficulty = _questionSelector.calculateNextDifficulty(
      currentDifficulty: _quizState.currentDifficulty,
      isCorrect: isCorrect,
      streak: gameStats.currentStreak,
      timeRemaining: _quizState.timeRemaining,
      totalQuestions: gameStats.score + gameStats.incorrectAnswers,
      correctAnswers: gameStats.score,
      incorrectAnswers: gameStats.incorrectAnswers,
    );
    setState(() {
      final nextQuestion = _questionSelector.pickNextQuestion(calculatedNewDifficulty, context);
      final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
        Duration(seconds: settings.slowMode ? 35 : 20)
      );
      _quizState = QuizState(
        question: nextQuestion,
        timeRemaining: optimalTimerDuration.inSeconds,
        currentDifficulty: calculatedNewDifficulty,
      );
      _timerManager.startTimer(context: context, reset: true);
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
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final isSmallPhone = context.isSmallPhone;

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
                horizontal: context.responsiveHorizontalPadding(isDesktop ? 32 : (isTablet ? 24 : 16)),
                vertical: context.responsiveVerticalPadding(20),
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
                        scoreAnimation: _animationController.scoreAnimation,
                        streakAnimation: _animationController.streakAnimation,
                        longestStreakAnimation: _animationController.longestStreakAnimation,
                        timeAnimation: _timerManager.timeAnimation,
                        timeColorAnimation: _timerManager.timeColorAnimation,
                        previousScore: _previousScore,
                        previousStreak: _previousStreak,
                        previousLongestStreak: _previousLongestStreak,
                        previousTime: _previousTime,
                        isDesktop: isDesktop,
                        isTablet: isTablet,
                        isSmallPhone: isSmallPhone,
                      ),
                      ResponsiveSizedBox(height: isDesktop ? 24 : 20),
                      // Question card below metrics
                      QuestionWidget(
                        question: _quizState.question,
                        selectedAnswerIndex: _quizState.selectedAnswerIndex,
                        isAnswering: _quizState.isAnswering,
                        isTransitioning: _quizState.isTransitioning,
                        onAnswerSelected: _handleAnswer,
                        language: settings.language,
                        performanceService: _performanceService,
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
 


  Future<void> _completeLessonSession() async {
    // Stop any timers
    _timerManager.timeAnimationController.stop();

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
      _timerManager.timeAnimationController.stop();
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
        final nextQuestion = _questionSelector.pickNextQuestion(newDifficulty, context);
        final optimalTimerDuration = _performanceService.getOptimalTimerDuration(
          Duration(seconds: settings.slowMode ? 35 : 20)
        );
        _quizState = QuizState(
          question: nextQuestion,
          timeRemaining: optimalTimerDuration.inSeconds,
          currentDifficulty: newDifficulty,
        );
        _timerManager.startTimer(context: context, reset: true);
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
      // Not enough stars
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showTopSnackBar(localContext, strings.AppStrings.notEnoughStars, style: TopSnackBarStyle.warning);
        }
      });
    }
  }
}

