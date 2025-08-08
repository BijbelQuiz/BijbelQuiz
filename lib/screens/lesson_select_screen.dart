import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/lesson.dart';
import '../providers/lesson_progress_provider.dart';
import '../providers/settings_provider.dart';
import '../services/lesson_service.dart';
import '../screens/quiz_screen.dart';

class LessonSelectScreen extends StatefulWidget {
  const LessonSelectScreen({super.key});

  @override
  State<LessonSelectScreen> createState() => _LessonSelectScreenState();
}

class _LessonSelectScreenState extends State<LessonSelectScreen> {
  final LessonService _lessonService = LessonService();

  bool _loading = true;
  String? _error;
  List<Lesson> _lessons = const [];
  // Search and filters removed for simplified UI

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      // Read current progress to size the visible track dynamically.
      final progress = Provider.of<LessonProgressProvider>(context, listen: false);
      final settings = Provider.of<SettingsProvider>(context, listen: false);

      // Always show at least (unlockedCount + buffer) lessons, with a floor.
      const int buffer = 12;
      const int minVisible = 36;
      final int desired = progress.unlockedCount + buffer;
      final int visibleCount = desired < minVisible ? minVisible : desired;

      final lessons = await _lessonService.generateLessons(
        settings.language,
        maxLessons: visibleCount,
        maxQuestionsPerLesson: 10,
      );

      if (!mounted) return;
      setState(() {
        _lessons = lessons;
      });

      // Ensure at least the first lesson is unlocked for new users.
      await progress.ensureUnlockedCountAtLeast(1);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Kon lessen niet laden';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final progress = Provider.of<LessonProgressProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    // Responsive: adapt grid by max tile width instead of fixed column count
    final screenWidth = MediaQuery.sizeOf(context).width;
    final double tileMaxExtent = screenWidth >= 1400
        ? 260
        : screenWidth >= 1200
            ? 240
            : screenWidth >= 1000
                ? 220
                : screenWidth >= 840
                    ? 210
                    : screenWidth >= 600
                        ? 200
                        : screenWidth >= 400
                            ? 170
                            : 160;
    final double gridAspect = screenWidth >= 1000
        ? 1.12
        : screenWidth >= 600
            ? 1.05
            : screenWidth >= 360
                ? 0.98
                : 0.92;

    // Simplified: show all lessons without search/filters
    final filteredIndices = List.generate(_lessons.length, (i) => i);

    // Determine the "continue" target to incentivize starting a game:
    // We pick the last unlocked lesson (index unlockedCount-1), capped to list length.
    final totalLessons = _lessons.length;
    final continueIdx = totalLessons == 0
        ? 0
        : (progress.unlockedCount.clamp(1, totalLessons) - 1);
    final Lesson? continueLesson = totalLessons > 0 ? _lessons[continueIdx] : null;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            'Lessen',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: _HeaderActionButton(
              icon: Icons.settings_rounded,
              label: 'Instellingen',
              onTap: () => Navigator.of(context).pushNamed('/settings'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _HeaderActionButton(
              icon: Icons.store_rounded,
              label: 'Winkel',
              onTap: () => Navigator.of(context).pushNamed('/store'),
            ),
          ),
        ],
      ),
      body: _loading
          ? const _LessonGridSkeleton()
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, style: TextStyle(color: colorScheme.error)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _loadLessons,
                        child: const Text('Opnieuw proberen'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadLessons,
                  child: CustomScrollView(
                    slivers: [
                      // Hero progress + CTA section
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ProgressHeader(
                                lessons: _lessons,
                                continueLesson: continueLesson,
                                onAfterQuizReturn: _loadLessons,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),


                      if (filteredIndices.isNotEmpty)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          sliver: SliverGrid(
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: tileMaxExtent,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: gridAspect,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final realIndex = filteredIndices[index];
                                final lesson = _lessons[realIndex];
                                final unlocked = progress.isLessonUnlocked(realIndex);
                                final stars = progress.bestStarsFor(lesson.id);
                                final recommended = totalLessons > 0 && realIndex == continueIdx;

                                return _LessonTile(
                                  lesson: lesson,
                                  index: realIndex,
                                  unlocked: unlocked,
                                  stars: stars,
                                  recommended: unlocked && recommended,
                                  onTap: () async {
                                    if (!unlocked) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Les is nog vergrendeld')),
                                      );
                                      return;
                                    }
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => QuizScreen(lesson: lesson, sessionLimit: lesson.maxQuestions),
                                      ),
                                    );
                                    // After returning from the quiz, ensure the grid extends if needed.
                                    if (!mounted) return;
                                    await _loadLessons();
                                  },
                                );
                              },
                              childCount: filteredIndices.length,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HeaderActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Icon(icon, color: cs.onSurface.withOpacity(0.8), size: 20),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final List<Lesson> lessons;
  final Lesson? continueLesson;
  final VoidCallback? onAfterQuizReturn;

  const _ProgressHeader({required this.lessons, this.continueLesson, this.onAfterQuizReturn});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final progress = Provider.of<LessonProgressProvider>(context, listen: true);
    final total = lessons.length;
    final unlocked = progress.unlockedCount.clamp(0, total == 0 ? 1 : total);
    final percent = total > 0 ? unlocked / total : 0.0;

    final totalStars = lessons.fold<int>(0, (sum, l) => sum + progress.bestStarsFor(l.id));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary.withOpacity(0.12),
            cs.primary.withOpacity(0.04),
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
          Text('Jouw voortgang', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: percent,
                    backgroundColor: cs.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('$unlocked/$total', style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.star_rounded, color: cs.primary),
              const SizedBox(width: 4),
              Text('$totalStars sterren verdiend', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 12),
          // CTA zone to incentivize starting a game
          if (continueLesson != null) ...[
            Text(
              'Klaar voor je volgende uitdaging?',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(
                          lesson: continueLesson,
                          sessionLimit: continueLesson!.maxQuestions,
                        ),
                      ),
                    );
                    // Ask parent to refresh/extend lessons after returning
                    onAfterQuizReturn?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text('Ga verder: ${continueLesson!.title}'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    side: BorderSide(color: cs.outlineVariant),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.flash_on_rounded),
                  label: const Text('Vrij oefenen (random)'),
                ),
              ],
            ),
          ] else ...[
            // Fallback CTA when there are no lessons (shouldn't normally happen)
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizScreen()));
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                side: BorderSide(color: cs.outlineVariant),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.flash_on_rounded),
              label: const Text('Vrij oefenen (random)'),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context) async {
    final cs = Theme.of(context).colorScheme;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Voortgang resetten?'),
        content: const Text('Dit zet je sterren en ontgrendelingen terug naar de beginstand.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Annuleren')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: cs.primary),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await Provider.of<LessonProgressProvider>(context, listen: false).resetAll();
    }
  }
}

class _LessonTile extends StatelessWidget {
  final Lesson lesson;
  final int index;
  final bool unlocked;
  final int stars;
  final bool recommended;
  final VoidCallback onTap;

  const _LessonTile({
    required this.lesson,
    required this.index,
    required this.unlocked,
    required this.stars,
    required this.onTap,
    this.recommended = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final gradient = _tileGradientForIndex(cs, index);

    IconData iconData = Icons.menu_book;
    switch ((lesson.iconHint ?? 'book').toLowerCase()) {
      case 'church':
        iconData = Icons.church;
        break;
      case 'stars':
        iconData = Icons.stars;
        break;
      case 'castle':
        iconData = Icons.fort;
        break;
      case 'forum':
        iconData = Icons.forum;
        break;
      case 'music_note':
        iconData = Icons.music_note;
        break;
      case 'emoji_objects':
        iconData = Icons.emoji_objects;
        break;
      case 'record_voice_over':
        iconData = Icons.record_voice_over;
        break;
      case 'auto_awesome':
        iconData = Icons.auto_awesome;
        break;
      case 'mail':
        iconData = Icons.mail;
        break;
      case 'book':
      default:
        iconData = Icons.menu_book;
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        decoration: BoxDecoration(
          gradient: unlocked ? gradient : null,
          color: unlocked ? null : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // top-left badge (only for unlocked lessons)
            if (unlocked)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: (unlocked ? cs.surface : cs.surfaceContainerHigh).withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Text('Les ${lesson.index + 1}', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
                ),
              ),
            // content (only for unlocked lessons) or lock-only for locked ones
            if (unlocked)
              Positioned.fill(
                child: Center(
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: cs.primary.withOpacity(0.15),
                    child: Icon(iconData, color: cs.primary, size: 36),
                  ),
                ),
              )
            else
              Positioned.fill(
                child: Center(
                  child: Icon(
                    Icons.lock_rounded,
                    color: cs.onSurface.withOpacity(0.7),
                    size: 40,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  LinearGradient _tileGradientForIndex(ColorScheme cs, int i) {
    // Soft playful alternating gradients
    final palettes = <List<Color>>[
      [cs.primaryContainer.withOpacity(0.65), cs.primary.withOpacity(0.25)],
      [const Color(0xFF10B981).withOpacity(0.55), const Color(0xFF34D399).withOpacity(0.25)],
      [const Color(0xFF6366F1).withOpacity(0.55), const Color(0xFFA78BFA).withOpacity(0.28)],
      [const Color(0xFFF59E0B).withOpacity(0.55), const Color(0xFFFCD34D).withOpacity(0.28)],
      [const Color(0xFFEF4444).withOpacity(0.55), const Color(0xFFF87171).withOpacity(0.28)],
      [const Color(0xFF06B6D4).withOpacity(0.55), const Color(0xFF67E8F9).withOpacity(0.28)],
    ];
    final colors = palettes[i % palettes.length];
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

class _LessonGridSkeleton extends StatelessWidget {
  const _LessonGridSkeleton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Responsive: adapt grid by max tile width instead of fixed column count
    final screenWidth = MediaQuery.sizeOf(context).width;
    final double tileMaxExtent = screenWidth >= 1400
        ? 260
        : screenWidth >= 1200
            ? 240
            : screenWidth >= 1000
                ? 220
                : screenWidth >= 840
                    ? 210
                    : screenWidth >= 600
                        ? 200
                        : screenWidth >= 400
                            ? 170
                            : 160;
    final double gridAspect = screenWidth >= 1000
        ? 1.12
        : screenWidth >= 600
            ? 1.05
            : screenWidth >= 360
                ? 0.98
                : 0.92;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: tileMaxExtent,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: gridAspect,
      ),
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? primaryAction;
  final String? primaryLabel;
  final VoidCallback? secondaryAction;
  final String? secondaryLabel;

  const _EmptyState({
    required this.title,
    required this.message,
    this.primaryAction,
    this.primaryLabel,
    this.secondaryAction,
    this.secondaryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              if (primaryAction != null && primaryLabel != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: primaryAction,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: cs.outlineVariant),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size.fromHeight(44),
                    ),
                    child: Text(primaryLabel!),
                  ),
                ),
              if (primaryAction != null && primaryLabel != null && secondaryAction != null && secondaryLabel != null)
                const SizedBox(width: 8),
              if (secondaryAction != null && secondaryLabel != null)
                Expanded(
                  child: ElevatedButton(
                    onPressed: secondaryAction,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(secondaryLabel!),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}