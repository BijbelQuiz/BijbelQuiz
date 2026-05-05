import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'dart:async';
import 'dart:io' show Platform;
import 'package:app_links/app_links.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart' show Level, Logger;
import 'package:bijbelquiz/l10n/app_localizations.dart';

import 'providers/settings_provider.dart';
import 'providers/game_stats_provider.dart';
import 'providers/messages_provider.dart';
import 'providers/lesson_progress_provider.dart';
import 'providers/store_provider.dart';
import 'utils/theme_utils.dart';
import 'utils/font_utils.dart'; // Import font utilities
import 'services/logger.dart';
import 'services/service_container.dart';
import 'services/time_tracking_service.dart';
import 'services/messaging_service.dart';
import 'utils/bijbelquiz_gen_utils.dart';
import 'screens/bijbelquiz_gen_screen.dart';
import 'screens/store_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'settings_screen.dart';
import 'screens/sync_screen.dart';
import 'screens/stats_share_screen.dart';
import 'config/supabase_config.dart';
import 'services/sync_service_v2.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Timeout check function to prevent app from hanging indefinitely
void _checkInitializationTimeout(
    DateTime startTime, Duration timeout, String phase) {
  final elapsed = DateTime.now().difference(startTime);
  if (elapsed > timeout) {
    AppLogger.error(
        'INITIALIZATION TIMEOUT: $phase took longer than ${timeout.inSeconds} seconds');
    AppLogger.error(
        'App initialization is taking too long. This may indicate a blocking operation.');
    AppLogger.error('Current elapsed time: ${elapsed.inMilliseconds}ms');
    // Continue execution but with a warning - don't throw as we want the app to continue
  } else {
    AppLogger.debug(
        'Initialization phase "$phase" completed in ${elapsed.inMilliseconds}ms (timeout: ${timeout.inSeconds}s)');
  }
}

/// Create a fallback service container with minimal functionality
ServiceContainer _createFallbackServiceContainer() {
  AppLogger.info(
      'Creating fallback service container with minimal functionality...');

  // Create a new service container instance
  final fallbackContainer = ServiceContainer();

  // Manually initialize only the most critical services
  try {
    // Create minimal providers that won't block
    final settingsProvider = SettingsProvider();
    final timeTrackingService = TimeTrackingService.instance;

    // Use reflection to set the private fields (this is a fallback mechanism)
    // Note: This is not ideal but necessary for recovery
    try {
      // Initialize time tracking service (most critical for basic functionality)
      unawaited(timeTrackingService.initialize().catchError((e) {
        AppLogger.error(
            'Failed to initialize time tracking in fallback mode', e);
      }));

      // Load settings asynchronously
      unawaited(settingsProvider.loadSettings().catchError((e) {
        AppLogger.error('Failed to load settings in fallback mode', e);
      }));

      AppLogger.info(
          'Fallback service container created with basic functionality');
      return fallbackContainer;
    } catch (e) {
      AppLogger.error('Failed to create even minimal fallback services', e);
      // Return the container anyway - it will have limited functionality
      return fallbackContainer;
    }
  } catch (e) {
    AppLogger.error('Critical failure in fallback service creation', e);
    // Return a basic container
    return ServiceContainer();
  }
}

/// The main entry point of the BijbelQuiz application with simplified service initialization.
Future<void> main() async {
  // Ensure that the Flutter binding is initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  // Set up a safety timeout to prevent app from hanging indefinitely
  final initializationTimeout = Duration(seconds: 30);
  final initializationStart = DateTime.now();

  // Initialize logging with secure settings based on environment
  AppLogger.setSecureLevel(
      isProduction: kReleaseMode,
      productionLevel: Level.WARNING,
      developmentLevel: Level.ALL);
  AppLogger.init();
  AppLogger.info(
      'Logger initialized successfully with secure settings (Release: $kReleaseMode)');

  AppLogger.info('BijbelQuiz app starting up...');

  try {
    // Wrap critical initialization in timeout protection
    final criticalInitStart = DateTime.now();

    // Initialize with timeout protection for each critical step
    bool fontLoaded = false;
    bool supabaseInitialized = false;
    ServiceContainer? serviceContainer;

    try {
      // Ensure Quicksand font is loaded before starting the app
      AppLogger.info('Loading Quicksand font...');
      final fontLoadStart = DateTime.now();
      await FontUtils.ensureQuicksandFontLoaded().timeout(
        Duration(seconds: 10),
        onTimeout: () {
          AppLogger.error(
              'FONT LOADING TIMEOUT: Quicksand font loading took too long');
          return Future.value(); // Continue without font
        },
      );
      final fontLoadDuration = DateTime.now().difference(fontLoadStart);
      AppLogger.info(
          'Quicksand font loaded successfully in ${fontLoadDuration.inMilliseconds}ms');
      fontLoaded = true;
    } catch (e) {
      AppLogger.error(
          'Failed to load Quicksand font, continuing with fallback', e);
      fontLoaded = false;
    }

    // Check timeout after font loading
    _checkInitializationTimeout(
        initializationStart, initializationTimeout, 'font loading');

    // Initialize Supabase (config is loaded from backend inside)
    try {
      // Initialize Supabase
      AppLogger.info('Initializing Supabase...');
      final supabaseInitStart = DateTime.now();
      await SupabaseConfig.initialize().timeout(
        Duration(seconds: 3),
        onTimeout: () {
          AppLogger.error(
              'SUPABASE INITIALIZATION TIMEOUT: Supabase initialization took too long');
          throw TimeoutException('Supabase initialization timeout');
        },
      );
      final supabaseInitDuration = DateTime.now().difference(supabaseInitStart);
      // Restore our desired log level after Supabase changes it
      Logger.root.level = kReleaseMode ? Level.WARNING : Level.ALL;
      AppLogger.info(
          'Supabase initialized successfully in ${supabaseInitDuration.inMilliseconds}ms');
      supabaseInitialized = true;
    } catch (e) {
      AppLogger.error(
          'Failed to initialize Supabase, continuing with limited functionality',
          e);
      supabaseInitialized = false;
      // Continue without Supabase - app will have limited functionality
    }

    // Check timeout after Supabase initialization
    _checkInitializationTimeout(
        initializationStart, initializationTimeout, 'Supabase initialization');

    // Set preferred screen orientations. On web, this helps maintain a consistent layout.
    if (kIsWeb) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    // Initialize service container with critical services first
    try {
      serviceContainer = ServiceContainer();

      AppLogger.info('Starting critical services initialization...');
      final criticalServicesStart = DateTime.now();
      await serviceContainer.initializeCriticalServices().timeout(
        Duration(seconds: 20),
        onTimeout: () {
          AppLogger.error(
              'CRITICAL SERVICES TIMEOUT: Critical services initialization took too long');
          throw TimeoutException('Critical services initialization timeout');
        },
      );
      final criticalServicesDuration =
          DateTime.now().difference(criticalServicesStart);
      AppLogger.info(
          'Critical services initialized in ${criticalServicesDuration.inMilliseconds}ms');
    } catch (e) {
      AppLogger.error('Failed to initialize critical services', e);
      // Create a fallback service container for minimal functionality
      serviceContainer = _createFallbackServiceContainer();
    }

    // Check timeout after critical services initialization
    _checkInitializationTimeout(initializationStart, initializationTimeout,
        'critical services initialization');

    final totalCriticalInitDuration =
        DateTime.now().difference(criticalInitStart);
    AppLogger.info(
        'Total critical initialization completed in ${totalCriticalInitDuration.inMilliseconds}ms');

    // Log initialization summary
    AppLogger.info('Initialization Summary:');
    AppLogger.info('- Font loaded: $fontLoaded');
    AppLogger.info('- Supabase initialized: $supabaseInitialized');
    AppLogger.info('- Critical services initialized: $serviceContainer');

    // Create providers for the app
    final gameStatsProvider = serviceContainer.gameStatsProvider;
    final settingsProvider = serviceContainer.settingsProvider;
    final lessonProgressProvider = LessonProgressProvider();

    // Set up sync listeners for real-time updates
    gameStatsProvider.setupSyncListener();
    settingsProvider.setupSyncListener();
    lessonProgressProvider.setupSyncListener();

    // Initialize store provider
    final storeProvider = StoreProvider();
    await storeProvider.loadStoreItems();

    AppLogger.info('Starting Flutter app with service container...');
    runApp(
      MultiProvider(
        providers: [
          // Core providers from service container
          ChangeNotifierProvider.value(value: settingsProvider),
          ChangeNotifierProvider.value(value: gameStatsProvider),
          ChangeNotifierProvider.value(value: lessonProgressProvider),

          // Store provider
          ChangeNotifierProvider.value(value: storeProvider),

          // Service container access
          Provider.value(value: serviceContainer),
          Provider.value(value: serviceContainer.themeManager),
          Provider.value(value: serviceContainer.timeTrackingService),

          // Optional services (can be null)
          Provider.value(value: serviceContainer.performanceService),
          Provider.value(value: serviceContainer.connectionService),
          Provider.value(value: serviceContainer.questionCacheService),
          Provider.value(value: serviceContainer.geminiService),
          Provider.value(value: serviceContainer.starTransactionService),
          Provider.value(value: serviceContainer.messagingService),

          // Messaging service and provider (with null safety)
          Provider(
              create: (_) =>
                  serviceContainer?.messagingService ?? MessagingService()),
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

    // Remove the problematic line - we'll use criticalInitStart instead
    AppLogger.info(
        'Flutter app started successfully in ${DateTime.now().difference(criticalInitStart).inMilliseconds}ms');

    // Initialize optional services in background (don't wait for these)
    AppLogger.info('Starting optional services initialization...');
    final optionalServicesStart = DateTime.now();
    serviceContainer.initializeOptionalServices();
    final optionalServicesDuration =
        DateTime.now().difference(optionalServicesStart);
    AppLogger.info(
        'Optional services initialization started in ${optionalServicesDuration.inMilliseconds}ms');

    // Track app launch performance
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final totalAppDuration = DateTime.now().difference(criticalInitStart);
        AppLogger.info(
            'App fully loaded in ${totalAppDuration.inMilliseconds}ms');
      } catch (e) {
        AppLogger.error('Error in app startup callback', e);
      }
    });
  } catch (e, stackTrace) {
    AppLogger.error('Critical error during app initialization', e, stackTrace);

    // Final timeout check
    final totalElapsed = DateTime.now().difference(initializationStart);
    if (totalElapsed > initializationTimeout) {
      AppLogger.error(
          'CRITICAL: App initialization exceeded timeout of ${initializationTimeout.inSeconds} seconds');
      AppLogger.error(
          'Total initialization time: ${totalElapsed.inMilliseconds}ms');
      AppLogger.error(
          'This indicates a severe blocking operation that needs immediate attention');
    }

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

      // Initialize Local API Service with providers
      final localApiService = _serviceContainer.localApiService;
      if (localApiService != null) {
        localApiService.initialize(
          gameStatsProvider: gameStatsProvider,
          lessonProgressProvider: lessonProgressProvider,
          settingsProvider:
              Provider.of<SettingsProvider>(context, listen: false),
          questionCacheService: _serviceContainer.questionCacheService!,
        );
        if (localApiService.isEnabled) {
          await localApiService.startServer();
        }
      }
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
    final timeTrackingService = _serviceContainer.timeTrackingService;
    AppLifecycleObserver(timeTrackingService).observe();
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
  }

  /// Builds the MaterialApp with theme configuration
  Widget _buildMaterialApp(SettingsProvider settings) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: navigatorKey.currentContext != null
          ? AppLocalizations.of(navigatorKey.currentContext!)?.appName
          : null ?? 'BijbelQuiz',
      theme: ThemeUtils.getLightTheme(settings),
      darkTheme: ThemeUtils.getDarkTheme(settings),
      themeMode: ThemeUtils.getThemeMode(settings),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
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

  AppLifecycleObserver(this._timeTrackingService);

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
        // Trigger sync check
        SyncServiceV2.instance.syncOnAppResume();
        break;
      case AppLifecycleState.paused:
        AppLogger.info('App lifecycle: paused');
        // End the current session when app is paused (sent to background)
        _parent._timeTrackingService.endSession();
        // Ensure sync queue is saved
        SyncServiceV2.instance.syncOnAppPause();
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
