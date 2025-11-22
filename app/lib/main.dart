import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:io' show Platform;
import 'package:app_links/app_links.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart' show Level;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'providers/settings_provider.dart';
import 'providers/game_stats_provider.dart';
import 'providers/messages_provider.dart';
import 'providers/lesson_progress_provider.dart';
import 'providers/multiplayer_provider.dart';
import 'utils/theme_utils.dart';
import 'services/logger.dart';
import 'services/service_container.dart';
import 'services/analytics_service.dart';
import 'services/time_tracking_service.dart';
import 'services/api_service.dart';
import 'services/messaging_service.dart';
import 'services/question_cache_service.dart';
import 'services/connection_service.dart';
import 'utils/bijbelquiz_gen_utils.dart';
import 'screens/bijbelquiz_gen_screen.dart';
import 'screens/store_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'settings_screen.dart';
import 'screens/sync_screen.dart';
import 'screens/stats_share_screen.dart';
import 'l10n/strings_nl.dart' as strings;
import 'config/supabase_config.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// The main entry point of the BijbelQuiz application with simplified service initialization.
Future<void> main() async {
  // Ensure that the Flutter binding is initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.info('BijbelQuiz app starting up...');

  try {
    // Initialize logging with secure settings based on environment
    bool isProduction =
        const bool.fromEnvironment('dart.vm.product', defaultValue: false);
    AppLogger.setSecureLevel(
        isProduction: isProduction,
        productionLevel: Level.INFO,
        developmentLevel: Level.ALL);
    AppLogger.info(
        'Logger initialized successfully with secure settings (Production: $isProduction)');

    // Load environment variables
    AppLogger.info('Loading environment variables...');
    await dotenv.load(fileName: "assets/.env");
    AppLogger.info('Environment variables loaded successfully');

    // Initialize Supabase
    AppLogger.info('Initializing Supabase...');
    await SupabaseConfig.initialize();
    AppLogger.info('Supabase initialized successfully');

    // Set preferred screen orientations. On web, this helps maintain a consistent layout.
    if (kIsWeb) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    // Initialize service container with critical services first
    final serviceContainer = ServiceContainer();
    final startTime = DateTime.now();

    await serviceContainer.initializeCriticalServices();

    // Initialize services needed for multiplayer synchronously
    AppLogger.info('Initializing multiplayer-required services...');
    final connectionService = ConnectionService();
    await connectionService.initialize();
    final questionCacheService = QuestionCacheService(connectionService);
    await questionCacheService.initialize();

    // Create providers for the app
    final gameStatsProvider = serviceContainer.gameStatsProvider;
    final settingsProvider = serviceContainer.settingsProvider;
    final lessonProgressProvider = LessonProgressProvider();
    final multiplayerProvider = MultiplayerProvider(
      questionCacheService,
      connectionService,
    );

    // Set up sync listeners for real-time updates
    gameStatsProvider.setupSyncListener();
    settingsProvider.setupSyncListener();
    lessonProgressProvider.setupSyncListener();

    AppLogger.info('Starting Flutter app with service container...');
    runApp(
      MultiProvider(
        providers: [
          // Core providers from service container
          ChangeNotifierProvider.value(value: settingsProvider),
          ChangeNotifierProvider.value(value: gameStatsProvider),
          ChangeNotifierProvider.value(value: lessonProgressProvider),
          ChangeNotifierProvider.value(value: multiplayerProvider),

          // Service container access
          Provider.value(value: serviceContainer),
          Provider.value(value: serviceContainer.analyticsService),
          Provider.value(value: serviceContainer.themeManager),
          Provider.value(value: serviceContainer.timeTrackingService),

          // Optional services (can be null)
          Provider.value(value: serviceContainer.performanceService),
          Provider.value(value: serviceContainer.connectionService),
          Provider.value(value: serviceContainer.questionCacheService),
          Provider.value(value: serviceContainer.geminiService),
          Provider.value(value: serviceContainer.starTransactionService),
          Provider.value(value: serviceContainer.messagingService),
          Provider.value(value: serviceContainer.notificationService),

          // Messaging service and provider
          Provider(
              create: (_) =>
                  serviceContainer.messagingService ?? MessagingService()),
          ChangeNotifierProvider(create: (context) {
            final messagingService =
                Provider.of<MessagingService>(context, listen: false);
            final messagesProvider = MessagesProvider(messagingService);
            messagesProvider.initialize();
            return messagesProvider;
          }),
        ],
        child: BijbelQuizApp(),
      ),
    );

    final appStartDuration = DateTime.now().difference(startTime);
    AppLogger.info(
        'Flutter app started successfully in ${appStartDuration.inMilliseconds}ms');

    // Initialize optional services in background (don't wait for these)
    serviceContainer.initializeOptionalServices();

    // Track app launch performance
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        AppLogger.info(
            'App fully loaded in ${appStartDuration.inMilliseconds}ms');
      } catch (e) {
        AppLogger.error('Error in app startup callback', e);
      }
    });
  } catch (e, stackTrace) {
    AppLogger.error('Critical error during app initialization', e, stackTrace);
    // Re-run with minimal error handling if needed
    rethrow;
  }
}

class BijbelQuizApp extends StatefulWidget {
  const BijbelQuizApp({super.key});

  @override
  State<BijbelQuizApp> createState() => _BijbelQuizAppState();
}

class _BijbelQuizAppState extends State<BijbelQuizApp> {
  StreamSubscription? _sub;
  late ServiceContainer _serviceContainer;

  @override
  void initState() {
    super.initState();
    AppLogger.info('BijbelQuizApp state initializing...');

    _serviceContainer = Provider.of<ServiceContainer>(context, listen: false);

    // Initialize Star Transaction Service with proper dependencies
    _initializeStarTransactionService();

    // Set up deep link handling
    _initDeepLinks();

    // Track app lifecycle for session management
    _trackAppLifecycle();
  }

  /// Initialize Star Transaction Service with required providers
  Future<void> _initializeStarTransactionService() async {
    try {
      final gameStatsProvider =
          Provider.of<GameStatsProvider>(context, listen: false);
      final lessonProgressProvider =
          Provider.of<LessonProgressProvider>(context, listen: false);

      await _serviceContainer.initializeStarTransactionService(
        gameStatsProvider: gameStatsProvider,
        lessonProgressProvider: lessonProgressProvider,
      );
    } catch (e) {
      AppLogger.warning('Failed to initialize star transaction service: $e');
    }
  }

  // Initialize deep link handling
  void _initDeepLinks() async {
    // For web platforms, use query parameters
    if (kIsWeb) {
      final uri = Uri.base;
      if (uri.path.startsWith('/stats') ||
          uri.path.startsWith('/gen.html') ||
          uri.hasQuery) {
        _handleDeepLink(uri);
      }
    } else if (Platform.isAndroid || Platform.isIOS) {
      // For mobile platforms, use app_links
      _sub = AppLinks().uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      }, onError: (err) {
        AppLogger.error('Error handling deep link: $err');
      });
    } else {
      // For other platforms (Linux, Windows, macOS), skip deep link handling
      AppLogger.info(
          'Skipping deep link handling on ${Platform.operatingSystem} platform');
    }
  }

  void _handleDeepLink(Uri uri) {
    // Check if this is a stats share URL
    if (uri.path.startsWith('/stats') ||
        uri.path.startsWith('/gen.html') ||
        uri.queryParameters.containsKey('score')) {
      final params = <String, String>{};

      // Add all query parameters to the map
      uri.queryParameters.forEach((key, value) {
        params[key] = value;
      });

      // If we have the necessary parameters to show stats, navigate to the stats share screen
      if (params.containsKey('score') || params.containsKey('currentStreak')) {
        // Use a callback to navigate once the app is fully built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            // Use the navigator key to navigate from the root
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (_) => StatsShareScreen(statsData: params),
              ),
            );
          }
        });
      }
    }
  }

  /// Track app lifecycle events for session management
  void _trackAppLifecycle() {
    final analyticsService = _serviceContainer.analyticsService;
    final timeTrackingService = _serviceContainer.timeTrackingService;
    AppLifecycleObserver(analyticsService, timeTrackingService).observe();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Start time tracking when the app widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timeTrackingService = _serviceContainer.timeTrackingService;

      if (!timeTrackingService.hasOngoingSession()) {
        timeTrackingService.startSession();
      }

      // Check if we're in the BijbelQuiz Gen period and redirect if needed
      if (BijbelQuizGenPeriod.isGenPeriod() &&
          !timeTrackingService.hasGenBeenShownThisPeriod()) {
        // Mark the Gen as shown for this period before navigating
        timeTrackingService.markGenAsShownThisPeriod();

        // Small delay to ensure context is ready
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && navigatorKey.currentState != null) {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (_) => const BijbelQuizGenScreen(),
              ),
            );
          }
        });
      }
    });

    // Handle API server lifecycle based on settings
    _handleApiServerLifecycle();
  }

  /// Handle API server lifecycle based on settings changes
  void _handleApiServerLifecycle() {
    WidgetsBinding.instance
        .addPostFrameCallback(_handleApiServerLifecycleAsync);
  }

  Future<void> _handleApiServerLifecycleAsync(Duration timestamp) async {
    if (!mounted) return;

    try {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final apiService = Provider.of<ApiService?>(context, listen: false);
      final questionCacheService =
          Provider.of<QuestionCacheService?>(context, listen: false);

      if (apiService == null || questionCacheService == null) return;

      if (settings.apiEnabled && settings.apiKey.isNotEmpty) {
        // Start API server if not already running
        if (!apiService.isRunning) {
          final gameStatsProvider =
              Provider.of<GameStatsProvider>(context, listen: false);
          final lessonProgressProvider =
              Provider.of<LessonProgressProvider>(context, listen: false);

          await apiService.startServer(
            port: settings.apiPort,
            apiKey: settings.apiKey,
            settingsProvider: settings,
            gameStatsProvider: gameStatsProvider,
            lessonProgressProvider: lessonProgressProvider,
            questionCacheService: questionCacheService,
          );
          AppLogger.info('API server started via settings change');
        }
      } else {
        // Stop API server if running
        if (apiService.isRunning) {
          await apiService.stopServer();
          AppLogger.info('API server stopped via settings change');
        }
      }
    } catch (e) {
      AppLogger.error('Error managing API server lifecycle: $e');
      // Show user-friendly error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${strings.AppStrings.apiErrorPrefix}${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Builds the MaterialApp with theme configuration
  Widget _buildMaterialApp(SettingsProvider settings) {
    final analyticsService = _serviceContainer.analyticsService;

    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [analyticsService.getObserver()],
      title: strings.AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeUtils.getLightTheme(settings),
      darkTheme: ThemeUtils.getDarkTheme(settings),
      themeMode: ThemeUtils.getThemeMode(settings),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('nl', ''), // Dutch
        Locale('en', ''), // English
      ],
      locale: Locale(settings.language, ''),
      routes: {
        '/store': (context) => const StoreScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/userId': (context) => const SyncScreen(),
      },
      home: const MainNavigationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // For deep link handling after app is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Wait a bit to ensure the app is fully initialized before checking for deep links
      Future.delayed(const Duration(milliseconds: 100), () {
        if (kIsWeb) {
          // For web, check current URI for stats parameters
          final uri = Uri.base;
          if (uri.path.startsWith('/stats') ||
              uri.path.startsWith('/gen.html') ||
              uri.hasQuery) {
            _handleDeepLink(uri);
          }
        }
      });
    });

    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        final app = _buildMaterialApp(settings);
        return app;
      },
    );
  }

  @override
  void dispose() {
    AppLogger.info('BijbelQuizApp disposing...');

    // Stop API server if running
    final apiService = Provider.of<ApiService?>(context, listen: false);
    apiService?.stopServer().then((_) {
      AppLogger.info('API server stopped during app disposal');
    }).catchError((e) {
      AppLogger.error('Error stopping API server during disposal: $e');
    });

    // Dispose service container
    _serviceContainer.dispose();

    // Cancel the deep link subscription
    _sub?.cancel();

    AppLogger.info('BijbelQuizApp disposed successfully');
    super.dispose();
  }
}

/// Observer class to track app lifecycle events
class AppLifecycleObserver {
  final TimeTrackingService _timeTrackingService;

  AppLifecycleObserver(
      AnalyticsService analyticsService, this._timeTrackingService);

  void observe() {
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver(this));
  }
}

class _AppLifecycleObserver extends WidgetsBindingObserver {
  final AppLifecycleObserver _parent;

  _AppLifecycleObserver(this._parent);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        AppLogger.info('App lifecycle: resumed');
        // Start a new session when app is resumed (brought to foreground)
        _parent._timeTrackingService.startSession();
        // Check for new messages when app is resumed
        _checkForMessagesOnAppResume();
        break;
      case AppLifecycleState.paused:
        AppLogger.info('App lifecycle: paused');
        // End the current session when app is paused (sent to background)
        _parent._timeTrackingService.endSession();
        break;
      case AppLifecycleState.inactive:
        AppLogger.info('App lifecycle: inactive');
        // End session when app becomes inactive (e.g., phone call, notification overlay)
        if (_parent._timeTrackingService.hasOngoingSession()) {
          _parent._timeTrackingService.endSession();
        }
        break;
      case AppLifecycleState.detached:
        AppLogger.info('App lifecycle: detached');
        // End session when app is detached
        _parent._timeTrackingService.endSession();
        break;
      case AppLifecycleState.hidden:
        AppLogger.info('App lifecycle: hidden');
        // End session when app is hidden (e.g., app moved to background)
        if (_parent._timeTrackingService.hasOngoingSession()) {
          _parent._timeTrackingService.endSession();
        }
        break;
    }
  }

  /// Check for messages when the app is resumed
  void _checkForMessagesOnAppResume() {
    try {
      final context = navigatorKey.currentContext;
      if (context != null) {
        final messagesProvider =
            Provider.of<MessagesProvider>(context, listen: false);
        messagesProvider.checkForNewMessages();
      }
    } catch (e) {
      AppLogger.warning('Could not check for messages on app resume: $e');
    }
  }
}
