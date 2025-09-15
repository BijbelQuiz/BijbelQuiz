import 'package:bijbelquiz/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:io' show Platform;
import 'package:provider/single_child_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'providers/settings_provider.dart';
import 'providers/game_stats_provider.dart';
import 'utils/theme_utils.dart';
import 'services/logger.dart';
import 'services/notification_service.dart';
import 'services/performance_service.dart';
import 'services/connection_service.dart';
import 'services/question_cache_service.dart';
import 'services/emergency_service.dart';
import 'screens/store_screen.dart';
import 'providers/lesson_progress_provider.dart';
import 'screens/lesson_select_screen.dart';
import 'settings_screen.dart';
import 'l10n/strings_nl.dart' as strings;

final analyticsService = AnalyticsService();

/// The main entry point of the BijbelQuiz application with performance optimizations.
void main() async {
  // Ensure that the Flutter binding is initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize logging
  AppLogger.init();
  // Initialize analytics
  await analyticsService.init();
  
  // Set preferred screen orientations. On web, this helps maintain a consistent layout.
  if (kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  
  final gameStatsProvider = GameStatsProvider();

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

  // Add mounted getter for older Flutter versions
  @override
  bool get mounted => _mounted;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    // Defer service initialization; don't block first render
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final performanceService = PerformanceService();
      final connectionService = ConnectionService();
      final questionCacheService = QuestionCacheService();
      final emergencyService = EmergencyService();

      // Kick off initialization in background
      final initFuture = Future.wait([
        performanceService.initialize(),
        connectionService.initialize(),
        questionCacheService.initialize(),
      ]);

      // Expose services immediately so UI can build without waiting
      setState(() {
        _performanceService = performanceService;
        _connectionService = connectionService;
        _questionCacheService = questionCacheService;
        _emergencyService = emergencyService;
      });

      // Continue with any post-init work when ready
      await initFuture;

      // Start polling for emergency messages
      emergencyService.startPolling();

      if (!kIsWeb && !Platform.isLinux) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await NotificationService().init();
        });
      } else if (!kIsWeb && Platform.isLinux) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await NotificationService().init();
          await NotificationService().cancelAllNotifications();
        });
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
      home: const LessonSelectScreen(),
    );
  }

  /// Gets deferred providers that are ready
  List<SingleChildWidget> _getDeferredProviders() {
    return [
      if (_performanceService != null) Provider.value(value: _performanceService!),
      if (_connectionService != null) Provider.value(value: _connectionService!),
      if (_questionCacheService != null) Provider.value(value: _questionCacheService!),
      if (_emergencyService != null) Provider.value(value: _emergencyService!),
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
    _mounted = false;
    _questionCacheService?.dispose();
    _connectionService?.dispose();
    super.dispose();
  }
}
