import 'package:flutter/material.dart';
import '../l10n/strings_nl.dart' as strings;
import '../error/error_handler.dart';
import '../error/error_types.dart';

/// A widget that displays error states in the quiz screen
/// with a consistent design and retry functionality.
class QuizErrorDisplay extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const QuizErrorDisplay({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Convert the legacy string error to AppError for consistency
    final appError = ErrorHandler().fromException(
      error,
      type: AppErrorType.unknown,
      userMessage: error,
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.outline.withAlpha((0.1 * 255).round()),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withAlpha((0.06 * 255).round()),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      appError.userMessage,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorScheme.onErrorContainer,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(strings.AppStrings.tryAgain),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            colorScheme.onErrorContainer.withValues(alpha: 0.2),
                        foregroundColor: colorScheme.onErrorContainer,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
