import 'quiz_question.dart';

/// Represents the state of a single question within the quiz.
///
/// This class holds all the information related to the current question being
/// displayed, including the question itself, the user's answer, and UI state
/// like timers and transitions. It is an immutable class, and state changes
/// are managed using the [copyWith] method.
class QuizState {
  /// The current [QuizQuestion] being displayed.
  final QuizQuestion question;

  /// The index of the answer selected by the user. `null` if no answer has been selected yet.
  final int? selectedAnswerIndex;

  /// `true` if the user is currently in the process of answering (e.g., timer is running).
  final bool isAnswering;

  /// `true` if the UI is transitioning between questions.
  final bool isTransitioning;

  /// The time remaining to answer the current question, in seconds.
  final int timeRemaining;

  /// The current difficulty level of the quiz.
  final double currentDifficulty;

  /// Creates a new [QuizState].
  const QuizState({
    required this.question,
    this.selectedAnswerIndex,
    this.isAnswering = false,
    this.isTransitioning = false,
    this.timeRemaining = 20,
    this.currentDifficulty = 0.0,
  });

  /// Creates a copy of this [QuizState] with the given fields updated.
  ///
  /// This is used to create a new state object when a property changes,
  /// preserving the immutability of the state.
  QuizState copyWith({
    QuizQuestion? question,
    Object? selectedAnswerIndex = _sentinel,
    bool? isAnswering,
    bool? isTransitioning,
    int? timeRemaining,
    double? currentDifficulty,
  }) {
    return QuizState(
      question: question ?? this.question,
      selectedAnswerIndex: selectedAnswerIndex == _sentinel
          ? this.selectedAnswerIndex
          : selectedAnswerIndex as int?,
      isAnswering: isAnswering ?? this.isAnswering,
      isTransitioning: isTransitioning ?? this.isTransitioning,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      currentDifficulty: currentDifficulty ?? this.currentDifficulty,
    );
  }

  static const _sentinel = Object();
}
