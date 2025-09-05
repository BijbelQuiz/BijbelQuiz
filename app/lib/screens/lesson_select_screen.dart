import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

import '../models/lesson.dart';
import '../providers/lesson_progress_provider.dart';
import '../providers/settings_provider.dart';
import '../services/lesson_service.dart';
import '../screens/quiz_screen.dart';
import '../screens/guide_screen.dart';
import '../widgets/top_snackbar.dart';
import '../l10n/strings_nl.dart' as strings;
import '../constants/urls.dart';

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
  bool _guideCheckCompleted = false; // Prevent multiple guide checks
  bool _showPromoCard = false;
  bool _isDonationPromo = true; // true for donation, false for follow
  // Search and filters removed for simplified UI

  @override
  void initState() {
    super.initState();
    _loadLessons();

    // Check if we need to show the guide screen (only once)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowGuide();
    });
  }

  void _checkAndShowGuide() {
    if (!mounted || _guideCheckCompleted) return;

    final settings = Provider.of<SettingsProvider>(context, listen: false);

    // Mark that we've completed the guide check to prevent multiple calls
    _guideCheckCompleted = true;

    // Add a small delay to ensure everything is properly initialized
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      if (!settings.isLoading && !settings.hasSeenGuide) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const GuideScreen(),
            ),
          );
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only check for guide if we haven't already completed the check
    if (mounted && !_guideCheckCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndShowGuide();
      });
    }
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
        _error = strings.AppStrings.couldNotLoadLessons;
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          // Show promo card occasionally (10% chance)
          _showPromoCard = Random().nextInt(10) == 0;
          _isDonationPromo = Random().nextBool();
        });
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openDonationPage() {
    _launchUrl(AppUrls.donateUrl);
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
          Semantics(
            label: 'App settings',
            hint: 'Open application settings',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: _HeaderActionButton(
                icon: Icons.settings_rounded,
                label: 'Instellingen',
                onTap: () => Navigator.of(context).pushNamed('/settings'),
              ),
            ),
          ),
          Semantics(
            label: 'Store',
            hint: 'Open the store to purchase items',
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _HeaderActionButton(
                icon: Icons.store_rounded,
                label: 'Winkel',
                onTap: () => Navigator.of(context).pushNamed('/store'),
              ),
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
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final h = constraints.maxHeight;
                    // Guard against transient zero-sized viewport during lifecycle changes.
                    if (!w.isFinite || !h.isFinite || w <= 0 || h <= 0) {
                      return const SizedBox.shrink();
                    }
                    return RefreshIndicator(
                      onRefresh: _loadLessons,
                      child: CustomScrollView(
                        slivers: [
                          // Promo card (if shown)
                          if (_showPromoCard)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                child: _PromoCard(
                                  isDonation: _isDonationPromo,
                                  onDismiss: () {
                                    setState(() {
                                      _showPromoCard = false;
                                    });
                                  },
                                  onAction: (url) {
                                    if (_isDonationPromo) {
                                      _openDonationPage();
                                    } else {
                                      _launchUrl(url);
                                    }
                                  },
                                ),
                              ),
                            ),

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
                            SliverLayoutBuilder(
                              builder: (context, constraints) {
                                final cross = constraints.crossAxisExtent;
                                // Guard against transient zero-width cross axis which makes SliverGrid assert.
                                if (!cross.isFinite || cross <= 0) {
                                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                                }
                                return SliverPadding(
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

                                        final playable = unlocked && realIndex == continueIdx;

                                        return _LessonTile(
                                          lesson: lesson,
                                          index: realIndex,
                                          unlocked: unlocked,
                                          playable: playable,
                                          stars: stars,
                                          recommended: unlocked && recommended,
                                          onTap: () async {
                                            if (!unlocked) {
                                              showTopSnackBar(context, 'Les is nog vergrendeld', style: TopSnackBarStyle.warning);
                                              return;
                                            }
                                            if (!playable) {
                                              showTopSnackBar(context, 'Je kunt alleen de meest recente ontgrendelde les spelen', style: TopSnackBarStyle.info);
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
                                );
                              },
                            ),
                        ],
                      ),
                    );
                  },
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
    return Semantics(
      label: label,
      hint: 'Tap to open $label',
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        focusColor: cs.primary.withAlpha((0.1 * 255).round()),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Icon(icon, color: cs.onSurface.withValues(alpha: 0.8), size: 20, semanticLabel: label),
        ),
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

    return Semantics(
      label: 'Progress overview',
      hint: 'Shows your current progress through lessons and earned stars',
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
            Text('Jouw voortgang', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Semantics(
              label: 'Lesson completion progress',
              hint: '$unlocked out of $total lessons completed',
              child: Row(
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
            ),
            const SizedBox(height: 10),
            Semantics(
              label: 'Stars earned',
              hint: 'You have earned $totalStars stars',
              child: Row(
                children: [
                  Icon(Icons.star_rounded, color: cs.primary, semanticLabel: 'Star'),
                  const SizedBox(width: 4),
                  Text('$totalStars sterren verdiend', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
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
                  Semantics(
                    label: 'Continue with lesson: ${continueLesson!.title}',
                    hint: 'Start the next recommended lesson in your progress',
                    button: true,
                    child: ElevatedButton.icon(
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
                      icon: const Icon(Icons.play_arrow_rounded, semanticLabel: 'Play'),
                      label: Text('Ga verder: ${continueLesson!.title}'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Semantics(
                    label: 'Practice mode',
                    hint: 'Start a random practice quiz without affecting progress',
                    button: true,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizScreen()));
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                        side: BorderSide(color: cs.outlineVariant),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.flash_on_rounded, semanticLabel: 'Lightning bolt'),
                      label: const Text('Vrij oefenen (random)'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Fallback CTA when there are no lessons (shouldn't normally happen)
              Semantics(
                label: 'Practice mode',
                hint: 'Start a random practice quiz',
                button: true,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    side: BorderSide(color: cs.outlineVariant),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.flash_on_rounded, semanticLabel: 'Lightning bolt'),
                  label: const Text('Vrij oefenen (random)'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  
}

class _LessonTile extends StatelessWidget {
  final Lesson lesson;
  final int index;
  final bool unlocked;
  final bool playable;
  final int stars;
  final bool recommended;
  final VoidCallback onTap;

  const _LessonTile({
    required this.lesson,
    required this.index,
    required this.unlocked,
    required this.playable,
    required this.stars,
    required this.onTap,
    this.recommended = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final gradient = _tileGradientForIndex(cs, index);

    // Build semantic label based on lesson state
    String semanticLabel = 'Lesson ${lesson.index + 1}: ${lesson.title}';
    String hint = '';

    if (!unlocked) {
      semanticLabel = '$semanticLabel (locked)';
      hint = 'This lesson is locked. Complete previous lessons to unlock it.';
    } else if (!playable) {
      semanticLabel = '$semanticLabel (unlocked but not playable)';
      hint = 'This lesson is unlocked but you can only play the most recent unlocked lesson.';
    } else {
      hint = 'Tap to start this lesson';
    }

    if (recommended) {
      semanticLabel = 'Recommended: $semanticLabel';
    }

    return Semantics(
      label: semanticLabel,
      hint: hint,
      button: playable,
      enabled: playable,
      selected: recommended,
      child: InkWell(
        onTap: playable ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        focusColor: playable ? cs.primary.withAlpha((0.1 * 255).round()) : null,
        child: Opacity(
          opacity: unlocked && !playable ? 0.55 : 1.0,
          child: Ink(
          decoration: BoxDecoration(
            gradient: unlocked ? gradient : null,
            color: unlocked ? null : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
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
                      color: (unlocked ? cs.surface : cs.surfaceContainerHigh).withValues(alpha: 0.85),
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
                      backgroundColor: cs.primary.withValues(alpha: 0.15),
                      child: Icon(
                        Icons.menu_book,
                        color: cs.primary,
                        size: 36,
                        semanticLabel: 'Book icon representing lesson content',
                      ),
                    ),
                  ),
                )
              else
                Positioned.fill(
                  child: Center(
                    child: Icon(
                      Icons.lock_rounded,
                      color: cs.onSurface.withValues(alpha: 0.7),
                      size: 40,
                      semanticLabel: 'Locked lesson',
                    ),
                  ),
                ),
            ],
          ),
        )),
      ),
    );
  }

  LinearGradient _tileGradientForIndex(ColorScheme cs, int i) {
    // Soft playful alternating gradients
    final palettes = <List<Color>>[
      [cs.primaryContainer.withValues(alpha: 0.65), cs.primary.withValues(alpha: 0.25)],
      [const Color(0xFF10B981).withValues(alpha: 0.55), const Color(0xFF34D399).withValues(alpha: 0.25)],
      [const Color(0xFF6366F1).withValues(alpha: 0.55), const Color(0xFFA78BFA).withValues(alpha: 0.28)],
      [const Color(0xFFF59E0B).withValues(alpha: 0.55), const Color(0xFFFCD34D).withValues(alpha: 0.28)],
      [const Color(0xFFEF4444).withValues(alpha: 0.55), const Color(0xFFF87171).withValues(alpha: 0.28)],
      [const Color(0xFF06B6D4).withValues(alpha: 0.55), const Color(0xFF67E8F9).withValues(alpha: 0.28)],
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        // Guard against transient zero-width layouts which cause GridView's
        // SliverGridDelegate to assert crossAxisExtent > 0.0.
        if (!w.isFinite || w <= 0) {
          return const SizedBox.shrink();
        }
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
      },
    );
  }
}

class _PromoCard extends StatelessWidget {
  final bool isDonation;
  final VoidCallback onDismiss;
  final Function(String) onAction;

  const _PromoCard({
    required this.isDonation,
    required this.onDismiss,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDonation
              ? [cs.primary.withValues(alpha: 0.14), cs.primary.withValues(alpha: 0.06)]
              : [cs.secondary.withValues(alpha: 0.14), cs.secondary.withValues(alpha: 0.06)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isDonation ? Icons.favorite_rounded : Icons.group_add_rounded,
                color: cs.onSurface.withValues(alpha: 0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isDonation ? strings.AppStrings.donate : strings.AppStrings.followUs,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                ),
              ),
              IconButton(
                onPressed: onDismiss,
                icon: Icon(Icons.close, color: cs.onSurface.withValues(alpha: 0.6)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isDonation ? strings.AppStrings.donateExplanation : strings.AppStrings.followUsMessage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          if (isDonation) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => onAction(''),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.favorite_rounded),
                    label: Text(strings.AppStrings.donateButton),
                  ),
                ),
              ],
            ),
          ] else ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SocialButton(
                  label: strings.AppStrings.followMastodon,
                  icon: Icons.alternate_email,
                  onPressed: () => onAction(strings.AppStrings.mastodonUrl),
                ),
                _SocialButton(
                  label: strings.AppStrings.followKwebler,
                  icon: Icons.group,
                  onPressed: () => onAction(strings.AppStrings.kweblerUrl),
                ),
                _SocialButton(
                  label: strings.AppStrings.followSignal,
                  icon: Icons.message,
                  onPressed: () => onAction(strings.AppStrings.signalUrl),
                ),
                _SocialButton(
                  label: strings.AppStrings.followDiscord,
                  icon: Icons.discord,
                  onPressed: () => onAction(strings.AppStrings.discordUrl),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: cs.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: Icon(icon, size: 16),
      label: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}