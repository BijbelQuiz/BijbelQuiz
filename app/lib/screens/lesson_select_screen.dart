import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:bijbelquiz/services/analytics_service.dart';

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
  bool _isSatisfactionPromo = false; // true for satisfaction survey
  // Search and filters removed for simplified UI

  @override
  void initState() {
    super.initState();
    Provider.of<AnalyticsService>(context, listen: false).screen(context, 'LessonSelectScreen');
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
    Provider.of<AnalyticsService>(context, listen: false).capture(context, 'load_lessons');
    final progress = Provider.of<LessonProgressProvider>(context, listen: false);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      // Read current progress to size the visible track dynamically.
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
      Provider.of<AnalyticsService>(context, listen: false).capture(context, 'load_lessons_error', properties: {'error': e.toString()});
      setState(() {
        _error = strings.AppStrings.couldNotLoadLessons;
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          // Show promo card occasionally (20% chance) with new logic for different popup types
          _showPromoCard = _shouldShowPromoCard(settings);
          if (_showPromoCard) {
            // Determine which type of promo to show
            final rand = Random().nextDouble();
            if (rand < 0.33) {
              _isDonationPromo = true;
              _isSatisfactionPromo = false;
            } else if (rand < 0.66) {
              _isDonationPromo = false;
              _isSatisfactionPromo = false;
            } else {
              _isDonationPromo = false;
              _isSatisfactionPromo = true;
            }
            Provider.of<AnalyticsService>(context, listen: false).capture(context, 'show_promo_card', properties: {
              'is_donation': _isDonationPromo,
              'is_satisfaction': _isSatisfactionPromo,
            });
          }
        });
      }
    }
  }

  /// Determines whether to show a promo card based on probability and user interaction history
  bool _shouldShowPromoCard(SettingsProvider settings) {
    // 20% chance to show a popup
    if (Random().nextInt(5) != 0) {
      return false;
    }

    // Check if user has clicked links recently - if so, don't show until next month
    final now = DateTime.now();
    
    // For donation popup
    if (settings.hasClickedDonationLink && settings.lastDonationPopup != null) {
      final lastPopup = settings.lastDonationPopup!;
      final nextAllowed = DateTime(lastPopup.year, lastPopup.month + 1, 1); // First of next month
      if (now.isBefore(nextAllowed)) {
        // Don't show donation popup
      }
    }
    
    // For follow popup
    if (settings.hasClickedFollowLink && settings.lastFollowPopup != null) {
      final lastPopup = settings.lastFollowPopup!;
      final nextAllowed = DateTime(lastPopup.year, lastPopup.month + 1, 1); // First of next month
      if (now.isBefore(nextAllowed)) {
        // Don't show follow popup
      }
    }
    
    // For satisfaction popup
    if (settings.hasClickedSatisfactionLink && settings.lastSatisfactionPopup != null) {
      final lastPopup = settings.lastSatisfactionPopup!;
      final nextAllowed = DateTime(lastPopup.year, lastPopup.month + 1, 1); // First of next month
      if (now.isBefore(nextAllowed)) {
        // Don't show satisfaction popup
      }
    }
    
    // If we get here, we can show a popup
    return true;
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openDonationPage() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    await settings.markDonationLinkAsClicked();
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
        actions: [],
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
                                  isSatisfaction: _isSatisfactionPromo,
                                  onDismiss: () {
                                    Provider.of<AnalyticsService>(context, listen: false).capture(context, 'dismiss_promo_card');
                                    setState(() {
                                      _showPromoCard = false;
                                    });
                                  },
                                  onAction: (url) async {
                                    final settings = Provider.of<SettingsProvider>(context, listen: false);
                                    
                                    if (_isDonationPromo) {
                                      Provider.of<AnalyticsService>(context, listen: false).capture(context, 'tap_donation_promo');
                                      await settings.markDonationLinkAsClicked();
                                      await settings.updateLastDonationPopup();
                                      _openDonationPage();
                                    } else if (_isSatisfactionPromo) {
                                      Provider.of<AnalyticsService>(context, listen: false).capture(context, 'tap_satisfaction_promo');
                                      await settings.markSatisfactionLinkAsClicked();
                                      await settings.updateLastSatisfactionPopup();
                                      _launchUrl(AppUrls.satisfactionSurveyUrl);
                                    } else {
                                      Provider.of<AnalyticsService>(context, listen: false).capture(context, 'tap_follow_promo', properties: {'url': url});
                                      await settings.markFollowLinkAsClicked();
                                      await settings.updateLastFollowPopup();
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
                                              Provider.of<AnalyticsService>(context, listen: false).capture(context, 'tap_locked_lesson', properties: {'lesson_id': lesson.id});
                                              showTopSnackBar(context, 'Les is nog vergrendeld', style: TopSnackBarStyle.warning);
                                              return;
                                            }
                                            if (!playable) {
                                              Provider.of<AnalyticsService>(context, listen: false).capture(context, 'tap_unplayable_lesson', properties: {'lesson_id': lesson.id});
                                              showTopSnackBar(context, 'Je kunt alleen de meest recente ontgrendelde les spelen', style: TopSnackBarStyle.info);
                                              return;
                                            }
                                            Provider.of<AnalyticsService>(context, listen: false).capture(context, 'tap_lesson', properties: {'lesson_id': lesson.id});
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

class _HeaderActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HeaderActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_HeaderActionButton> createState() => _HeaderActionButtonState();
}

class _HeaderActionButtonState extends State<_HeaderActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
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
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label: widget.label,
      hint: 'Tap to open ${widget.label}',
      button: true,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onTap,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
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
            child: Icon(widget.icon,
                color: cs.onSurface.withValues(alpha: 0.8),
                size: 20,
                semanticLabel: widget.label),
          ),
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatefulWidget {
  final List<Lesson> lessons;
  final Lesson? continueLesson;
  final VoidCallback? onAfterQuizReturn;

  const _ProgressHeader({required this.lessons, this.continueLesson, this.onAfterQuizReturn});

  @override
  State<_ProgressHeader> createState() => _ProgressHeaderState();
}

class _ProgressHeaderState extends State<_ProgressHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

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
    // Start the animation when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
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

    final totalStars = widget.lessons.fold<int>(0, (sum, l) => sum + progress.bestStarsFor(l.id));

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
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            minHeight: 10,
                            value: percent * _progressAnimation.value,
                            backgroundColor: cs.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                          );
                        },
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
            if (widget.continueLesson != null) ...[
              Text(
                'Klaar voor je volgende uitdaging?',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    label: 'Continue with lesson: ${widget.continueLesson!.title}',
                    hint: 'Start the next recommended lesson in your progress',
                    button: true,
                    child: _AnimatedButton(
                      onPressed: () async {
                        Provider.of<AnalyticsService>(context, listen: false).capture(context, 'start_quiz', properties: {
                          if (widget.continueLesson?.id != null) 'lesson_id': widget.continueLesson!.id,
                        });
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(
                              lesson: widget.continueLesson,
                              sessionLimit: widget.continueLesson!.maxQuestions,
                            ),
                          ),
                        );
                        // Ask parent to refresh/extend lessons after returning
                        widget.onAfterQuizReturn?.call();
                      },
                      label: 'Ga verder: ${widget.continueLesson!.title}',
                      icon: Icons.play_arrow_rounded,
                      color: cs.primary,
                      textColor: cs.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Semantics(
                    label: 'Practice mode',
                    hint: 'Start a random practice quiz without affecting progress',
                    button: true,
                    child: _AnimatedButton(
                      onPressed: () {
                        Provider.of<AnalyticsService>(context, listen: false).capture(context, 'start_practice_quiz');
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizScreen()));
                      },
                      label: 'Vrij oefenen (random)',
                      icon: Icons.flash_on_rounded,
                      color: cs.primary,
                      textColor: cs.onPrimary,
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
                child: _AnimatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizScreen()));
                  },
                  label: 'Vrij oefenen (random)',
                  icon: Icons.flash_on_rounded,
                  color: cs.primary,
                  textColor: cs.onPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LessonTile extends StatefulWidget {
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
  State<_LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<_LessonTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _shadowAnimation = Tween<double>(begin: 0.06, end: 0.12).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.playable) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.playable) {
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.playable) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final gradient = _tileGradientForIndex(cs, widget.index);

    // Build semantic label based on lesson state
    String semanticLabel = 'Lesson ${widget.lesson.index + 1}: ${widget.lesson.title}';
    String hint = '';

    if (!widget.unlocked) {
      semanticLabel = '$semanticLabel (locked)';
      hint = 'This lesson is locked. Complete previous lessons to unlock it.';
    } else if (!widget.playable) {
      semanticLabel = '$semanticLabel (unlocked but not playable)';
      hint = 'This lesson is unlocked but you can only play the most recent unlocked lesson.';
    } else {
      hint = 'Tap to start this lesson';
    }

    if (widget.recommended) {
      semanticLabel = 'Recommended: $semanticLabel';
    }

    return Semantics(
      label: semanticLabel,
      hint: hint,
      button: widget.playable,
      enabled: widget.playable,
      selected: widget.recommended,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: _shadowAnimation.value),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: InkWell(
          onTap: widget.playable ? widget.onTap : null,
          onTapDown: widget.playable ? _onTapDown : null,
          onTapUp: widget.playable ? _onTapUp : null,
          onTapCancel: widget.playable ? _onTapCancel : null,
          borderRadius: BorderRadius.circular(18),
          focusColor: widget.playable
              ? cs.primary.withAlpha((0.1 * 255).round())
              : null,
          child: Opacity(
            opacity: widget.unlocked && !widget.playable ? 0.55 : 1.0,
            child: Ink(
              decoration: BoxDecoration(
                gradient: widget.unlocked ? gradient : null,
                color: widget.unlocked ? null : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: widget.recommended
                      ? cs.primary
                      : cs.outlineVariant.withValues(alpha: 0.7),
                  width: widget.recommended ? 2.0 : 1.0,
                ),
              ),
              child: Stack(
                children: [
                  // top-left badge (only for unlocked lessons)
                  if (widget.unlocked)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: (widget.unlocked
                                  ? cs.surface
                                  : cs.surfaceContainerHigh)
                              .withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: Text(
                          'Les ${widget.lesson.index + 1}',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  // content (only for unlocked lessons) or lock-only for locked ones
                  if (widget.unlocked)
                    Positioned.fill(
                      child: Center(
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: cs.primary.withValues(alpha: 0.15),
                          child: Icon(
                            Icons.menu_book,
                            color: cs.primary,
                            size: 36,
                            semanticLabel:
                                'Book icon representing lesson content',
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
                  // Recommended indicator
                  if (widget.recommended)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.recommend_rounded,
                          color: cs.onPrimary,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _tileGradientForIndex(ColorScheme cs, int i) {
    // Soft playful alternating gradients with improved colors
    final palettes = <List<Color>>[
      [cs.primaryContainer.withValues(alpha: 0.7), cs.primary.withValues(alpha: 0.3)],
      [const Color(0xFF10B981).withValues(alpha: 0.6), const Color(0xFF34D399).withValues(alpha: 0.3)],
      [const Color(0xFF6366F1).withValues(alpha: 0.6), const Color(0xFFA78BFA).withValues(alpha: 0.32)],
      [const Color(0xFFF59E0B).withValues(alpha: 0.6), const Color(0xFFFCD34D).withValues(alpha: 0.32)],
      [const Color(0xFFEF4444).withValues(alpha: 0.6), const Color(0xFFF87171).withValues(alpha: 0.32)],
      [const Color(0xFF06B6D4).withValues(alpha: 0.6), const Color(0xFF67E8F9).withValues(alpha: 0.32)],
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
  final bool isSatisfaction;
  final VoidCallback onDismiss;
  final Function(String) onAction;

  const _PromoCard({
    required this.isDonation,
    required this.isSatisfaction,
    required this.onDismiss,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Determine colors based on promo type
    List<Color> gradientColors;
    if (isDonation) {
      gradientColors = [cs.primary.withValues(alpha: 0.14), cs.primary.withValues(alpha: 0.06)];
    } else if (isSatisfaction) {
      gradientColors = [cs.primary.withValues(alpha: 0.14), cs.primary.withValues(alpha: 0.06)];
    } else {
      gradientColors = [cs.primary.withValues(alpha: 0.14), cs.primary.withValues(alpha: 0.06)];
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
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
                isDonation 
                  ? Icons.favorite_rounded 
                  : isSatisfaction 
                    ? Icons.feedback_rounded 
                    : Icons.group_add_rounded,
                color: cs.onSurface.withValues(alpha: 0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isDonation 
                    ? strings.AppStrings.donate 
                    : isSatisfaction 
                      ? strings.AppStrings.satisfactionSurvey 
                      : strings.AppStrings.followUs,
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
            isDonation 
              ? strings.AppStrings.donateExplanation 
              : isSatisfaction 
                ? strings.AppStrings.satisfactionSurveyMessage 
                : strings.AppStrings.followUsMessage,
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
          ] else if (isSatisfaction) ...[
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
                    icon: const Icon(Icons.feedback_rounded),
                    label: Text(strings.AppStrings.satisfactionSurveyButton),
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
                    label: strings.AppStrings.followPixelfed,
                    icon: Icons.camera_alt,
                    onPressed: () => onAction(AppUrls.pixelfedUrl),
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
    final minHeight = widget.label.contains('Vrij oefenen') ? 44.0 : 48.0;
    final borderRadius = widget.label.contains('Vrij oefenen') ? 12.0 : 14.0;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1 * (_elevationAnimation.value / 6)),
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
          constraints: BoxConstraints(minHeight: minHeight),
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