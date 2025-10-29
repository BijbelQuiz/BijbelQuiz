import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:bijbelquiz/services/analytics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lesson.dart';
import '../providers/lesson_progress_provider.dart';
import '../providers/settings_provider.dart';
import '../services/lesson_service.dart';
import '../screens/quiz_screen.dart';
import '../screens/guide_screen.dart';
import '../screens/multiplayer_game_setup_screen.dart';
import '../widgets/top_snackbar.dart';
import '../l10n/strings_nl.dart' as strings;
import '../constants/urls.dart';
import '../widgets/progress_header.dart';
import '../widgets/lesson_tile.dart';
import '../widgets/promo_card.dart';
import '../widgets/lesson_grid_skeleton.dart';

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
  bool _isDifficultyPromo = false; // true for difficulty feedback
  // Search and filters removed for simplified UI

  // Daily usage streak tracking (persisted locally)
  static const String _activeDaysKey = 'daily_active_days_v1';
  Set<String> _activeDays = {};
  int _streakDays = 0;

  @override
  void initState() {
    super.initState();
    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

    // Track screen view
    analyticsService.screen(context, 'LessonSelectScreen');

    // Track lesson system access
    analyticsService.trackFeatureStart(context, AnalyticsService.FEATURE_LESSON_SYSTEM);

    _loadLessons();
    _loadStreakData();

    // Check if we need to show the guide screen (only once)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowGuide();
    });
  }

  void _checkAndShowGuide() {
    if (!mounted || _guideCheckCompleted) return;

    final settings = Provider.of<SettingsProvider>(context, listen: false);

    // If settings are still loading, retry shortly after load completes
    if (settings.isLoading) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _checkAndShowGuide();
      });
      return;
    }

    // Only show the guide if the user hasn't seen it yet
    if (!settings.hasSeenGuide) {
      // Prevent multiple navigations
      _guideCheckCompleted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const GuideScreen(),
          ),
        );
      });
      return;
    }

    // No need to show the guide; mark check as completed
    _guideCheckCompleted = true;
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

  // --- Daily streak helpers ---
  String _fmtDate(DateTime d) {
    // yyyy-MM-dd
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  bool _isSunday(DateTime d) => d.weekday == DateTime.sunday;

  Future<void> _loadStreakData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_activeDaysKey) ?? <String>[];
      _activeDays = list.toSet();

      _recomputeStreak();
    } catch (_) {
      // Ignore streak errors silently
    }
    if (mounted) setState(() {});
  }

  Future<void> _refreshStreakData() async {
    await _loadStreakData();
  }

  void _recomputeStreak() {
    int streak = 0;
    DateTime now = DateTime.now();
    DateTime cursor = DateTime(now.year, now.month, now.day);
    while (true) {
      if (_isSunday(cursor)) {
        // Sunday is a free day, does not break or add to streak
        cursor = cursor.subtract(const Duration(days: 1));
        continue;
      }
      final dayStr = _fmtDate(cursor);
      if (_activeDays.contains(dayStr)) {
        streak += 1;
        cursor = cursor.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    _streakDays = streak;
  }

  List<DayIndicator> _getFiveDayWindow() {
    final List<DayIndicator> out = [];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (int offset = -2; offset <= 2; offset++) {
      final day = today.add(Duration(days: offset));
      final isFuture = day.isAfter(today);
      final dayStr = _fmtDate(day);
      DayState state;
      if (isFuture) {
        state = DayState.future;
      } else if (_isSunday(day)) {
        // Sunday streak freeze only applies to non-future days
        state = DayState.freeze;
      } else if (_activeDays.contains(dayStr)) {
        state = DayState.success;
      } else {
        // For the current day, show fail state only after the day is completely over
        if (day.isAtSameMomentAs(today)) {
          // Current day not done yet, use fail state for now (this will be handled in the UI with orange)
          state = DayState.fail;
        } else {
          // Past day without activity
          state = DayState.fail;
        }
      }
      out.add(DayIndicator(date: day, state: state));
    }
    return out;
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
            if (rand < 0.25) {
              _isDonationPromo = true;
              _isSatisfactionPromo = false;
              _isDifficultyPromo = false;
            } else if (rand < 0.50) {
              _isDonationPromo = false;
              _isSatisfactionPromo = false;
              _isDifficultyPromo = true;
            } else if (rand < 0.75) {
              _isDonationPromo = false;
              _isSatisfactionPromo = false;
              _isDifficultyPromo = false;
            } else {
              _isDonationPromo = false;
              _isSatisfactionPromo = true;
              _isDifficultyPromo = false;
            }
            Provider.of<AnalyticsService>(context, listen: false).capture(context, 'show_promo_card', properties: {
              'is_donation': _isDonationPromo,
              'is_satisfaction': _isSatisfactionPromo,
              'is_difficulty': _isDifficultyPromo,
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
    
    // For difficulty feedback popup
    if (settings.hasClickedDifficultyLink && settings.lastDifficultyPopup != null) {
      final lastPopup = settings.lastDifficultyPopup!;
      final nextAllowed = DateTime(lastPopup.year, lastPopup.month + 1, 1); // First of next month
      if (now.isBefore(nextAllowed)) {
        // Don't show difficulty popup
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

  /// Adjusts the difficulty level based on user feedback
  /// The ProgressiveQuestionSelector dynamically adjusts difficulty based on performance
  /// so we'll store the user's preference to potentially influence future difficulty
  Future<void> _adjustDifficulty(String feedback) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    
    // Store the user's difficulty preference
    await settings.setDifficultyPreference(feedback);
    
    Provider.of<AnalyticsService>(context, listen: false).capture(context, 'difficulty_adjusted', 
      properties: {'feedback': feedback});
  }

  /// Builds the lesson layout based on the selected layout type
  Widget _buildLessonLayout(String layoutType, List<int> filteredIndices, LessonProgressProvider progress, int totalLessons, int continueIdx, double tileMaxExtent, double gridAspect) {
    switch (layoutType) {
      case SettingsProvider.layoutList:
        // List view layout
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final realIndex = filteredIndices[index];
                final lesson = _lessons[realIndex];
                final unlocked = progress.isLessonUnlocked(realIndex);
                final stars = progress.bestStarsFor(lesson.id);
                final recommended = totalLessons > 0 && realIndex == continueIdx;

                final playable = unlocked && realIndex == continueIdx;

                return Container(
                  height: 120, // Fixed height for list items
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: LessonTile(
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

                      // Track lesson selection
                      final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

                      // Track lesson system usage
                      analyticsService.trackFeatureSuccess(context, AnalyticsService.FEATURE_LESSON_SYSTEM, additionalProperties: {
                        'lesson_id': lesson.id,
                        'lesson_category': lesson.category,
                        'lesson_unlocked': unlocked,
                      });

                      // Track streak feature if this contributes to streak
                      if (_streakDays > 0) {
                        analyticsService.trackFeatureUsage(context, AnalyticsService.FEATURE_STREAK_TRACKING, AnalyticsService.ACTION_USED, additionalProperties: {
                          'current_streak': _streakDays,
                        });
                      }

                      Provider.of<AnalyticsService>(context, listen: false).capture(context, 'tap_lesson', properties: {'lesson_id': lesson.id});
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(lesson: lesson, sessionLimit: lesson.maxQuestions),
                        ),
                      );
                      // After returning from the quiz, refresh streak data and reload lessons if needed.
                      if (!mounted) return;
                      await _refreshStreakData();
                      await _loadLessons();
                    },
                  ),
                );
              },
              childCount: filteredIndices.length,
            ),
          ),
        );
      case SettingsProvider.layoutCompactGrid:
        // Compact grid layout with smaller tiles
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: tileMaxExtent * 0.8, // 80% of normal size
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: gridAspect * 0.9, // Slightly more square
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final realIndex = filteredIndices[index];
                final lesson = _lessons[realIndex];
                final unlocked = progress.isLessonUnlocked(realIndex);
                final stars = progress.bestStarsFor(lesson.id);
                final recommended = totalLessons > 0 && realIndex == continueIdx;

                final playable = unlocked && realIndex == continueIdx;

                return LessonTile(
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

                    // Track lesson selection
                    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

                    // Track lesson system usage
                    analyticsService.trackFeatureSuccess(context, AnalyticsService.FEATURE_LESSON_SYSTEM, additionalProperties: {
                      'lesson_id': lesson.id,
                      'lesson_category': lesson.category,
                      'lesson_unlocked': unlocked,
                    });

                    // Track streak feature if this contributes to streak
                    if (_streakDays > 0) {
                      analyticsService.trackFeatureUsage(context, AnalyticsService.FEATURE_STREAK_TRACKING, AnalyticsService.ACTION_USED, additionalProperties: {
                        'current_streak': _streakDays,
                      });
                    }

                    Provider.of<AnalyticsService>(context, listen: false).capture(context, 'tap_lesson', properties: {'lesson_id': lesson.id});
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(lesson: lesson, sessionLimit: lesson.maxQuestions),
                      ),
                    );
                    // After returning from the quiz, refresh streak data and reload lessons if needed.
                    if (!mounted) return;
                    await _refreshStreakData();
                    await _loadLessons();
                  },
                );
              },
              childCount: filteredIndices.length,
              // Performance: disable keep-alives and semantic indexes for grid items.
              // The grid lazily builds children and does not need to keep offscreen items alive.
              addAutomaticKeepAlives: false,
              addSemanticIndexes: false,
              addRepaintBoundaries: true,
            ),
          ),
        );
      case SettingsProvider.layoutGrid:
      default:
        // Original grid layout
        return SliverLayoutBuilder(
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

                    return LessonTile(
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

                        // Track lesson selection
                        final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

                        // Track lesson system usage
                        analyticsService.trackFeatureSuccess(context, AnalyticsService.FEATURE_LESSON_SYSTEM, additionalProperties: {
                          'lesson_id': lesson.id,
                          'lesson_category': lesson.category,
                          'lesson_unlocked': unlocked,
                        });

                        // Track streak feature if this contributes to streak
                        if (_streakDays > 0) {
                          analyticsService.trackFeatureUsage(context, AnalyticsService.FEATURE_STREAK_TRACKING, AnalyticsService.ACTION_USED, additionalProperties: {
                            'current_streak': _streakDays,
                          });
                        }

                        Provider.of<AnalyticsService>(context, listen: false).capture(context, 'tap_lesson', properties: {'lesson_id': lesson.id});
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(lesson: lesson, sessionLimit: lesson.maxQuestions),
                          ),
                        );
                        // After returning from the quiz, refresh streak data and reload lessons if needed.
                        if (!mounted) return;
                        await _refreshStreakData();
                        await _loadLessons();
                      },
                    );
                  },
                  childCount: filteredIndices.length,
                  // Performance: disable keep-alives and semantic indexes for grid items.
                  // The grid lazily builds children and does not need to keep offscreen items alive.
                  addAutomaticKeepAlives: false,
                  addSemanticIndexes: false,
                  addRepaintBoundaries: true,
                ),
              ),
            );
          },
        );
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

    // Get the selected layout type from settings
    final settings = Provider.of<SettingsProvider>(context);
    final layoutType = settings.layoutType;

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
          ? const LessonGridSkeleton()
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
                        // Increase cache extent to prebuild upcoming sliver children
                        // for smoother, jank-free scrolling at the cost of some memory.
                        cacheExtent: 800,
                        slivers: [
                          // Promo card (if shown)
                          if (_showPromoCard)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                child: PromoCard(
                                  isDonation: _isDonationPromo,
                                  isSatisfaction: _isSatisfactionPromo,
                                  isDifficulty: _isDifficultyPromo,
                                  onDismiss: () {
                                    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
                                    analyticsService.capture(context, 'dismiss_promo_card');
                                    analyticsService.trackFeatureDismissal(context, AnalyticsService.FEATURE_PROMO_CARDS, additionalProperties: {
                                      'promo_type': _isDonationPromo ? 'donation' : (_isSatisfactionPromo ? 'satisfaction' : 'difficulty'),
                                    });
                                    setState(() {
                                      _showPromoCard = false;
                                    });
                                  },
                                  onAction: (url) async {
                                    final settings = Provider.of<SettingsProvider>(context, listen: false);
                                    
                                    if (_isDonationPromo) {
                                      final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
                                      analyticsService.capture(context, 'tap_donation_promo');
                                      analyticsService.trackFeatureSuccess(context, AnalyticsService.FEATURE_DONATION_SYSTEM);
                                      await settings.markDonationLinkAsClicked();
                                      await settings.updateLastDonationPopup();
                                      _openDonationPage();
                                    } else if (_isSatisfactionPromo) {
                                      final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
                                      analyticsService.capture(context, 'tap_satisfaction_promo');
                                      analyticsService.trackFeatureSuccess(context, AnalyticsService.FEATURE_SATISFACTION_SURVEYS);
                                      await settings.markSatisfactionLinkAsClicked();
                                      await settings.updateLastSatisfactionPopup();
                                      _launchUrl(AppUrls.satisfactionSurveyUrl);
                                    } else if (_isDifficultyPromo) {
                                      // Handle difficulty feedback
                                      final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
                                      analyticsService.capture(context, 'tap_difficulty_feedback', properties: {'feedback': url});
                                      analyticsService.trackFeatureSuccess(context, AnalyticsService.FEATURE_DIFFICULTY_FEEDBACK, additionalProperties: {'feedback_type': url});
                                      await settings.markDifficultyLinkAsClicked();
                                      await settings.updateLastDifficultyPopup();
                                      
                                      // Handle the different feedback options
                                      if (url == 'too_hard') {
                                        // User feels questions are too hard
                                        await _adjustDifficulty('too_hard');
                                      } else if (url == 'too_easy') {
                                        // User feels questions are too easy
                                        await _adjustDifficulty('too_easy');
                                      } else if (url == 'good') {
                                        // User feels questions are just right
                                        await _adjustDifficulty('good');
                                      }
                                      
                                      // Hide the promo after action
                                      setState(() {
                                        _showPromoCard = false;
                                      });
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
                                  ProgressHeader(
                                    lessons: _lessons,
                                    continueLesson: continueLesson,
                                    streakDays: _streakDays,
                                    dayWindow: _getFiveDayWindow(),
                                    onAfterQuizReturn: _refreshStreakData,
                                    onMultiplayerPressed: () {
                                      final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
                                      analyticsService.capture(context, 'multiplayer_button_tapped');
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const MultiplayerGameSetupScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),

                          if (filteredIndices.isNotEmpty)
                            _buildLessonLayout(layoutType, filteredIndices, progress, totalLessons, continueIdx, tileMaxExtent, gridAspect),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}