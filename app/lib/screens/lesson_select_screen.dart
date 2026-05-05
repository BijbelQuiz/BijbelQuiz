import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bijbelquiz/services/version_check.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/lesson.dart';
import '../providers/lesson_progress_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/game_stats_provider.dart';
import '../services/lesson_service.dart';
import '../screens/quiz_screen.dart';
import '../screens/guide_screen.dart';
import '../screens/multiplayer_game_setup_screen.dart';
import '../screens/social_screen.dart';
import '../widgets/top_snackbar.dart';
import 'package:bijbelquiz/l10n/app_localizations.dart';
import '../constants/urls.dart';
import '../widgets/progress_header.dart';
import '../widgets/lesson_tile.dart';
import '../widgets/lesson_skeleton.dart';
import '../widgets/promo_card.dart';
import '../utils/streak_calculator.dart' as streak_utils;

enum PromoType {
  donation,
  satisfaction,
  difficulty,
  accountCreation,
  follow,
  referral,
  shareStats
}

extension PromoTypeExtension on PromoType {
  String get analyticsName {
    switch (this) {
      case PromoType.donation:
        return 'donation';
      case PromoType.satisfaction:
        return 'satisfaction';
      case PromoType.difficulty:
        return 'difficulty';
      case PromoType.accountCreation:
        return 'account_creation';
      case PromoType.follow:
        return 'follow';
      case PromoType.referral:
        return 'referral';
      case PromoType.shareStats:
        return 'share_stats';
    }
  }
}

class LessonSelectScreen extends StatefulWidget {
  const LessonSelectScreen({super.key});

  @override
  State<LessonSelectScreen> createState() => _LessonSelectScreenState();
}

class _LessonSelectScreenState extends State<LessonSelectScreen>
    with SingleTickerProviderStateMixin {
  final LessonService _lessonService = LessonService();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  /// Whether lessons are currently loading for the first time
  bool _isInitialLoading = true;

  /// Whether lessons are currently loading
  bool _isLoading = false;

  /// Whether more lessons are currently loading
  bool _isLoadingMore = false;

  /// Whether to show skeleton loaders while loading
  bool _showSkeletons = true;

  /// Error message if loading failed
  String? _error;

  /// List of loaded lessons
  List<Lesson> _lessons = const [];

  /// Flag to prevent multiple guide checks
  bool _guideCheckCompleted = false;

  /// Whether to show the promotional card
  bool _showPromoCard = false;

  /// Current promo type to display
  PromoType? _currentPromoType;

  /// Whether an update is available (Linux only)
  bool _updateAvailable = false;

  /// Whether update check has already been performed (one-time guard)
  bool _hasCheckedForUpdates = false;

  /// Whether status page check has already been performed (one-time guard)
  bool _hasCheckedStatusPage = false;

  /// Whether status page check is in progress
  bool _isCheckingStatusPage = false;

  /// Whether to show the status impact card
  bool _showStatusImpactCard = false;

  /// Status page title
  String? _statusTitle;

  /// Status page summary
  String? _statusSummary;

  /// Status page event description (from active events)
  String? _statusDescription;

  /// Status page event title (from active events)
  String? _statusEventTitle;

  /// Status page impact (app, website, or app_website)
  String? _statusImpact;

  /// Version check service
  final VersionCheckService _versionCheckService = VersionCheckService();

  // Daily usage streak tracking (persisted locally)
  static const String _activeDaysKey = 'daily_active_days_v1';
  Set<String> _activeDays = {};
  int _streakDays = 0;

  // Cached lessons
  static const String _cachedLessonsKey = 'cached_lessons_v1';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutCubic,
      ),
    );
    _fadeController.forward();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowGuide();
      _checkForUpdates();
      _checkStatusPage();
    });

    unawaited(_loadCachedLessons()
        .then((_) => unawaited(_loadLessons(maxLessons: 20))));
    unawaited(_loadStreakData());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 500 &&
        !_isLoadingMore &&
        !_isLoading) {
      _loadMoreLessons();
    }
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

  /// Helper method to track lesson selection analytics
  void _trackLessonSelection(Lesson lesson, bool unlocked) {
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
    // Check for updates every time the screen is rendered
    if (mounted) {
      _checkForUpdates();
    }
  }

  Future<void> _checkForUpdates() async {
    // One-time guard: skip if already checked
    if (_hasCheckedForUpdates) return;

    // Mark as checked immediately to prevent concurrent calls
    _hasCheckedForUpdates = true;

    try {
      final shouldShow =
          await _versionCheckService.shouldShowUpdateNotification('linux');
      if (mounted) {
        setState(() {
          _updateAvailable = shouldShow;
        });
      }
    } catch (e) {
      // Log error but don't rethrow - update check failures shouldn't break the UI
      debugPrint('Error checking for updates: $e');
    }
  }

  Future<void> _checkStatusPage({bool force = false}) async {
    if (_isCheckingStatusPage) return;
    if (_hasCheckedStatusPage && !force) return;

    _hasCheckedStatusPage = true;
    _isCheckingStatusPage = true;

    try {
      final response = await http
          .get(Uri.parse(AppUrls.statusJsonUrl))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) {
        debugPrint('Status page check failed: HTTP ${response.statusCode}');
        return;
      }

      final data = json.decode(response.body);
      if (data is! Map<String, dynamic>) {
        debugPrint('Status page check failed: invalid JSON payload');
        return;
      }

      final title = data['title']?.toString() ?? '';
      final summary = data['summary']?.toString() ?? '';
      final events = data['events'];
      final appImpactEvents = <Map<String, dynamic>>[];
      if (events is List) {
        for (final event in events) {
          if (event is Map<String, dynamic>) {
            final impactValue = event['impact']?.toString();
            final normalizedImpact =
                (impactValue == null || impactValue.isEmpty)
                    ? 'app'
                    : impactValue;
            if (normalizedImpact == 'app' ||
                normalizedImpact == 'app_website') {
              appImpactEvents.add(event);
            }
          } else if (event is Map) {
            final impactValue = event['impact']?.toString();
            final normalizedImpact =
                (impactValue == null || impactValue.isEmpty)
                    ? 'app'
                    : impactValue;
            if (normalizedImpact == 'app' ||
                normalizedImpact == 'app_website') {
              appImpactEvents.add(Map<String, dynamic>.from(event));
            }
          }
        }
      }

      String? eventDescription;
      String? eventTitle;
      for (final event in appImpactEvents) {
        final titleValue = event['title']?.toString();
        if (eventTitle == null &&
            titleValue != null &&
            titleValue.trim().isNotEmpty) {
          eventTitle = titleValue.trim();
        }
        final value = event['description']?.toString();
        if (value != null && value.trim().isNotEmpty) {
          eventDescription = value.trim();
        }
        if (eventTitle != null && eventDescription != null) {
          break;
        }
      }

      String? impact;
      if (appImpactEvents.isNotEmpty) {
        impact = 'app';
      }

      final hasAppImpactEvents = appImpactEvents.isNotEmpty;
      final shouldShow = hasAppImpactEvents;

      if (!mounted) return;
      setState(() {
        _showStatusImpactCard = shouldShow;
        _statusTitle = title;
        _statusSummary = summary;
        _statusDescription = eventDescription;
        _statusEventTitle = eventTitle;
        _statusImpact = impact;
      });
    } catch (e) {
      debugPrint('Error checking status page: $e');
    } finally {
      _isCheckingStatusPage = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadStreakData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_activeDaysKey) ?? <String>[];
      _activeDays = list.toSet();

      // Calculate streak using the utility class
      _streakDays =
          streak_utils.StreakCalculator.calculateCurrentStreak(_activeDays);
    } catch (e) {
      // Log error but continue gracefully
      debugPrint('Error loading streak data: $e');
    }
    if (mounted) setState(() {});
  }

  Future<void> _refreshStreakData() async {
    await _loadStreakData();
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      _loadLessons(maxLessons: 20),
      _checkStatusPage(force: true),
    ]);
  }

  String _formatStatusImpact(AppLocalizations loc) {
    String impactLabel;
    switch (_statusImpact) {
      case 'app':
        impactLabel = loc.statusImpactApp;
        break;
      case 'website':
        impactLabel = loc.statusImpactWebsite;
        break;
      case 'app_website':
        impactLabel = loc.statusImpactAppAndWebsite;
        break;
      default:
        impactLabel = loc.statusImpactUnknown;
    }
    return '${loc.statusImpactLabel}: $impactLabel';
  }

  Future<void> _loadCachedLessons() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_cachedLessonsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        final cachedLessons = jsonList.map((e) => Lesson.fromJson(e)).toList();

        if (cachedLessons.isNotEmpty && mounted) {
          setState(() {
            _lessons = cachedLessons;
            _showSkeletons = false;
            _isInitialLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading cached lessons: $e');
    }
  }

  Future<void> _saveCachedLessons() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(_lessons.map((l) => l.toJson()).toList());
      await prefs.setString(_cachedLessonsKey, jsonString);
    } catch (e) {
      // Log error but continue gracefully
      debugPrint('Error saving cached lessons: $e');
    }
  }

  List<DayIndicator> _getFiveDayWindow() {
    final streakDayIndicators =
        streak_utils.StreakCalculator.getFiveDayWindow(_activeDays);
    // Convert from streak_utils.DayIndicator to progress_header.DayIndicator
    return streakDayIndicators.map((streakDayIndicator) {
      DayState state;
      switch (streakDayIndicator.state) {
        case streak_utils.DayState.success:
          state = DayState.success;
        case streak_utils.DayState.fail:
          state = DayState.fail;
        case streak_utils.DayState.freeze:
          state = DayState.freeze;
        case streak_utils.DayState.future:
          state = DayState.future;
      }
      return DayIndicator(date: streakDayIndicator.date, state: state);
    }).toList();
  }

  Future<void> _loadLessons({int? maxLessons, bool append = false}) async {
    final progress =
        Provider.of<LessonProgressProvider>(context, listen: false);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    try {
      if (!append) {
        final hasCachedData = _lessons.isNotEmpty;
        setState(() {
          _isLoading = true;
          _error = null;

          if (!hasCachedData) {
            _showSkeletons = true;
          }
        });
      }

      const int buffer = 12;
      const int minVisible = 36;
      final int desired = append
          ? (maxLessons ?? _lessons.length + 20)
          : (progress.unlockedCount + buffer);
      final int visibleCount = desired < minVisible ? minVisible : desired;

      final lessons = await _lessonService.generateLessons(
        settings.language,
        maxLessons: visibleCount,
        maxQuestionsPerLesson: 10,
      );

      if (!mounted) return;
      setState(() {
        if (append) {
          _lessons.addAll(lessons.sublist(_lessons.length));
        } else {
          _lessons = lessons;
        }

        _showSkeletons = false;
        _isInitialLoading = false;
      });

      await _saveCachedLessons();

      if (!append) {
        await progress.ensureUnlockedCountAtLeast(1);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AppLocalizations.of(context)!.couldNotLoadLessons;
        _showSkeletons = false;
        _isInitialLoading = false;
      });
    } finally {
      if (mounted && !append) {
        setState(() {
          _isLoading = false;
          _showPromoCard = _shouldShowPromoCard(settings);
          if (_showPromoCard) {
            _currentPromoType = _determinePromoType();
            _trackPromoCardShown();
          }
        });
      }
    }
  }

  Future<void> _loadMoreLessons() async {
    if (_isLoadingMore || _isLoading) return;
    setState(() => _isLoadingMore = true);
    try {
      await _loadLessons(maxLessons: _lessons.length + 20, append: true);
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  /// Determines whether to show a promo card
  bool _shouldShowPromoCard(SettingsProvider settings) {
    // Don't show promo cards when an update is available
    if (_updateAvailable) return false;

    // Check if user is not logged in - if so, always show account creation promo
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
    if (!isLoggedIn) {
      return true;
    }

    return false;
  }

  PromoType _determinePromoType() {
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
    if (!isLoggedIn) {
      return PromoType.accountCreation;
    }

    final rand = Random().nextInt(6);
    switch (rand) {
      case 0:
        return PromoType.donation;
      case 1:
        return PromoType.difficulty;
      case 2:
        return PromoType.satisfaction;
      case 3:
        return PromoType.follow;
      case 4:
        return PromoType.referral;
      default:
        return PromoType.shareStats;
    }
  }

  void _trackPromoCardShown() {
  }

  void _onPromoDismissed() {
    setState(() {
      _showPromoCard = false;
    });
  }

  void _onUpdateDismissed() {
    setState(() {
      _updateAvailable = false;
    });
  }

  void _onPromoViewed() {
  }

  Future<void> _onPromoAction(String action) async {
    switch (_currentPromoType) {
      case PromoType.donation:
        await _handleDonationAction();
        break;
      case PromoType.satisfaction:
        await _handleSatisfactionAction();
        break;
      case PromoType.difficulty:
        await _handleDifficultyAction(action);
        break;
      case PromoType.accountCreation:
        await _handleAccountCreationAction();
        break;
      case PromoType.follow:
        await _handleFollowAction(action);
        break;
      case PromoType.referral:
        await _handleReferralAction();
        break;
      case PromoType.shareStats:
        await _handleShareStatsAction();
        break;
      case null:
        break;
    }
  }

  Future<void> _handleDonationAction() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    await settings.markDonationLinkAsClicked();
    await settings.updateLastDonationPopup();
    _openDonationPage();
  }

  Future<void> _handleSatisfactionAction() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    await settings.markSatisfactionLinkAsClicked();
    await settings.updateLastSatisfactionPopup();
    _launchUrl(AppUrls.satisfactionSurveyUrl);
  }

  Future<void> _handleDifficultyAction(String feedback) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    await settings.markDifficultyLinkAsClicked();
    await settings.updateLastDifficultyPopup();

    if (feedback == 'too_hard' ||
        feedback == 'too_easy' ||
        feedback == 'good') {
      await _adjustDifficulty(feedback);
    }

    setState(() {
      _showPromoCard = false;
    });
  }

  Future<void> _handleAccountCreationAction() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SocialScreen(),
      ),
    );
  }

  Future<void> _handleFollowAction(String url) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    await settings.markFollowLinkAsClicked();
    await settings.updateLastFollowPopup();
    _launchUrl(url);
  }

  Future<void> _handleReferralAction() async {
    final TextEditingController yourNameController = TextEditingController();
    final TextEditingController friendNameController = TextEditingController();

    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.customizeInvite),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: yourNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.enterYourName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: friendNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.enterFriendName,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                final yourName = yourNameController.text.trim();
                final friendName = friendNameController.text.trim();

                String inviteUrl = 'https://bijbelquiz.thomasboom.com/invite.html';
                final Map<String, String> queryParams = {};
                if (yourName.isNotEmpty) queryParams['yourName'] = yourName;
                if (friendName.isNotEmpty) {
                  queryParams['friendName'] = friendName;
                }

                if (queryParams.isNotEmpty) {
                  inviteUrl = Uri.parse(inviteUrl)
                      .replace(queryParameters: queryParams)
                      .toString();
                }

                await Clipboard.setData(ClipboardData(text: inviteUrl));

                if (dialogContext.mounted) {
                  showTopSnackBar(dialogContext,
                      AppLocalizations.of(context)!.inviteLinkCopied,
                      style: TopSnackBarStyle.success);
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(AppLocalizations.of(context)!.sendInvite),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleShareStatsAction() async {
    try {
      final gameStats = Provider.of<GameStatsProvider>(context, listen: false);

      final totalQuestions = gameStats.score + gameStats.incorrectAnswers;
      final correctPercentage = totalQuestions > 0
          ? ((gameStats.score / totalQuestions) * 100).round()
          : 0;

      final statsString =
          '${gameStats.score}:${gameStats.currentStreak}:${gameStats.longestStreak}:${gameStats.incorrectAnswers}:$totalQuestions:$correctPercentage';

      final bytes = utf8.encode(statsString);
      final digest = sha256.convert(bytes);
      final statsHash = digest.toString().substring(0, 16);

      final statsUrl =
          'https://bijbelquiz.thomasboom.com/score.html?s=$statsString&h=$statsHash';

      await Clipboard.setData(ClipboardData(text: statsUrl));

      if (context.mounted) {
        showTopSnackBar(context, AppLocalizations.of(context)!.statsLinkCopied,
            style: TopSnackBarStyle.success);
      }
    } catch (e) {
      if (context.mounted) {
        showTopSnackBar(context, AppLocalizations.of(context)!.errorCopyingLink,
            style: TopSnackBarStyle.error);
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        debugPrint('Could not launch URL: $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
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
    // Get analytics service before any async operations to avoid context issues
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    // Store the user's difficulty preference
    await settings.setDifficultyPreference(feedback);
  }

  /// Helper method to handle analytics for locked lesson taps
  void _handleLockedLessonTap(String lessonId) {
    showTopSnackBar(context, AppLocalizations.of(context)!.lessonLocked,
        style: TopSnackBarStyle.warning);
  }

  /// Helper method to handle navigation to quiz screen
  Future<void> _navigateToQuiz(Lesson lesson) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            QuizScreen(lesson: lesson, sessionLimit: lesson.maxQuestions),
      ),
    );

    // After returning from the quiz, refresh streak data and reload lessons if needed.
    if (!mounted) return;
    await _refreshStreakData();
    await _loadLessons();
  }

  /// Builds the lesson layout based on the selected layout type
  Widget _buildLessonLayout(
      String layoutType,
      List<int> filteredIndices,
      LessonProgressProvider progress,
      int totalLessons,
      int continueIdx,
      double tileMaxExtent,
      double gridAspect) {
    // Create a common lesson tile with unified tap handler
    Widget createLessonTile(int index) {
      final realIndex = filteredIndices[index];
      final lesson = _lessons[realIndex];
      final unlocked = progress.isLessonUnlocked(realIndex);
      final stars = progress.bestStarsFor(lesson.id);
      final recommended = totalLessons > 0 && realIndex == continueIdx;
      final playable = unlocked;

      return LessonTile(
        lesson: lesson,
        index: realIndex,
        unlocked: unlocked,
        playable: playable,
        stars: stars,
        recommended: unlocked && recommended,
        onTap: () async {
          if (!unlocked) {
            _handleLockedLessonTap(lesson.id);
            return;
          }

          // Navigate to quiz
          await _navigateToQuiz(lesson);
        },
      );
    }

    // Create a skeleton tile for loading states
    Widget createSkeletonTile(int index) {
      return LessonTileSkeleton(
        layoutType: layoutType,
        isDesktop: MediaQuery.of(context).size.width > 1200,
        isTablet: MediaQuery.of(context).size.width > 600 &&
            MediaQuery.of(context).size.width <= 1200,
        isSmallPhone: MediaQuery.of(context).size.width < 400,
      );
    }

    final isList = layoutType == SettingsProvider.layoutList;
    final isCompactGrid = layoutType == SettingsProvider.layoutCompactGrid;
    final childCount =
        _showSkeletons ? (isList ? 10 : 12) : filteredIndices.length;
    final maxExtent = isCompactGrid ? tileMaxExtent * 0.8 : tileMaxExtent;
    final spacing = isCompactGrid ? 10.0 : 14.0;
    final aspect = isCompactGrid ? gridAspect * 0.9 : gridAspect;

    final delegate = SliverChildBuilderDelegate(
      (context, index) {
        final child = _showSkeletons
            ? createSkeletonTile(index)
            : RepaintBoundary(child: createLessonTile(index));
        if (isList) {
          return Container(
            height: 120,
            margin: const EdgeInsets.only(bottom: 8.0),
            child: child,
          );
        }
        return child;
      },
      childCount: childCount,
      addAutomaticKeepAlives: false,
      addSemanticIndexes: false,
      addRepaintBoundaries: true,
    );

    if (isList) {
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        sliver: SliverList(delegate: delegate),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxExtent,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: aspect,
        ),
        delegate: delegate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final loc = AppLocalizations.of(context)!;
    final progress = Provider.of<LessonProgressProvider>(context);

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
    final Lesson? continueLesson =
        totalLessons > 0 ? _lessons[continueIdx] : null;

    final String? statusTitle =
        (_statusEventTitle != null && _statusEventTitle!.trim().isNotEmpty)
            ? _statusEventTitle!.trim()
            : (_statusTitle != null && _statusTitle!.trim().isNotEmpty)
                ? _statusTitle!.trim()
                : loc.statusIncidentTitle;
    final String? statusMessage =
        (_statusDescription != null && _statusDescription!.trim().isNotEmpty)
            ? _statusDescription!.trim()
            : (_statusSummary != null && _statusSummary!.trim().isNotEmpty)
                ? _statusSummary!.trim()
                : loc.statusIncidentMessage;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.15),
                    colorScheme.primary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 22,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              AppLocalizations.of(context)!.lessons,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        surfaceTintColor: colorScheme.surface,
      ),
      body: _isInitialLoading && _showSkeletons
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.loading,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color:
                            colorScheme.errorContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.error.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.couldNotLoadLessons,
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadLessons,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.error,
                              foregroundColor: colorScheme.onError,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(AppLocalizations.of(context)!.tryAgain),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;
                      if (!w.isFinite || !h.isFinite || w <= 0 || h <= 0) {
                        return const SizedBox.shrink();
                      }
                      return RefreshIndicator(
                        onRefresh: _refreshAll,
                        color: colorScheme.primary,
                        backgroundColor: colorScheme.surface,
                        child: CustomScrollView(
                          controller: _scrollController,
                          cacheExtent: 1000,
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            if (_showStatusImpactCard)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                  child: RepaintBoundary(
                                    child: PromoCard(
                                      isDonation: false,
                                      isSatisfaction: false,
                                      isDifficulty: false,
                                      isAccountCreation: false,
                                      isStatus: true,
                                      isDismissible: false,
                                      statusTitle: statusTitle,
                                      statusMessage: statusMessage,
                                      statusImpactText:
                                          _formatStatusImpact(loc),
                                      onDismiss: () {},
                                      onAction: (_) {},
                                    ),
                                  ),
                                ),
                              ),
                            if (_updateAvailable)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                  child: RepaintBoundary(
                                    child: PromoCard(
                                      isDonation: false,
                                      isSatisfaction: false,
                                      isDifficulty: false,
                                      isAccountCreation: false,
                                      isUpdate: true,
                                      onDismiss: () async {
                                        await _versionCheckService
                                            .dismissUpdateNotification();
                                        _onUpdateDismissed();
                                      },
                                      onAction: (action) async {
                                        try {
                                          final packageInfo =
                                              await PackageInfo.fromPlatform();
                                          final url =
                                              '${AppUrls.updateUrl}?version=${packageInfo.version}&platform=linux';
                                          await _launchUrl(url);
                                         } catch (e) {
                                           debugPrint(
                                               'Error getting package info: $e');
                                         }
                                       },
                                    ),
                                  ),
                                ),
                              )
                            else if (_showPromoCard)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                  child: RepaintBoundary(
                                    child: PromoCard(
                                      isDonation: _currentPromoType ==
                                          PromoType.donation,
                                      isSatisfaction: _currentPromoType ==
                                          PromoType.satisfaction,
                                      isDifficulty: _currentPromoType ==
                                          PromoType.difficulty,
                                      isAccountCreation: _currentPromoType ==
                                          PromoType.accountCreation,
                                      isReferral: _currentPromoType ==
                                          PromoType.referral,
                                      isShareStats: _currentPromoType ==
                                          PromoType.shareStats,
                                      socialMediaType:
                                          _currentPromoType == PromoType.follow
                                              ? 'follow'
                                              : null,
                                      onDismiss: _onPromoDismissed,
                                      onView: _onPromoViewed,
                                      onAction: _onPromoAction,
                                    ),
                                  ),
                                ),
                              ),

                            // Hero progress + CTA section
                            SliverToBoxAdapter(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RepaintBoundary(
                                      child: ProgressHeader(
                                        lessons: _lessons,
                                        continueLesson: continueLesson,
                                        streakDays: _streakDays,
                                        dayWindow: _getFiveDayWindow(),
                                        onAfterQuizReturn: _refreshStreakData,
                                        onMultiplayerPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const MultiplayerGameSetupScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),

                            if (filteredIndices.isNotEmpty)
                              _buildLessonLayout(
                                  layoutType,
                                  filteredIndices,
                                  progress,
                                  totalLessons,
                                  continueIdx,
                                  tileMaxExtent,
                                  gridAspect),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
