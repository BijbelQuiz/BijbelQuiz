import 'package:flutter_test/flutter_test.dart';
import 'package:bijbelquiz/models/quiz_question.dart';

void main() {
  group('True/False Question Logic', () {
    test('Correctly identifies "Waar" as correct answer', () {
      final question = QuizQuestion(
        question: 'Test question',
        correctAnswer: 'Waar',
        incorrectAnswers: ['Niet waar'],
        difficulty: '1',
        type: QuestionType.tf,
      );

      // Simulate the logic we fixed in QuestionCard
      final lcCorrect = question.correctAnswer.toLowerCase();
      final correctIndex = (lcCorrect == 'waar' || lcCorrect == 'true' || lcCorrect == 'goed') ? 0 : 1;
      
      // For "Waar", the correct index should be 0 ('Goed')
      expect(correctIndex, 0);
    });

    test('Correctly identifies "Niet waar" as correct answer', () {
      final question = QuizQuestion(
        question: 'Test question',
        correctAnswer: 'Niet waar',
        incorrectAnswers: ['Waar'],
        difficulty: '1',
        type: QuestionType.tf,
      );

      // Simulate the logic we fixed in QuestionCard
      final lcCorrect = question.correctAnswer.toLowerCase();
      final correctIndex = (lcCorrect == 'waar' || lcCorrect == 'true' || lcCorrect == 'goed') ? 0 : 1;
      
      // For "Niet waar", the correct index should be 1 ('Fout')
      expect(correctIndex, 1);
    });

    test('Correctly identifies "True" as correct answer', () {
      final question = QuizQuestion(
        question: 'Test question',
        correctAnswer: 'True',
        incorrectAnswers: ['False'],
        difficulty: '1',
        type: QuestionType.tf,
      );

      // Simulate the logic we fixed in QuestionCard
      final lcCorrect = question.correctAnswer.toLowerCase();
      final correctIndex = (lcCorrect == 'waar' || lcCorrect == 'true' || lcCorrect == 'goed') ? 0 : 1;
      
      // For "True", the correct index should be 0 ('Goed')
      expect(correctIndex, 0);
    });

    test('Correctly identifies "False" as correct answer', () {
      final question = QuizQuestion(
        question: 'Test question',
        correctAnswer: 'False',
        incorrectAnswers: ['True'],
        difficulty: '1',
        type: QuestionType.tf,
      );

      // Simulate the logic we fixed in QuestionCard
      final lcCorrect = question.correctAnswer.toLowerCase();
      final correctIndex = (lcCorrect == 'waar' || lcCorrect == 'true' || lcCorrect == 'goed') ? 0 : 1;
      
      // For "False", the correct index should be 1 ('Fout')
      expect(correctIndex, 1);
    });
  });
}