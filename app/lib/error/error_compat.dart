import 'package:flutter/material.dart';

import 'error_types.dart';
import 'error_handler.dart';

/// A compatibility wrapper that adapts the legacy error display functionality
/// to work with the new centralized error handling system
class QuizErrorDisplay extends StatelessWidget {
  /// Legacy error string parameter
  final String error;

  /// Legacy retry callback
  final VoidCallback onRetry;

  const QuizErrorDisplay({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Create an AppError from the legacy string
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
                      label: Text('Try Again'),
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

/// Extension to provide a convenient way to show errors from the new error system
/// using the legacy format
extension LegacyErrorDisplay on BuildContext {
  /// Shows a legacy-style error display with retry functionality
  Widget buildLegacyErrorDisplay({
    required String error,
    required VoidCallback onRetry,
  }) {
    return QuizErrorDisplay(error: error, onRetry: onRetry);
  }
}
