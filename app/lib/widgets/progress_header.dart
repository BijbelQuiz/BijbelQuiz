import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/lesson.dart';
import '../providers/lesson_progress_provider.dart';
import '../screens/quiz_screen.dart';
import '../services/analytics_service.dart';
import '../services/greeting_service.dart';
import '../services/logger.dart';
import '../l10n/strings_nl.dart' as strings;

enum DayState { success, fail, freeze, future }

class DayIndicator {
  final DateTime date;
  final DayState state;
  const DayIndicator({required this.date, required this.state});
}

class ProgressHeader extends StatefulWidget {
  final List<Lesson> lessons;
  final Lesson? continueLesson;
  final VoidCallback? onAfterQuizReturn;
  final int streakDays;
  final List<DayIndicator> dayWindow;
  final VoidCallback? onMultiplayerPressed;

  const ProgressHeader(
      {super.key,
      required this.lessons,
      this.continueLesson,
      this.onAfterQuizReturn,
      this.streakDays = 0,
      this.dayWindow = const [],
      this.onMultiplayerPressed});

  @override
  State<ProgressHeader> createState() => _ProgressHeaderState();
}

class _ProgressHeaderState extends State<ProgressHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  String _greeting = 'Jouw voortgang'; // Default fallback
  final GreetingService _greetingService = GreetingService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _progressAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _loadGreeting();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _animationController.forward();
    });
  }

  Future<void> _loadGreeting() async {
    try {
      final greeting = await _greetingService.getTimeBasedGreeting();
      if (mounted) {
        setState(() {
          _greeting = greeting;
        });
        AppLogger.info('Loaded greeting: $greeting');
      }
    } catch (e) {
      AppLogger.warning('Error loading greeting: $e');
      if (mounted) {
        setState(() {
          _greeting = 'Jouw voortgang'; // Keep fallback
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final progress = Provider.of<LessonProgressProvider>(context, listen: true);
    final total = widget.lessons.length;
    final unlocked = progress.unlockedCount.clamp(0, total == 0 ? 1 : total);
    final percent = total > 0 ? unlocked / total : 0.0;

    return Semantics(
      label: 'Progress overview',
      hint: 'Shows your current progress through lessons',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cs.primary.withValues(alpha: 0.12),
              cs.primary.withValues(alpha: 0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_greeting,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Semantics(
              label: 'Lesson completion progress',
              hint: '$unlocked out of $total lessons completed',
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            minHeight: 10,
                            value: percent * _progressAnimation.value,
                            backgroundColor: cs.surfaceContainerHighest,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(cs.primary),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('$unlocked/$total',
                      style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (widget.dayWindow.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.fireplace,
                            color: cs.onPrimaryContainer,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.AppStrings.dailyStreak,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: cs.primary,
                                    ),
                              ),
                              Text(
                                'Je gebruikt ${strings.AppStrings.appName} al ${widget.streakDays} ${widget.streakDays == 1 ? "dag" : "dagen"} op rij',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: cs.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < widget.dayWindow.length; i++)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              children: [
                                Text(
                                  _getDayAbbreviation(widget.dayWindow[i].date),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: _getDayTextColor(
                                            context, widget.dayWindow[i]),
                                        fontWeight: i == 2
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: _getDayBackgroundColor(
                                        context, widget.dayWindow[i]),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _getDayBorderColor(
                                          context, widget.dayWindow[i]),
                                      width: i == 2 ? 2.5 : 1.8,
                                    ),
                                    boxShadow: i == 2 &&
                                            widget.dayWindow[i].state ==
                                                DayState.success
                                        ? [
                                            BoxShadow(
                                              color: _getDayBorderColor(context,
                                                      widget.dayWindow[i])
                                                  .withValues(alpha: 0.35),
                                              blurRadius: 8,
                                              spreadRadius: 0,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: widget.dayWindow[i].state ==
                                          DayState.freeze
                                      ? Icon(
                                          Icons.local_cafe,
                                          size: 16,
                                          color: cs.onSurfaceVariant,
                                        )
                                      : widget.dayWindow[i].state ==
                                              DayState.success
                                          ? Icon(
                                              Icons.check,
                                              size: 18,
                                              color: cs.onPrimary,
                                            )
                                          : widget.dayWindow[i].state ==
                                                  DayState.fail
                                              ? _isCurrentDayNotCompleted(
                                                      widget.dayWindow[i])
                                                  ? Icon(
                                                      Icons
                                                          .pending_actions, // Using a more squiggle-like icon
                                                      size: 18,
                                                      color: cs
                                                          .onSecondaryContainer, // Use appropriate color for orange background
                                                    )
                                                  : Icon(
                                                      Icons.close,
                                                      size: 18,
                                                      color:
                                                          cs.onErrorContainer,
                                                    )
                                              : null,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (widget.continueLesson != null) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    label:
                        'Continue with lesson: ${widget.continueLesson!.title}',
                    hint: 'Start the next recommended lesson in your progress',
                    button: true,
                    child: _AnimatedButton(
                      onPressed: () async {
                        Provider.of<AnalyticsService>(context, listen: false)
                            .capture(context, 'start_quiz', properties: {
                          if (widget.continueLesson?.id != null)
                            'lesson_id': widget.continueLesson!.id,
                        });
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(
                              lesson: widget.continueLesson,
                              sessionLimit: widget.continueLesson!.maxQuestions,
                            ),
                          ),
                        );
                        widget.onAfterQuizReturn?.call();
                      },
                      label:
                          '${strings.AppStrings.continueWith}: ${widget.continueLesson!.title}',
                      icon: Icons.play_arrow_rounded,
                      color: cs.primary,
                      textColor: cs.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Semantics(
                    label: 'Practice mode',
                    hint:
                        'Start a random practice quiz without affecting progress',
                    button: true,
                    child: _AnimatedButton(
                      onPressed: () {
                        Provider.of<AnalyticsService>(context, listen: false)
                            .capture(context, 'start_practice_quiz');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const QuizScreen()));
                      },
                      label: strings.AppStrings.freePractice,
                      icon: Icons.flash_on_rounded,
                      color: Colors.transparent,
                      textColor: cs.primary,
                      borderColor: cs.primary,
                    ),
                  ),
                  if (widget.onMultiplayerPressed != null) ...[
                    const SizedBox(height: 8),
                    Semantics(
                      label: 'Multiplayer mode',
                      hint: 'Start a multiplayer quiz game',
                      button: true,
                      child: _AnimatedButton(
                        onPressed: () {
                          Provider.of<AnalyticsService>(context, listen: false)
                              .capture(context, 'start_multiplayer_quiz');
                          widget.onMultiplayerPressed!();
                        },
                        label: strings.AppStrings.multiplayerQuiz,
                        icon: Icons.people,
                        color: Colors.transparent,
                        textColor: cs.primary,
                        borderColor: cs.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ] else ...[
              Semantics(
                label: 'Practice mode',
                hint: 'Start a random practice quiz',
                button: true,
                child: _AnimatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const QuizScreen()));
                  },
                  label: strings.AppStrings.freePractice,
                  icon: Icons.flash_on_rounded,
                  color: Colors.transparent,
                  textColor: cs.primary,
                  borderColor: cs.primary,
                ),
              ),
              if (widget.onMultiplayerPressed != null) ...[
                const SizedBox(height: 8),
                Semantics(
                  label: 'Multiplayer mode',
                  hint: 'Start a multiplayer quiz game',
                  button: true,
                  child: _AnimatedButton(
                    onPressed: () {
                      Provider.of<AnalyticsService>(context, listen: false)
                          .capture(context, 'start_multiplayer_quiz');
                      widget.onMultiplayerPressed!();
                    },
                    label: strings.AppStrings.multiplayerQuiz,
                    icon: Icons.people,
                    color: Colors.transparent,
                    textColor: cs.primary,
                    borderColor: cs.primary,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

bool _isCurrentDayNotCompleted(DayIndicator indicator) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return indicator.date.isAtSameMomentAs(today);
}

String _getDayAbbreviation(DateTime date) {
  // Get the day of the week as an abbreviation
  switch (date.weekday) {
    case DateTime.monday:
      return 'Ma';
    case DateTime.tuesday:
      return 'Di';
    case DateTime.wednesday:
      return 'Wo';
    case DateTime.thursday:
      return 'Do';
    case DateTime.friday:
      return 'Vr';
    case DateTime.saturday:
      return 'Za';
    case DateTime.sunday:
      return 'Zo';
    default:
      return '';
  }
}

Color _getDayTextColor(BuildContext context, DayIndicator indicator) {
  final cs = Theme.of(context).colorScheme;
  if (indicator.state == DayState.future) {
    return cs.onSurfaceVariant;
  } else if (indicator.state == DayState.fail) {
    // Check if this is the current day (index 2 in a 5-day window)
    // For current day not completed yet, use orange/tangelo color instead of error
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (indicator.date.isAtSameMomentAs(today)) {
      return cs
          .primary; // Use primary color to match the orange background intention
    }
    return cs.error;
  } else {
    return cs.primary;
  }
}

Color _getDayBackgroundColor(BuildContext context, DayIndicator indicator) {
  final cs = Theme.of(context).colorScheme;
  switch (indicator.state) {
    case DayState.success:
      return cs.primary;
    case DayState.fail:
      // For the current day not completed yet, use orange instead of red
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (indicator.date.isAtSameMomentAs(today)) {
        return cs.secondaryContainer; // Use orange-like color
      }
      return cs.errorContainer;
    case DayState.freeze:
      return cs.surfaceContainerHighest;
    case DayState.future:
      return cs.surface;
  }
}

Color _getDayBorderColor(BuildContext context, DayIndicator indicator) {
  final cs = Theme.of(context).colorScheme;
  switch (indicator.state) {
    case DayState.success:
      return cs.primary;
    case DayState.fail:
      // For the current day not completed yet, use orange border instead of red
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (indicator.date.isAtSameMomentAs(today)) {
        return cs.secondaryContainer; // Use orange-like color
      }
      return cs.errorContainer;
    case DayState.freeze:
      return cs.outline;
    case DayState.future:
      return cs.outlineVariant;
  }
}

class _AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final Color? borderColor;

  const _AnimatedButton({
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
    this.borderColor,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 2.0, end: 6.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isOutlined = widget.borderColor != null;
    const minHeight = 48.0;
    const borderRadius = 14.0;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: 0.1 * (_elevationAnimation.value / 6)),
                  blurRadius: _elevationAnimation.value,
                  offset: Offset(0, _elevationAnimation.value / 2),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: widget.onPressed,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          constraints: const BoxConstraints(minHeight: minHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(borderRadius),
            border: isOutlined
                ? Border.all(color: widget.borderColor!, width: 1.5)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon,
                  color: widget.textColor, size: 20, semanticLabel: 'Play'),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: widget.textColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
