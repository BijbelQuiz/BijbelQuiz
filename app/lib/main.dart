import 'package:bijbelquiz/services/analytics_service.dart';
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
import 'services/emergency_service.dart';
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
  
  final gameStatsProvider = GameStatsProvider();
  AppLogger.info('Game stats provider initialized');

  AppLogger.info('Starting Flutter app with providers...');
  final appStartTime = DateTime.now();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider.value(value: gameStatsProvider),
        ChangeNotifierProvider(create: (_) => LessonProgressProvider()),
        Provider.value(value: analyticsService),
      ],
      child: BijbelQuizApp(),
    ),
  );
  final appStartDuration = DateTime.now().difference(appStartTime);
  AppLogger.info('Flutter app started successfully in ${appStartDuration.inMilliseconds}ms');
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
  EmergencyService? _emergencyService;
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

    // Defer service initialization; don't block first render
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AppLogger.info('Starting deferred service initialization...');
      final performanceService = PerformanceService();
      final connectionService = ConnectionService();
      final questionCacheService = QuestionCacheService();
      final emergencyService = EmergencyService();
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
        _emergencyService = emergencyService;
        _geminiService = geminiService;
        _featureFlagsService = featureFlagsService;
      });

      // Continue with any post-init work when ready
      AppLogger.info('Waiting for service initialization to complete...');
      await initFuture;
      AppLogger.info('All services initialized successfully');

      // Start polling for emergency messages
      AppLogger.info('Starting emergency service polling...');
      emergencyService.startPolling();

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
    return MaterialApp(
      navigatorKey: EmergencyService.navigatorKey,
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
    );
  }

  /// Gets deferred providers that are ready
  List<SingleChildWidget> _getDeferredProviders() {
    return [
      if (_performanceService != null) Provider.value(value: _performanceService!),
      if (_connectionService != null) Provider.value(value: _connectionService!),
      if (_questionCacheService != null) Provider.value(value: _questionCacheService!),
      if (_emergencyService != null) Provider.value(value: _emergencyService!),
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
