import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:xml/xml.dart' as xml;
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
import '../constants/urls.dart';
import '../utils/bible_book_mapper.dart';
import '../services/logger.dart';
import '../utils/quiz_action_price_helper.dart';

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

  bool _showResults = false;

  // Biblical reference overlay state
  bool _player1ShowingBiblicalReference = false;
  bool _player2ShowingBiblicalReference = false;
  String? _player1BiblicalReference;
  String? _player2BiblicalReference;

  // Biblical reference content state
  bool _player1BiblicalLoading = false;
  bool _player2BiblicalLoading = false;
  String _player1BiblicalContent = '';
  String _player2BiblicalContent = '';
  String _player1BiblicalError = '';
  String _player2BiblicalError = '';

  // HTTP client for biblical reference
  final http.Client _biblicalClient = http.Client();

  // Player scores
  int _player1Score = 0;
  int _player2Score = 0;

  // Independent quiz states for both players
  late QuizState _player1QuizState;
  late QuizState _player2QuizState;

  // Separate question selectors for each player
  late ProgressiveQuestionSelector _player1QuestionSelector;
  late ProgressiveQuestionSelector _player2QuestionSelector;

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

  // Race condition prevention flags
  bool _player1IsProcessingAnswer = false;
  bool _player2IsProcessingAnswer = false;
  bool _gameEndInProgress = false;

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

    final analyticsService =
        Provider.of<AnalyticsService>(context, listen: false);

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
    _performanceService = PerformanceService();
    _connectionService = ConnectionService();
    _platformFeedbackService = PlatformFeedbackService();
    _questionCacheService = QuestionCacheService(_connectionService);

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
    // Prevent multiple game end calls
    if (_gameEndInProgress) {
      return;
    }

    _gameEndInProgress = true;
    _gameTimer.cancel();

    _showResults = true;

    final analyticsService =
        Provider.of<AnalyticsService>(context, listen: false);
    analyticsService.capture(context, 'multiplayer_game_ended', properties: {
      'duration_minutes': widget.gameDurationMinutes,
      'player1_score': _player1Score,
      'player2_score': _player2Score,
      'winner': _player1Score > _player2Score
          ? 'player1'
          : (_player2Score > _player1Score ? 'player2' : 'tie'),
    });

    // Track multiplayer game completion
    analyticsService.trackFeatureCompletion(
        context, AnalyticsService.featureMultiplayerGame,
        additionalProperties: {
          'duration_minutes': widget.gameDurationMinutes,
          'player1_score': _player1Score,
          'player2_score': _player2Score,
          'winner': _player1Score > _player2Score
              ? 'player1'
              : (_player2Score > _player1Score ? 'player2' : 'tie'),
          'total_questions_answered': _player1Score + _player2Score,
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
      AppLogger.error(
          'Failed to initialize services in MultiplayerQuizScreen', e);
    }
  }

  void _initializeManagers() {
    // Player 1 managers
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
    Provider.of<AnalyticsService>(context, listen: false);

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final language = settings.language;

      // Load questions for both players
      if (!_player1QuestionSelector.allQuestionsLoaded) {
        _player1QuestionSelector.allQuestions =
            await _questionCacheService.getQuestions(
          language,
          startIndex: 0,
        );
        _player1QuestionSelector.allQuestions.shuffle();
        _player1QuestionSelector.allQuestionsLoaded = true;
      }

      if (!_player2QuestionSelector.allQuestionsLoaded) {
        _player2QuestionSelector.allQuestions =
            await _questionCacheService.getQuestions(
          language,
          startIndex: 0,
        );
        _player2QuestionSelector.allQuestions.shuffle();
        _player2QuestionSelector.allQuestionsLoaded = true;
      }

      if (_player1QuestionSelector.allQuestions.isEmpty ||
          _player2QuestionSelector.allQuestions.isEmpty) {
        throw Exception(strings.AppStrings.errorNoQuestions);
      }

      if (!mounted) return;

      // Initialize both players with different questions
      final QuizQuestion player1FirstQuestion =
          _player1QuestionSelector.pickNextQuestion(0.0, context);
      final QuizQuestion player2FirstQuestion =
          _player2QuestionSelector.pickNextQuestion(0.0, context);

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

      // Trigger animations for both players
      if (!mounted) return;
      _player1AnimationController.triggerTimeAnimation();
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

  // Player 1 next question handler
  Future<void> _handlePlayer1NextQuestion(
      bool isCorrect, double newDifficulty) async {
    try {
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

      await Future.delayed(
          _platformFeedbackService.getTransitionPauseDuration());
      if (!mounted) return;

      // Record answer result for player 1
      _player1QuestionSelector.recordAnswerResult(
          _player1QuizState.question.question, isCorrect);

      // Calculate new difficulty for player 1
      final calculatedNewDifficulty =
          _player1QuestionSelector.calculateNextDifficulty(
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
      final QuizQuestion nextQuestion = _player1QuestionSelector
          .pickNextQuestion(calculatedNewDifficulty, context);
      setState(() {
        _player1QuizState = QuizState(
          question: nextQuestion,
          timeRemaining: 20,
          currentDifficulty: calculatedNewDifficulty,
        );
        _player1AnimationController.triggerTimeAnimation();
      });
    } finally {
      // Always reset the processing flag when done
      _player1IsProcessingAnswer = false;
    }
  }

  // Player 2 next question handler
  Future<void> _handlePlayer2NextQuestion(
      bool isCorrect, double newDifficulty) async {
    try {
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

      await Future.delayed(
          _platformFeedbackService.getTransitionPauseDuration());
      if (!mounted) return;

      // Record answer result for player 2
      _player2QuestionSelector.recordAnswerResult(
          _player2QuizState.question.question, isCorrect);

      // Calculate new difficulty for player 2
      final calculatedNewDifficulty =
          _player2QuestionSelector.calculateNextDifficulty(
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
      final QuizQuestion nextQuestion = _player2QuestionSelector
          .pickNextQuestion(calculatedNewDifficulty, context);
      setState(() {
        _player2QuizState = QuizState(
          question: nextQuestion,
          timeRemaining: 20,
          currentDifficulty: calculatedNewDifficulty,
        );
        _player2AnimationController.triggerTimeAnimation();
      });
    } finally {
      // Always reset the processing flag when done
      _player2IsProcessingAnswer = false;
    }
  }

  void _handleAnswer(int selectedIndex, bool isPlayer1) {
    Provider.of<AnalyticsService>(context, listen: false);

    // Prevent race conditions - check if already processing
    if (isPlayer1 && _player1IsProcessingAnswer) {
      return;
    }
    if (!isPlayer1 && _player2IsProcessingAnswer) {
      return;
    }

    // Set processing flag immediately
    if (isPlayer1) {
      _player1IsProcessingAnswer = true;
      _answerHandler.handleAnswer(
        selectedIndex: selectedIndex,
        quizState: _player1QuizState,
        updateQuizState: (newState) {
          setState(() {
            _player1QuizState = newState;
          });
        },
        handleNextQuestion: (isCorrect, difficulty) =>
            _handlePlayer1NextQuestion(isCorrect, difficulty),
        context: context,
      );
    } else {
      _player2IsProcessingAnswer = true;
      _answerHandler.handleAnswer(
        selectedIndex: selectedIndex,
        quizState: _player2QuizState,
        updateQuizState: (newState) {
          setState(() {
            _player2QuizState = newState;
          });
        },
        handleNextQuestion: (isCorrect, difficulty) =>
            _handlePlayer2NextQuestion(isCorrect, difficulty),
        context: context,
      );
    }
  }

  @override
  void dispose() {
    // Reset race condition flags
    _player1IsProcessingAnswer = false;
    _player2IsProcessingAnswer = false;
    _gameEndInProgress = false;

    // Reset biblical reference state
    _player1ShowingBiblicalReference = false;
    _player2ShowingBiblicalReference = false;
    _player1BiblicalReference = null;
    _player2BiblicalReference = null;
    _player1BiblicalContent = '';
    _player2BiblicalContent = '';
    _player1BiblicalError = '';
    _player2BiblicalError = '';
    _player1BiblicalLoading = false;
    _player2BiblicalLoading = false;

    // Close HTTP client
    _biblicalClient.close();

    // Dispose player 1 managers
    _player1QuestionSelector.setMounted(false);
    _player1AnimationController.dispose();

    // Dispose player 2 managers
    _player2QuestionSelector.setMounted(false);
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
    // Timer management removed - no action needed for app lifecycle state changes
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
        child: KeyboardListener(
          focusNode: _keyboardFocusNode..requestFocus(),
          onKeyEvent: (KeyEvent event) {
            // Only handle on desktop platforms
            if (defaultTargetPlatform == TargetPlatform.windows ||
                defaultTargetPlatform == TargetPlatform.macOS ||
                defaultTargetPlatform == TargetPlatform.linux) {
              if (event is KeyDownEvent) {
                final key = event.logicalKey;
                int? answerIndex;
                bool? isPlayer1;
                if ([
                  LogicalKeyboardKey.keyA,
                  LogicalKeyboardKey.keyS,
                  LogicalKeyboardKey.keyD,
                  LogicalKeyboardKey.keyF
                ].contains(key)) {
                  isPlayer1 = true;
                  if (key == LogicalKeyboardKey.keyA) {
                    answerIndex = 0;
                  } else if (key == LogicalKeyboardKey.keyS) {
                    answerIndex = 1;
                  } else if (key == LogicalKeyboardKey.keyD) {
                    answerIndex = 2;
                  } else if (key == LogicalKeyboardKey.keyF) {
                    answerIndex = 3;
                  }
                } else if ([
                  LogicalKeyboardKey.keyH,
                  LogicalKeyboardKey.keyJ,
                  LogicalKeyboardKey.keyK,
                  LogicalKeyboardKey.keyL
                ].contains(key)) {
                  isPlayer1 = false;
                  if (key == LogicalKeyboardKey.keyH) {
                    answerIndex = 0;
                  } else if (key == LogicalKeyboardKey.keyJ) {
                    answerIndex = 1;
                  } else if (key == LogicalKeyboardKey.keyK) {
                    answerIndex = 2;
                  } else if (key == LogicalKeyboardKey.keyL) {
                    answerIndex = 3;
                  }
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
                      child: _buildPlayerColumn(
                        context,
                        isPlayer1: true,
                        playerName: 'Speler 1',
                      ),
                    ),

                    // Divider - subtle and full height
                    Container(
                      width: 1,
                      color: colorScheme.outline,
                      margin: EdgeInsets.zero,
                    ),

                    // Right half - Player 2 (rotated on mobile) with its own bottom bar
                    Expanded(
                      child: _buildPlayerColumn(
                        context,
                        isPlayer1: false,
                        playerName: 'Speler 2',
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

  Widget _buildPlayerColumn(BuildContext context,
      {required bool isPlayer1, required String playerName}) {
    Provider.of<SettingsProvider>(context);

    // Determine winner
    if (_player1Score > _player2Score) {
    } else if (_player2Score > _player1Score) {
    } else {}

    // Check if we're on a mobile device
    bool isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    // Build the column content
    Widget columnContent = Column(
      children: [
        Expanded(
          child: _buildScrollablePlayerArea(
            context,
            isPlayer1: isPlayer1,
            playerName: playerName,
          ),
        ),
        // Only show bottom bar when not showing results
        if (!_showResults)
          QuizBottomBar(
            quizState: isPlayer1 ? _player1QuizState : _player2QuizState,
            gameStats: Provider.of<GameStatsProvider>(context),
            settings: Provider.of<SettingsProvider>(context),
            questionId: isPlayer1
                ? _player1QuizState.question.id
                : _player2QuizState.question.id,
            onSkipPressed: () => _handleSkipForPlayer(isPlayer1),
            onUnlockPressed: () =>
                _handleUnlockBiblicalReferenceForPlayer(isPlayer1),
            onFlagPressed: () => _handleFlagForPlayer(isPlayer1),
            isDesktop: false, // This is a mobile app screen
          ),
      ],
    );

    // Apply rotation for Player 2 on mobile devices
    if (isMobile && !isPlayer1) {
      columnContent = Transform.rotate(
        angle: 3.14159, // 180 degrees in radians
        child: columnContent,
      );
    }

    return columnContent;
  }

  Widget _buildScrollablePlayerArea(BuildContext context,
      {required bool isPlayer1, required String playerName}) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = Provider.of<SettingsProvider>(context);

    // Determine winner
    String? winner;
    if (_player1Score > _player2Score) {
      winner = 'player1';
    } else if (_player2Score > _player1Score) {
      winner = 'player2';
    } else {
      winner = 'tie';
    }

    final isWinner =
        winner == 'player1' && isPlayer1 || winner == 'player2' && !isPlayer1;
    final isTie = winner == 'tie';

    // Check if we're on a mobile device
    bool isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    // Check if this player is showing biblical reference
    final showingBiblicalReference = isPlayer1
        ? _player1ShowingBiblicalReference
        : _player2ShowingBiblicalReference;
    final biblicalReference =
        isPlayer1 ? _player1BiblicalReference : _player2BiblicalReference;

    return Container(
      color: _showResults
          ? (isWinner ? colorScheme.primary : colorScheme.surface)
          : colorScheme.surface,
      child: showingBiblicalReference && biblicalReference != null
          ? _buildBiblicalReferenceFullScreen(
              context, biblicalReference, isPlayer1)
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Transform.scale(
                      scale:
                          0.85, // Scale down the entire content to reduce scrolling
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _showResults
                            ? Center(
                                child: _buildResultsWidget(
                                    context, isPlayer1, isWinner, isTie),
                              )
                            : QuestionWidget(
                                question: isPlayer1
                                    ? _player1QuizState.question
                                    : _player2QuizState.question,
                                selectedAnswerIndex: isPlayer1
                                    ? _player1QuizState.selectedAnswerIndex
                                    : _player2QuizState.selectedAnswerIndex,
                                isAnswering: isPlayer1
                                    ? _player1QuizState.isAnswering
                                    : _player2QuizState.isAnswering,
                                isTransitioning: isPlayer1
                                    ? _player1QuizState.isTransitioning
                                    : _player2QuizState.isTransitioning,
                                onAnswerSelected: (index) =>
                                    _handleAnswer(index, isPlayer1),
                                language: settings.language,
                                performanceService: _performanceService,
                                isCompact: true,
                                customLetters: isMobile
                                    ? ['A', 'B', 'C', 'D']
                                    : (isPlayer1
                                        ? ['A', 'S', 'D', 'F']
                                        : ['H', 'J', 'K', 'L']),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildBiblicalReferenceFullScreen(
      BuildContext context, String biblicalReference, bool isPlayer1) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.AppStrings.biblicalReference),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _closeBiblicalReferenceForPlayer(isPlayer1),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child:
                  _buildBiblicalContentForPlayer(isPlayer1, biblicalReference),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .shadow
                          .withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _closeBiblicalReferenceForPlayer(isPlayer1),
                    borderRadius: BorderRadius.circular(16),
                    focusColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          strings.AppStrings.resumeToGame,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onPrimary,
                                height: 1.4,
                                letterSpacing: 0.1,
                                fontSize: 16,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiblicalContentForPlayer(
      bool isPlayer1, String biblicalReference) {
    final isLoading =
        isPlayer1 ? _player1BiblicalLoading : _player2BiblicalLoading;
    final content =
        isPlayer1 ? _player1BiblicalContent : _player2BiblicalContent;
    final error = isPlayer1 ? _player1BiblicalError : _player2BiblicalError;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : error.isNotEmpty
            ? Center(
                child: Text(
                  error,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 16,
                      ),
                  textAlign: TextAlign.center,
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    content,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          height: 1.6,
                          letterSpacing: 0.2,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              );
  }

  Widget _buildResultsWidget(
      BuildContext context, bool isPlayer1, bool isWinner, bool isTie) {
    final colorScheme = Theme.of(context).colorScheme;
    final score = isPlayer1 ? _player1Score : _player2Score;

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
    final analyticsService =
        Provider.of<AnalyticsService>(context, listen: false);
    final QuizState quizState =
        isPlayer1 ? _player1QuizState : _player2QuizState;
    final ProgressiveQuestionSelector questionSelector =
        isPlayer1 ? _player1QuestionSelector : _player2QuestionSelector;
    final String playerName = isPlayer1 ? 'Player1' : 'Player2';

    // Track skip feature usage
    analyticsService.trackFeatureAttempt(
        context, AnalyticsService.featureSkipQuestion,
        additionalProperties: {
          'question_category': quizState.question.category,
          'question_difficulty': quizState.question.difficulty,
          'time_remaining': quizState.timeRemaining,
          'player': playerName,
        });

    Provider.of<AnalyticsService>(context, listen: false)
        .capture(context, 'skip_question_$playerName');
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    Provider.of<SettingsProvider>(context, listen: false);
    final isDev = kDebugMode;

    final skipCost = await QuizActionPriceHelper().getSkipQuestionPrice();
    final success = isDev
        ? true
        : await gameStats.spendStarsWithTransaction(
            amount: skipCost,
            reason: 'Vraag overslaan',
            metadata: {
              'question_category': quizState.question.category,
              'question_difficulty': quizState.question.difficulty,
              'time_remaining': quizState.timeRemaining,
              'player': playerName,
            },
          );

    if (success) {
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

      // Track successful question skip after state update
      if (mounted) {
        analyticsService.trackFeatureSuccess(
            context, AnalyticsService.featureSkipQuestion,
            additionalProperties: {
              'question_category': quizState.question.category,
              'question_difficulty': quizState.question.difficulty,
              'time_remaining': quizState.timeRemaining,
              'player': playerName,
            });
      }

      await Future.delayed(_performanceService
          .getOptimalAnimationDuration(const Duration(milliseconds: 300)));
      if (!mounted) return;

      setState(() {
        // Record that the current question was not answered correctly (since it was skipped)
        questionSelector.recordAnswerResult(quizState.question.question, false);
        final nextQuestion = questionSelector.pickNextQuestion(
            quizState.currentDifficulty, context);

        if (isPlayer1) {
          _player1QuizState = QuizState(
            question: nextQuestion,
            timeRemaining: 20, // Default timer
            currentDifficulty: quizState.currentDifficulty,
          );

          // Restart animation for player 1
          _player1AnimationController.triggerTimeAnimation();
        } else {
          _player2QuizState = QuizState(
            question: nextQuestion,
            timeRemaining: 20, // Default timer
            currentDifficulty: quizState.currentDifficulty,
          );

          // Restart animation for player 2
          _player2AnimationController.triggerTimeAnimation();
        }
      });
    } else {
      if (mounted) {
        showTopSnackBar(context, strings.AppStrings.notEnoughStarsForSkip,
            style: TopSnackBarStyle.warning);
      }
    }
  }

  Future<void> _handleUnlockBiblicalReferenceForPlayer(bool isPlayer1) async {
    final analyticsService =
        Provider.of<AnalyticsService>(context, listen: false);
    final QuizState quizState =
        isPlayer1 ? _player1QuizState : _player2QuizState;
    final String playerName = isPlayer1 ? 'Player1' : 'Player2';

    // Track biblical reference unlock attempt
    analyticsService.trackFeatureAttempt(
        context, AnalyticsService.featureBiblicalReferences,
        additionalProperties: {
          'question_category': quizState.question.category,
          'question_difficulty': quizState.question.difficulty,
          'biblical_reference': quizState.question.biblicalReference ?? 'none',
          'time_remaining': quizState.timeRemaining,
          'player': playerName,
        });

    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    final isDev = kDebugMode;

    // First check if the reference can be parsed
    final parsed =
        _parseBiblicalReference(quizState.question.biblicalReference!);
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
        showTopSnackBar(context, strings.AppStrings.invalidBiblicalReference,
            style: TopSnackBarStyle.error);
      }
      return;
    }

    // Spend stars for unlocking the biblical reference (free in debug mode)
    final biblicalCost =
        await QuizActionPriceHelper().getUnlockBiblicalReferencePrice();
    final success = isDev
        ? true
        : await gameStats.spendStarsWithTransaction(
            amount: biblicalCost,
            reason: 'Bijbelse referentie ontgrendelen',
            metadata: {
              'question_category': quizState.question.category,
              'question_difficulty': quizState.question.difficulty,
              'biblical_reference':
                  quizState.question.biblicalReference ?? 'none',
              'time_remaining': quizState.timeRemaining,
              'player': playerName,
            },
          );
    if (success) {
      // Show the biblical reference dialog only for the specific player
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showBiblicalReferenceDialogForPlayer(
              context, quizState.question.biblicalReference!, isPlayer1);
        }
      });

      // Track successful biblical reference unlock
      if (mounted) {
        analyticsService.trackFeatureSuccess(
            context, AnalyticsService.featureBiblicalReferences,
            additionalProperties: {
              'question_category': quizState.question.category,
              'question_difficulty': quizState.question.difficulty,
              'biblical_reference':
                  quizState.question.biblicalReference ?? 'none',
              'time_remaining': quizState.timeRemaining,
              'player': playerName,
            });
      }
    } else {
      // Not enough stars - this is a user state issue, not an error to report automatically
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showTopSnackBar(context, strings.AppStrings.notEnoughStars,
              style: TopSnackBarStyle.warning);
        }
      });
    }
  }

  Future<void> _handleFlagForPlayer(bool isPlayer1) async {
    final QuizState quizState =
        isPlayer1 ? _player1QuizState : _player2QuizState;
    final questionId = quizState.question.id;
    final String playerName = isPlayer1 ? 'Player1' : 'Player2';

    try {
      // Report the issue to the tracking service
      final gameStatsProvider =
          Provider.of<GameStatsProvider>(context, listen: false);
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

  void _showBiblicalReferenceDialogForPlayer(
      BuildContext context, String biblicalReference, bool isPlayer1) {
    // Timer functionality removed

    // Show player-specific biblical reference overlay and start loading
    setState(() {
      if (isPlayer1) {
        _player1ShowingBiblicalReference = true;
        _player1BiblicalReference = biblicalReference;
        _player1BiblicalLoading = true;
        _player1BiblicalContent = '';
        _player1BiblicalError = '';
      } else {
        _player2ShowingBiblicalReference = true;
        _player2BiblicalReference = biblicalReference;
        _player2BiblicalLoading = true;
        _player2BiblicalContent = '';
        _player2BiblicalError = '';
      }
    });

    // Load biblical content for the specific player
    _loadBiblicalReferenceForPlayer(biblicalReference, isPlayer1);

    // Track successful biblical reference unlock
    final analyticsService =
        Provider.of<AnalyticsService>(context, listen: false);
    final quizState = isPlayer1 ? _player1QuizState : _player2QuizState;
    final String playerName = isPlayer1 ? 'Player1' : 'Player2';

    analyticsService.trackFeatureSuccess(
        context, AnalyticsService.featureBiblicalReferences,
        additionalProperties: {
          'question_category': quizState.question.category,
          'question_difficulty': quizState.question.difficulty,
          'biblical_reference': biblicalReference,
          'time_remaining': quizState.timeRemaining,
          'player': playerName,
        });
  }

  Future<void> _loadBiblicalReferenceForPlayer(
      String biblicalReference, bool isPlayer1) async {
    try {
      // Parse the reference to extract book, chapter, and verse
      final parsed = _parseBiblicalReference(biblicalReference);
      if (parsed == null) {
        await AutomaticErrorReporter.reportBiblicalReferenceError(
          message: 'Ongeldige bijbelverwijzing: "$biblicalReference"',
          userMessage: 'Invalid Bible reference format',
          reference: biblicalReference,
          additionalInfo: {
            'parsing_error': 'Reference could not be parsed',
          },
        );
        throw Exception('Ongeldige bijbelverwijzing: "$biblicalReference"');
      }

      final book = parsed['book'];
      final chapter = parsed['chapter'];
      final startVerse = parsed['startVerse'];
      final endVerse = parsed['endVerse'];

      // Convert book name to book number for the new API
      final bookNumber = BibleBookMapper.getBookNumber(book);
      if (bookNumber == null) {
        // Auto-report book mapping errors
        await AutomaticErrorReporter.reportBiblicalReferenceError(
          message: 'Ongeldig boeknaam: "$book"',
          userMessage: 'Invalid book name in biblical reference',
          reference: biblicalReference,
          additionalInfo: {
            'book': book,
            'available_books':
                BibleBookMapper.getAllBookNames().take(10).join(", "),
          },
        );
        final validBooks = BibleBookMapper.getAllBookNames();
        throw Exception(
            'Ongeldig boeknaam: "$book". Geldige boeken: ${validBooks.take(10).join(", ")}...');
      }

      String url;
      if (startVerse != null && endVerse != null) {
        // Multiple verses - format as "startVerse-endVerse"
        url =
            '${AppUrls.bibleApiBase}?b=$bookNumber&h=$chapter&v=$startVerse-$endVerse';
      } else if (startVerse != null) {
        // Single verse
        url = '${AppUrls.bibleApiBase}?b=$bookNumber&h=$chapter&v=$startVerse';
      } else {
        // Entire chapter - request a reasonable sample (first 10 verses)
        url = '${AppUrls.bibleApiBase}?b=$bookNumber&h=$chapter&v=1-10';
      }

      // Validate URL to ensure it's from our trusted domain
      final uri = Uri.parse(url);
      if (uri.host != Uri.parse(AppUrls.bibleApiBase).host) {
        await AutomaticErrorReporter.reportBiblicalReferenceError(
          message: 'Ongeldige API URL',
          userMessage: 'Invalid API URL for biblical reference',
          reference: biblicalReference,
          additionalInfo: {
            'url': url,
            'expected_host': Uri.parse(AppUrls.bibleApiBase).host,
            'actual_host': uri.host,
          },
        );
        throw Exception('Ongeldige API URL');
      }

      // Make HTTP request with timeout
      final response = await _biblicalClient.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          // Auto-report timeout errors
          AutomaticErrorReporter.reportBiblicalReferenceError(
            message: 'Time-out bij het laden van de bijbeltekst',
            userMessage: 'Timeout loading biblical text',
            reference: biblicalReference,
            additionalInfo: {
              'url': url,
              'timeout_seconds': 10,
            },
          ).catchError((e) {
            // Don't let reporting errors affect the main functionality
          });
          throw Exception('Time-out bij het laden van de bijbeltekst');
        },
      );

      if (response.statusCode == 200) {
        // Validate content type - be more flexible
        final contentType = response.headers['content-type'];
        if (contentType == null ||
            (!contentType.contains('xml') && !contentType.contains('text'))) {
          // Auto-report content type errors
          AutomaticErrorReporter.reportBiblicalReferenceError(
            message:
                'Ongeldig antwoord van de server. Content-Type: $contentType',
            userMessage: 'Invalid response from biblical text API',
            reference: biblicalReference,
            additionalInfo: {
              'url': url,
              'status_code': response.statusCode,
              'content_type': contentType,
              'response_preview': response.body.substring(0, 300),
            },
          ).catchError((e) {
            // Don't let reporting errors affect the main functionality
          });
          throw Exception(
              'Ongeldig antwoord van de server. Content-Type: $contentType. Response: ${response.body.substring(0, 300)}...');
        }

        // Parse XML response
        String content = '';
        try {
          // Clean the response body first (remove BOM or other artifacts)
          String cleanBody = response.body.trim();
          if (cleanBody.startsWith('\uFEFF')) {
            cleanBody = cleanBody.substring(1);
          }

          final document = xml.XmlDocument.parse(cleanBody);

          // Find all verse elements in the XML structure: bijbel > bijbelboek > hoofdstuk > vers
          final verses = document.findAllElements('vers');

          for (final verse in verses) {
            final verseNumber = verse.getAttribute('name');
            final verseText = verse.innerText.trim();

            if (verseNumber != null && verseText.isNotEmpty) {
              // Sanitize text to prevent XSS
              final sanitizedText = _sanitizeText(verseText);
              content += '$verseNumber. $sanitizedText\n';
            }
          }

          // If no verses found with 'vers' elements, try alternative element names
          if (content.isEmpty) {
            final alternativeVerseElements = document.findAllElements('verse');
            for (final verse in alternativeVerseElements) {
              final verseNumber =
                  verse.getAttribute('name') ?? verse.getAttribute('number');
              final verseText = verse.innerText.trim();

              if (verseNumber != null && verseText.isNotEmpty) {
                final sanitizedText = _sanitizeText(verseText);
                content += '$verseNumber. $sanitizedText\n';
              }
            }
          }

          // If still no content, try to extract any meaningful text
          if (content.isEmpty) {
            final allElements = <xml.XmlElement>[];
            _collectAllElements(document.rootElement, allElements);

            for (final element in allElements) {
              final elementText = element.innerText.trim();
              // Look for elements that contain actual Bible text (not just markup)
              if (elementText.isNotEmpty &&
                  elementText.length > 10 &&
                  !elementText.contains('<') &&
                  !elementText.contains('xml') &&
                  !elementText.contains('bijbel')) {
                final sanitizedText = _sanitizeText(elementText);
                content += '$sanitizedText\n';
              }
            }
          }

          // If still no content, show debug info
          if (content.isEmpty) {
            AutomaticErrorReporter.reportBiblicalReferenceError(
              message: 'Geen tekst gevonden in XML na parsing',
              userMessage: 'No text found in biblical reference response',
              reference: biblicalReference,
              additionalInfo: {
                'url': url,
                'response_length': response.body.length,
                'response_preview': response.body.substring(0, 300),
              },
            ).catchError((e) {
              // Don't let reporting errors affect the main functionality
            });
            throw Exception(
                'Geen tekst gevonden in XML na parsing. XML length: ${response.body.length}, First 300 chars: ${response.body.substring(0, 300)}');
          }
        } catch (e) {
          // If XML parsing fails, try to extract text directly from response
          String extractedText = _extractTextFromResponse(response.body);
          if (extractedText.isNotEmpty) {
            content = _sanitizeText(extractedText);
          } else {
            // Report XML parsing errors
            AutomaticErrorReporter.reportBiblicalReferenceError(
              message: 'XML parsing mislukt en geen tekst gevonden',
              userMessage: 'XML parsing failed for biblical reference',
              reference: biblicalReference,
              additionalInfo: {
                'url': url,
                'error': e.toString(),
                'response_preview': response.body.substring(0, 300),
              },
            ).catchError((e) {
              // Don't let reporting errors affect the main functionality
            });
            throw Exception('XML parsing mislukt en geen tekst gevonden: $e');
          }
        }

        if (mounted) {
          setState(() {
            if (isPlayer1) {
              _player1BiblicalContent = content;
              _player1BiblicalLoading = false;
            } else {
              _player2BiblicalContent = content;
              _player2BiblicalLoading = false;
            }
          });
        }
      } else if (response.statusCode == 429) {
        // Report rate limiting errors
        AutomaticErrorReporter.reportBiblicalReferenceError(
          message: 'Te veel verzoeken naar de biblical API',
          userMessage: 'Rate limited by biblical text API',
          reference: biblicalReference,
          additionalInfo: {
            'url': url,
            'status_code': response.statusCode,
          },
        ).catchError((e) {
          // Don't let reporting errors affect the main functionality
        });
        throw Exception('Te veel verzoeken. Probeer het later opnieuw.');
      } else {
        // Report other HTTP errors
        AutomaticErrorReporter.reportBiblicalReferenceError(
          message:
              'Fout bij het laden van de bijbeltekst (status: ${response.statusCode})',
          userMessage: 'HTTP error loading biblical text',
          reference: biblicalReference,
          additionalInfo: {
            'url': url,
            'status_code': response.statusCode,
          },
        ).catchError((e) {
          // Don't let reporting errors affect the main functionality
        });
        throw Exception(
            'Fout bij het laden van de bijbeltekst (status: ${response.statusCode})');
      }
    } on SocketException {
      // Report network errors
      AutomaticErrorReporter.reportBiblicalReferenceError(
        message: 'Netwerkfout bij laden van bijbeltekst',
        userMessage: 'Network error loading biblical text',
        reference: biblicalReference,
      ).catchError((e) {
        // Don't let reporting errors affect the main functionality
      });
      if (mounted) {
        setState(() {
          if (isPlayer1) {
            _player1BiblicalError =
                'Netwerkfout. Controleer uw internetverbinding.';
            _player1BiblicalLoading = false;
          } else {
            _player2BiblicalError =
                'Netwerkfout. Controleer uw internetverbinding.';
            _player2BiblicalLoading = false;
          }
        });
      }
    } on Exception catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('Time-out')) {
        // Time-out was already handled above, but in case it bubbles up
        if (mounted) {
          setState(() {
            if (isPlayer1) {
              _player1BiblicalError =
                  'Time-out bij het laden van de bijbeltekst. Probeer het later opnieuw.';
              _player1BiblicalLoading = false;
            } else {
              _player2BiblicalError =
                  'Time-out bij het laden van de bijbeltekst. Probeer het later opnieuw.';
              _player2BiblicalLoading = false;
            }
          });
        }
      } else {
        // Report other errors
        AutomaticErrorReporter.reportBiblicalReferenceError(
          message: 'Fout bij het laden van bijbeltekst',
          userMessage: 'Error loading biblical text',
          reference: biblicalReference,
          additionalInfo: {
            'error': errorMessage,
          },
        ).catchError((e) {
          // Don't let reporting errors affect the main functionality
        });
        if (mounted) {
          setState(() {
            if (isPlayer1) {
              _player1BiblicalError = 'Fout bij het laden: $errorMessage';
              _player1BiblicalLoading = false;
            } else {
              _player2BiblicalError = 'Fout bij het laden: $errorMessage';
              _player2BiblicalLoading = false;
            }
          });
        }
      }
    } catch (e) {
      // Report any other errors
      AutomaticErrorReporter.reportBiblicalReferenceError(
        message: 'Onverwachte fout bij laden van bijbeltekst',
        userMessage: 'Unexpected error loading biblical text',
        reference: biblicalReference,
        additionalInfo: {
          'error': e.toString(),
        },
      ).catchError((e) {
        // Don't let reporting errors affect the main functionality
      });
      if (mounted) {
        setState(() {
          if (isPlayer1) {
            _player1BiblicalError = 'Fout bij het laden: ${e.toString()}';
            _player1BiblicalLoading = false;
          } else {
            _player2BiblicalError = 'Fout bij het laden: ${e.toString()}';
            _player2BiblicalLoading = false;
          }
        });
      }
    }
  }

  // Simple text sanitization to prevent XSS
  String _sanitizeText(String text) {
    // First decode Unicode escape sequences
    String decodedText = _decodeUnicodeEscapes(text);

    return decodedText
        .replaceAll('&', '&')
        .replaceAll('<', '<')
        .replaceAll('>', '>')
        .replaceAll('"', '"')
        .replaceAll("'", '&#x27;');
  }

  // Decode Unicode escape sequences like \u00ebl
  String _decodeUnicodeEscapes(String text) {
    final RegExp unicodeRegex = RegExp(r'\\u([0-9a-fA-F]{4})');
    return text.replaceAllMapped(unicodeRegex, (Match match) {
      final String hexCode = match.group(1)!;
      final int charCode = int.parse(hexCode, radix: 16);
      return String.fromCharCode(charCode);
    });
  }

  void _collectAllElements(
      xml.XmlElement element, List<xml.XmlElement> collection) {
    collection.add(element);
    for (final child in element.childElements) {
      _collectAllElements(child, collection);
    }
  }

  String _extractTextFromResponse(String responseBody) {
    // Try to extract meaningful text from various response formats
    try {
      // If it's XML, try to parse and extract text content
      if (responseBody.contains('<') && responseBody.contains('>')) {
        final document = xml.XmlDocument.parse(responseBody);
        final allElements = <xml.XmlElement>[];
        _collectAllElements(document.rootElement, allElements);

        for (final element in allElements) {
          final text = element.innerText.trim();
          if (text.isNotEmpty && text.length > 10) {
            return text;
          }
        }
      }

      // If not XML or no text found, return the whole body (it might be plain text)
      return responseBody.trim();
    } catch (e) {
      // If all parsing fails, return the original body
      return responseBody.trim();
    }
  }

  void _closeBiblicalReferenceForPlayer(bool isPlayer1) {
    setState(() {
      if (isPlayer1) {
        _player1ShowingBiblicalReference = false;
        _player1BiblicalReference = null;
      } else {
        _player2ShowingBiblicalReference = false;
        _player2BiblicalReference = null;
      }
    });

    // Timer functionality removed - no action needed
  }
}
