import 'package:flutter_test/flutter_test.dart';
import 'package:bijbelquiz/models/lesson.dart';

void main() {
  group('Lesson', () {
    test('should create Lesson with required parameters', () {
      final lesson = Lesson(
        id: 'lesson_0001',
        title: 'Genesis',
        category: 'genesis',
        maxQuestions: 10,
        index: 0,
      );

      expect(lesson.id, 'lesson_0001');
      expect(lesson.title, 'Genesis');
      expect(lesson.category, 'genesis');
      expect(lesson.maxQuestions, 10);
      expect(lesson.index, 0);
      expect(lesson.description, isNull);
      expect(lesson.iconHint, isNull);
    });

    test('should create Lesson with optional parameters', () {
      final lesson = Lesson(
        id: 'lesson_0002',
        title: 'Exodus',
        category: 'exodus',
        maxQuestions: 15,
        index: 1,
        description: 'The story of Moses and the Israelites',
        iconHint: '📖',
      );

      expect(lesson.description, 'The story of Moses and the Israelites');
      expect(lesson.iconHint, '📖');
    });

    test('should create Lesson from category using factory', () {
      final lesson = Lesson.fromCategory(
        category: 'old_testament',
        index: 5,
        maxQuestions: 20,
        description: 'Old Testament overview',
        iconHint: '📚',
      );

      expect(lesson.id, 'lesson_0005');
      expect(lesson.title, 'Old Testament');
      expect(lesson.category, 'old_testament');
      expect(lesson.maxQuestions, 20);
      expect(lesson.index, 5);
      expect(lesson.description, 'Old Testament overview');
      expect(lesson.iconHint, '📚');
    });

    test('should convert category to title case', () {
      final lesson = Lesson.fromCategory(category: 'old_testament_books', index: 0);
      expect(lesson.title, 'Old Testament Books');
    });

    test('should handle single word category', () {
      final lesson = Lesson.fromCategory(category: 'genesis', index: 1);
      expect(lesson.title, 'Genesis');
    });

    test('should handle empty category', () {
      final lesson = Lesson.fromCategory(category: '', index: 2);
      expect(lesson.title, '');
    });

    test('should handle category with multiple underscores and hyphens', () {
      final lesson = Lesson.fromCategory(category: 'new_testament-books', index: 3);
      expect(lesson.title, 'New Testament Books');
    });

    test('should use default maxQuestions when not specified', () {
      final lesson = Lesson.fromCategory(category: 'test_category', index: 4);
      expect(lesson.maxQuestions, 10);
    });

    test('should copy Lesson with updated fields', () {
      final original = Lesson(
        id: 'lesson_0001',
        title: 'Genesis',
        category: 'genesis',
        maxQuestions: 10,
        index: 0,
        description: 'Original description',
        iconHint: '📖',
      );

      final copied = original.copyWith(
        title: 'Genesis Updated',
        maxQuestions: 15,
        description: 'Updated description',
      );

      expect(copied.id, 'lesson_0001'); // unchanged
      expect(copied.title, 'Genesis Updated');
      expect(copied.category, 'genesis'); // unchanged
      expect(copied.maxQuestions, 15);
      expect(copied.index, 0); // unchanged
      expect(copied.description, 'Updated description');
      expect(copied.iconHint, '📖'); // unchanged
    });

    test('should copy Lesson with null values (no changes)', () {
      final original = Lesson(
        id: 'lesson_0001',
        title: 'Genesis',
        category: 'genesis',
        maxQuestions: 10,
        index: 0,
      );

      final copied = original.copyWith();

      expect(copied.id, original.id);
      expect(copied.title, original.title);
      expect(copied.category, original.category);
      expect(copied.maxQuestions, original.maxQuestions);
      expect(copied.index, original.index);
      expect(copied.description, original.description);
      expect(copied.iconHint, original.iconHint);
    });

    test('should serialize to JSON', () {
      final lesson = Lesson(
        id: 'lesson_0001',
        title: 'Genesis',
        category: 'genesis',
        maxQuestions: 10,
        index: 0,
        description: 'Book of beginnings',
        iconHint: '🌅',
      );

      final json = lesson.toJson();

      expect(json['id'], 'lesson_0001');
      expect(json['title'], 'Genesis');
      expect(json['category'], 'genesis');
      expect(json['maxQuestions'], 10);
      expect(json['index'], 0);
      expect(json['description'], 'Book of beginnings');
      expect(json['iconHint'], '🌅');
    });

    test('should parse from JSON', () {
      final json = {
        'id': 'lesson_0002',
        'title': 'Exodus',
        'category': 'exodus',
        'maxQuestions': 15,
        'index': 1,
        'description': 'The exodus story from Egypt',
        'iconHint': '🏜️',
      };

      final lesson = Lesson.fromJson(json);

      expect(lesson.id, 'lesson_0002');
      expect(lesson.title, 'Exodus');
      expect(lesson.category, 'exodus');
      expect(lesson.maxQuestions, 15);
      expect(lesson.index, 1);
      expect(lesson.description, 'The exodus story from Egypt');
      expect(lesson.iconHint, '🏜️');
    });

    test('should handle missing optional fields in JSON', () {
      final json = {
        'id': 'lesson_0003',
        'title': 'Leviticus',
        'category': 'leviticus',
        'maxQuestions': 12,
        'index': 2,
      };

      final lesson = Lesson.fromJson(json);

      expect(lesson.description, isNull);
      expect(lesson.iconHint, isNull);
    });

    test('should handle string maxQuestions in JSON', () {
      final json = {
        'id': 'lesson_0004',
        'title': 'Numbers',
        'category': 'numbers',
        'maxQuestions': '8',
        'index': 3,
      };

      final lesson = Lesson.fromJson(json);

      expect(lesson.maxQuestions, 8);
    });

    test('should handle invalid maxQuestions in JSON', () {
      final json = {
        'id': 'lesson_0005',
        'title': 'Deuteronomy',
        'category': 'deuteronomy',
        'maxQuestions': 'invalid',
        'index': 4,
      };

      final lesson = Lesson.fromJson(json);

      expect(lesson.maxQuestions, 10); // default fallback
    });

    test('should handle string index in JSON', () {
      final json = {
        'id': 'lesson_0006',
        'title': 'Joshua',
        'category': 'joshua',
        'maxQuestions': 10,
        'index': '5',
      };

      final lesson = Lesson.fromJson(json);

      expect(lesson.index, 5);
    });

    test('should handle invalid index in JSON', () {
      final json = {
        'id': 'lesson_0007',
        'title': 'Judges',
        'category': 'judges',
        'maxQuestions': 10,
        'index': 'invalid',
      };

      final lesson = Lesson.fromJson(json);

      expect(lesson.index, 0); // default fallback
    });

    test('should handle null values in JSON', () {
      final json = {
        'id': null,
        'title': null,
        'category': null,
        'maxQuestions': null,
        'index': null,
      };

      final lesson = Lesson.fromJson(json);

      expect(lesson.id, '');
      expect(lesson.title, '');
      expect(lesson.category, '');
      expect(lesson.maxQuestions, 10);
      expect(lesson.index, 0);
    });

    test('should convert to string representation', () {
      final lesson = Lesson(
        id: 'lesson_0001',
        title: 'Genesis',
        category: 'genesis',
        maxQuestions: 10,
        index: 0,
      );

      final jsonString = lesson.toString();
      expect(jsonString, isNotEmpty);
      expect(jsonString.contains('lesson_0001'), isTrue);
      expect(jsonString.contains('Genesis'), isTrue);
    });

    test('should handle complex category names correctly', () {
      final lesson = Lesson.fromCategory(category: 'new_testament_gospels_matthew', index: 10);
      expect(lesson.title, 'New Testament Gospels Matthew');
    });

    test('should handle category with numbers', () {
      final lesson = Lesson.fromCategory(category: 'psalms_119', index: 18);
      expect(lesson.title, 'Psalms 119');
    });

    test('should handle mixed case category', () {
      final lesson = Lesson.fromCategory(category: 'NeW_tEsTaMeNt', index: 26);
      expect(lesson.title, 'New Testament');
    });

    test('should handle category with special characters', () {
      final lesson = Lesson.fromCategory(category: 'song-of-solomon', index: 21);
      expect(lesson.title, 'Song Of Solomon');
    });
  });
}