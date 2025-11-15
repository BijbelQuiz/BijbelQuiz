import 'package:flutter/material.dart';

import 'error_types.dart';

/// A widget that displays error states in a user-friendly way
class AppErrorDisplay extends StatelessWidget {
  /// The error to display
  final AppError error;

  /// Optional callback for retry action
  final VoidCallback? onRetry;

  /// Whether to show technical details
  final bool showTechnicalDetails;

  /// Whether to show the error icon
  final bool showIcon;

  /// Custom title for the error display
  final String? title;

  const AppErrorDisplay({
    super.key,
    required this.error,
    this.onRetry,
    this.showTechnicalDetails = false,
    this.showIcon = true,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showIcon) ...[
                Icon(
                  Icons.error_outline_rounded,
                  color: colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title ?? 'Error',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            error.userMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onErrorContainer,
            ),
          ),
          if (showTechnicalDetails &&
              error.technicalMessage != error.userMessage) ...[
            const SizedBox(height: 8),
            Text(
              'Technical: ${error.technicalMessage}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onErrorContainer.withValues(alpha: 0.7),
              ),
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    colorScheme.onErrorContainer.withValues(alpha: 0.2),
                foregroundColor: colorScheme.onErrorContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
