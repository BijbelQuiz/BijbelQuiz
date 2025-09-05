import 'package:flutter_test/flutter_test.dart';
import 'package:bijbelquiz/models/quiz_question.dart';

void main() {
  group('QuizQuestion', () {
    test('should create QuizQuestion with required parameters', () {
      final question = QuizQuestion(
        question: 'Test question?',
        correctAnswer: 'Correct',
        incorrectAnswers: ['Wrong1', 'Wrong2'],
        difficulty: '1',
        type: QuestionType.mc,
      );

      expect(question.question, 'Test question?');
      expect(question.correctAnswer, 'Correct');
      expect(question.incorrectAnswers, ['Wrong1', 'Wrong2']);
      expect(question.difficulty, '1');
      expect(question.type, QuestionType.mc);
      expect(question.categories, isEmpty);
      expect(question.biblicalReference, isNull);
    });

    test('should create QuizQuestion with optional parameters', () {
      final question = QuizQuestion(
        question: 'Test question?',
        correctAnswer: 'Correct',
        incorrectAnswers: ['Wrong1'],
        difficulty: '2',
        type: QuestionType.fitb,
        categories: ['Old Testament'],
        biblicalReference: 'Genesis 1:1',
      );

      expect(question.categories, ['Old Testament']);
      expect(question.biblicalReference, 'Genesis 1:1');
    });

    test('should parse from JSON - multiple choice', () {
      final json = {
        'vraag': 'What is 2+2?',
        'juisteAntwoord': '4',
        'fouteAntwoorden': ['3', '5'],
        'moeilijkheidsgraad': '1',
        'type': 'mc',
        'categories': ['Math'],
        'biblicalReference': 'Proverbs 1:1',
      };

      final question = QuizQuestion.fromJson(json);

      expect(question.question, 'What is 2+2?');
      expect(question.correctAnswer, '4');
      expect(question.incorrectAnswers, ['3', '5']);
      expect(question.difficulty, '1');
      expect(question.type, QuestionType.mc);
      expect(question.categories, ['Math']);
      expect(question.biblicalReference, 'Proverbs 1:1');
    });

    test('should parse from JSON - fill in the blank', () {
      final json = {
        'vraag': 'Complete the verse: "In the beginning ___"',
        'juisteAntwoord': 'God created',
        'fouteAntwoorden': ['was the word', 'there was light'],
        'moeilijkheidsgraad': '2',
        'type': 'fitb',
      };

      final question = QuizQuestion.fromJson(json);

      expect(question.type, QuestionType.fitb);
    });

    test('should parse from JSON - true/false with provided incorrect answers', () {
      final json = {
        'vraag': 'Is God real?',
        'juisteAntwoord': 'Waar',
        'fouteAntwoorden': ['Niet waar'],
        'moeilijkheidsgraad': '1',
        'type': 'tf',
      };

      final question = QuizQuestion.fromJson(json);

      expect(question.type, QuestionType.tf);
      expect(question.incorrectAnswers, ['Niet waar']);
    });

    test('should generate incorrect answers for true/false when not provided - Waar', () {
      final json = {
        'vraag': 'Is Jesus the Son of God?',
        'juisteAntwoord': 'Waar',
        'moeilijkheidsgraad': '1',
        'type': 'tf',
      };

      final question = QuizQuestion.fromJson(json);

      expect(question.incorrectAnswers, ['Niet waar']);
    });

    test('should generate incorrect answers for true/false when not provided - Niet waar', () {
      final json = {
        'vraag': 'Is the Bible fiction?',
        'juisteAntwoord': 'Niet waar',
        'moeilijkheidsgraad': '1',
        'type': 'tf',
      };

      final question = QuizQuestion.fromJson(json);

      expect(question.incorrectAnswers, ['Waar']);
    });

    test('should generate incorrect answers for true/false when not provided - True', () {
      final json = {
        'vraag': 'God exists?',
        'juisteAntwoord': 'True',
        'moeilijkheidsgraad': '1',
        'type': 'tf',
      };

      final question = QuizQuestion.fromJson(json);

      expect(question.incorrectAnswers, ['Niet waar']);
    });

    test('should generate incorrect answers for true/false when not provided - False', () {
      final json = {
        'vraag': 'Is sin good?',
        'juisteAntwoord': 'False',
        'moeilijkheidsgraad': '1',
        'type': 'tf',
      };

      final question = QuizQuestion.fromJson(json);

      expect(question.incorrectAnswers, ['Waar']);
    });

    test('should handle empty JSON gracefully', () {
      final Map<String, dynamic> json = {};

      final question = QuizQuestion.fromJson(json);

      expect(question.question, '');
      expect(question.correctAnswer, '');
      expect(question.incorrectAnswers, isEmpty);
      expect(question.difficulty, '');
      expect(question.type, QuestionType.mc);
    });

    test('should serialize to JSON', () {
      final question = QuizQuestion(
        question: 'Test?',
        correctAnswer: 'Yes',
        incorrectAnswers: ['No'],
        difficulty: '1',
        type: QuestionType.mc,
        categories: ['Test'],
        biblicalReference: 'Test 1:1',
      );

      final json = question.toJson();

      expect(json['vraag'], 'Test?');
      expect(json['juisteAntwoord'], 'Yes');
      expect(json['fouteAntwoorden'], ['No']);
      expect(json['moeilijkheidsgraad'], '1');
      expect(json['type'], 'mc');
      expect(json['categories'], ['Test']);
      expect(json['biblicalReference'], 'Test 1:1');
    });

    test('should shuffle answer options', () {
      final question = QuizQuestion(
        question: 'Test?',
        correctAnswer: 'Correct',
        incorrectAnswers: ['Wrong1', 'Wrong2', 'Wrong3'],
        difficulty: '1',
        type: QuestionType.mc,
      );

      final options = question.allOptions;
      expect(options.length, 4);
      expect(options.contains('Correct'), isTrue);
      expect(options.contains('Wrong1'), isTrue);
      expect(options.contains('Wrong2'), isTrue);
      expect(options.contains('Wrong3'), isTrue);
    });

    test('should return correct answer index', () {
      final question = QuizQuestion(
        question: 'Test?',
        correctAnswer: 'Correct',
        incorrectAnswers: ['Wrong1', 'Wrong2'],
        difficulty: '1',
        type: QuestionType.mc,
      );

      final index = question.correctAnswerIndex;
      expect(question.allOptions[index], 'Correct');
    });

    test('should return primary category', () {
      final question = QuizQuestion(
        question: 'Test?',
        correctAnswer: 'Correct',
        incorrectAnswers: ['Wrong'],
        difficulty: '1',
        type: QuestionType.mc,
        categories: ['Old Testament', 'Genesis'],
      );

      expect(question.category, 'Old Testament');
    });

    test('should return empty string when no categories', () {
      final question = QuizQuestion(
        question: 'Test?',
        correctAnswer: 'Correct',
        incorrectAnswers: ['Wrong'],
        difficulty: '1',
        type: QuestionType.mc,
      );

      expect(question.category, '');
    });
  });

  group('QuestionType parsing', () {
    test('should parse mc type from JSON', () {
      final json = {'type': 'mc'};
      final question = QuizQuestion.fromJson(json);
      expect(question.type, QuestionType.mc);
    });

    test('should parse fitb type from JSON', () {
      final json = {'type': 'fitb'};
      final question = QuizQuestion.fromJson(json);
      expect(question.type, QuestionType.fitb);
    });

    test('should parse tf type from JSON', () {
      final json = {'type': 'tf'};
      final question = QuizQuestion.fromJson(json);
      expect(question.type, QuestionType.tf);
    });

    test('should default to mc for unknown type', () {
      final json = {'type': 'unknown'};
      final question = QuizQuestion.fromJson(json);
      expect(question.type, QuestionType.mc);
    });

    test('should default to mc for null type', () {
      final Map<String, dynamic> json = {};
      final question = QuizQuestion.fromJson(json);
      expect(question.type, QuestionType.mc);
    });
  });

  group('Incorrect answers parsing', () {
    test('should parse list of incorrect answers from JSON', () {
      final json = {
        'fouteAntwoorden': ['Wrong1', 'Wrong2'],
        'type': 'mc'
      };
      final question = QuizQuestion.fromJson(json);
      expect(question.incorrectAnswers, ['Wrong1', 'Wrong2']);
    });

    test('should handle empty incorrect answers list', () {
      final json = {
        'fouteAntwoorden': [],
        'type': 'mc'
      };
      final question = QuizQuestion.fromJson(json);
      expect(question.incorrectAnswers, isEmpty);
    });

    test('should handle non-list incorrect answers', () {
      final json = {
        'fouteAntwoorden': 'not a list',
        'type': 'mc'
      };
      final question = QuizQuestion.fromJson(json);
      expect(question.incorrectAnswers, isEmpty);
    });

    test('should generate opposites for TF - Waar', () {
      final json = {
        'juisteAntwoord': 'Waar',
        'type': 'tf'
      };
      final question = QuizQuestion.fromJson(json);
      expect(question.incorrectAnswers, ['Niet waar']);
    });

    test('should generate opposites for TF - Niet waar', () {
      final json = {
        'juisteAntwoord': 'Niet waar',
        'type': 'tf'
      };
      final question = QuizQuestion.fromJson(json);
      expect(question.incorrectAnswers, ['Waar']);
    });

    test('should generate opposites for TF - True', () {
      final json = {
        'juisteAntwoord': 'True',
        'type': 'tf'
      };
      final question = QuizQuestion.fromJson(json);
      expect(question.incorrectAnswers, ['Niet waar']);
    });

    test('should generate opposites for TF - False', () {
      final json = {
        'juisteAntwoord': 'False',
        'type': 'tf'
      };
      final question = QuizQuestion.fromJson(json);
      expect(question.incorrectAnswers, ['Waar']);
    });

    test('should fallback for unknown TF answer', () {
      final json = {
        'juisteAntwoord': 'Unknown',
        'type': 'tf'
      };
      final question = QuizQuestion.fromJson(json);
      expect(question.incorrectAnswers, ['Niet waar']);
    });
  });

  group('Categories parsing', () {
    test('should parse list of categories from JSON', () {
      final json = {
        'categories': ['Old Testament', 'Genesis']
      };
      final question = QuizQuestion.fromJson(json);
      expect(question.categories, ['Old Testament', 'Genesis']);
    });

    test('should handle empty categories list', () {
      final json = {
        'categories': []
      };
      final question = QuizQuestion.fromJson(json);
      expect(question.categories, isEmpty);
    });

    test('should handle non-list categories', () {
      final json = {
        'categories': 'not a list'
      };
      final question = QuizQuestion.fromJson(json);
      expect(question.categories, isEmpty);
    });
  });
}