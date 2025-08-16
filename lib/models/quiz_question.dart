/// Represents a single quiz question, including the question text, answers,
/// and difficulty level.
enum QuestionType { mc, fitb, tf }

QuestionType _parseQuestionType(String? type) {
  switch (type) {
    case 'mc':
      return QuestionType.mc;
    case 'fitb':
      return QuestionType.fitb;
    case 'tf':
      return QuestionType.tf;
    default:
      return QuestionType.mc; // fallback for now
  }
}

String _questionTypeToString(QuestionType type) {
  switch (type) {
    case QuestionType.mc:
      return 'mc';
    case QuestionType.fitb:
      return 'fitb';
    case QuestionType.tf:
      return 'tf';
  }
}

class QuizQuestion {
  /// The text of the quiz question.
  final String question;

  /// The correct answer for the question.
  final String correctAnswer;

  /// A list of incorrect answer options.
  final List<String> incorrectAnswers;

  /// The difficulty level of the question (e.g., "Easy", "Hard").
  final String difficulty;

  /// The type of the question (e.g., multiple choice, true/false, etc.)
  final QuestionType type;

  /// The categories this question belongs to
  final List<String> categories;

  /// The biblical reference for this question
  final String? biblicalReference;

  /// A private list of all answer options (correct and incorrect) in a shuffled order.
  final List<String> _shuffledOptions;

  /// Creates a new [QuizQuestion].
  ///
  /// The [question], [correctAnswer], [incorrectAnswers], [difficulty], and [type] are required.
  /// The answer options are automatically shuffled upon creation.
  QuizQuestion({
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.difficulty,
    required this.type,
    this.categories = const [],
    this.biblicalReference,
  }) : _shuffledOptions = _createShuffledOptions(correctAnswer, incorrectAnswers);

  /// Creates a [QuizQuestion] from a JSON map.
  ///
  /// This factory is used to parse question data from a JSON source.
  /// The JSON keys 'vraag', 'juisteAntwoord', 'fouteAntwoorden', 'moeilijkheidsgraad', and 'type' are used to populate the question's properties.
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final type = _parseQuestionType(json['type']?.toString() ?? 'mc');
    final correctAnswer = json['juisteAntwoord']?.toString() ?? '';
    List<String> incorrectAnswers;

    final rawIncorrect = json['fouteAntwoorden'];
    if (type == QuestionType.tf) {
      // Use provided incorrect answers when present, otherwise generate a sensible opposite
      if (rawIncorrect is List && rawIncorrect.isNotEmpty) {
        incorrectAnswers = rawIncorrect.map((e) => e.toString()).toList();
      } else {
        final lc = correctAnswer.toLowerCase();
        if (lc == 'true' || lc == 'waar') {
          incorrectAnswers = ['Niet waar'];
        } else if (lc == 'false' || lc == 'niet waar') {
          incorrectAnswers = ['Waar'];
        } else {
          // Fallback assumes Dutch labeling in dataset
          incorrectAnswers = ['Niet waar'];
        }
      }
    } else {
      if (rawIncorrect is List) {
        incorrectAnswers = rawIncorrect.map((e) => e.toString()).toList();
      } else {
        incorrectAnswers = [];
      }
    }

    // Parse categories
    List<String> categories = [];
    final rawCategories = json['categories'];
    if (rawCategories is List) {
      categories = rawCategories.map((e) => e.toString()).toList();
    }

    // Parse biblical reference
    final biblicalReference = json['biblicalReference'] is String 
        ? json['biblicalReference'] as String 
        : null;

    return QuizQuestion(
      question: json['vraag']?.toString() ?? '',
      correctAnswer: correctAnswer,
      incorrectAnswers: incorrectAnswers,
      difficulty: json['moeilijkheidsgraad']?.toString() ?? '',
      type: type,
      categories: categories,
      biblicalReference: biblicalReference,
    );
  }

  /// Converts the [QuizQuestion] to a JSON map.
  ///
  /// This method is used for caching questions to persistent storage.
  Map<String, dynamic> toJson() {
    return {
      'vraag': question,
      'juisteAntwoord': correctAnswer,
      'fouteAntwoorden': incorrectAnswers,
      'moeilijkheidsgraad': difficulty,
      'type': _questionTypeToString(type),
      'categories': categories,
      'biblicalReference': biblicalReference,
    };
  }

  /// A private helper method to create a shuffled list of answer options.
  static List<String> _createShuffledOptions(String correctAnswer, List<String> incorrectAnswers) {
    final List<String> options = List.from(incorrectAnswers);
    options.add(correctAnswer);
    options.shuffle();
    return options;
  }

  /// Returns a shuffled list of all answer options.
  List<String> get allOptions => List.from(_shuffledOptions);

  /// Returns the index of the correct answer within the shuffled [allOptions] list.
  int get correctAnswerIndex => _shuffledOptions.indexOf(correctAnswer);

  /// Returns the primary category (first category) or empty string if none
  String get category => categories.isNotEmpty ? categories.first : '';
} 