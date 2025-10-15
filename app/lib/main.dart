import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bijbelquiz/services/analytics_service.dart';
import 'package:bijbelquiz/services/database_service.dart';
import 'package:bijbelquiz/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:io' show Platform;
import 'package:provider/single_child_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart' show Level;

import 'providers/settings_provider.dart';
import 'providers/game_stats_provider.dart';
import 'utils/theme_utils.dart';
import 'services/logger.dart';
import 'services/notification_service.dart';
import 'services/performance_service.dart';
import 'services/connection_service.dart';
import 'services/question_cache_service.dart';
import 'services/gemini_service.dart';
import 'services/feature_flags_service.dart';
import 'screens/store_screen.dart';
import 'providers/lesson_progress_provider.dart';
import 'screens/main_navigation_screen.dart';
import 'settings_screen.dart';
import 'l10n/strings_nl.dart' as strings;

final analyticsService = AnalyticsService();

/// The main entry point of the BijbelQuiz application with performance optimizations.
void main() async {
  // Ensure that the Flutter binding is initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.info('BijbelQuiz app starting up...');

  // Initialize logging
  AppLogger.init(level: Level.ALL);
  AppLogger.info('Logger initialized successfully');

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  AppLogger.info('Supabase initialized successfully');

  // Initialize analytics
  AppLogger.info('Initializing analytics service...');
  await analyticsService.init();
  AppLogger.info('Analytics service initialized successfully');
  
  // Set preferred screen orientations. On web, this helps maintain a consistent layout.
  if (kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  
  final dbService = SupabaseService();
  final gameStatsProvider = GameStatsProvider(dbService: dbService);
  AppLogger.info('Game stats provider initialized');

  AppLogger.info('Starting Flutter app with providers...');
  final appStartTime = DateTime.now();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider.value(value: gameStatsProvider),
        ChangeNotifierProvider(create: (_) => LessonProgressProvider(dbService: dbService)),
        Provider.value(value: analyticsService),
        Provider<DatabaseService>(create: (_) => dbService),
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
  FeatureFlagsService? _featureFlagsService;

  // Add mounted getter for older Flutter versions
  @override
  bool get mounted => _mounted;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    AppLogger.info('BijbelQuizApp state initializing...');

    // Track app lifecycle for session management
    _trackAppLifecycle();

    // Defer service initialization; don't block first render
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AppLogger.info('Starting deferred service initialization...');
      final performanceService = PerformanceService();
      final connectionService = ConnectionService();
      final questionCacheService = QuestionCacheService();
      final featureFlagsService = FeatureFlagsService();

      // Initialize Gemini service (with error handling for missing API key)
      AppLogger.info('Initializing Gemini service...');
      final geminiService = GeminiService.instance;
      final geminiInitFuture = geminiService.initialize().catchError((e) {
        AppLogger.warning('Gemini service initialization failed (API key may be missing): $e');
        // Don't fail the entire app if Gemini API key is missing
        return null;
      });

      // Initialize feature flags service
      AppLogger.info('Initializing feature flags service...');
      final featureFlagsInitFuture = featureFlagsService.initialize().catchError((e) {
        AppLogger.warning('Feature flags service initialization failed: $e');
        // Don't fail the entire app if feature flags fail
        return null;
      });

      // Set up connection status tracking
      connectionService.setConnectionStatusCallback((isConnected, connectionType) {
        // Connection status tracking removed - emergency service navigator key no longer available
        AppLogger.info('Connection status changed: ${isConnected ? 'connected' : 'disconnected'} ($connectionType)');
      });

      // Kick off initialization in background
      AppLogger.info('Starting parallel service initialization...');
      final initFuture = Future.wait([
        performanceService.initialize(),
        connectionService.initialize(),
        questionCacheService.initialize(),
        featureFlagsInitFuture,
        geminiInitFuture,
      ]);

      // Expose services immediately so UI can build without waiting
      AppLogger.info('Exposing services to providers...');
      setState(() {
        _performanceService = performanceService;
        _connectionService = connectionService;
        _questionCacheService = questionCacheService;
        _geminiService = geminiService;
        _featureFlagsService = featureFlagsService;
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Guide showing logic moved to LessonSelectScreen for better control
  }


  /// Builds the MaterialApp with theme configuration
  Widget _buildMaterialApp(SettingsProvider settings) {
    return ClerkAuth(
      config: ClerkAuthConfig(
        publishableKey: dotenv.env['CLERK_PUBLISHABLE_KEY']!,
      ),
      child: MaterialApp(
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
      },
      home: const MainNavigationScreen(),
    ));
  }

  /// Gets deferred providers that are ready
  List<SingleChildWidget> _getDeferredProviders() {
    return [
      if (_performanceService != null) Provider.value(value: _performanceService!),
      if (_connectionService != null) Provider.value(value: _connectionService!),
      if (_questionCacheService != null) Provider.value(value: _questionCacheService!),
      if (_geminiService != null) Provider.value(value: _geminiService!),
      if (_featureFlagsService != null) Provider.value(value: _featureFlagsService!),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        final app = _buildMaterialApp(settings);
        final deferredProviders = _getDeferredProviders();

        return deferredProviders.isNotEmpty
            ? MultiProvider(providers: deferredProviders, child: app)
            : app;
      },
    );
  }

  /// Track app lifecycle events for session management
  void _trackAppLifecycle() {
    AppLifecycleObserver(analyticsService).observe();
  }

  @override
  void dispose() {
    AppLogger.info('BijbelQuizApp disposing...');
    _mounted = false;
    _questionCacheService?.dispose();
    _connectionService?.dispose();
    AppLogger.info('BijbelQuizApp disposed successfully');
    super.dispose();
  }
}

/// Observer class to track app lifecycle events
class AppLifecycleObserver {
  final AnalyticsService _analyticsService;
  DateTime? _lastPausedTime;

  AppLifecycleObserver(this._analyticsService);

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
        break;
      case AppLifecycleState.paused:
        _parent._lastPausedTime = DateTime.now();
        AppLogger.info('App lifecycle: paused');
        break;
      case AppLifecycleState.inactive:
        AppLogger.info('App lifecycle: inactive');
        break;
      case AppLifecycleState.detached:
        AppLogger.info('App lifecycle: detached');
        break;
      case AppLifecycleState.hidden:
        AppLogger.info('App lifecycle: hidden');
        break;
    }
  }
}
