import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:io' show Platform;
import 'package:provider/single_child_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/strings_nl.dart' as strings;

import 'providers/game_stats_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/guide_screen.dart';
import 'screens/quiz_screen.dart';
import 'theme/app_theme.dart';
import 'services/logger.dart';
import 'widgets/quiz_skeleton.dart';
import 'services/notification_service.dart';
import 'services/performance_service.dart';
import 'services/connection_service.dart';
import 'services/question_cache_service.dart';
import 'screens/store_screen.dart';
import 'providers/lesson_progress_provider.dart';
import 'screens/lesson_select_screen.dart';
import 'settings_screen.dart';
import 'services/activation_service.dart';
import 'screens/activation_screen.dart';



/// The main entry point of the BijbelQuiz application with performance optimizations.
void main() async {
  // Ensure that the Flutter binding is initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize logging
  AppLogger.init();
  
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
  bool _servicesInitialized = false;

  @override
  void initState() {
    super.initState();
    // Defer service initialization; don't block first render
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final performanceService = PerformanceService();
      final connectionService = ConnectionService();
      final questionCacheService = QuestionCacheService();

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
        _servicesInitialized = true;
      });

      // Continue with any post-init work when ready
      await initFuture;

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

  ThemeData? getCustomTheme(String? key) {
    switch (key) {
      case 'oled':
        return oledTheme;
      case 'green':
        return greenTheme;
      case 'orange':
        return orangeTheme;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    final isDesktop = MediaQuery.of(context).size.width > 1200 || kIsWeb;
    final isTablet = MediaQuery.of(context).size.width > 600 && !isDesktop;
    final isSmallPhone = MediaQuery.of(context).size.width < 350;
    // Show a loading indicator if settings are still loading
    if (!_servicesInitialized) {
      return MaterialApp(
        key: const ValueKey('loading'),
        title: strings.AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: appLightTheme,
        darkTheme: appDarkTheme,
        themeMode: settings.themeMode,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('nl', ''), // Dutch only
        ],
        locale: const Locale('nl', ''), // Force Dutch locale
        home: Scaffold(
          body: Center(
            child: QuizSkeleton(
              isDesktop: isDesktop,
              isTablet: isTablet,
              isSmallPhone: isSmallPhone,
            ),
          ),
        ),
      );
    }
    // Collect deferred providers
    final List<SingleChildWidget> deferredProviders = [
      if (_performanceService != null) Provider.value(value: _performanceService!),
      if (_connectionService != null) Provider.value(value: _connectionService!),
      if (_questionCacheService != null) Provider.value(value: _questionCacheService!),
    ];
    // Determine theme
    ThemeData? customTheme;
    if (settings.selectedCustomThemeKey != null &&
        settings.isThemeUnlocked(settings.selectedCustomThemeKey!)) {
      customTheme = getCustomTheme(settings.selectedCustomThemeKey);
    }
    final app = MaterialApp(
      key: ValueKey('${settings.selectedCustomThemeKey}_${settings.themeMode}'),
      navigatorKey: gameStats.navigatorKey,
      title: strings.AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: customTheme ?? appLightTheme,
      darkTheme: customTheme ?? appDarkTheme,
      themeMode: customTheme != null ? ThemeMode.light : settings.themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('nl', ''), // Dutch only
      ],
      locale: const Locale('nl', ''), // Force Dutch locale
      routes: {
        '/store': (context) => const StoreScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
      home: ActivationGate(child: const LessonSelectScreen()),
    );
    
    // Show guide if needed after app is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final activated = await ActivationService().isActivated();
      if (!settings.isLoading &&
          activated &&
          !settings.hasSeenGuide &&
          gameStats.navigatorKey.currentContext != null) {
        Navigator.of(gameStats.navigatorKey.currentContext!).push(
          MaterialPageRoute(
            builder: (context) => const GuideScreen(),
          ),
        );
      }
    });
    if (deferredProviders.isNotEmpty) {
      return MultiProvider(
        providers: deferredProviders,
        child: app,
      );
    }
    return app;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
