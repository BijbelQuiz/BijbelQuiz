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

import 'package:bijbelquiz/screens/quiz_screen.dart';

void main() {
  setUpAll(() {
    ConnectionService.disableTimersForTest = true;
  });

  tearDownAll(() {
    ConnectionService.disableTimersForTest = false;
  });

  testWidgets('Quiz screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(create: (_) => GameStatsProvider()),

        ],
        child: const MaterialApp(home: QuizScreen()),
      ),
    );

    // Verify that the quiz screen is displayed
    expect(find.byType(QuizScreen), findsOneWidget);

    // Remove the widget from the tree to trigger dispose
    await tester.pumpWidget(Container());
    await tester.pumpAndSettle();
  });
}
