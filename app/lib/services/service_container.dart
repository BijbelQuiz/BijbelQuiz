import 'dart:async';
import 'logger.dart';
import 'performance_service.dart';
import 'connection_service.dart';
import 'question_cache_service.dart';
import 'gemini_service.dart';
import 'star_transaction_service.dart';
import 'time_tracking_service.dart';
import 'local_api_service.dart';
import '../providers/settings_provider.dart';
import '../providers/game_stats_provider.dart';
import '../providers/lesson_progress_provider.dart';
import '../theme/theme_manager.dart';
import 'messaging_service.dart';
import 'notification_service.dart';

/// Container for managing service lifecycle and dependencies
class ServiceContainer {
  static final ServiceContainer _instance = ServiceContainer._internal();
  factory ServiceContainer() => _instance;
  ServiceContainer._internal();

  // Core services (critical for app startup)
  ThemeManager? _themeManager;
  SettingsProvider? _settingsProvider;
  GameStatsProvider? _gameStatsProvider;
  TimeTrackingService? _timeTrackingService;

  // Optional services (non-critical, can fail gracefully)
  PerformanceService? _performanceService;
  ConnectionService? _connectionService;
  QuestionCacheService? _questionCacheService;
  GeminiService? _geminiService;
  StarTransactionService? _starTransactionService;
  MessagingService? _messagingService;
  NotificationService? _notificationService;
  LocalApiService? _localApiService;

  // Initialization state tracking
  final Map<String, Completer<void>> _initializationCompleters = {};
  final Set<String> _failedServices = {};

  /// Initialize critical services that are required for app startup
  Future<void> initializeCriticalServices() async {
    AppLogger.info('Initializing critical services...');

    try {
      // Theme manager (required for UI)
      final themeStart = DateTime.now();
      await _initializeService('theme_manager', () async {
        _themeManager = ThemeManager();
        await _themeManager!.initialize();
      });
      final themeDuration = DateTime.now().difference(themeStart);
      AppLogger.info(
          'Theme manager initialized in ${themeDuration.inMilliseconds}ms');

      // Settings provider (required for app configuration)
      final settingsStart = DateTime.now();
      await _initializeService('settings_provider', () async {
        _settingsProvider = SettingsProvider();
        await _settingsProvider!.loadSettings();
      });
      final settingsDuration = DateTime.now().difference(settingsStart);
      AppLogger.info(
          'Settings provider initialized in ${settingsDuration.inMilliseconds}ms');

      // Game stats provider (required for core functionality)
      final gameStatsStart = DateTime.now();
      await _initializeService('game_stats_provider', () async {
        _gameStatsProvider = GameStatsProvider();
      });
      final gameStatsDuration = DateTime.now().difference(gameStatsStart);
      AppLogger.info(
          'Game stats provider initialized in ${gameStatsDuration.inMilliseconds}ms');

      // Time tracking service (singleton)
      final timeTrackingStart = DateTime.now();
      await _initializeService('time_tracking', () async {
        _timeTrackingService = TimeTrackingService.instance;
        await _timeTrackingService!.initialize();
      });
      final timeTrackingDuration = DateTime.now().difference(timeTrackingStart);
      AppLogger.info(
          'Time tracking service initialized in ${timeTrackingDuration.inMilliseconds}ms');

      AppLogger.info('Critical services initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize critical services', e);
      rethrow;
    }
  }

  /// Initialize optional services in the background
  Future<void> initializeOptionalServices() async {
    AppLogger.info('Initializing optional services in background...');

    // Start all optional service initializations in parallel
    unawaited(_initializeService('performance', () async {
      _performanceService = PerformanceService();
      await _performanceService!.initialize();
    }));

    unawaited(_initializeService('connection', () async {
      _connectionService = ConnectionService();
      await _connectionService!.initialize();
    }));

    unawaited(_initializeService('question_cache', () async {
      // Question cache depends on connection service
      await _waitForService('connection');
      _questionCacheService = QuestionCacheService(_connectionService!);
      await _questionCacheService!.initialize();
    }));

    unawaited(_initializeService('gemini', () async {
      _geminiService = GeminiService.instance;
      // Don't wait for Gemini - it can fail gracefully
      _geminiService!.initialize().catchError((e) {
        AppLogger.warning(
            'Gemini service initialization failed (API key may be missing): $e');
        _failedServices.add('gemini');
      });
    }));

    unawaited(_initializeService('messaging', () async {
      _messagingService = MessagingService();
    }));

    unawaited(_initializeService('notification', () async {
      _notificationService = NotificationService();
      await _notificationService!.initialize();
      await _notificationService!.checkAndScheduleDailyNotifications();
    }));

    // Star transaction service needs providers to be ready
    unawaited(_initializeService('star_transaction', () async {
      await _waitForService('settings_provider');
      await _waitForService('game_stats_provider');

      _starTransactionService = StarTransactionService.instance;
      // This will be initialized properly later when providers are available
    }));

    // Local API service (needs providers and question cache)
    unawaited(_initializeService('local_api', () async {
      await _waitForService('settings_provider');
      await _waitForService('game_stats_provider');
      await _waitForService('question_cache');

      _localApiService = LocalApiService.instance;
      await _localApiService!.loadSettings();
    }));

    AppLogger.info('Optional services initialization started');
  }

  /// Initialize Star Transaction Service with required providers
  Future<void> initializeStarTransactionService({
    required GameStatsProvider gameStatsProvider,
    required LessonProgressProvider lessonProgressProvider,
  }) async {
    if (_starTransactionService != null &&
        !_isServiceInitialized('star_transaction')) {
      try {
        await _starTransactionService!.initialize(
          gameStatsProvider: gameStatsProvider,
          lessonProgressProvider: lessonProgressProvider,
        );
        _completeService('star_transaction');
      } catch (e) {
        AppLogger.error('Failed to initialize star transaction service', e);
        _failedServices.add('star_transaction');
      }
    }
  }

  /// Generic service initialization with error handling
  Future<void> _initializeService(
      String serviceName, Future<void> Function() initializer) async {
    if (_isServiceInitialized(serviceName)) return;

    final completer = Completer<void>();
    _initializationCompleters[serviceName] = completer;

    try {
      await initializer();
      completer.complete();
      AppLogger.info('Service initialized: $serviceName');
    } catch (e) {
      completer.completeError(e);
      _failedServices.add(serviceName);
      AppLogger.error('Failed to initialize service: $serviceName', e);
    }
  }

  /// Wait for a service to be initialized
  Future<void> _waitForService(String serviceName) async {
    if (_isServiceInitialized(serviceName)) return;

    final completer = _initializationCompleters[serviceName];
    if (completer != null) {
      await completer.future;
    }
  }

  /// Check if a service is initialized
  bool _isServiceInitialized(String serviceName) {
    return !_failedServices.contains(serviceName) &&
        _initializationCompleters[serviceName]?.isCompleted == true;
  }

  /// Mark service as completed (for services that don't use the generic initializer)
  void _completeService(String serviceName) {
    final completer = _initializationCompleters[serviceName];
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }

  // === Service Accessors ===

  ThemeManager get themeManager {
    if (_themeManager == null) {
      throw Exception('Theme manager not initialized');
    }
    return _themeManager!;
  }

  SettingsProvider get settingsProvider {
    if (_settingsProvider == null) {
      throw Exception('Settings provider not initialized');
    }
    return _settingsProvider!;
  }

  GameStatsProvider get gameStatsProvider {
    if (_gameStatsProvider == null) {
      throw Exception('Game stats provider not initialized');
    }
    return _gameStatsProvider!;
  }

  TimeTrackingService get timeTrackingService {
    if (_timeTrackingService == null) {
      throw Exception('Time tracking service not initialized');
    }
    return _timeTrackingService!;
  }

  PerformanceService? get performanceService => _performanceService;

  ConnectionService? get connectionService => _connectionService;

  QuestionCacheService? get questionCacheService => _questionCacheService;

  GeminiService? get geminiService =>
      _failedServices.contains('gemini') ? null : _geminiService;

  StarTransactionService? get starTransactionService => _starTransactionService;

  MessagingService? get messagingService => _messagingService;

  NotificationService? get notificationService => _notificationService;

  LocalApiService? get localApiService => _localApiService;

  /// Check if all critical services are ready
  bool get areCriticalServicesReady {
    return _themeManager != null &&
        _settingsProvider != null &&
        _gameStatsProvider != null &&
        _timeTrackingService != null;
  }

  /// Check if a specific service is available and working
  bool isServiceAvailable(String serviceName) {
    if (_failedServices.contains(serviceName)) return false;

    switch (serviceName) {
      case 'performance':
        return _performanceService != null;
      case 'connection':
        return _connectionService != null;
      case 'question_cache':
        return _questionCacheService != null;
      case 'gemini':
        return _geminiService != null && !_failedServices.contains('gemini');
      case 'star_transaction':
        return _starTransactionService != null &&
            _isServiceInitialized('star_transaction');
      case 'messaging':
        return _messagingService != null;
      case 'notification':
        return _notificationService != null;
      case 'local_api':
        return _localApiService != null;
      default:
        return false;
    }
  }

  /// Get initialization status for debugging
  Map<String, dynamic> getInitializationStatus() {
    return {
      'critical_services': {
        'theme_manager': _themeManager != null,
        'settings_provider': _settingsProvider != null,
        'game_stats_provider': _gameStatsProvider != null,
        'time_tracking': _timeTrackingService != null,
      },
      'optional_services': {
        'performance': _performanceService != null,
        'connection': _connectionService != null,
        'question_cache': _questionCacheService != null,
        'gemini': _geminiService != null && !_failedServices.contains('gemini'),
        'star_transaction': _starTransactionService != null &&
            _isServiceInitialized('star_transaction'),
        'messaging': _messagingService != null,
        'notification': _notificationService != null,
        'local_api': _localApiService != null,
      },
      'failed_services': _failedServices.toList(),
      'all_critical_ready': areCriticalServicesReady,
    };
  }

  /// Dispose of all services
  void dispose() {
    _performanceService?.dispose();
    _connectionService?.dispose();
    _questionCacheService?.dispose();
    _timeTrackingService?.dispose();

    // Clear state
    _initializationCompleters.clear();
    _failedServices.clear();

    AppLogger.info('Service container disposed');
  }
}
