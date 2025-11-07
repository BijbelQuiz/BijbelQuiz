import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../models/quiz_question.dart';
import '../models/quiz_state.dart';
import '../services/sound_service.dart';
import '../services/question_cache_service.dart';
import '../services/performance_service.dart';
import '../services/connection_service.dart';
import '../services/platform_feedback_service.dart';
import '../providers/settings_provider.dart';
import '../providers/game_stats_provider.dart';
import '../services/analytics_service.dart';
import '../services/quiz_timer_manager.dart';
import '../services/quiz_animation_controller.dart';
import '../services/progressive_question_selector.dart';
import '../services/quiz_answer_handler.dart';
import '../widgets/quiz_error_display.dart';
import '../error/error_handler.dart';
import '../error/error_types.dart';
import '../widgets/quiz_bottom_bar.dart';
import '../widgets/question_widget.dart';
import '../widgets/quiz_skeleton.dart';
import '../widgets/top_snackbar.dart';
import '../l10n/strings_nl.dart' as strings;
import '../services/logger.dart';
import '../widgets/biblical_reference_dialog.dart';
import '../utils/automatic_error_reporter.dart';

/// Multiplayer quiz screen with split-screen layout
class MultiplayerQuizScreen extends StatefulWidget {
  final int gameDurationMinutes;

  const MultiplayerQuizScreen({
    super.key,
    required this.gameDurationMinutes,
  });

  @override
  State<MultiplayerQuizScreen> createState() => _MultiplayerQuizScreenState();
}

class _MultiplayerQuizScreenState extends State<MultiplayerQuizScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Game state
  bool _isLoading = true;
  String? _error;
  late Timer _gameTimer;
  int _gameTimeRemaining = 0; // in seconds
  bool _gameEnded = false;
  bool _showResults = false;

  // Player scores
  int _player1Score = 0;
  int _player2Score = 0;

  // Independent quiz states for both players
  late QuizState _player1QuizState;
  late QuizState _player2QuizState;

  // Separate question selectors for each player
  late ProgressiveQuestionSelector _player1QuestionSelector;
  late ProgressiveQuestionSelector _player2QuestionSelector;

  // Separate timers for each player
  late QuizTimerManager _player1TimerManager;
  late QuizTimerManager _player2TimerManager;

  // Separate animation controllers for each player
  late QuizAnimationController _player1AnimationController;
  late QuizAnimationController _player2AnimationController;

  // Services
  late QuestionCacheService _questionCacheService;
  late PerformanceService _performanceService;
  late ConnectionService _connectionService;
  late PlatformFeedbackService _platformFeedbackService;
  final SoundService _soundService = SoundService();

  // Keyboard focus for desktop key handling
  late FocusNode _keyboardFocusNode;

  // Managers
  late QuizAnswerHandler _answerHandler;

  @override
  void initState() {
    super.initState();

    // Force landscape orientation for multiplayer split-screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

    // Track screen view
    analyticsService.screen(context, 'MultiplayerQuizScreen');
    analyticsService.capture(context, 'multiplayer_game_started', properties: {
      'duration_minutes': widget.gameDurationMinutes,
    });

    WidgetsBinding.instance.addObserver(this);
    AppLogger.info('MultiplayerQuizScreen loaded');

    // Initialize keyboard focus node
    _keyboardFocusNode = FocusNode();

    // Initialize game timer
    _gameTimeRemaining = widget.gameDurationMinutes * 60;
    _startGameTimer();

    // Initialize services
    _questionCacheService = QuestionCacheService();
    _performanceService = PerformanceService();
    _connectionService = ConnectionService();
    _platformFeedbackService = PlatformFeedbackService();

    _initializeServices();
    _initializeManagers();
    _initializeQuiz();

    // Attach error handler for sound service
    _soundService.onError = (message) {
      if (mounted) {
        showTopSnackBar(context, message, style: TopSnackBarStyle.error);
      }
    };
  }

  void _startGameTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _gameTimeRemaining--;
        if (_gameTimeRemaining <= 0) {
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    _gameTimer.cancel();
    _gameEnded = true;
    _showResults = true;

    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    analyticsService.capture(context, 'multiplayer_game_ended', properties: {
      'duration_minutes': widget.gameDurationMinutes,
      'player1_score': _player1Score,
      'player2_score': _player2Score,
      'winner': _player1Score > _player2Score ? 'player1' : (_player2Score > _player1Score ? 'player2' : 'tie'),
    });

    // Update UI to show results instead of dialog
    setState(() {});
  }


  Future<void> _initializeServices() async {
    try {
      await Future.wait([
        _performanceService.initialize(),
        _connectionService.initialize(),
        _platformFeedbackService.initialize(),
        _soundService.initialize(),
      ]);
      AppLogger.info('MultiplayerQuizScreen services initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize services in MultiplayerQuizScreen', e);
    }
  }

  void _initializeManagers() {
    // Player 1 managers
    _player1TimerManager = QuizTimerManager(
      performanceService: _performanceService,
      vsync: this,
      onTimeTick: () => _onPlayer1TimeTick(),
      onTimeUp: _showPlayer1TimeUpDialog,
    );

    _player1AnimationController = QuizAnimationController(
      performanceService: _performanceService,
      vsync: this,
    );

    _player1QuestionSelector = ProgressiveQuestionSelector(
      questionCacheService: _questionCacheService,
    );
    _player1QuestionSelector.setStateCallback(setState);
    _player1QuestionSelector.setMounted(mounted);

    // Player 2 managers
    _player2TimerManager = QuizTimerManager(
      performanceService: _performanceService,
      vsync: this,
      onTimeTick: () => _onPlayer2TimeTick(),
      onTimeUp: _showPlayer2TimeUpDialog,
    );

    _player2AnimationController = QuizAnimationController(
      performanceService: _performanceService,
      vsync: this,
    );

    _player2QuestionSelector = ProgressiveQuestionSelector(
      questionCacheService: _questionCacheService,
    );
    _player2QuestionSelector.setStateCallback(setState);
    _player2QuestionSelector.setMounted(mounted);

    _answerHandler = QuizAnswerHandler(
      soundService: _soundService,
      platformFeedbackService: _platformFeedbackService,
      enableSounds: false,
    );
  }

  Future<void> _initializeQuiz() async {
    final initStartTime = DateTime.now();
    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final language = settings.language;

      // Load questions for both players
      if (!_player1QuestionSelector.allQuestionsLoaded) {
        _player1QuestionSelector.allQuestions = await _questionCacheService.getQuestions(
          language,
          startIndex: 0,
        );
        _player1QuestionSelector.allQuestions.shuffle();
        _player1QuestionSelector.allQuestionsLoaded = true;
      }

      if (!_player2QuestionSelector.allQuestionsLoaded) {
        _player2QuestionSelector.allQuestions = await _questionCacheService.getQuestions(
          language,
          startIndex: 0,
        );
        _player2QuestionSelector.allQuestions.shuffle();
        _player2QuestionSelector.allQuestionsLoaded = true;
      }

      if (_player1QuestionSelector.allQuestions.isEmpty || _player2QuestionSelector.allQuestions.isEmpty) {
        throw Exception(strings.AppStrings.errorNoQuestions);
      }

      if (!mounted) return;

      // Initialize both players with different questions
      final QuizQuestion player1FirstQuestion = _player1QuestionSelector.pickNextQuestion(0.0, context);
      final QuizQuestion player2FirstQuestion = _player2QuestionSelector.pickNextQuestion(0.0, context);

      _player1QuizState = QuizState(
        question: player1FirstQuestion,
        timeRemaining: 20,
        currentDifficulty: 0.0,
      );

      _player2QuizState = QuizState(
        question: player2FirstQuestion,
        timeRemaining: 20,
        currentDifficulty: 0.0,
      );

      // Start timers for both players
      if (!mounted) return;
      _player1TimerManager.startTimer(context: context, reset: true);
      _player1AnimationController.triggerTimeAnimation();

      _player2TimerManager.startTimer(context: context, reset: true);
      _player2AnimationController.triggerTimeAnimation();

    } catch (e) {
      if (!mounted) return;
      
      // Use the new error handling system
      final appError = ErrorHandler().fromException(
        e,
        type: AppErrorType.dataLoading,
        userMessage: strings.AppStrings.errorLoadQuestions,
        context: {
          'error_type': e.runtimeType.toString(),
        },
      );
      
      setState(() {
        _error = appError.userMessage;
      });

      final analytics = Provider.of<AnalyticsService>(context, listen: false);
      analytics.capture(context, 'multiplayer_quiz_loading_error', properties: {
        'error_type': e.runtimeType.toString(),
        'error_message': e.toString(),
      });

      // The error is now logged by the ErrorHandler, but we can add additional logging if needed
      AppLogger.error('Failed to load questions in MultiplayerQuizScreen', e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Player 1 timer tick
  void _onPlayer1TimeTick() {
    if (!mounted) return;
    final duration = _player1TimerManager.timeAnimationController.duration;
    if (duration == null) return;

    final elapsedMs = (_player1TimerManager.timeAnimationController.value * duration.inMilliseconds)
        .clamp(0.0, duration.inMilliseconds.toDouble())
        .toInt();
    final remainingMs = duration.inMilliseconds - elapsedMs;
    final remainingSeconds = (remainingMs / 1000).ceil();

    if (remainingSeconds != _player1QuizState.timeRemaining) {
      setState(() {
        _player1QuizState = _player1QuizState.copyWith(timeRemaining: remainingSeconds);
      });

      // Trigger animation when time reaches critical threshold (5 seconds)
      if (remainingSeconds == 5) {
        _player1AnimationController.triggerTimeAnimation();
      }
    }
  }

  // Player 2 timer tick
  void _onPlayer2TimeTick() {
    if (!mounted) return;
    final duration = _player2TimerManager.timeAnimationController.duration;
    if (duration == null) return;

    final elapsedMs = (_player2TimerManager.timeAnimationController.value * duration.inMilliseconds)
        .clamp(0.0, duration.inMilliseconds.toDouble())
        .toInt();
    final remainingMs = duration.inMilliseconds - elapsedMs;
    final remainingSeconds = (remainingMs / 1000).ceil();

    if (remainingSeconds != _player2QuizState.timeRemaining) {
      setState(() {
        _player2QuizState = _player2QuizState.copyWith(timeRemaining: remainingSeconds);
      });

      // Trigger animation when time reaches critical threshold (5 seconds)
      if (remainingSeconds == 5) {
        _player2AnimationController.triggerTimeAnimation();
      }
    }
  }

  // Player 1 time up dialog
  Future<void> _showPlayer1TimeUpDialog() async {
    _handlePlayer1NextQuestion(false, _player1QuizState.currentDifficulty);
  }

  // Player 2 time up dialog
  Future<void> _showPlayer2TimeUpDialog() async {
    _handlePlayer2NextQuestion(false, _player2QuizState.currentDifficulty);
  }

  // Player 1 next question handler
  Future<void> _handlePlayer1NextQuestion(bool isCorrect, double newDifficulty) async {
    // Update score
    if (isCorrect) {
      _player1Score++;
    }

    // Move to next question for player 1
    setState(() {
      _player1QuizState = _player1QuizState.copyWith(
        selectedAnswerIndex: null,
        isTransitioning: true,
      );
    });

    await Future.delayed(_platformFeedbackService.getTransitionPauseDuration());
    if (!mounted) return;

    // Record answer result for player 1
    _player1QuestionSelector.recordAnswerResult(_player1QuizState.question.question, isCorrect);

    // Calculate new difficulty for player 1
    final calculatedNewDifficulty = _player1QuestionSelector.calculateNextDifficulty(
      currentDifficulty: _player1QuizState.currentDifficulty,
      isCorrect: isCorrect,
      streak: _player1Score,
      timeRemaining: _player1QuizState.timeRemaining,
      totalQuestions: _player1Score,
      correctAnswers: _player1Score,
      incorrectAnswers: 0,
      context: context,
    );

    // Get next question for player 1
    final QuizQuestion nextQuestion = _player1QuestionSelector.pickNextQuestion(calculatedNewDifficulty, context);
    setState(() {
      _player1QuizState = QuizState(
        question: nextQuestion,
        timeRemaining: 20,
        currentDifficulty: calculatedNewDifficulty,
      );
      _player1TimerManager.startTimer(context: context, reset: true);
      _player1AnimationController.triggerTimeAnimation();
    });
  }

  // Player 2 next question handler
  Future<void> _handlePlayer2NextQuestion(bool isCorrect, double newDifficulty) async {
    // Update score
    if (isCorrect) {
      _player2Score++;
    }

    // Move to next question for player 2
    setState(() {
      _player2QuizState = _player2QuizState.copyWith(
        selectedAnswerIndex: null,
        isTransitioning: true,
      );
    });

    await Future.delayed(_platformFeedbackService.getTransitionPauseDuration());
    if (!mounted) return;

    // Record answer result for player 2
    _player2QuestionSelector.recordAnswerResult(_player2QuizState.question.question, isCorrect);

    // Calculate new difficulty for player 2
    final calculatedNewDifficulty = _player2QuestionSelector.calculateNextDifficulty(
      currentDifficulty: _player2QuizState.currentDifficulty,
      isCorrect: isCorrect,
      streak: _player2Score,
      timeRemaining: _player2QuizState.timeRemaining,
      totalQuestions: _player2Score,
      correctAnswers: _player2Score,
      incorrectAnswers: 0,
      context: context,
    );

    // Get next question for player 2
    final QuizQuestion nextQuestion = _player2QuestionSelector.pickNextQuestion(calculatedNewDifficulty, context);
    setState(() {
      _player2QuizState = QuizState(
        question: nextQuestion,
        timeRemaining: 20,
        currentDifficulty: calculatedNewDifficulty,
      );
      _player2TimerManager.startTimer(context: context, reset: true);
      _player2AnimationController.triggerTimeAnimation();
    });
  }

  void _handleAnswer(int selectedIndex, bool isPlayer1) {
    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

    if (isPlayer1) {
      _answerHandler.handleAnswer(
        selectedIndex: selectedIndex,
        quizState: _player1QuizState,
        updateQuizState: (newState) {
          setState(() {
            _player1QuizState = newState;
          });
        },
        handleNextQuestion: (isCorrect, difficulty) => _handlePlayer1NextQuestion(isCorrect, difficulty),
        context: context,
      );
    } else {
      _answerHandler.handleAnswer(
        selectedIndex: selectedIndex,
        quizState: _player2QuizState,
        updateQuizState: (newState) {
          setState(() {
            _player2QuizState = newState;
          });
        },
        handleNextQuestion: (isCorrect, difficulty) => _handlePlayer2NextQuestion(isCorrect, difficulty),
        context: context,
      );
    }
  }


  @override
  void dispose() {
    // Dispose player 1 managers
    _player1QuestionSelector.setMounted(false);
    _player1TimerManager.dispose();
    _player1AnimationController.dispose();

    // Dispose player 2 managers
    _player2QuestionSelector.setMounted(false);
    _player2TimerManager.dispose();
    _player2AnimationController.dispose();

    // Dispose services
    _performanceService.dispose();
    _connectionService.dispose();
    _soundService.dispose();

    _gameTimer.cancel();
    WidgetsBinding.instance.removeObserver(this);

    // Dispose keyboard focus node
    _keyboardFocusNode.dispose();

    // Reset orientation preferences
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _player1TimerManager.handleAppLifecycleState(state, context);
    _player2TimerManager.handleAppLifecycleState(state, context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: const Center(
          child: QuizSkeleton(
            isDesktop: false,
            isTablet: false,
            isSmallPhone: false,
            metricsCount: 2,
            answerCount: 4,
            questionType: 'mc',
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
      body: SafeArea(
        child: RawKeyboardListener(
          focusNode: _keyboardFocusNode..requestFocus(),
          onKey: (RawKeyEvent event) {
            // Only handle on desktop platforms
            if (defaultTargetPlatform == TargetPlatform.windows ||
                defaultTargetPlatform == TargetPlatform.macOS ||
                defaultTargetPlatform == TargetPlatform.linux) {
              if (event is RawKeyDownEvent) {
                final key = event.logicalKey;
                int? answerIndex;
                bool? isPlayer1;
                if ([LogicalKeyboardKey.keyA, LogicalKeyboardKey.keyS, LogicalKeyboardKey.keyD, LogicalKeyboardKey.keyF].contains(key)) {
                  isPlayer1 = true;
                  if (key == LogicalKeyboardKey.keyA) {
                    answerIndex = 0;
                  } else if (key == LogicalKeyboardKey.keyS) answerIndex = 1;
                  else if (key == LogicalKeyboardKey.keyD) answerIndex = 2;
                  else if (key == LogicalKeyboardKey.keyF) answerIndex = 3;
                } else if ([LogicalKeyboardKey.keyH, LogicalKeyboardKey.keyJ, LogicalKeyboardKey.keyK, LogicalKeyboardKey.keyL].contains(key)) {
                  isPlayer1 = false;
                  if (key == LogicalKeyboardKey.keyH) {
                    answerIndex = 0;
                  } else if (key == LogicalKeyboardKey.keyJ) answerIndex = 1;
                  else if (key == LogicalKeyboardKey.keyK) answerIndex = 2;
                  else if (key == LogicalKeyboardKey.keyL) answerIndex = 3;
                }
                if (answerIndex != null && isPlayer1 != null) {
                  _handleAnswer(answerIndex, isPlayer1);
                }
              }
            }
          },
          child: Column(
            children: [
              // Split screen layout with individual bottom bars
              Expanded(
                child: Row(
                  children: [
                    // Left half - Player 1 (normal orientation) with its own bottom bar
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _buildScrollablePlayerArea(
                              context,
                              isPlayer1: true,
                              playerName: 'Speler 1',
                            ),
                          ),
                          QuizBottomBar(
                            quizState: _player1QuizState,
                            gameStats: Provider.of<GameStatsProvider>(context),
                            settings: Provider.of<SettingsProvider>(context),
                            questionId: _player1QuizState.question.id,
                            onSkipPressed: () => _handleSkipForPlayer(true),
                            onUnlockPressed: () => _handleUnlockBiblicalReferenceForPlayer(true),
                            onFlagPressed: () => _handleFlagForPlayer(true),
                            isDesktop: false, // This is a mobile app screen
                          ),
                        ],
                      ),
                    ),

                    // Divider - subtle and full height
                    Container(
                      width: 1,
                      color: colorScheme.outline,
                      margin: EdgeInsets.zero,
                    ),

                    // Right half - Player 2 (normal orientation) with its own bottom bar
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _buildScrollablePlayerArea(
                              context,
                              isPlayer1: false,
                              playerName: 'Speler 2',
                            ),
                          ),
                          QuizBottomBar(
                            quizState: _player2QuizState,
                            gameStats: Provider.of<GameStatsProvider>(context),
                            settings: Provider.of<SettingsProvider>(context),
                            questionId: _player2QuizState.question.id,
                            onSkipPressed: () => _handleSkipForPlayer(false),
                            onUnlockPressed: () => _handleUnlockBiblicalReferenceForPlayer(false),
                            onFlagPressed: () => _handleFlagForPlayer(false),
                            isDesktop: false, // This is a mobile app screen
                          ),
                        ],
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

  Widget _buildScrollablePlayerArea(BuildContext context, {required bool isPlayer1, required String playerName}) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = Provider.of<SettingsProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    // Determine winner
    String? winner;
    if (_player1Score > _player2Score) {
      winner = 'player1';
    } else if (_player2Score > _player1Score) {
      winner = 'player2';
    } else {
      winner = 'tie';
    }

    final isWinner = winner == 'player1' && isPlayer1 || winner == 'player2' && !isPlayer1;
    final isTie = winner == 'tie';

    // Check if we're on a mobile device
    bool isMobile = !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || 
                                defaultTargetPlatform == TargetPlatform.iOS);

    // Wrap Player 2 area with rotation on mobile devices
    Widget playerContent = Container(
      color: _showResults ? (isWinner ? colorScheme.primary : colorScheme.surface) : colorScheme.surface,
      child: Column(
        children: [
          // Show results or question based on game state
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Transform.scale(
                scale: 0.85, // Scale down the entire content to reduce scrolling
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 4 : 8),
                  child: _showResults
                      ? Center(
                          child: _buildResultsWidget(context, isPlayer1, isWinner, isTie),
                        )
                      : QuestionWidget(
                          question: isPlayer1 ? _player1QuizState.question : _player2QuizState.question,
                          selectedAnswerIndex: isPlayer1 ? _player1QuizState.selectedAnswerIndex : _player2QuizState.selectedAnswerIndex,
                          isAnswering: isPlayer1 ? _player1QuizState.isAnswering : _player2QuizState.isAnswering,
                          isTransitioning: isPlayer1 ? _player1QuizState.isTransitioning : _player2QuizState.isTransitioning,
                          onAnswerSelected: (index) => _handleAnswer(index, isPlayer1),
                          language: settings.language,
                          performanceService: _performanceService,
                          isCompact: true,
                          customLetters: isMobile ? ['A', 'B', 'C', 'D'] : (isPlayer1 ? ['A', 'S', 'D', 'F'] : ['H', 'J', 'K', 'L']),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Apply rotation for Player 2 on mobile devices
    if (isMobile && !isPlayer1) {
      playerContent = Transform.rotate(
        angle: 3.14159, // 180 degrees in radians
        child: playerContent,
      );
    }

    return playerContent;
  }


  Widget _buildResultsWidget(BuildContext context, bool isPlayer1, bool isWinner, bool isTie) {
    final colorScheme = Theme.of(context).colorScheme;
    final score = isPlayer1 ? _player1Score : _player2Score;
    final playerName = isPlayer1 ? 'Speler 1' : 'Speler 2';

    String statusText;
    if (isTie) {
      statusText = 'Gelijkspel!';
    } else if (isWinner) {
      statusText = 'Gewonnen!';
    } else {
      statusText = 'Verloren!';
    }

    final textColor = isWinner ? Colors.white : colorScheme.onSurface;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          statusText,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Punten: $score',
          style: TextStyle(
            fontSize: 24,
            color: textColor,
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Go back to setup screen
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isWinner ? Colors.white : colorScheme.primary,
            foregroundColor: isWinner ? colorScheme.primary : Colors.white,
          ),
          child: const Text('Nieuw spel'),
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

  // Player-specific handler methods
  Future<void> _handleSkipForPlayer(bool isPlayer1) async {
    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    final QuizState quizState = isPlayer1 ? _player1QuizState : _player2QuizState;
    final ProgressiveQuestionSelector questionSelector = isPlayer1 ? _player1QuestionSelector : _player2QuestionSelector;
    final QuizTimerManager timerManager = isPlayer1 ? _player1TimerManager : _player2TimerManager;
    final QuizAnimationController animationController = isPlayer1 ? _player1AnimationController : _player2AnimationController;
    final String playerName = isPlayer1 ? 'Player1' : 'Player2';

    // Track skip feature usage
    analyticsService.trackFeatureAttempt(context, AnalyticsService.FEATURE_SKIP_QUESTION, additionalProperties: {
      'question_category': quizState.question.category,
      'question_difficulty': quizState.question.difficulty,
      'time_remaining': quizState.timeRemaining,
      'player': playerName,
    });

    Provider.of<AnalyticsService>(context, listen: false).capture(context, 'skip_question_$playerName');
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDev = kDebugMode;

    final success = isDev ? true : await gameStats.spendStarsWithTransaction(
      amount: 35,
      reason: 'Vraag overslaan',
      metadata: {
        'question_category': quizState.question.category,
        'question_difficulty': quizState.question.difficulty,
        'time_remaining': quizState.timeRemaining,
        'player': playerName,
      },
    );
    
    if (success) {
      // Stop the appropriate player's timer
      timerManager.timeAnimationController.stop();
      
      setState(() {
        if (isPlayer1) {
          _player1QuizState = _player1QuizState.copyWith(
            selectedAnswerIndex: null,
            isTransitioning: true,
          );
        } else {
          _player2QuizState = _player2QuizState.copyWith(
            selectedAnswerIndex: null,
            isTransitioning: true,
          );
        }
      });
      
      await Future.delayed(_performanceService.getOptimalAnimationDuration(const Duration(milliseconds: 300)));
      if (!mounted) return;
      
      setState(() {
        // Record that the current question was not answered correctly (since it was skipped)
        questionSelector.recordAnswerResult(quizState.question.question, false);
        final nextQuestion = questionSelector.pickNextQuestion(quizState.currentDifficulty, context);
        
        if (isPlayer1) {
          _player1QuizState = QuizState(
            question: nextQuestion,
            timeRemaining: 20, // Default timer
            currentDifficulty: quizState.currentDifficulty,
          );
          
          // Restart timer for player 1
          _player1TimerManager.startTimer(context: context, reset: true);
          _player1AnimationController.triggerTimeAnimation();
        } else {
          _player2QuizState = QuizState(
            question: nextQuestion,
            timeRemaining: 20, // Default timer
            currentDifficulty: quizState.currentDifficulty,
          );
          
          // Restart timer for player 2
          _player2TimerManager.startTimer(context: context, reset: true);
          _player2AnimationController.triggerTimeAnimation();
        }
      });
    } else {
      if (mounted) {
        showTopSnackBar(context, strings.AppStrings.notEnoughStarsForSkip, style: TopSnackBarStyle.warning);
      }
    }
  }

  Future<void> _handleUnlockBiblicalReferenceForPlayer(bool isPlayer1) async {
    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    final QuizState quizState = isPlayer1 ? _player1QuizState : _player2QuizState;
    final QuizTimerManager timerManager = isPlayer1 ? _player1TimerManager : _player2TimerManager;
    final String playerName = isPlayer1 ? 'Player1' : 'Player2';

    // Track biblical reference unlock attempt
    analyticsService.trackFeatureAttempt(context, AnalyticsService.FEATURE_BIBLICAL_REFERENCES, additionalProperties: {
      'question_category': quizState.question.category,
      'question_difficulty': quizState.question.difficulty,
      'biblical_reference': quizState.question.biblicalReference ?? 'none',
      'time_remaining': quizState.timeRemaining,
      'player': playerName,
    });

    final localContext = context;
    final gameStats = Provider.of<GameStatsProvider>(localContext, listen: false);
    final isDev = kDebugMode;

    // First check if the reference can be parsed
    final parsed = _parseBiblicalReference(quizState.question.biblicalReference!);
    if (parsed == null) {
      // Report this error automatically since it indicates issues with question data
      await AutomaticErrorReporter.reportBiblicalReferenceError(
        message: 'Could not parse biblical reference',
        userMessage: 'Invalid biblical reference in question',
        reference: quizState.question.biblicalReference ?? 'null',
        questionId: quizState.question.id,
        additionalInfo: {
          'question_id': quizState.question.id,
          'question_text': quizState.question.question,
          'player': playerName,
        },
      );
      
      if (mounted) {
        showTopSnackBar(localContext, strings.AppStrings.invalidBiblicalReference, style: TopSnackBarStyle.error);
      }
      return;
    }

    // Spend 10 stars for unlocking the biblical reference (free in debug mode)
    final success = isDev ? true : await gameStats.spendStarsWithTransaction(
      amount: 10,
      reason: 'Bijbelse referentie ontgrendelen',
      metadata: {
        'question_category': quizState.question.category,
        'question_difficulty': quizState.question.difficulty,
        'biblical_reference': quizState.question.biblicalReference ?? 'none',
        'time_remaining': quizState.timeRemaining,
        'player': playerName,
      },
    );
    if (success) {
      // Pause the appropriate player's timer
      if (mounted) {
        timerManager.pauseTimer();
      }

      // Show the biblical reference dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showDialog(
            context: localContext,
            builder: (BuildContext context) {
              return BiblicalReferenceDialog(
                reference: quizState.question.biblicalReference!,
              );
            },
          ).then((_) {
            // Resume the timer when dialog is closed
            if (mounted) {
              timerManager.resumeTimer();
            }
          });
        }
      });
    } else {
      // Not enough stars - this is a user state issue, not an error to report automatically
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showTopSnackBar(localContext, strings.AppStrings.notEnoughStars, style: TopSnackBarStyle.warning);
        }
      });
    }
  }

  Future<void> _handleFlagForPlayer(bool isPlayer1) async {
    final QuizState quizState = isPlayer1 ? _player1QuizState : _player2QuizState;
    final questionId = quizState.question.id;
    final String playerName = isPlayer1 ? 'Player1' : 'Player2';
    
    try {
      // Report the issue to the tracking service
      final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
      await AutomaticErrorReporter.reportQuestionError(
        message: 'User reported issue with question',
        userMessage: 'Question reported by user',
        questionId: questionId,
        questionText: quizState.question.question,
        additionalInfo: {
          'correct_answer': quizState.question.correctAnswer,
          'incorrect_answers': quizState.question.incorrectAnswers,
          'category': quizState.question.category,
          'difficulty': quizState.question.difficulty,
          'current_streak': gameStatsProvider.currentStreak,
          'score': gameStatsProvider.score,
          'player': playerName,
        },
      );

      // Show success feedback to user
      if (mounted) {
        showTopSnackBar(
          context,
          strings.AppStrings.questionReportedSuccessfully,
          style: TopSnackBarStyle.success,
        );
      }
    } catch (e) {
      // If reporting fails, show error to user
      if (mounted) {
        showTopSnackBar(
          context,
          strings.AppStrings.errorReportingQuestion,
          style: TopSnackBarStyle.error,
        );
      }
    }
  }
}