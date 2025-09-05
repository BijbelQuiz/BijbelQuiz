import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_stats_provider.dart';
import '../l10n/strings_nl.dart' as strings;
import 'metric_item.dart';

/// A widget that displays the quiz metrics (score, streak, best streak, time)
/// in a responsive layout that adapts to different screen sizes.
class QuizMetricsDisplay extends StatelessWidget {
  final Animation<double> scoreAnimation;
  final Animation<double> streakAnimation;
  final Animation<double> longestStreakAnimation;
  final Animation<double> timeAnimation;
  final Animation<Color?> timeColorAnimation;
  final int previousScore;
  final int previousStreak;
  final int previousLongestStreak;
  final int previousTime;
  final bool isDesktop;
  final bool isTablet;
  final bool isSmallPhone;

  const QuizMetricsDisplay({
    super.key,
    required this.scoreAnimation,
    required this.streakAnimation,
    required this.longestStreakAnimation,
    required this.timeAnimation,
    required this.timeColorAnimation,
    required this.previousScore,
    required this.previousStreak,
    required this.previousLongestStreak,
    required this.previousTime,
    required this.isDesktop,
    required this.isTablet,
    required this.isSmallPhone,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final gameStats = Provider.of<GameStatsProvider>(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250), // Optimized for better responsiveness
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: Container(
        key: ValueKey<String>(
          isDesktop
              ? 'desktop_metrics'
              : isTablet
                  ? 'tablet_metrics'
                  : isSmallPhone
                      ? 'smallPhone_metrics'
                      : MediaQuery.of(context).size.width < 320
                          ? 'verySmallPhone_metrics'
                          : 'mobile_metrics',
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 16 : 12,
          vertical: isDesktop ? 12 : 10,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withAlpha((0.1 * 255).round()),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isDesktop || isTablet
            ? _buildDesktopTabletMetrics(colorScheme, gameStats)
            : _buildMobileMetrics(colorScheme, gameStats),
      ),
    );
  }

  Widget _buildDesktopTabletMetrics(ColorScheme colorScheme, GameStatsProvider gameStats) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 12,
      children: [
        MetricItem(
          icon: Icons.star_rounded,
          value: gameStats.score.toString(),
          label: strings.AppStrings.score,
          colorScheme: colorScheme,
          color: colorScheme.primary,
          animation: scoreAnimation,
          previousValue: previousScore,
          onAnimationComplete: () {},
          isSmallPhone: false,
          highlight: gameStats.isPowerupActive,
        ),
        MetricItem(
          icon: Icons.local_fire_department_rounded,
          value: gameStats.currentStreak.toString(),
          label: strings.AppStrings.streak,
          colorScheme: colorScheme,
          color: const Color(0xFFF59E0B),
          animation: streakAnimation,
          previousValue: previousStreak,
          onAnimationComplete: () {},
          isSmallPhone: false,
        ),
        MetricItem(
          icon: Icons.emoji_events_rounded,
          value: gameStats.longestStreak.toString(),
          label: strings.AppStrings.best,
          colorScheme: colorScheme,
          color: const Color(0xFFF59E0B),
          animation: longestStreakAnimation,
          previousValue: previousLongestStreak,
          onAnimationComplete: () {},
          isSmallPhone: false,
        ),
        MetricItem(
          icon: Icons.timer_rounded,
          value: previousTime.toString(),
          label: strings.AppStrings.time,
          colorScheme: colorScheme,
          color: timeColorAnimation.value ?? const Color(0xFF10B981),
          animation: timeAnimation,
          previousValue: previousTime,
          onAnimationComplete: () {},
          isSmallPhone: false,
        ),
      ],
    );
  }

  Widget _buildMobileMetrics(ColorScheme colorScheme, GameStatsProvider gameStats) {
    return Builder(
      builder: (context) {
        final size = MediaQuery.of(context).size;
        double width = size.width;

        // If the screen is extremely small, show a not supported message
        if (width < 260) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Schermgrootte niet ondersteund',
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Determine scale factor based on width
        double scale;
        if (width < 320) {
          scale = 0.7;
        } else if (width < 380) {
          scale = 0.8;
        } else if (width < 440) {
          scale = 0.9;
        } else {
          scale = 1.0;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: MetricItem(
                icon: Icons.star_rounded,
                value: gameStats.score.toString(),
                label: strings.AppStrings.score,
                colorScheme: colorScheme,
                color: colorScheme.primary,
                animation: scoreAnimation,
                previousValue: previousScore,
                onAnimationComplete: () {},
                isSmallPhone: false,
                highlight: gameStats.isPowerupActive,
                scale: scale,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: MetricItem(
                icon: Icons.local_fire_department_rounded,
                value: gameStats.currentStreak.toString(),
                label: strings.AppStrings.streak,
                colorScheme: colorScheme,
                color: const Color(0xFFF59E0B),
                animation: streakAnimation,
                previousValue: previousStreak,
                onAnimationComplete: () {},
                isSmallPhone: false,
                scale: scale,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: MetricItem(
                icon: Icons.emoji_events_rounded,
                value: gameStats.longestStreak.toString(),
                label: strings.AppStrings.best,
                colorScheme: colorScheme,
                color: const Color(0xFFF59E0B),
                animation: longestStreakAnimation,
                previousValue: previousLongestStreak,
                onAnimationComplete: () {},
                isSmallPhone: false,
                scale: scale,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: MetricItem(
                icon: Icons.timer_rounded,
                value: previousTime.toString(),
                label: 'Tijd',
                colorScheme: colorScheme,
                color: timeColorAnimation.value ?? const Color(0xFF10B981),
                animation: timeAnimation,
                previousValue: previousTime,
                onAnimationComplete: () {},
                isSmallPhone: false,
                scale: scale,
              ),
            ),
          ],
        );
      },
    );
  }
}