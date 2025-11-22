import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/quiz_question.dart';
import '../services/logger.dart';
import '../services/question_cache_service.dart';
import '../services/connection_service.dart';

enum GameStatus { waiting, active, finished }
enum PlayerRole { organizer, player }

class MultiplayerGameSession {
  final String id;
  final String gameCode;
  final String organizerId;
  final GameStatus status;
  final Map<String, dynamic> gameSettings;
  final int currentQuestionIndex;
  final DateTime? currentQuestionStartTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  MultiplayerGameSession({
    required this.id,
    required this.gameCode,
    required this.organizerId,
    required this.status,
    required this.gameSettings,
    required this.currentQuestionIndex,
    this.currentQuestionStartTime,
    required this.createdAt,
    required this.updatedAt,
  });

  MultiplayerGameSession copyWith({
    String? id,
    String? gameCode,
    String? organizerId,
    GameStatus? status,
    Map<String, dynamic>? gameSettings,
    int? currentQuestionIndex,
    DateTime? currentQuestionStartTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MultiplayerGameSession(
      id: id ?? this.id,
      gameCode: gameCode ?? this.gameCode,
      organizerId: organizerId ?? this.organizerId,
      status: status ?? this.status,
      gameSettings: gameSettings ?? this.gameSettings,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      currentQuestionStartTime: currentQuestionStartTime ?? this.currentQuestionStartTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory MultiplayerGameSession.fromJson(Map<String, dynamic> json) {
    return MultiplayerGameSession(
      id: json['id'],
      gameCode: json['game_code'],
      organizerId: json['organizer_id'],
      status: GameStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => GameStatus.waiting,
      ),
      gameSettings: json['game_settings'] ?? {},
      currentQuestionIndex: json['current_question_index'] ?? 0,
      currentQuestionStartTime: json['current_question_start_time'] != null
          ? DateTime.parse(json['current_question_start_time'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_code': gameCode,
      'organizer_id': organizerId,
      'status': status.name,
      'game_settings': gameSettings,
      'current_question_index': currentQuestionIndex,
      'current_question_start_time': currentQuestionStartTime?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class MultiplayerPlayer {
  final String id;
  final String gameSessionId;
  final String playerId;
  final String playerName;
  final bool isOrganizer;
  final DateTime joinedAt;
  final DateTime lastSeenAt;
  final bool isConnected;
  final int score;
  final String? currentAnswer;
  final int? answerTimeSeconds;

  MultiplayerPlayer({
    required this.id,
    required this.gameSessionId,
    required this.playerId,
    required this.playerName,
    required this.isOrganizer,
    required this.joinedAt,
    required this.lastSeenAt,
    required this.isConnected,
    required this.score,
    this.currentAnswer,
    this.answerTimeSeconds,
  });

  MultiplayerPlayer copyWith({
    String? id,
    String? gameSessionId,
    String? playerId,
    String? playerName,
    bool? isOrganizer,
    DateTime? joinedAt,
    DateTime? lastSeenAt,
    bool? isConnected,
    int? score,
    String? currentAnswer,
    int? answerTimeSeconds,
  }) {
    return MultiplayerPlayer(
      id: id ?? this.id,
      gameSessionId: gameSessionId ?? this.gameSessionId,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      isOrganizer: isOrganizer ?? this.isOrganizer,
      joinedAt: joinedAt ?? this.joinedAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      isConnected: isConnected ?? this.isConnected,
      score: score ?? this.score,
      currentAnswer: currentAnswer ?? this.currentAnswer,
      answerTimeSeconds: answerTimeSeconds ?? this.answerTimeSeconds,
    );
  }

  factory MultiplayerPlayer.fromJson(Map<String, dynamic> json) {
    return MultiplayerPlayer(
      id: json['id'],
      gameSessionId: json['game_session_id'],
      playerId: json['player_id'],
      playerName: json['player_name'],
      isOrganizer: json['is_organizer'] ?? false,
      joinedAt: DateTime.parse(json['joined_at']),
      lastSeenAt: DateTime.parse(json['last_seen_at']),
      isConnected: json['is_connected'] ?? true,
      score: json['score'] ?? 0,
      currentAnswer: json['current_answer'],
      answerTimeSeconds: json['answer_time_seconds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_session_id': gameSessionId,
      'player_id': playerId,
      'player_name': playerName,
      'is_organizer': isOrganizer,
      'joined_at': joinedAt.toIso8601String(),
      'last_seen_at': lastSeenAt.toIso8601String(),
      'is_connected': isConnected,
      'score': score,
      'current_answer': currentAnswer,
      'answer_time_seconds': answerTimeSeconds,
    };
  }
}

class MultiplayerProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final QuestionCacheService _questionCacheService;
  final ConnectionService _connectionService;

  MultiplayerGameSession? _currentGameSession;
  MultiplayerPlayer? _currentPlayer;
  List<MultiplayerPlayer> _players = [];
  List<QuizQuestion> _questions = [];
  RealtimeChannel? _gameChannel;
  RealtimeChannel? _playersChannel;
  Timer? _heartbeatTimer;
  Timer? _disconnectTimer;
  static const Duration _heartbeatInterval = Duration(seconds: 30);
  static const Duration _disconnectTimeout = Duration(seconds: 90);

  // Rate limiting for game joining
  final Map<String, List<DateTime>> _joinAttempts = {};
  static const int _maxJoinAttempts = 5;
  static const Duration _joinAttemptWindow = Duration(minutes: 15);

  bool _isLoading = false;
  String? _error;

  MultiplayerProvider(this._questionCacheService, this._connectionService);

  // Getters
  MultiplayerGameSession? get currentGameSession => _currentGameSession;
  MultiplayerPlayer? get currentPlayer => _currentPlayer;
  List<MultiplayerPlayer> get players => _players;
  List<QuizQuestion> get questions => _questions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOrganizer => _currentPlayer?.isOrganizer ?? false;
  bool get isGameActive => _currentGameSession?.status == GameStatus.active;
  bool get isGameFinished => _currentGameSession?.status == GameStatus.finished;
  int get currentQuestionIndex => _currentGameSession?.currentQuestionIndex ?? 0;
  QuizQuestion? get currentQuestion =>
      currentQuestionIndex < _questions.length ? _questions[currentQuestionIndex] : null;

  // Create a new game session
  Future<String?> createGameSession({
    required String organizerId,
    required String organizerName,
    int? numQuestions,
    int? timeLimitMinutes,
    int questionTimeSeconds = 20,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Generate unique game code
      final gameCode = await _generateGameCode();

      final gameSettings = {
        'num_questions': numQuestions,
        'time_limit_minutes': timeLimitMinutes,
        'question_time_seconds': questionTimeSeconds,
      };

      final response = await _supabase
          .from('multiplayer_game_sessions')
          .insert({
            'game_code': gameCode,
            'organizer_id': organizerId,
            'game_settings': gameSettings,
          })
          .select()
          .single();

      final session = MultiplayerGameSession.fromJson(response);
      _currentGameSession = session;

      // Add organizer as first player
      await _joinGameSession(gameCode, organizerId, organizerName, isOrganizer: true);

      // Load questions
      await _loadQuestions();

      // Set up real-time subscriptions
      _setupRealtimeSubscriptions();

      _isLoading = false;
      notifyListeners();

      return gameCode;
    } catch (e) {
      _error = 'Failed to create game session: $e';
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Failed to create game session', e);
      return null;
    }
  }

  // Join an existing game session
  Future<bool> joinGameSession(String gameCode, String playerId, String playerName) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Server-side rate limiting check using user/device identifier
      try {
        final rateLimitResult = await _supabase.rpc('check_join_rate_limit', params: {
          'p_user_identifier': playerId, // Use player ID as identifier
          'p_game_code': gameCode,
        });

        if (!(rateLimitResult as bool? ?? true)) {
          AppLogger.warning('Server-side rate limit exceeded for player $playerId, game code: $gameCode');
          _error = 'Te veel join pogingen. Probeer het over 15 minuten opnieuw.';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } catch (e) {
        AppLogger.warning('Failed to check server-side rate limit, falling back to client-side: $e');
        // Fallback to client-side rate limiting
        if (!_checkJoinRateLimit(gameCode)) {
          _error = 'Te veel join pogingen. Probeer het later opnieuw.';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      // Record join attempt server-side
      try {
        await _supabase.rpc('record_join_attempt', params: {
          'p_user_identifier': playerId,
          'p_game_code': gameCode,
        });
      } catch (e) {
        AppLogger.warning('Failed to record join attempt server-side: $e');
        // Fallback to client-side recording
        _recordJoinAttempt(gameCode);
      }

      final success = await _joinGameSession(gameCode, playerId, playerName, isOrganizer: false);

      if (success) {
        // Load questions (organizer has already loaded them)
        await _loadQuestions();

        // Set up real-time subscriptions
        _setupRealtimeSubscriptions();

        // Start heartbeat to maintain connection
        _startHeartbeat();
      }

      _isLoading = false;
      notifyListeners();

      return success;
    } catch (e) {
      _error = 'Failed to join game session: $e';
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Failed to join game session', e);
      return false;
    }
  }

  Future<bool> _joinGameSession(String gameCode, String playerId, String playerName, {required bool isOrganizer}) async {
    try {
      AppLogger.info('Player $playerName ($playerId) attempting to join game session $gameCode');

      // First, get the game session
      final sessionResponse = await _supabase
          .from('multiplayer_game_sessions')
          .select()
          .eq('game_code', gameCode)
          .single();

      _currentGameSession = MultiplayerGameSession.fromJson(sessionResponse);
      AppLogger.info('Found game session: ${_currentGameSession!.id}, status: ${_currentGameSession!.status}');

      // Check if player can join (server-side validation)
      if (!isOrganizer) {
        try {
          final canJoinResult = await _supabase.rpc('can_join_game_session', params: {
            'p_game_session_id': _currentGameSession!.id,
            'p_player_id': playerId,
          });

          if (canJoinResult == null || canJoinResult.isEmpty) {
            AppLogger.warning('Server-side join validation failed for player $playerId');
            return false;
          }

          final result = canJoinResult[0] as Map<String, dynamic>;
          final canJoin = result['can_join'] as bool? ?? false;
          final reason = result['reason'] as String?;

          if (!canJoin) {
            AppLogger.warning('Player $playerId cannot join game $gameCode: $reason');
            _error = reason ?? 'Kan niet deelnemen aan dit spel';
            return false;
          }
        } catch (e) {
          AppLogger.warning('Failed to check join eligibility server-side, proceeding with caution: $e');
        }
      }

      // Check if player already exists
      final existingPlayer = await _supabase
          .from('multiplayer_game_players')
          .select()
          .eq('game_session_id', _currentGameSession!.id)
          .eq('player_id', playerId)
          .maybeSingle();

      if (existingPlayer != null) {
        AppLogger.info('Reconnecting existing player: ${existingPlayer['player_name']}');
        // Reconnect existing player
        await _supabase
            .from('multiplayer_game_players')
            .update({
              'is_connected': true,
              'last_seen_at': DateTime.now().toIso8601String(),
            })
            .eq('id', existingPlayer['id']);

        _currentPlayer = MultiplayerPlayer.fromJson(existingPlayer);
      } else {
        AppLogger.info('Adding new player: $playerName');
        // Add new player
        final playerResponse = await _supabase
            .from('multiplayer_game_players')
            .insert({
              'game_session_id': _currentGameSession!.id,
              'player_id': playerId,
              'player_name': playerName,
              'is_organizer': isOrganizer,
            })
            .select()
            .single();

        _currentPlayer = MultiplayerPlayer.fromJson(playerResponse);
      }

      // Load all players
      await _loadPlayers();

      AppLogger.info('Player $playerName successfully joined game session $gameCode');
      return true;
    } catch (e) {
      AppLogger.error('Failed to join game session $gameCode for player $playerName', e);
      return false;
    }
  }

  // Start the game (organizer only)
  Future<bool> startGame() async {
    if (!isOrganizer || _currentGameSession == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      await _supabase
          .from('multiplayer_game_sessions')
          .update({
            'status': GameStatus.active.name,
            'current_question_start_time': DateTime.now().toIso8601String(),
          })
          .eq('id', _currentGameSession!.id);

      _currentGameSession = _currentGameSession!.copyWith(
        status: GameStatus.active,
        currentQuestionStartTime: DateTime.now(),
      );

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _error = 'Failed to start game: $e';
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Failed to start game', e);
      return false;
    }
  }

  // Submit answer for current question
  Future<bool> submitAnswer(String answer, int answerTimeSeconds) async {
    if (_currentGameSession == null || _currentPlayer == null || currentQuestion == null) {
      AppLogger.warning('submitAnswer called with invalid state: gameSession=${_currentGameSession != null}, player=${_currentPlayer != null}, question=${currentQuestion != null}');
      return false;
    }

    final submitTime = DateTime.now();
    AppLogger.info('Player ${_currentPlayer!.playerName} (${_currentPlayer!.playerId}) attempting to submit answer for question $currentQuestionIndex at $submitTime');

    // Prevent multiple submissions for the same question
    if (_currentPlayer!.currentAnswer != null && _currentPlayer!.currentAnswer!.isNotEmpty) {
      AppLogger.warning('Player ${_currentPlayer!.playerName} prevented from submitting - already answered: "${_currentPlayer!.currentAnswer}"');
      return false; // Already answered
    }

    try {
      // Server-side validation and scoring using RPC call
      final validationResult = await _supabase.rpc('validate_and_score_answer', params: {
        'p_game_session_id': _currentGameSession!.id,
        'p_player_id': _currentPlayer!.playerId,
        'p_question_index': currentQuestionIndex,
        'p_answer': answer,
        'p_answer_time_seconds': answerTimeSeconds,
      });

      if (validationResult == null || validationResult.isEmpty) {
        AppLogger.error('Server-side validation failed - no result returned');
        return false;
      }

      final result = validationResult[0] as Map<String, dynamic>;
      final isCorrect = result['is_correct'] as bool? ?? false;
      final points = result['points_earned'] as int? ?? 0;
      final validationError = result['validation_error'] as String?;

      if (validationError != null) {
        AppLogger.warning('Server-side validation error: $validationError');
        return false;
      }

      AppLogger.info('Server-side validation: answer="$answer", isCorrect=$isCorrect, points=$points');

      // Use database transaction for atomic updates
      final transactionResult = await _supabase.rpc('submit_answer_transaction', params: {
        'p_player_id': _currentPlayer!.id,
        'p_game_session_id': _currentGameSession!.id,
        'p_question_index': currentQuestionIndex,
        'p_answer': answer,
        'p_is_correct': isCorrect,
        'p_answer_time_seconds': answerTimeSeconds,
        'p_points_earned': points,
      });

      if (transactionResult == null) {
        AppLogger.error('Transaction failed - no result returned');
        return false;
      }

      final newScore = transactionResult['new_score'] as int?;
      if (newScore == null) {
        AppLogger.error('Transaction failed - invalid score returned');
        return false;
      }

      // Update local player state
      _currentPlayer = _currentPlayer!.copyWith(
        score: newScore,
        currentAnswer: answer,
        answerTimeSeconds: answerTimeSeconds,
      );

      final totalTime = DateTime.now().difference(submitTime);
      AppLogger.info('Answer submission completed successfully for player ${_currentPlayer!.playerName} in ${totalTime.inMilliseconds}ms');

      notifyListeners();
      return true;
    } catch (e) {
      final totalTime = DateTime.now().difference(submitTime);
      AppLogger.error('Failed to submit answer for player ${_currentPlayer!.playerName} after ${totalTime.inMilliseconds}ms', e);
      return false;
    }
  }

  // Move to next question (organizer only)
  Future<bool> nextQuestion() async {
    if (!isOrganizer || _currentGameSession == null) return false;

    try {
      final nextIndex = currentQuestionIndex + 1;
      final isFinished = nextIndex >= _questions.length;

      await _supabase
          .from('multiplayer_game_sessions')
          .update({
            'current_question_index': nextIndex,
            'status': isFinished ? GameStatus.finished.name : GameStatus.active.name,
            'current_question_start_time': isFinished ? null : DateTime.now().toIso8601String(),
          })
          .eq('id', _currentGameSession!.id);

      _currentGameSession = _currentGameSession!.copyWith(
        currentQuestionIndex: nextIndex,
        status: isFinished ? GameStatus.finished : GameStatus.active,
        currentQuestionStartTime: isFinished ? null : DateTime.now(),
      );

      // Clear current answers for all players
      await _supabase
          .from('multiplayer_game_players')
          .update({
            'current_answer': null,
            'answer_time_seconds': null,
          })
          .eq('game_session_id', _currentGameSession!.id);

      notifyListeners();

      return true;
    } catch (e) {
      AppLogger.error('Failed to move to next question', e);
      return false;
    }
  }

  // Leave game session
  Future<void> leaveGameSession() async {
    if (_currentPlayer != null) {
      try {
        await _supabase
            .from('multiplayer_game_players')
            .update({'is_connected': false})
            .eq('id', _currentPlayer!.id);
      } catch (e) {
        AppLogger.error('Failed to update player connection status', e);
      }
    }

    _cleanup();
  }

  // Private methods
  Future<String> _generateGameCode() async {
    const uuid = Uuid();
    String code;
    Map<String, dynamic>? exists;

    do {
      code = uuid.v4().substring(0, 6).toUpperCase();
      exists = await _supabase
          .from('multiplayer_game_sessions')
          .select('id')
          .eq('game_code', code)
          .maybeSingle();
    } while (exists != null);

    return code;
  }

  Future<void> _loadQuestions() async {
    if (_currentGameSession == null) return;

    try {
      // First try to load from server-side storage
      final serverQuestions = await _loadQuestionsFromServer();
      if (serverQuestions.isNotEmpty) {
        _questions = serverQuestions;
        AppLogger.info('Loaded ${serverQuestions.length} questions from server');
        return;
      }

      // Load questions from cache service
      final language = 'nl'; // Default language

      _questions = await _questionCacheService.getQuestions(
        language,
        startIndex: 0,
        count: _currentGameSession!.gameSettings['num_questions'] ?? 10,
      );

      // Store and shuffle questions server-side for validation
      await _shuffleAndStoreQuestionsServerSide();

      AppLogger.info('Loaded and stored ${questions.length} questions with server-side shuffling');
    } catch (e) {
      AppLogger.error('Failed to load questions', e);
    }
  }

  Future<List<QuizQuestion>> _loadQuestionsFromServer() async {
    try {
      final response = await _supabase
          .from('game_session_questions')
          .select('question_index, question_text, correct_answer, options')
          .eq('game_session_id', _currentGameSession!.id)
          .order('question_index');

      return response.map((json) => QuizQuestion(
        id: 'server_${json['question_index']}', // Generate ID from index
        question: json['question_text'],
        correctAnswer: json['correct_answer'],
        incorrectAnswers: [], // Not stored, will be empty for now
        difficulty: 'medium', // Default difficulty
        type: QuestionType.fitb, // Default to fill-in-the-blank
      )).toList();
    } catch (e) {
      AppLogger.warning('Failed to load questions from server, will use cache: $e');
      return [];
    }
  }

  Future<void> _shuffleAndStoreQuestionsServerSide() async {
    if (_currentGameSession == null || _questions.isEmpty) return;

    try {
      // Convert questions to JSONB format for server-side processing
      final questionsJson = _questions.map((question) => {
        'question': question.question,
        'correctAnswer': question.correctAnswer,
        'incorrectAnswers': question.incorrectAnswers,
      }).toList();

      // Use server-side function for shuffling and storage
      await _supabase.rpc('shuffle_and_store_questions', params: {
        'p_game_session_id': _currentGameSession!.id,
        'p_questions': questionsJson,
      });

      AppLogger.info('Stored and shuffled ${_questions.length} questions server-side');
    } catch (e) {
      AppLogger.error('Failed to shuffle and store questions server-side', e);
    }
  }

  Future<void> _loadPlayers() async {
    if (_currentGameSession == null) {
      AppLogger.warning('_loadPlayers called with no current game session');
      return;
    }

    try {
      AppLogger.debug('Loading players for game session ${_currentGameSession!.gameCode}');
      final response = await _supabase
          .from('multiplayer_game_players')
          .select()
          .eq('game_session_id', _currentGameSession!.id)
          .order('joined_at');

      _players = response.map((json) => MultiplayerPlayer.fromJson(json)).toList();
      AppLogger.info('Loaded ${_players.length} players for game session ${_currentGameSession!.gameCode}');
      notifyListeners();
    } catch (e) {
      AppLogger.error('Failed to load players for game session ${_currentGameSession!.gameCode}', e);
    }
  }

  void _setupRealtimeSubscriptions() {
    if (_currentGameSession == null) return;

    AppLogger.info('Setting up real-time subscriptions for game session ${_currentGameSession!.gameCode}');

    // Clean up existing subscriptions first
    _cleanupRealtimeSubscriptions();

    try {
      // Subscribe to game session changes
      _gameChannel = _supabase
          .channel('game_session_${_currentGameSession!.id}')
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'multiplayer_game_sessions',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'id',
              value: _currentGameSession!.id,
            ),
            callback: (payload) {
              AppLogger.debug('Game session update received: ${payload.eventType} for session ${_currentGameSession!.gameCode}');
              try {
                final updatedSession = MultiplayerGameSession.fromJson(payload.newRecord);
                AppLogger.info('Game session updated: status=${updatedSession.status}, questionIndex=${updatedSession.currentQuestionIndex}');
                _currentGameSession = updatedSession;
                notifyListeners();
              } catch (e) {
                AppLogger.error('Failed to parse game session update', e);
              }
            },
          )
          .subscribe();

      // Subscribe to player changes
      _playersChannel = _supabase
          .channel('game_players_${_currentGameSession!.id}')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'multiplayer_game_players',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'game_session_id',
              value: _currentGameSession!.id,
            ),
            callback: (payload) {
              AppLogger.debug('Player change received: ${payload.eventType} for session ${_currentGameSession!.gameCode}');
              try {
                _loadPlayers(); // Reload all players
              } catch (e) {
                AppLogger.error('Failed to reload players after change', e);
              }
            },
          )
          .subscribe();

      AppLogger.info('Real-time subscriptions set up successfully');
    } catch (e) {
      AppLogger.error('Failed to set up real-time subscriptions', e);
      _cleanupRealtimeSubscriptions();
    }
  }

  void _cleanupRealtimeSubscriptions() {
    try {
      _gameChannel?.unsubscribe();
      _gameChannel = null;
    } catch (e) {
      AppLogger.warning('Error cleaning up game channel: $e');
    }

    try {
      _playersChannel?.unsubscribe();
      _playersChannel = null;
    } catch (e) {
      AppLogger.warning('Error cleaning up players channel: $e');
    }
  }


  void _startHeartbeat() {
    AppLogger.info('Starting heartbeat for player ${_currentPlayer?.playerName}');
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) async {
      if (_currentPlayer != null) {
        final heartbeatTime = DateTime.now();
        AppLogger.debug('Sending heartbeat for player ${_currentPlayer!.playerName} at $heartbeatTime');
        try {
          await _supabase
              .from('multiplayer_game_players')
              .update({
                'last_seen_at': DateTime.now().toIso8601String(),
                'is_connected': true,
              })
              .eq('id', _currentPlayer!.id);
          AppLogger.debug('Heartbeat sent successfully for player ${_currentPlayer!.playerName}');
        } catch (e) {
          AppLogger.error('Failed to send heartbeat for player ${_currentPlayer!.playerName}', e);
          // If heartbeat fails, mark as disconnected
          _handleDisconnection();
        }
      } else {
        AppLogger.warning('Heartbeat timer triggered but no current player');
      }
    });

    // Set up disconnect timer
    _disconnectTimer?.cancel();
    _disconnectTimer = Timer(_disconnectTimeout, () {
      AppLogger.warning('Disconnect timeout reached for player ${_currentPlayer?.playerName}');
      _handleDisconnection();
    });
    AppLogger.info('Heartbeat and disconnect timer started');
  }

  void _handleDisconnection() {
    AppLogger.warning('Player ${_currentPlayer?.playerName} disconnected from game session ${_currentGameSession?.gameCode}');

    if (_currentPlayer != null && _currentGameSession != null) {
      // Mark as disconnected but don't clean up completely
      _currentPlayer = _currentPlayer!.copyWith(isConnected: false);
      notifyListeners();

      // Attempt automatic reconnection after a delay
      Future.delayed(const Duration(seconds: 5), () {
        if (_currentPlayer != null && !_currentPlayer!.isConnected) {
          _attemptReconnection();
        }
      });
    } else {
      _cleanup();
    }
  }

  Future<void> _attemptReconnection() async {
    if (_currentPlayer == null || _currentGameSession == null) return;

    try {
      AppLogger.info('Attempting to reconnect player ${_currentPlayer!.playerName} to game ${_currentGameSession!.gameCode}');

      // Update connection status
      await _supabase
          .from('multiplayer_game_players')
          .update({
            'is_connected': true,
            'last_seen_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _currentPlayer!.id);

      _currentPlayer = _currentPlayer!.copyWith(isConnected: true);

      // Re-setup subscriptions if needed
      if (_gameChannel == null || _playersChannel == null) {
        _setupRealtimeSubscriptions();
      }

      // Restart heartbeat
      _startHeartbeat();

      AppLogger.info('Successfully reconnected player ${_currentPlayer!.playerName}');
      notifyListeners();
    } catch (e) {
      AppLogger.error('Failed to reconnect player ${_currentPlayer!.playerName}', e);

      // If reconnection fails, wait longer and try again
      Future.delayed(const Duration(seconds: 30), () {
        if (_currentPlayer != null && !_currentPlayer!.isConnected) {
          _attemptReconnection();
        }
      });
    }
  }

  // Manual reconnection method for user-initiated reconnection
  Future<bool> reconnectToGame() async {
    if (_currentPlayer == null || _currentGameSession == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      await _attemptReconnection();

      _isLoading = false;
      notifyListeners();

      return _currentPlayer?.isConnected ?? false;
    } catch (e) {
      _error = 'Kon niet opnieuw verbinden: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Rate limiting methods
  bool _checkJoinRateLimit(String gameCode) {
    final now = DateTime.now();
    final attempts = _joinAttempts[gameCode] ?? [];

    // Remove old attempts outside the window
    final validAttempts = attempts.where((attempt) =>
        now.difference(attempt) <= _joinAttemptWindow).toList();

    _joinAttempts[gameCode] = validAttempts;

    return validAttempts.length < _maxJoinAttempts;
  }

  void _recordJoinAttempt(String gameCode) {
    final now = DateTime.now();
    _joinAttempts.putIfAbsent(gameCode, () => []).add(now);

    // Clean up old entries periodically
    if (_joinAttempts.length > 100) {
      _cleanupOldJoinAttempts();
    }
  }

  void _cleanupOldJoinAttempts() {
    final now = DateTime.now();
    _joinAttempts.removeWhere((gameCode, attempts) {
      final validAttempts = attempts.where((attempt) =>
          now.difference(attempt) <= _joinAttemptWindow).toList();
      return validAttempts.isEmpty;
    });
  }

  void _cleanup() {
    AppLogger.info('Cleaning up multiplayer provider resources');

    // Cancel timers first
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;

    _disconnectTimer?.cancel();
    _disconnectTimer = null;

    // Clean up real-time subscriptions
    _cleanupRealtimeSubscriptions();

    // Clear data
    _currentGameSession = null;
    _currentPlayer = null;
    _players = [];
    _questions = [];
    _error = null;

    notifyListeners();
    AppLogger.info('Multiplayer provider cleanup completed');
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }
}