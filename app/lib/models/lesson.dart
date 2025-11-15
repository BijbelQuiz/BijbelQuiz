import 'dart:convert';

/// Lightweight model describing a Duolingo-like lesson.
/// Lessons are generated from question categories and capped to a fixed size.
class Lesson {
  /// Unique id, e.g., "lesson_0001"
  final String id;

  /// Display title, usually derived from [category]
  final String title;

  /// Backing question category used to fetch questions
  final String category;

  /// Optional description shown in selection UI
  final String? description;

  /// Optional icon hint for UI (material icon name or emoji)
  /// UI may map known names to Icons.* or fallback to an emoji.
  final String? iconHint;

  /// Max number of questions in this lesson
  final int maxQuestions;

  /// Sequential index in the lesson track (0-based)
  final int index;

  const Lesson({
    required this.id,
    required this.title,
    required this.category,
    required this.maxQuestions,
    required this.index,
    this.description,
    this.iconHint,
  });

  /// Convenience factory to build a lesson from a category name.
  factory Lesson.fromCategory({
    required String category,
    required int index,
    int maxQuestions = 10,
    String? description,
    String? iconHint,
  }) {
    final safeId = 'lesson_${index.toString().padLeft(4, '0')}';
    final title = _toTitleCase(category);
    return Lesson(
      id: safeId,
      title: title,
      category: category,
      maxQuestions: maxQuestions,
      index: index,
      description: description,
      iconHint: iconHint,
    );
  }

  Lesson copyWith({
    String? id,
    String? title,
    String? category,
    String? description,
    String? iconHint,
    int? maxQuestions,
    int? index,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      iconHint: iconHint ?? this.iconHint,
      maxQuestions: maxQuestions ?? this.maxQuestions,
      index: index ?? this.index,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'description': description,
        'iconHint': iconHint,
        'maxQuestions': maxQuestions,
        'index': index,
      };

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        category: json['category']?.toString() ?? '',
        description: json['description']?.toString(),
        iconHint: json['iconHint']?.toString(),
        maxQuestions: (json['maxQuestions'] is int)
            ? json['maxQuestions'] as int
            : int.tryParse(json['maxQuestions']?.toString() ?? '') ?? 10,
        index: (json['index'] is int)
            ? json['index'] as int
            : int.tryParse(json['index']?.toString() ?? '') ?? 0,
      );

  @override
  String toString() => jsonEncode(toJson());

  static String _toTitleCase(String input) {
    if (input.isEmpty) return input;
    final words = input
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .where((w) => w.trim().isNotEmpty)
        .toList();
    final cased = words
        .map((w) =>
            w.substring(0, 1).toUpperCase() +
            (w.length > 1 ? w.substring(1).toLowerCase() : ''))
        .join(' ');
    return cased;
  }
}
