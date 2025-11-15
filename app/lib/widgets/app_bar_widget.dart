import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../l10n/strings_nl.dart' as strings;
import 'progress_widget.dart';

/// A custom app bar widget for the quiz screen
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Lesson? lesson;
  final int sessionAnswered;
  final int? sessionLimit;
  final bool lessonMode;

  const AppBarWidget({
    super.key,
    this.lesson,
    required this.sessionAnswered,
    this.sessionLimit,
    required this.lessonMode,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 24);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.quiz_rounded,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            strings.AppStrings.appName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                ),
          ),
        ],
      ),
      bottom: lessonMode
          ? PreferredSize(
              preferredSize: const Size.fromHeight(24),
              child: ProgressWidget(
                current: sessionAnswered,
                total: sessionLimit ?? 1,
              ),
            )
          : null,
      actions: const [],
    );
  }
}
