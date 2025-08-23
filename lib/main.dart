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
import 'screens/guide_screen.dart';
import 'theme/app_theme.dart';
import 'services/logger.dart';
import 'services/notification_service.dart';
import 'services/performance_service.dart';
import 'services/connection_service.dart';
import 'services/question_cache_service.dart';
import 'services/emergency_service.dart';
import 'services/update_service.dart';
import 'widgets/update_dialog.dart';
import 'screens/store_screen.dart';
import 'providers/lesson_progress_provider.dart';
import 'screens/lesson_select_screen.dart';
import 'settings_screen.dart';

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
  EmergencyService? _emergencyService;
  bool _hasShownGuide = false;

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
      final updateService = UpdateService();

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
      
      // Set up update notification callback
      updateService.onUpdateAvailable = (updateInfo) {
        // Show update dialog if we have a context
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => UpdateDialog(updateInfo: updateInfo),
          );
        }
      };
      
      // Start periodic update checks
      updateService.startPeriodicChecks();

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
    // Show guide on first run if not seen yet (fallback)
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (!settings.isLoading && !settings.hasSeenGuide && !_hasShownGuide) {
      _hasShownGuide = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const GuideScreen(),
            ),
          );
        }
      });
    }
  }
  


  @override
  Widget build(BuildContext context) {
    // Collect deferred providers
    final List<SingleChildWidget> deferredProviders = [
      if (_performanceService != null) Provider.value(value: _performanceService!),
      if (_connectionService != null) Provider.value(value: _connectionService!),
      if (_questionCacheService != null) Provider.value(value: _questionCacheService!),
      if (_emergencyService != null) Provider.value(value: _emergencyService!),
    ];
    
    // Build the main app widget
    final app = Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        // Determine which theme to use based on settings
        final ThemeData lightTheme;
        final ThemeData darkTheme;
        
        if (settings.selectedCustomThemeKey != null) {
          switch (settings.selectedCustomThemeKey) {
            case 'oled':
              lightTheme = oledTheme;
              darkTheme = oledTheme;
              break;
            case 'green':
              lightTheme = greenTheme;
              darkTheme = greenTheme;
              break;
            case 'orange':
              lightTheme = orangeTheme;
              darkTheme = orangeTheme;
              break;
            default:
              lightTheme = appLightTheme;
              darkTheme = appDarkTheme;
          }
        } else {
          lightTheme = appLightTheme;
          darkTheme = appDarkTheme;
        }
        
        return MaterialApp(
          navigatorKey: EmergencyService.navigatorKey,
          title: 'BijbelQuiz',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settings.selectedCustomThemeKey != null 
              ? ThemeMode.light  // Custom themes are always applied as light theme
              : settings.themeMode,  // Use system preference when no custom theme
          localizationsDelegates: const [
            // Remove StringsDelegate as it's not defined in strings_nl.dart
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
      },
    );

    // Wrap with providers if any
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
    // Cancel the periodic update checks timer
    UpdateService().stopPeriodicChecks();
    _mounted = false;
    super.dispose();
  }
}
