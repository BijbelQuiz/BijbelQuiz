import 'package:flutter/material.dart';
import 'lesson_progress_bar.dart';

/// A widget that displays the lesson progress bar
class ProgressWidget extends StatelessWidget {
  final int current;
  final int total;

  const ProgressWidget({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return LessonProgressBar(
      current: current,
      total: total,
    );
  }
}
