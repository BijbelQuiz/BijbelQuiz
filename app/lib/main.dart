import 'package:bijbelquiz/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:io' show Platform;
import 'package:app_links/app_links.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart' show Level;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'providers/settings_provider.dart';
import 'providers/game_stats_provider.dart';
import 'utils/theme_utils.dart';
import 'theme/theme_manager.dart';
import 'services/logger.dart';
import 'services/notification_service.dart';
import 'services/performance_service.dart';
import 'services/connection_service.dart';
import 'services/question_cache_service.dart';
import 'services/gemini_service.dart';
import 'services/api_service.dart';
import 'services/star_transaction_service.dart';
import 'services/time_tracking_service.dart';
import 'utils/bijbelquiz_gen_utils.dart';
import 'screens/bijbelquiz_gen_screen.dart';
import 'screens/store_screen.dart';
import 'providers/lesson_progress_provider.dart';
import 'screens/main_navigation_screen.dart';
import 'settings_screen.dart';
import 'screens/sync_screen.dart';
import 'screens/stats_share_screen.dart';
import 'l10n/strings_nl.dart' as strings;
import 'config/supabase_config.dart';

final analyticsService = AnalyticsService();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// The main entry point of the BijbelQuiz application with performance optimizations.
void main() async {
  // Ensure that the Flutter binding is initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.info('BijbelQuiz app starting up...');

  // Initialize logging
  AppLogger.init(level: Level.INFO);
  AppLogger.info('Logger initialized successfully');

  // Initialize analytics
  AppLogger.info('Initializing analytics service...');
  await analyticsService.init();
  AppLogger.info('Analytics service initialized successfully');

  // Load environment variables
  AppLogger.info('Loading environment variables...');
  await dotenv.load(fileName: "assets/.env");
  AppLogger.info('Environment variables loaded successfully');

  // Initialize Supabase
  AppLogger.info('Initializing Supabase...');
  await SupabaseConfig.initialize();
  AppLogger.info('Supabase initialized successfully');
  
  // Initialize theme manager
  AppLogger.info('Initializing theme manager...');
  await ThemeManager().initialize();
  AppLogger.info('Theme manager initialized successfully');
  
  // Set preferred screen orientations. On web, this helps maintain a consistent layout.
  if (kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  
  final gameStatsProvider = GameStatsProvider();
  AppLogger.info('Game stats provider initialized');

  // Initialize settings provider and wait for it
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  AppLogger.info('Starting Flutter app with providers...');
  final appStartTime = DateTime.now();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: gameStatsProvider),
        ChangeNotifierProvider(create: (_) => LessonProgressProvider()),
        Provider.value(value: analyticsService),
      ],
      child: BijbelQuizApp(),
    ),
  );
  final appStartDuration = DateTime.now().difference(appStartTime);
  AppLogger.info('Flutter app started successfully in ${appStartDuration.inMilliseconds}ms');

  // Track app launch performance
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      // Analytics tracking removed - emergency service navigator key no longer available
      AppLogger.info('App started successfully in ${appStartDuration.inMilliseconds}ms');
    } catch (e) {
      AppLogger.error('Error in app startup', e);
    }
  });
}

class BijbelQuizApp extends StatefulWidget {
  const BijbelQuizApp({super.key});

  @override
  State<BijbelQuizApp> createState() => _BijbelQuizAppState();
}

class _BijbelQuizAppState extends State<BijbelQuizApp> {
  PerformanceService? _performanceService;
  ConnectionService? _connectionService;
  QuestionCacheService? _questionCacheService;
  GeminiService? _geminiService;
  // FeatureFlagsService removed
  ApiService? _apiService;
  StarTransactionService? _starTransactionService;
  TimeTrackingService _timeTrackingService = TimeTrackingService.instance;
  StreamSubscription? _sub;

  // Add mounted getter for older Flutter versions
  @override
  bool get mounted => _mounted;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    AppLogger.info('BijbelQuizApp state initializing...');

    // Set up deep link handling
    _initDeepLinks();

    // Track app lifecycle for session management
    _trackAppLifecycle();

    // Initialize time tracking service
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _timeTrackingService.initialize();
      
      // If there was an ongoing session (app crashed/force closed), end it
      if (_timeTrackingService.hasOngoingSession()) {
        _timeTrackingService.endSession();
      }
    });

    // Defer service initialization; don't block first render
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AppLogger.info('Starting deferred service initialization...');
      final performanceService = PerformanceService();
      final connectionService = ConnectionService();
      final questionCacheService = QuestionCacheService();
      // FeatureFlagsService removed
      final apiService = ApiService();

      // Initialize StarTransactionService with required providers
      AppLogger.info('Initializing star transaction service...');
      final starTransactionService = StarTransactionService.instance;

      // Initialize Gemini service (with error handling for missing API key)
      AppLogger.info('Initializing Gemini service...');
      final geminiService = GeminiService.instance;
      // Defer Gemini initialization to not block startup
      geminiService.initialize().catchError((e) {
        AppLogger.warning('Gemini service initialization failed (API key may be missing): $e');
        // Don't fail the entire app if Gemini API key is missing
        return null;
      });

      // Feature flags service removed

      // Set up connection status tracking
      connectionService.setConnectionStatusCallback((isConnected, connectionType) {
        // Connection status tracking removed - emergency service navigator key no longer available
        AppLogger.info('Connection status changed: ${isConnected ? 'connected' : 'disconnected'} ($connectionType)');
      });

      // Initialize StarTransactionService after providers are available
      AppLogger.info('Initializing star transaction service...');
      final starTransactionInitFuture = Future(() async {
        // Wait a bit for providers to be ready
        await Future.delayed(Duration(milliseconds: 100));
        final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
        final lessonProgressProvider = Provider.of<LessonProgressProvider>(context, listen: false);
        await starTransactionService.initialize(
          gameStatsProvider: gameStatsProvider,
          lessonProgressProvider: lessonProgressProvider,
        );
      });

      // Kick off initialization in background
      AppLogger.info('Starting parallel service initialization...');
      final initFuture = Future.wait([
        performanceService.initialize(),
        connectionService.initialize(),
        questionCacheService.initialize(),
        // featureFlagsInitFuture removed
        starTransactionInitFuture,
      ]);

      // Expose services immediately so UI can build without waiting
      AppLogger.info('Exposing services to providers...');
      setState(() {
        _performanceService = performanceService;
        _connectionService = connectionService;
        _questionCacheService = questionCacheService;
        _geminiService = geminiService;
        // _featureFlagsService removed
        _apiService = apiService;
        _starTransactionService = starTransactionService;
      });

      // Continue with any post-init work when ready
      AppLogger.info('Waiting for service initialization to complete...');
      await initFuture;
      AppLogger.info('All services initialized successfully');


      AppLogger.info('Initializing notification service for platform: ${Platform.operatingSystem}');
      if (!kIsWeb && !Platform.isLinux) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          AppLogger.info('Initializing notifications for mobile platform...');
          await NotificationService().init();
          AppLogger.info('Notification service initialized for mobile');
        });
      } else if (!kIsWeb && Platform.isLinux) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          AppLogger.info('Initializing notifications for Linux platform...');
          await NotificationService().init();
          await NotificationService().cancelAllNotifications();
          AppLogger.info('Notification service initialized for Linux');
        });
      } else {
        AppLogger.info('Skipping notification service initialization for Web platform');
      }
    });
  }

  // Initialize deep link handling
  void _initDeepLinks() async {
    // For web platforms, use query parameters
    if (kIsWeb) {
      final uri = Uri.base;
      if (uri.path.startsWith('/stats') || uri.path.startsWith('/gen.html') || uri.hasQuery) {
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
      AppLogger.info('Skipping deep link handling on ${Platform.operatingSystem} platform');
    }
  }

  void _handleDeepLink(Uri uri) {
    // Check if this is a stats share URL
    if (uri.path.startsWith('/stats') || uri.path.startsWith('/gen.html') || uri.queryParameters.containsKey('score')) {
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Guide showing logic moved to LessonSelectScreen for better control
  }


  /// Builds the MaterialApp with theme configuration
  Widget _buildMaterialApp(SettingsProvider settings) {
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
      ],
      locale: const Locale('nl', ''), // Force Dutch locale
      routes: {
        '/store': (context) => const StoreScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/userId': (context) => const SyncScreen(),
      },
      home: const MainNavigationScreen(),
    );
  }

  /// Gets deferred providers that are ready
  List<SingleChildWidget> _getDeferredProviders() {
    return [
      if (_performanceService != null) Provider.value(value: _performanceService!),
      if (_connectionService != null) Provider.value(value: _connectionService!),
      if (_questionCacheService != null) Provider.value(value: _questionCacheService!),
      if (_geminiService != null) Provider.value(value: _geminiService!),
      // if (_featureFlagsService != null) removed
      if (_apiService != null) Provider.value(value: _apiService!),
      if (_starTransactionService != null) Provider.value(value: _starTransactionService!),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Start time tracking when the app widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_timeTrackingService.hasOngoingSession()) {
        _timeTrackingService.startSession();
      }
      
      // Check if we're in the BijbelQuiz Gen period and redirect if needed
      if (BijbelQuizGenPeriod.isGenPeriod() && !_timeTrackingService.hasGenBeenShownThisPeriod()) {
        // Mark the Gen as shown for this period before navigating
        _timeTrackingService.markGenAsShownThisPeriod();
        
        // Small delay to ensure context is ready
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const BijbelQuizGenScreen(),
              ),
            );
          }
        });
      }
    });

    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        // Handle API server lifecycle based on settings
        _handleApiServerLifecycle(context, settings);

        final app = _buildMaterialApp(settings);
        final deferredProviders = _getDeferredProviders();

        // For deep link handling after app is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Wait a bit to ensure the app is fully initialized before checking for deep links
          Future.delayed(const Duration(milliseconds: 100), () {
            if (kIsWeb) {
              // For web, check current URI for stats parameters
              final uri = Uri.base;
              if (uri.path.startsWith('/stats') || uri.path.startsWith('/gen.html') || uri.hasQuery) {
                _handleDeepLink(uri);
              }
            }
          });
        });

        return deferredProviders.isNotEmpty
            ? MultiProvider(providers: deferredProviders, child: app)
            : app;
      },
    );
  }

  /// Handle API server lifecycle based on settings changes
  void _handleApiServerLifecycle(BuildContext context, SettingsProvider settings) {
    if (_apiService == null || _questionCacheService == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (settings.apiEnabled && settings.apiKey.isNotEmpty) {
          // Start API server if not already running
          if (!_apiService!.isRunning) {
            final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
            final lessonProgressProvider = Provider.of<LessonProgressProvider>(context, listen: false);

            await _apiService!.startServer(
              port: settings.apiPort,
              apiKey: settings.apiKey,
              settingsProvider: settings,
              gameStatsProvider: gameStatsProvider,
              lessonProgressProvider: lessonProgressProvider,
              questionCacheService: _questionCacheService!,
            );
            AppLogger.info('API server started via settings change');
          }
        } else {
          // Stop API server if running
          if (_apiService!.isRunning) {
            await _apiService!.stopServer();
            AppLogger.info('API server stopped via settings change');
          }
        }
      } catch (e) {
        AppLogger.error('Error managing API server lifecycle: $e');
        // Show user-friendly error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('API Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  /// Track app lifecycle events for session management
  void _trackAppLifecycle() {
    AppLifecycleObserver(analyticsService, _timeTrackingService).observe();
  }

  @override
  void dispose() {
    AppLogger.info('BijbelQuizApp disposing...');
    _mounted = false;

    // Stop API server if running
    _apiService?.stopServer().then((_) {
      AppLogger.info('API server stopped during app disposal');
    }).catchError((e) {
      AppLogger.error('Error stopping API server during disposal: $e');
    });

    _questionCacheService?.dispose();
    _connectionService?.dispose();
    _timeTrackingService.dispose();
    
    // Cancel the deep link subscription
    _sub?.cancel();
    
    AppLogger.info('BijbelQuizApp disposed successfully');
    super.dispose();
  }
}

/// Observer class to track app lifecycle events
class AppLifecycleObserver {
  final AnalyticsService _analyticsService;
  final TimeTrackingService _timeTrackingService;
  DateTime? _lastPausedTime;

  AppLifecycleObserver(this._analyticsService, this._timeTrackingService);

  void observe() {
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver(this));
  }
}

class _AppLifecycleObserver extends WidgetsBindingObserver {
  final AppLifecycleObserver _parent;

  _AppLifecycleObserver(this._parent);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App lifecycle tracking removed - emergency service navigator key no longer available
    switch (state) {
      case AppLifecycleState.resumed:
        AppLogger.info('App lifecycle: resumed');
        // Start a new session when app is resumed (brought to foreground)
        _parent._timeTrackingService.startSession();
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
}
