import 'package:flutter/material.dart';
import 'multiplayer_quiz_screen.dart';
import 'package:bijbelquiz/l10n/app_localizations.dart';

/// Screen for setting up a multiplayer game
class MultiplayerGameSetupScreen extends StatefulWidget {
  const MultiplayerGameSetupScreen({super.key});

  @override
  State<MultiplayerGameSetupScreen> createState() =>
      _MultiplayerGameSetupScreenState();
}

class _MultiplayerGameSetupScreenState
    extends State<MultiplayerGameSetupScreen> {
  int _selectedDuration = 5; // Default 5 minutes

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.multiplayerQuiz,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Game mode description - responsive padding
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.multiplayerQuiz,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.multiplayerDescription,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Duration selection
                Text(
                  AppLocalizations.of(context)!.chooseGameDuration,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Duration options
                ...[1, 3, 5, 10, 15]
                    .map((duration) => _buildDurationOption(duration)),

                const SizedBox(height: 32),

                // Start game button
                ElevatedButton(
                  onPressed: _startMultiplayerGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.startMultiplayerQuiz,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                const SizedBox(height: 16),

                // Game rules
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.gameRules,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      _buildRuleItem(
                          AppLocalizations.of(context)!.ruleBothPlayers),
                      _buildRuleItem(
                          AppLocalizations.of(context)!.ruleCorrectAnswer),
                      _buildRuleItem(AppLocalizations.of(context)!.ruleWinner),
                      _buildRuleItem(
                          AppLocalizations.of(context)!.ruleScreenRotation),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDurationOption(int duration) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedDuration == duration;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected
            ? colorScheme.primary.withValues(alpha: 0.1)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => setState(() => _selectedDuration = duration),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected ? colorScheme.primary : colorScheme.outline,
                ),
                const SizedBox(width: 12),
                Text(
                  '$duration ${AppLocalizations.of(context)!.minutes}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  void _startMultiplayerGame() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiplayerQuizScreen(
          gameDurationMinutes: _selectedDuration,
        ),
      ),
    );
  }
}
