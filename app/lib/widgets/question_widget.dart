import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../services/performance_service.dart';
import 'question_card.dart';

/// A widget that displays the question and handles answer selection
class QuestionWidget extends StatelessWidget {
  final QuizQuestion question;
  final int? selectedAnswerIndex;
  final bool isAnswering;
  final bool isTransitioning;
  final Function(int) onAnswerSelected;
  final String language;
  final PerformanceService? performanceService;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.selectedAnswerIndex,
    required this.isAnswering,
    required this.isTransitioning,
    required this.onAnswerSelected,
    required this.language,
    this.performanceService,
  });

  @override
  Widget build(BuildContext context) {
    return QuestionCard(
      question: question,
      selectedAnswerIndex: selectedAnswerIndex,
      isAnswering: isAnswering,
      isTransitioning: isTransitioning,
      onAnswerSelected: onAnswerSelected,
      language: language,
      performanceService: performanceService,
    );
  }
}