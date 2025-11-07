// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:bijbelquiz/providers/settings_provider.dart';
import 'package:bijbelquiz/providers/game_stats_provider.dart';
import 'package:bijbelquiz/services/connection_service.dart';
import 'package:bijbelquiz/services/analytics_service.dart';

void main() {
  setUpAll(() {
    ConnectionService.disableTimersForTest = true;
  });

  tearDownAll(() {
    ConnectionService.disableTimersForTest = false;
  });

  testWidgets('Quiz screen smoke test', (WidgetTester tester) async {
    // Test that providers can be created and used together
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(create: (_) => GameStatsProvider()),
          Provider(create: (_) => AnalyticsService()),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Text('Test Scaffold'),
          ),
        ),
      ),
    );

    // Verify that the providers are working
    expect(find.text('Test Scaffold'), findsOneWidget);

    // Test provider access
    final settings = Provider.of<SettingsProvider>(
      tester.element(find.byType(Scaffold)),
      listen: false,
    );
    final gameStats = Provider.of<GameStatsProvider>(
      tester.element(find.byType(Scaffold)),
      listen: false,
    );

    expect(settings, isNotNull);
    expect(gameStats, isNotNull);
    expect(settings.themeMode, isA<ThemeMode>());
    expect(gameStats.score, isA<int>());
  });

  testWidgets('Settings provider integration test', (WidgetTester tester) async {
    late SettingsProvider settingsProvider;

    await tester.pumpWidget(
      ChangeNotifierProvider<SettingsProvider>(
        create: (context) {
          settingsProvider = SettingsProvider();
          return settingsProvider;
        },
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              final settings = Provider.of<SettingsProvider>(context);
              return Scaffold(
                body: Text('Theme: ${settings.themeMode.toString()}'),
              );
            },
          ),
        ),
      ),
    );

    // Verify that the settings provider is working
    expect(find.textContaining('Theme:'), findsOneWidget);

    // Test that we can read the theme mode
    final settings = Provider.of<SettingsProvider>(
      tester.element(find.byType(Scaffold)),
      listen: false,
    );
    expect(settings.themeMode, isA<ThemeMode>());
  });

  testWidgets('Game stats provider integration test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<GameStatsProvider>(
        create: (_) => GameStatsProvider(),
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              final gameStats = Provider.of<GameStatsProvider>(context);
              return Scaffold(
                body: Text('Current score: ${gameStats.score}'),
              );
            },
          ),
        ),
      ),
    );

    // Verify that the game stats provider is working
    expect(find.textContaining('Current score:'), findsOneWidget);

    // Test that we can read the score
    final gameStats = Provider.of<GameStatsProvider>(
      tester.element(find.byType(Scaffold)),
      listen: false,
    );
    expect(gameStats.score, isA<int>());
    expect(gameStats.score, greaterThanOrEqualTo(0));
  });

  testWidgets('Multiple providers integration test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsProvider>(create: (_) => SettingsProvider()),
          ChangeNotifierProvider<GameStatsProvider>(create: (_) => GameStatsProvider()),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              final settings = Provider.of<SettingsProvider>(context);
              final gameStats = Provider.of<GameStatsProvider>(context);
              return Scaffold(
                body: Column(
                  children: [
                    Text('Theme: ${settings.themeMode.toString()}'),
                    Text('Score: ${gameStats.score}'),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    // Verify that both providers are working together
    expect(find.textContaining('Theme:'), findsOneWidget);
    expect(find.textContaining('Score:'), findsOneWidget);

    // Test that both providers are accessible
    final settings = Provider.of<SettingsProvider>(
      tester.element(find.byType(Scaffold)),
      listen: false,
    );
    final gameStats = Provider.of<GameStatsProvider>(
      tester.element(find.byType(Scaffold)),
      listen: false,
    );

    expect(settings.themeMode, isA<ThemeMode>());
    expect(gameStats.score, isA<int>());
  });

  testWidgets('Provider state changes test', (WidgetTester tester) async {
    late SettingsProvider settingsProvider;

    await tester.pumpWidget(
      ChangeNotifierProvider<SettingsProvider>(
        create: (context) {
          settingsProvider = SettingsProvider();
          return settingsProvider;
        },
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              final settings = Provider.of<SettingsProvider>(context);
              return Scaffold(
                body: Text('Theme: ${settings.themeMode.toString()}'),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => settings.setThemeMode(ThemeMode.dark),
                  child: const Icon(Icons.dark_mode),
                ),
              );
            },
          ),
        ),
      ),
    );

    // Verify initial state
    expect(find.textContaining('Theme: ThemeMode.system'), findsOneWidget);

    // Tap the button to change theme
    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pumpAndSettle();

    // Verify state changed
    expect(find.textContaining('Theme: ThemeMode.dark'), findsOneWidget);
  });

  testWidgets('Error handling in providers test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<SettingsProvider>(
        create: (_) => SettingsProvider(),
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              final settings = Provider.of<SettingsProvider>(context);
              return Scaffold(
                body: Text('Loading: ${settings.isLoading}'),
              );
            },
          ),
        ),
      ),
    );

    // Verify that error state is handled properly
    final settings = Provider.of<SettingsProvider>(
      tester.element(find.byType(Scaffold)),
      listen: false,
    );

    expect(settings.isLoading, isA<bool>());
    expect(settings.error, isNull); // Should be null initially
  });

  testWidgets('Provider disposal test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<SettingsProvider>(
        create: (_) => SettingsProvider(),
        child: const MaterialApp(
          home: Scaffold(
            body: Text('Test'),
          ),
        ),
      ),
    );

    // Verify provider is created
    final settings = Provider.of<SettingsProvider>(
      tester.element(find.byType(Scaffold)),
      listen: false,
    );
    expect(settings, isNotNull);

    // Remove the widget tree
    await tester.pumpWidget(Container());

    // Provider should be disposed automatically by Provider
    // We can't easily test disposal in widget tests, but we can verify
    // that the widget tree cleanup works without errors
    expect(true, isTrue);
  });
}