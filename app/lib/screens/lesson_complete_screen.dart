import 'package:bijbelquiz/services/analytics_service.dart';
import 'package:flutter/material.dart';

import '../models/lesson.dart';
import './quiz_screen.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../services/lesson_service.dart';
import '../l10n/strings_nl.dart' as strings;

class LessonCompleteScreen extends StatefulWidget {
  final Lesson lesson;
  final int stars; // 0..3
  final int correct;
  final int total;
  final int bestStreak;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const LessonCompleteScreen({
    super.key,
    required this.lesson,
    required this.stars,
    required this.correct,
    required this.total,
    required this.bestStreak,
    required this.onRetry,
    required this.onExit,
  });

  @override
  State<LessonCompleteScreen> createState() => _LessonCompleteScreenState();
}

class _LessonCompleteScreenState extends State<LessonCompleteScreen> with SingleTickerProviderStateMixin {

  

  @override
  Widget build(BuildContext context) {
    Provider.of<AnalyticsService>(context, listen: false).screen('LessonCompleteScreen');
    final cs = Theme.of(context).colorScheme;
    final pctValue = widget.total > 0 ? (widget.correct / widget.total * 100.0) : 0.0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        child: Scaffold(
          backgroundColor: cs.surface,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: cs.onSurface),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ),
          body: Stack(
            children: [
              // Background gradient
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cs.primary.withValues(alpha: 0.10),
                      cs.primaryContainer.withValues(alpha: 0.06),
                      cs.surface,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              // Confetti removed
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                      child: SingleChildScrollView(
                        child: Column(
                        children: [
                          const SizedBox(height: 8),
                          // Heading + Icon (animated)
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.9, end: 1.0),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutBack,
                            builder: (context, value, child) => Transform.scale(scale: value, child: child),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: cs.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: cs.outlineVariant),
                                boxShadow: [
                                  BoxShadow(
                                    color: cs.primary.withValues(alpha: 0.15),
                                    blurRadius: 18,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.emoji_events_rounded, color: cs.primary, size: 36),
                                  const SizedBox(width: 12),
                                  Text(
                                    strings.AppStrings.lessonComplete,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          // Lesson title/badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: cs.outlineVariant),
                            ),
                            child: Text(
                              widget.lesson.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 24),
                          // Animated Stars row (celebration)
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Soft glow
                              Container(
                                width: 160,
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      cs.primary.withValues(alpha: 0.18),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (i) {
                                  final filled = i < widget.stars;
                                  final delayMs = 150 * i;
                                  return TweenAnimationBuilder<double>(
                                    key: ValueKey('star_$i-${widget.stars}'),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: Duration(milliseconds: 500 + delayMs),
                                    curve: Curves.easeOutBack,
                                    builder: (context, value, child) => Transform.scale(
                                      scale: value.clamp(0.0, 1.0),
                                      child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(right: i == 2 ? 0 : 12),
                                      child: Icon(
                                        Icons.star_rounded,
                                        size: 48,
                                        color: filled ? cs.primary : cs.outlineVariant,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),
                          // Stats cards
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _AnimatedNumberCard(
                                icon: Icons.check_circle_rounded,
                                label: strings.AppStrings.correct,
                                target: widget.correct,
                              ),
                              _AnimatedNumberCard(
                                icon: Icons.percent_rounded,
                                label: strings.AppStrings.percentage,
                                target: pctValue.round(),
                                suffix: '%',
                              ),
                              _StatCard(
                                icon: Icons.local_fire_department_rounded,
                                label: strings.AppStrings.bestStreak,
                                value: '${widget.bestStreak}',
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Call-to-actions
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Provider.of<AnalyticsService>(context, listen: false).capture('retry_lesson_from_complete');
                                    widget.onRetry();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.refresh_rounded, size: 20),
                                      const SizedBox(width: 8),
                                      const Text(strings.AppStrings.retryLesson),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: widget.stars > 0 ? () {
                                    Provider.of<AnalyticsService>(context, listen: false).capture('start_next_lesson_from_complete');
                                    _startNextQuiz();
                                  } : null,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(strings.AppStrings.nextLesson),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward_rounded, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startNextQuiz() async {
    try {
      final nextIndex = widget.lesson.index + 1;
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final service = LessonService();
      final lessons = await service.generateLessons(
        settings.language,
        maxLessons: nextIndex + 1,
        maxQuestionsPerLesson: widget.lesson.maxQuestions,
      );
      if (nextIndex < 0 || nextIndex >= lessons.length) return;
      final nextLesson = lessons[nextIndex];
      if (!mounted) return;
      final nav = Navigator.of(context);
      nav.pop();
      await nav.push(
        MaterialPageRoute(
          builder: (_) => QuizScreen(lesson: nextLesson, sessionLimit: nextLesson.maxQuestions),
        ),
      );
    } catch (_) {
      // Silently ignore; button is disabled when not eligible.
    }
  }

  // Confetti helper removed
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 168,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: cs.primary),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedNumberCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int target;
  final String? suffix;

  const _AnimatedNumberCard({
    required this.icon,
    required this.label,
    required this.target,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 168,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: cs.primary),
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: target.toDouble()),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              final text = value.round().toString() + (suffix ?? '');
              return Text(
                text,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              );
            },
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }
}