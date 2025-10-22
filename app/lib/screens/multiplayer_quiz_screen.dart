import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:math';
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
import '../widgets/quiz_bottom_bar.dart';
import '../widgets/question_widget.dart';
import '../widgets/metrics_widget.dart';
import '../widgets/quiz_skeleton.dart';
import '../widgets/top_snackbar.dart';
import '../l10n/strings_nl.dart' as strings;
import '../services/logger.dart';

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

  // Managers
  late QuizTimerManager _timerManager;
  late QuizAnimationController _animationController;
  late ProgressiveQuestionSelector _questionSelector;
  late QuizAnswerHandler _answerHandler;

  @override
  void initState() {
    super.initState();
    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

    // Track screen view
    analyticsService.screen(context, 'MultiplayerQuizScreen');
    analyticsService.capture(context, 'multiplayer_game_started', properties: {
      'duration_minutes': widget.gameDurationMinutes,
    });

    WidgetsBinding.instance.addObserver(this);
    AppLogger.info('MultiplayerQuizScreen loaded');

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

    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    analyticsService.capture(context, 'multiplayer_game_ended', properties: {
      'duration_minutes': widget.gameDurationMinutes,
      'player1_score': _player1Score,
      'player2_score': _player2Score,
      'winner': _player1Score > _player2Score ? 'player1' : (_player2Score > _player1Score ? 'player2' : 'tie'),
    });

    // Show end game dialog
    _showGameEndDialog();
  }

  void _showGameEndDialog() {
    final winner = _player1Score > _player2Score ? 'Speler 1' : (_player2Score > _player1Score ? 'Speler 2' : 'Gelijkspel');
    final isTie = _player1Score == _player2Score;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Spel afgelopen!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isTie ? 'Het is gelijkspel!' : '$winner wint!',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Text(
                'Speler 1: $_player1Score punten\nSpeler 2: $_player2Score punten',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Speeltijd: ${widget.gameDurationMinutes} minuten',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to setup screen
              },
              child: Text(
                'Nieuw spel',
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
      setState(() {
        _error = '${strings.AppStrings.errorLoadQuestions}: ${e.toString()}';
      });

      final analytics = Provider.of<AnalyticsService>(context, listen: false);
      analytics.capture(context, 'multiplayer_quiz_loading_error', properties: {
        'error_type': e.runtimeType.toString(),
        'error_message': e.toString(),
      });

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

    if (_gameEnded) {
      return Container(); // Game end dialog is shown, screen will be popped
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: SizedBox(
            width: size.width,
            height: max(size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom, 600),
            child: Column(
              children: [
                // Game timer and scores header - responsive for smaller screens
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  color: colorScheme.primaryContainer,
                  child: Row(
                    children: [
                      // Game timer
                      Expanded(
                        child: Text(
                          'Tijd: ${_formatDuration(Duration(seconds: _gameTimeRemaining))}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimaryContainer,
                                fontSize: isSmallScreen ? 14 : null,
                              ),
                        ),
                      ),
                      // Player scores
                      Text(
                        '$_player1Score - $_player2Score',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                              fontSize: isSmallScreen ? 16 : null,
                            ),
                      ),
                    ],
                  ),
                ),

                // Split screen layout with better proportions
                Expanded(
                  child: Row(
                    children: [
                      // Left half - Player 1 (normal orientation)
                      Expanded(
                        child: Container(
                          color: colorScheme.surface,
                          child: _buildPlayerQuizArea(
                            context,
                            isPlayer1: true,
                            playerName: 'Speler 1',
                          ),
                        ),
                      ),

                      // Divider - responsive width
                      Container(
                        width: isSmallScreen ? 1 : 2,
                        color: colorScheme.primary,
                        margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 16),
                      ),

                      // Right half - Player 2 (rotated 180 degrees)
                      Expanded(
                        child: Transform.rotate(
                          angle: 3.14159, // 180 degrees in radians
                          child: Container(
                            color: colorScheme.surface,
                            child: _buildPlayerQuizArea(
                              context,
                              isPlayer1: false,
                              playerName: 'Speler 2',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerQuizArea(BuildContext context, {required bool isPlayer1, required String playerName}) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = Provider.of<SettingsProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 4 : 8),
      child: Column(
        children: [
          // Player indicator and score in one row - more compact on small screens
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8 : 12,
              vertical: isSmallScreen ? 4 : 6,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  playerName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                        fontSize: isSmallScreen ? 14 : null,
                      ),
                ),
                SizedBox(width: isSmallScreen ? 6 : 8),
                Text(
                  '$_player1Score',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                        fontSize: isSmallScreen ? 14 : null,
                      ),
                ),
              ],
            ),
          ),

          SizedBox(height: isSmallScreen ? 4 : 8),

          // Question area - use the same QuestionWidget as main quiz
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 4 : 8),
              child: QuestionWidget(
                question: isPlayer1 ? _player1QuizState.question : _player2QuizState.question,
                selectedAnswerIndex: isPlayer1 ? _player1QuizState.selectedAnswerIndex : _player2QuizState.selectedAnswerIndex,
                isAnswering: isPlayer1 ? _player1QuizState.isAnswering : _player2QuizState.isAnswering,
                isTransitioning: isPlayer1 ? _player1QuizState.isTransitioning : _player2QuizState.isTransitioning,
                onAnswerSelected: (index) => _handleAnswer(index, isPlayer1),
                language: settings.language,
                performanceService: _performanceService,
                isCompact: true,
              ),
            ),
          ),
        ],
      ),
    );
  }


  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}