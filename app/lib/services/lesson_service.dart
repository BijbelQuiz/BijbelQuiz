import '../models/lesson.dart';
import '../services/logger.dart';

/// Builds Duolingo-like lessons not tied to categories.
/// Lessons are generic, numbered, and each pulls a capped set of random questions.
class LessonService {
  LessonService();

  /// Generates a sequential list of generic lessons (Les 1, Les 2, ...).
  ///
  /// - [language]: question language (currently forced to 'nl' in settings)
  /// - [maxLessons]: number of lessons to expose in the track
  /// - [maxQuestionsPerLesson]: cap of questions per lesson
  Future<List<Lesson>> generateLessons(
    String language, {
    int maxLessons = 30,
    int maxQuestionsPerLesson = 10,
  }) async {
    try {
      final lessons = List<Lesson>.generate(maxLessons, (i) {
        final id = 'lesson_${i.toString().padLeft(4, '0')}';
        final title = 'Les ${i + 1}';
        return Lesson(
          id: id,
          title: title,
          // Not category-based. We keep a neutral marker.
          category: 'Algemeen',
          maxQuestions: maxQuestionsPerLesson,
          index: i,
          description: 'Beantwoord $maxQuestionsPerLesson vragen',
          iconHint: _iconForIndex(i),
        );
      });

      if (lessons.isEmpty) {
        return [
          Lesson(
            id: 'lesson_0000',
            title: 'Les 1',
            category: 'Algemeen',
            maxQuestions: maxQuestionsPerLesson,
            index: 0,
            description: 'Beantwoord $maxQuestionsPerLesson vragen',
            iconHint: 'menu_book',
          ),
        ];
      }

      return lessons;
    } catch (e) {
      AppLogger.error('Failed to generate lessons', e);
      // Minimal fallback to keep UI functional
      return [
        Lesson(
          id: 'lesson_0000',
          title: 'Les 1',
          category: 'Algemeen',
          maxQuestions: maxQuestionsPerLesson,
          index: 0,
          description: 'Beantwoord $maxQuestionsPerLesson vragen',
          iconHint: 'menu_book',
        ),
      ];
    }
  }

  String _iconForIndex(int i) {
    const icons = [
      'menu_book',
      'stars',
      'auto_awesome',
      'emoji_objects',
      'record_voice_over',
      'forum',
      'church',
      'music_note',
      'mail',
      'castle',
    ];
    return icons[i % icons.length];
  }
}
