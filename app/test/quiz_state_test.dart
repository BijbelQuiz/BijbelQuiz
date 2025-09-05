import 'package:flutter_test/flutter_test.dart';
import 'package:bijbelquiz/models/quiz_question.dart';
import 'package:bijbelquiz/models/quiz_state.dart';

void main() {
  // Helper function to create a test question
  QuizQuestion _createTestQuestion() {
    return QuizQuestion(
      question: 'Test question?',
      correctAnswer: 'Correct',
      incorrectAnswers: ['Wrong1', 'Wrong2'],
      difficulty: '1',
      type: QuestionType.mc,
    );
  }

  group('QuizState', () {
    test('should create QuizState with required parameters', () {
      final question = _createTestQuestion();
      final state = QuizState(question: question);

      expect(state.question, question);
      expect(state.selectedAnswerIndex, isNull);
      expect(state.isAnswering, isFalse);
      expect(state.isTransitioning, isFalse);
      expect(state.timeRemaining, 20);
      expect(state.currentDifficulty, 0.0);
    });

    test('should create QuizState with all parameters', () {
      final question = _createTestQuestion();
      final state = QuizState(
        question: question,
        selectedAnswerIndex: 1,
        isAnswering: true,
        isTransitioning: false,
        timeRemaining: 15,
        currentDifficulty: 2.5,
      );

      expect(state.question, question);
      expect(state.selectedAnswerIndex, 1);
      expect(state.isAnswering, isTrue);
      expect(state.isTransitioning, isFalse);
      expect(state.timeRemaining, 15);
      expect(state.currentDifficulty, 2.5);
    });

    test('should copy QuizState with updated fields', () {
      final question1 = _createTestQuestion();
      final question2 = QuizQuestion(
        question: 'Another question?',
        correctAnswer: 'Answer',
        incorrectAnswers: ['Wrong'],
        difficulty: '2',
        type: QuestionType.tf,
      );

      final original = QuizState(
        question: question1,
        selectedAnswerIndex: null,
        isAnswering: false,
        isTransitioning: false,
        timeRemaining: 20,
        currentDifficulty: 0.0,
      );

      final copied = original.copyWith(
        question: question2,
        selectedAnswerIndex: 0,
        isAnswering: true,
        isTransitioning: true,
        timeRemaining: 10,
        currentDifficulty: 1.5,
      );

      expect(copied.question, question2);
      expect(copied.selectedAnswerIndex, 0);
      expect(copied.isAnswering, isTrue);
      expect(copied.isTransitioning, isTrue);
      expect(copied.timeRemaining, 10);
      expect(copied.currentDifficulty, 1.5);

      // Original should remain unchanged
      expect(original.question, question1);
      expect(original.selectedAnswerIndex, isNull);
      expect(original.isAnswering, isFalse);
      expect(original.isTransitioning, isFalse);
      expect(original.timeRemaining, 20);
      expect(original.currentDifficulty, 0.0);
    });

    test('should copy QuizState with null values (no changes)', () {
      final question = _createTestQuestion();
      final original = QuizState(
        question: question,
        selectedAnswerIndex: 1,
        isAnswering: true,
        isTransitioning: false,
        timeRemaining: 15,
        currentDifficulty: 2.5,
      );

      final copied = original.copyWith();

      expect(copied.question, original.question);
      expect(copied.selectedAnswerIndex, original.selectedAnswerIndex);
      expect(copied.isAnswering, original.isAnswering);
      expect(copied.isTransitioning, original.isTransitioning);
      expect(copied.timeRemaining, original.timeRemaining);
      expect(copied.currentDifficulty, original.currentDifficulty);
    });

    test('should copy QuizState with partial updates', () {
      final question = _createTestQuestion();
      final original = QuizState(
        question: question,
        selectedAnswerIndex: null,
        isAnswering: false,
        isTransitioning: false,
        timeRemaining: 20,
        currentDifficulty: 0.0,
      );

      // Update only selectedAnswerIndex and timeRemaining
      final copied = original.copyWith(
        selectedAnswerIndex: 2,
        timeRemaining: 5,
      );

      expect(copied.question, original.question); // unchanged
      expect(copied.selectedAnswerIndex, 2);
      expect(copied.isAnswering, original.isAnswering); // unchanged
      expect(copied.isTransitioning, original.isTransitioning); // unchanged
      expect(copied.timeRemaining, 5);
      expect(copied.currentDifficulty, original.currentDifficulty); // unchanged
    });

    test('should maintain immutability when copying', () {
      final question = _createTestQuestion();
      final original = QuizState(
        question: question,
        selectedAnswerIndex: 0,
        isAnswering: true,
        isTransitioning: false,
        timeRemaining: 20,
        currentDifficulty: 1.0,
      );

      final copied = original.copyWith(selectedAnswerIndex: 1);

      // Verify they are different objects
      expect(identical(original, copied), isFalse);

      // Verify original is unchanged
      expect(original.selectedAnswerIndex, 0);

      // Verify copy has new value
      expect(copied.selectedAnswerIndex, 1);
    });

    test('should handle null selectedAnswerIndex', () {
      final question = _createTestQuestion();
      final state = QuizState(
        question: question,
        selectedAnswerIndex: null,
      );

      expect(state.selectedAnswerIndex, isNull);

      final copied = state.copyWith(selectedAnswerIndex: 1);
      expect(copied.selectedAnswerIndex, 1);

      final copiedBack = copied.copyWith(selectedAnswerIndex: null);
      expect(copiedBack.selectedAnswerIndex, isNull);
    });

    test('should handle boolean flag updates', () {
      final question = _createTestQuestion();
      final state = QuizState(
        question: question,
        isAnswering: false,
        isTransitioning: false,
      );

      var updated = state.copyWith(isAnswering: true);
      expect(updated.isAnswering, isTrue);
      expect(updated.isTransitioning, isFalse);

      updated = updated.copyWith(isTransitioning: true);
      expect(updated.isAnswering, isTrue);
      expect(updated.isTransitioning, isTrue);

      updated = updated.copyWith(isAnswering: false, isTransitioning: false);
      expect(updated.isAnswering, isFalse);
      expect(updated.isTransitioning, isFalse);
    });

    test('should handle time remaining updates', () {
      final question = _createTestQuestion();
      final state = QuizState(
        question: question,
        timeRemaining: 20,
      );

      var updated = state.copyWith(timeRemaining: 15);
      expect(updated.timeRemaining, 15);

      updated = updated.copyWith(timeRemaining: 0);
      expect(updated.timeRemaining, 0);

      updated = updated.copyWith(timeRemaining: 30);
      expect(updated.timeRemaining, 30);
    });

    test('should handle difficulty updates', () {
      final question = _createTestQuestion();
      final state = QuizState(
        question: question,
        currentDifficulty: 0.0,
      );

      var updated = state.copyWith(currentDifficulty: 1.5);
      expect(updated.currentDifficulty, 1.5);

      updated = updated.copyWith(currentDifficulty: 3.0);
      expect(updated.currentDifficulty, 3.0);

      updated = updated.copyWith(currentDifficulty: -1.0);
      expect(updated.currentDifficulty, -1.0);
    });

    test('should handle question replacement', () {
      final question1 = _createTestQuestion();
      final question2 = QuizQuestion(
        question: 'Different question?',
        correctAnswer: 'Different',
        incorrectAnswers: ['Wrong'],
        difficulty: '3',
        type: QuestionType.fitb,
      );

      final state = QuizState(question: question1);
      expect(state.question.question, 'Test question?');

      final updated = state.copyWith(question: question2);
      expect(updated.question.question, 'Different question?');
      expect(updated.question.type, QuestionType.fitb);
    });
  });
}