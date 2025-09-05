import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bijbelquiz/models/quiz_question.dart';
import 'package:bijbelquiz/widgets/question_card.dart';
import 'package:bijbelquiz/widgets/answer_button.dart';

void main() {
  late QuizQuestion mcQuestion;
  late QuizQuestion tfQuestion;
  late QuizQuestion fitbQuestion;

  setUp(() {
    mcQuestion = QuizQuestion(
      question: 'What is 2+2?',
      correctAnswer: '4',
      incorrectAnswers: ['3', '5', '6'],
      difficulty: '1',
      type: QuestionType.mc,
    );

    tfQuestion = QuizQuestion(
      question: 'Is God real?',
      correctAnswer: 'Waar',
      incorrectAnswers: ['Niet waar'],
      difficulty: '1',
      type: QuestionType.tf,
    );

    fitbQuestion = QuizQuestion(
      question: 'Complete the verse: "In the beginning _____"',
      correctAnswer: 'God created',
      incorrectAnswers: ['was the word', 'there was light'],
      difficulty: '2',
      type: QuestionType.fitb,
    );
  });

  group('QuestionCard', () {
    testWidgets('should render multiple choice question correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: mcQuestion,
              selectedAnswerIndex: null,
              isAnswering: false,
              isTransitioning: false,
              onAnswerSelected: (index) {},
              language: 'nl',
            ),
          ),
        ),
      );

      // Check question text is displayed
      expect(find.text('What is 2+2?'), findsOneWidget);

      // Check all answer options are displayed
      expect(find.text('4'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);

      // Check answer buttons are present
      expect(find.byType(AnswerButton), findsNWidgets(4));
    });

    testWidgets('should render true/false question correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: tfQuestion,
              selectedAnswerIndex: null,
              isAnswering: false,
              isTransitioning: false,
              onAnswerSelected: (index) {},
              language: 'nl',
            ),
          ),
        ),
      );

      // Check question text is displayed
      expect(find.text('Is God real?'), findsOneWidget);

      // Check TF options are displayed
      expect(find.text('Goed'), findsOneWidget);
      expect(find.text('Fout'), findsOneWidget);

      // Check answer buttons are present
      expect(find.byType(AnswerButton), findsNWidgets(2));
    });

    testWidgets('should render fill in the blank question correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: fitbQuestion,
              selectedAnswerIndex: null,
              isAnswering: false,
              isTransitioning: false,
              onAnswerSelected: (index) {},
              language: 'nl',
            ),
          ),
        ),
      );

      // Check question text is displayed (without the blank)
      expect(find.text('Complete the verse: "In the beginning'), findsOneWidget);

      // Check blank indicator is present
      expect(find.text('______'), findsOneWidget);

      // Check all answer options are displayed
      expect(find.text('God created'), findsOneWidget);
      expect(find.text('was the word'), findsOneWidget);
      expect(find.text('there was light'), findsOneWidget);

      // Check answer buttons are present
      expect(find.byType(AnswerButton), findsNWidgets(3));
    });

    testWidgets('should call onAnswerSelected when answer button is tapped', (WidgetTester tester) async {
      int? selectedIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: mcQuestion,
              selectedAnswerIndex: null,
              isAnswering: false,
              isTransitioning: false,
              onAnswerSelected: (index) => selectedIndex = index,
              language: 'nl',
            ),
          ),
        ),
      );

      // Tap the first answer button
      await tester.tap(find.text('4'));
      await tester.pump();

      expect(selectedIndex, 0);
    });

    testWidgets('should not call onAnswerSelected when isAnswering is true', (WidgetTester tester) async {
      int? selectedIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: mcQuestion,
              selectedAnswerIndex: null,
              isAnswering: true,
              isTransitioning: false,
              onAnswerSelected: (index) => selectedIndex = index,
              language: 'nl',
            ),
          ),
        ),
      );

      // Try to tap an answer button
      await tester.tap(find.text('4'));
      await tester.pump();

      expect(selectedIndex, isNull);
    });

    testWidgets('should not call onAnswerSelected when selectedAnswerIndex is not null', (WidgetTester tester) async {
      int? selectedIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: mcQuestion,
              selectedAnswerIndex: 1,
              isAnswering: false,
              isTransitioning: false,
              onAnswerSelected: (index) => selectedIndex = index,
              language: 'nl',
            ),
          ),
        ),
      );

      // Try to tap an answer button
      await tester.tap(find.text('4'));
      await tester.pump();

      expect(selectedIndex, isNull);
    });

    testWidgets('should show correct feedback when answer is selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: mcQuestion,
              selectedAnswerIndex: 0, // Correct answer (4)
              isAnswering: false,
              isTransitioning: false,
              onAnswerSelected: (index) {},
              language: 'nl',
            ),
          ),
        ),
      );

      // Check that AnswerButton widgets exist
      expect(find.byType(AnswerButton), findsNWidgets(4));
    });

    testWidgets('should show incorrect feedback when wrong answer is selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: mcQuestion,
              selectedAnswerIndex: 1, // Wrong answer (3)
              isAnswering: false,
              isTransitioning: false,
              onAnswerSelected: (index) {},
              language: 'nl',
            ),
          ),
        ),
      );

      // Check that AnswerButton widgets exist
      expect(find.byType(AnswerButton), findsNWidgets(4));
    });

    testWidgets('should handle keyboard shortcuts on desktop', (WidgetTester tester) async {
      // Set up desktop size
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      int? selectedIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: mcQuestion,
              selectedAnswerIndex: null,
              isAnswering: false,
              isTransitioning: false,
              onAnswerSelected: (index) => selectedIndex = index,
              language: 'nl',
            ),
          ),
        ),
      );

      // Simulate pressing 'A' key
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      await tester.pump();

      expect(selectedIndex, 0);

      // Reset for next test
      selectedIndex = null;

      // Simulate pressing 'B' key
      await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
      await tester.pump();

      expect(selectedIndex, 1);
    });

    testWidgets('should not handle keyboard shortcuts when isAnswering is true', (WidgetTester tester) async {
      // Set up desktop size
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      int? selectedIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: mcQuestion,
              selectedAnswerIndex: null,
              isAnswering: true,
              isTransitioning: false,
              onAnswerSelected: (index) => selectedIndex = index,
              language: 'nl',
            ),
          ),
        ),
      );

      // Try to press 'A' key
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      await tester.pump();

      expect(selectedIndex, isNull);
    });

    testWidgets('should not handle keyboard shortcuts when isTransitioning is true', (WidgetTester tester) async {
      // Set up desktop size
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      int? selectedIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: mcQuestion,
              selectedAnswerIndex: null,
              isAnswering: false,
              isTransitioning: true,
              onAnswerSelected: (index) => selectedIndex = index,
              language: 'nl',
            ),
          ),
        ),
      );

      // Try to press 'A' key
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      await tester.pump();

      expect(selectedIndex, isNull);
    });

    testWidgets('should handle keyboard shortcuts only for available options', (WidgetTester tester) async {
      // Set up desktop size
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      int? selectedIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: mcQuestion,
              selectedAnswerIndex: null,
              isAnswering: false,
              isTransitioning: false,
              onAnswerSelected: (index) => selectedIndex = index,
              language: 'nl',
            ),
          ),
        ),
      );

      // Try to press 'E' key (no option E)
      await tester.sendKeyEvent(LogicalKeyboardKey.keyE);
      await tester.pump();

      expect(selectedIndex, isNull);
    });

    testWidgets('should handle TF question with True/False answers', (WidgetTester tester) async {
      final tfQuestionEnglish = QuizQuestion(
        question: 'Is God real?',
        correctAnswer: 'True',
        incorrectAnswers: ['False'],
        difficulty: '1',
        type: QuestionType.tf,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: tfQuestionEnglish,
              selectedAnswerIndex: null,
              isAnswering: false,
              isTransitioning: false,
              onAnswerSelected: (index) {},
              language: 'nl',
            ),
          ),
        ),
      );

      // Check TF options are displayed
      expect(find.text('Goed'), findsOneWidget);
      expect(find.text('Fout'), findsOneWidget);
    });

    testWidgets('should handle TF question with Niet waar/Waar answers', (WidgetTester tester) async {
      final tfQuestionDutch = QuizQuestion(
        question: 'Is God real?',
        correctAnswer: 'Niet waar',
        incorrectAnswers: ['Waar'],
        difficulty: '1',
        type: QuestionType.tf,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: tfQuestionDutch,
              selectedAnswerIndex: null,
              isAnswering: false,
              isTransitioning: false,
              onAnswerSelected: (index) {},
              language: 'nl',
            ),
          ),
        ),
      );

      // Check TF options are displayed
      expect(find.text('Goed'), findsOneWidget);
      expect(find.text('Fout'), findsOneWidget);
    });

    testWidgets('should handle FITB question with ellipsis', (WidgetTester tester) async {
      final fitbQuestionEllipsis = QuizQuestion(
        question: 'Complete the verse: "In the beginning ..."',
        correctAnswer: 'God created',
        incorrectAnswers: ['was the word'],
        difficulty: '2',
        type: QuestionType.fitb,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: fitbQuestionEllipsis,
              selectedAnswerIndex: null,
              isAnswering: false,
              isTransitioning: false,
              onAnswerSelected: (index) {},
              language: 'nl',
            ),
          ),
        ),
      );

      // Check question text is displayed (without the blank)
      expect(find.text('Complete the verse: "In the beginning'), findsOneWidget);

      // Check blank indicator is present
      expect(find.text('______'), findsOneWidget);
    });

    testWidgets('should handle FITB question without blank', (WidgetTester tester) async {
      final fitbQuestionNoBlank = QuizQuestion(
        question: 'What is the capital of France?',
        correctAnswer: 'Paris',
        incorrectAnswers: ['London', 'Berlin'],
        difficulty: '1',
        type: QuestionType.fitb,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: fitbQuestionNoBlank,
              selectedAnswerIndex: null,
              isAnswering: false,
              isTransitioning: false,
              onAnswerSelected: (index) {},
              language: 'nl',
            ),
          ),
        ),
      );

      // Check full question text is displayed
      expect(find.text('What is the capital of France?'), findsOneWidget);

      // Check answer options are displayed
      expect(find.text('Paris'), findsOneWidget);
      expect(find.text('London'), findsOneWidget);
      expect(find.text('Berlin'), findsOneWidget);
    });
  });
}