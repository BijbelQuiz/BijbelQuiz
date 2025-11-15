import 'package:flutter/material.dart';
import '../providers/game_stats_provider.dart';
import '../providers/settings_provider.dart';
import '../models/quiz_state.dart';
import '../utils/quiz_action_price_helper.dart';
import '../l10n/strings_nl.dart' as strings;

/// Bottom navigation bar for quiz screen with action buttons
/// (skip question, unlock biblical reference, report question) and cost display.
class QuizBottomBar extends StatefulWidget {
  final QuizState quizState;
  final GameStatsProvider gameStats;
  final SettingsProvider settings;
  final String questionId;
  final VoidCallback onSkipPressed;
  final VoidCallback onUnlockPressed;
  final VoidCallback onFlagPressed;
  final bool isDesktop;

  const QuizBottomBar({
    super.key,
    required this.quizState,
    required this.gameStats,
    required this.settings,
    required this.questionId,
    required this.onSkipPressed,
    required this.onUnlockPressed,
    required this.onFlagPressed,
    required this.isDesktop,
  });

  @override
  State<QuizBottomBar> createState() => _QuizBottomBarState();
}

class _QuizBottomBarState extends State<QuizBottomBar> {
  int _skipCost = 35; // Default fallback
  int _biblicalCost = 10; // Default fallback
  bool _isLoadingPrices = true;

  @override
  void initState() {
    super.initState();
    _loadActionPrices();
  }

  Future<void> _loadActionPrices() async {
    try {
      setState(() {
        _isLoadingPrices = true;
      });

      final priceHelper = QuizActionPriceHelper();

      // Load both prices concurrently
      final results = await Future.wait([
        priceHelper.getSkipQuestionPrice(),
        priceHelper.getUnlockBiblicalReferencePrice(),
      ]);

      setState(() {
        _skipCost = results[0];
        _biblicalCost = results[1];
        _isLoadingPrices = false;
      });
    } catch (e) {
      // Keep default prices if loading fails (offline fallback)
      setState(() {
        _isLoadingPrices = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final canSkip = widget.gameStats.score >= _skipCost &&
        !widget.quizState.isAnswering &&
        !widget.quizState.isTransitioning;
    final hasBiblicalReference =
        widget.quizState.question.biblicalReference != null &&
            widget.quizState.question.biblicalReference!.isNotEmpty;
    final canUnlock = widget.gameStats.score >= _biblicalCost &&
        !widget.quizState.isAnswering &&
        !widget.quizState.isTransitioning &&
        hasBiblicalReference;

    // Show loading indicator while fetching prices
    if (_isLoadingPrices) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Semantics(
      label: 'Quiz actions',
      hint: 'Additional actions you can take during the quiz',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outline.withAlpha((0.1 * 255).round()),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).round()),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Skip button
              _buildActionButton(
                context: context,
                icon: Icons.skip_next_rounded,
                label: widget.settings.language == 'en'
                    ? strings.AppStrings.skip
                    : strings.AppStrings.overslaan,
                cost: _skipCost,
                canUse: canSkip,
                onPressed: widget.onSkipPressed,
                isDesktop: widget.isDesktop,
              ),

              // Unlock biblical reference button
              if (hasBiblicalReference)
                _buildActionButton(
                  context: context,
                  icon: Icons.book_rounded,
                  label: strings.AppStrings.unlockBiblicalReference,
                  cost: _biblicalCost,
                  canUse: canUnlock,
                  onPressed: widget.onUnlockPressed,
                  isDesktop: widget.isDesktop,
                ),

              // Report question button
              _buildActionButton(
                context: context,
                icon: Icons.flag_rounded,
                label: strings.AppStrings.reportQuestion,
                cost: 0,
                canUse: true,
                onPressed: widget.onFlagPressed,
                isDesktop: widget.isDesktop,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int cost,
    required bool canUse,
    required VoidCallback onPressed,
    required bool isDesktop,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = canUse ? colorScheme.primary : colorScheme.outline;

    // Build semantic label based on button state
    String semanticLabel = label;
    String hint = '';

    if (!canUse) {
      semanticLabel = '$label (disabled)';
      hint = 'Not enough stars to use this action';
    } else {
      hint = 'Tap to $label for $cost stars';
    }

    return Semantics(
      label: semanticLabel,
      hint: hint,
      button: true,
      enabled: canUse,
      child: Container(
        constraints: BoxConstraints(
          minWidth: isDesktop ? 140 : 100,
          maxWidth: isDesktop ? 220 : 140,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: canUse ? onPressed : null,
            borderRadius: BorderRadius.circular(12),
            focusColor: canUse
                ? colorScheme.primary.withAlpha((0.1 * 255).round())
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: isDesktop ? 20 : 18,
                    color: textColor,
                    semanticLabel: _getIconSemanticLabel(icon),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.star_rounded,
                    size: isDesktop ? 16 : 14,
                    color: textColor,
                    semanticLabel: 'Star currency',
                  ),
                  const SizedBox(width: 2),
                  Text(
                    cost.toString(),
                    style: TextStyle(
                      color: textColor,
                      fontSize: isDesktop ? 14 : 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isDesktop) ...[
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getIconSemanticLabel(IconData icon) {
    if (icon == Icons.skip_next_rounded) {
      return 'Skip question';
    } else if (icon == Icons.book_rounded) {
      return 'Unlock biblical reference';
    } else if (icon == Icons.flag_rounded) {
      return 'Report question';
    }
    return '';
  }
}
