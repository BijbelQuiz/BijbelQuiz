import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bijbelquiz/widgets/answer_button.dart';

void main() {
  late ColorScheme colorScheme;

  setUp(() {
    colorScheme = const ColorScheme.light(
      primary: Colors.blue,
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      outline: Colors.grey,
      shadow: Colors.black26,
    );
  });

  group('AnswerButton', () {
    testWidgets('should render with default feedback (none)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () {},
              feedback: AnswerFeedback.none,
              label: 'Test Answer',
              colorScheme: colorScheme,
            ),
          ),
        ),
      );

      // Check that the button is rendered
      expect(find.text('Test Answer'), findsOneWidget);
      expect(find.byType(AnswerButton), findsOneWidget);
    });

    testWidgets('should render with letter indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () {},
              feedback: AnswerFeedback.none,
              label: 'Test Answer',
              colorScheme: colorScheme,
              letter: 'A',
            ),
          ),
        ),
      );

      // Check that the letter is displayed
      expect(find.text('A'), findsOneWidget);
      expect(find.text('Test Answer'), findsOneWidget);
    });

    testWidgets('should render with correct feedback', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () {},
              feedback: AnswerFeedback.correct,
              label: 'Correct Answer',
              colorScheme: colorScheme,
            ),
          ),
        ),
      );

      // Check that the check icon is displayed
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.text('Correct Answer'), findsOneWidget);
    });

    testWidgets('should render with incorrect feedback', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () {},
              feedback: AnswerFeedback.incorrect,
              label: 'Wrong Answer',
              colorScheme: colorScheme,
            ),
          ),
        ),
      );

      // Check that the close icon is displayed
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      expect(find.text('Wrong Answer'), findsOneWidget);
    });

    testWidgets('should render with revealed correct feedback', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () {},
              feedback: AnswerFeedback.revealedCorrect,
              label: 'Revealed Correct',
              colorScheme: colorScheme,
            ),
          ),
        ),
      );

      // Check that the check icon is displayed
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.text('Revealed Correct'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () => pressed = true,
              feedback: AnswerFeedback.none,
              label: 'Test Answer',
              colorScheme: colorScheme,
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.text('Test Answer'));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('should not call onPressed when disabled', (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () => pressed = true,
              feedback: AnswerFeedback.none,
              label: 'Test Answer',
              colorScheme: colorScheme,
              isDisabled: true,
            ),
          ),
        ),
      );

      // Try to tap the button
      await tester.tap(find.text('Test Answer'));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets('should not call onPressed when onPressed is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: null,
              feedback: AnswerFeedback.none,
              label: 'Test Answer',
              colorScheme: colorScheme,
            ),
          ),
        ),
      );

      // Try to tap the button
      await tester.tap(find.text('Test Answer'));
      await tester.pump();

      // Should not crash
      expect(find.text('Test Answer'), findsOneWidget);
    });

    testWidgets('should render as large button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () {},
              feedback: AnswerFeedback.none,
              label: 'Large Answer',
              colorScheme: colorScheme,
              isLarge: true,
            ),
          ),
        ),
      );

      // Check that the button is rendered with large styling
      expect(find.text('Large Answer'), findsOneWidget);
      expect(find.byType(AnswerButton), findsOneWidget);
    });

    testWidgets('should handle feedback state changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () {},
              feedback: AnswerFeedback.none,
              label: 'Test Answer',
              colorScheme: colorScheme,
            ),
          ),
        ),
      );

      // Initially no icon
      expect(find.byIcon(Icons.check_rounded), findsNothing);
      expect(find.byIcon(Icons.close_rounded), findsNothing);

      // Rebuild with correct feedback
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () {},
              feedback: AnswerFeedback.correct,
              label: 'Test Answer',
              colorScheme: colorScheme,
            ),
          ),
        ),
      );

      // Now should have check icon
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsNothing);
    });

    testWidgets('should handle letter indicator with different feedback states', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () {},
              feedback: AnswerFeedback.correct,
              label: 'Correct Answer',
              colorScheme: colorScheme,
              letter: 'A',
            ),
          ),
        ),
      );

      // Check that letter and icon are both displayed
      expect(find.text('A'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.text('Correct Answer'), findsOneWidget);
    });

    testWidgets('should handle tap animations', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () {},
              feedback: AnswerFeedback.none,
              label: 'Test Answer',
              colorScheme: colorScheme,
            ),
          ),
        ),
      );

      // Initial state
      expect(find.text('Test Answer'), findsOneWidget);

      // Simulate tap down
      final button = find.text('Test Answer');
      await tester.press(button);
      await tester.pump();

      // Button should still be visible during animation
      expect(find.text('Test Answer'), findsOneWidget);

      // Tap to trigger onPressed
      await tester.tap(button);
      await tester.pump();

      // Button should still be visible
      expect(find.text('Test Answer'), findsOneWidget);
    });

    testWidgets('should handle disabled state with feedback', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () {},
              feedback: AnswerFeedback.correct,
              label: 'Disabled Correct',
              colorScheme: colorScheme,
              isDisabled: true,
            ),
          ),
        ),
      );

      // Should still show feedback even when disabled
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.text('Disabled Correct'), findsOneWidget);
    });

    testWidgets('should handle long labels', (WidgetTester tester) async {
      const longLabel = 'This is a very long answer label that should still be displayed properly in the button';

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: AnswerButton(
                onPressed: () {},
                feedback: AnswerFeedback.none,
                label: longLabel,
                colorScheme: colorScheme,
              ),
            ),
          ),
        ),
      );

      // Check that the long label is displayed
      expect(find.text(longLabel), findsOneWidget);
    });

    testWidgets('should handle empty label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () {},
              feedback: AnswerFeedback.none,
              label: '',
              colorScheme: colorScheme,
            ),
          ),
        ),
      );

      // Should handle empty label gracefully
      expect(find.byType(AnswerButton), findsOneWidget);
    });

    testWidgets('should handle special characters in label', (WidgetTester tester) async {
      const specialLabel = 'Answer with émojis 🎉 and spëcial chärs';

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: Scaffold(
            body: AnswerButton(
              onPressed: () {},
              feedback: AnswerFeedback.none,
              label: specialLabel,
              colorScheme: colorScheme,
            ),
          ),
        ),
      );

      // Check that special characters are displayed
      expect(find.text(specialLabel), findsOneWidget);
    });
  });
}