import 'package:flutter/material.dart';
import '../l10n/strings_nl.dart' as strings;

class StatsShareScreen extends StatelessWidget {
  final Map<String, String> statsData;

  const StatsShareScreen({super.key, required this.statsData});

  @override
  Widget build(BuildContext context) {
    // Extract stats from the URL parameters
    final int score = int.tryParse(statsData['score'] ?? '0') ?? 0;
    final int currentStreak = int.tryParse(statsData['currentStreak'] ?? '0') ?? 0;
    final int longestStreak = int.tryParse(statsData['longestStreak'] ?? '0') ?? 0;
    final int incorrect = int.tryParse(statsData['incorrect'] ?? '0') ?? 0;
    final int totalQuestions = int.tryParse(statsData['totalQuestions'] ?? '0') ?? 0;
    final int accuracy = int.tryParse(statsData['accuracy'] ?? '0') ?? 0;
    final double hoursSpent = double.tryParse(statsData['hoursSpent'] ?? '0.0') ?? 0.0;
    
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gedeelde Statistieken'),
        backgroundColor: Colors.amber.shade200, // Similar to year-in-review page color
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.amber.shade200,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                size: 80,
                color: Colors.black,
              ),
              const SizedBox(height: 24),
              Text(
                'Gedeelde Statistieken',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Bekijk de BijbelQuiz resultaten van een vriend',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    _buildStatRow(
                      context,
                      Text(
                        score.toString(),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      strings.AppStrings.correctAnswers,
                      Colors.black,
                    ),
                    const Divider(height: 16, thickness: 1),
                    _buildStatRow(
                      context,
                      Text(
                        '$accuracy%',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      strings.AppStrings.accuracy,
                      Colors.black,
                    ),
                    const Divider(height: 16, thickness: 1),
                    _buildStatRow(
                      context,
                      Text(
                        hoursSpent.toStringAsFixed(1),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      strings.AppStrings.hours,
                      Colors.black,
                    ),
                    const Divider(height: 16, thickness: 1),
                    _buildStatRow(
                      context,
                      Text(
                        currentStreak.toString(),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      strings.AppStrings.currentStreak,
                      Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    _buildStatRow(
                      context,
                      Text(
                        longestStreak.toString(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      'Langste reeks',
                      Colors.black,
                    ),
                    const Divider(height: 12, thickness: 1),
                    _buildStatRow(
                      context,
                      Text(
                        incorrect.toString(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      'Fouten',
                      Colors.black,
                    ),
                    const Divider(height: 12, thickness: 1),
                    _buildStatRow(
                      context,
                      Text(
                        totalQuestions.toString(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      'Totaal vragen',
                      Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 18,
                ),
                label: Text(
                  'Terug naar app',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    Widget valueWidget,
    String label,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black,
                ),
          ),
          valueWidget,
        ],
      ),
    );
  }
}