/// Represents a single quiz question, including the question text, answers,
/// and difficulty level.
enum QuestionType { mc, fitb, tf }

QuestionType _parseQuestionType(String? type) {
  if (type == null) return QuestionType.mc;

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

/// Parses incorrect answers from JSON data
List<String> _parseIncorrectAnswers(
    dynamic rawIncorrect, QuestionType type, String correctAnswer) {
  if (rawIncorrect is List && rawIncorrect.isNotEmpty) {
    return rawIncorrect.map((e) => e.toString()).toList();
  }

  // For true/false questions without provided incorrect answers, generate sensible opposites
  if (type == QuestionType.tf) {
    final lc = correctAnswer.toLowerCase();
    if (lc == 'true' || lc == 'waar') {
      return ['Niet waar'];
    } else if (lc == 'false' || lc == 'niet waar') {
      return ['Waar'];
    } else {
      // Fallback assumes Dutch labeling in dataset
      return ['Niet waar'];
    }
  }

  return [];
}

/// Parses categories from JSON data
List<String> _parseCategories(dynamic rawCategories) {
  if (rawCategories is List) {
    return rawCategories.map((e) => e.toString()).toList();
  }
  return [];
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
  /// The unique ID of the quiz question.
  final String id;

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
  /// The [id], [question], [correctAnswer], [incorrectAnswers], [difficulty], and [type] are required.
  /// The answer options are automatically shuffled upon creation.
  QuizQuestion({
    required this.id,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.difficulty,
    required this.type,
    this.categories = const [],
    this.biblicalReference,
  }) : _shuffledOptions =
            _createShuffledOptions(correctAnswer, incorrectAnswers) {
    // Input validation
    _validateId(id);
    _validateQuestion(question);
    _validateCorrectAnswer(correctAnswer);
    _validateIncorrectAnswers(incorrectAnswers);
    _validateDifficulty(difficulty);
    _validateCategories(categories);
    _validateBiblicalReference(biblicalReference);
  }

  static void _validateId(String id) {
    if (id.isEmpty || id.length > 100) {
      throw ArgumentError('id must be non-empty and less than 100 characters');
    }
  }

  static void _validateQuestion(String question) {
    if (question.isEmpty || question.length > 1000) {
      throw ArgumentError('question must be non-empty and less than 1000 characters');
    }
  }

  static void _validateCorrectAnswer(String correctAnswer) {
    if (correctAnswer.isEmpty || correctAnswer.length > 500) {
      throw ArgumentError('correctAnswer must be non-empty and less than 500 characters');
    }
  }

  static void _validateIncorrectAnswers(List<String> incorrectAnswers) {
    if (incorrectAnswers.isEmpty) {
      throw ArgumentError('incorrectAnswers must not be empty');
    }
    if (incorrectAnswers.length > 10) {
      throw ArgumentError('incorrectAnswers must have at most 10 items');
    }
    for (final answer in incorrectAnswers) {
      if (answer.isEmpty || answer.length > 500) {
        throw ArgumentError('Each incorrect answer must be non-empty and less than 500 characters');
      }
    }
  }

  static void _validateDifficulty(String difficulty) {
    if (difficulty.isEmpty || difficulty.length > 50) {
      throw ArgumentError('difficulty must be non-empty and less than 50 characters');
    }
  }

  static void _validateCategories(List<String> categories) {
    if (categories.length > 50) {
      throw ArgumentError('categories must have at most 50 items');
    }
    for (final category in categories) {
      if (category.isEmpty || category.length > 50) {
        throw ArgumentError('Each category must be non-empty and less than 50 characters');
      }
    }
  }

  static void _validateBiblicalReference(String? biblicalReference) {
    if (biblicalReference != null && biblicalReference.length > 100) {
      throw ArgumentError('biblicalReference must be less than 100 characters');
    }
  }

  /// Creates a [QuizQuestion] from a JSON map.
  ///
  /// This factory is used to parse question data from a JSON source.
  /// The JSON keys 'id', 'vraag', 'juisteAntwoord', 'fouteAntwoorden', 'moeilijkheidsgraad', and 'type' are used to populate the question's properties.
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final type = _parseQuestionType(json['type']?.toString());
    final correctAnswer = json['juisteAntwoord']?.toString() ?? json['correctAnswer']?.toString() ?? '';
    final incorrectAnswers =
        _parseIncorrectAnswers(json['fouteAntwoorden'] ?? json['incorrectAnswers'], type, correctAnswer);
    final categories = _parseCategories(json['categories']);
    final biblicalReference = json['biblicalReference'] as String?;
    final id = json['id']?.toString() ?? '';
    final question = json['vraag']?.toString() ?? json['question']?.toString() ?? '';
    final difficulty = json['moeilijkheidsgraad']?.toString() ?? json['difficulty']?.toString() ?? '';

    // Validate parsed data before creating instance
    _validateId(id);
    _validateQuestion(question);
    _validateCorrectAnswer(correctAnswer);
    _validateIncorrectAnswers(incorrectAnswers);
    _validateDifficulty(difficulty);
    _validateCategories(categories);
    _validateBiblicalReference(biblicalReference);

    return QuizQuestion(
      id: id,
      question: question,
      correctAnswer: correctAnswer,
      incorrectAnswers: incorrectAnswers,
      difficulty: difficulty,
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
      'id': id,
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
  static List<String> _createShuffledOptions(
      String correctAnswer, List<String> incorrectAnswers) {
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
