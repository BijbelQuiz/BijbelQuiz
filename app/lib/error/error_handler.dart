import 'package:flutter/material.dart';
import '../services/error_reporting_service.dart';
import '../services/logger.dart';

import 'error_types.dart';
import '../widgets/top_snackbar.dart';
import '../l10n/strings_nl.dart' as strings_en;

/// Centralized error handling service that provides user-friendly error messages
/// and consistent error handling across the application
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  /// Displays a user-friendly error message using snackbar
  void showError({
    required BuildContext context,
    required AppError error,
    bool showTechnicalDetails = false,
    String? questionId,
    Map<String, dynamic>? additionalInfo,
  }) {
    _logError(error);
    
    // Report the error to Supabase for debugging
    _reportErrorToSupabase(error, questionId: questionId, additionalInfo: additionalInfo);
    
    final String message = _buildUserErrorMessage(error, showTechnicalDetails);
    showTopSnackBar(
      context,
      message,
      style: TopSnackBarStyle.error,
    );
  }

  /// Displays a user-friendly error message using an alert dialog
  Future<void> showErrorDialog({
    required BuildContext context,
    required AppError error,
    bool showTechnicalDetails = false,
    String? title,
    String? questionId,
    Map<String, dynamic>? additionalInfo,
  }) async {
    _logError(error);
    
    // Report the error to Supabase for debugging
    _reportErrorToSupabase(error, questionId: questionId, additionalInfo: additionalInfo);
    
    final String message = _buildUserErrorMessage(error, showTechnicalDetails);
    
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title ?? strings_en.AppStrings.error),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                if (showTechnicalDetails && error.errorCode != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Error Code: ${error.errorCode}',
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline),
                  ),
                ],
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(strings_en.AppStrings.ok),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Reports an error to the Supabase database
  void _reportErrorToSupabase(
    AppError error, {
    String? questionId,
    Map<String, dynamic>? additionalInfo,
  }) {
    // For certain error types, always report automatically (especially for critical features like biblical references)
    final shouldAutoReport = _shouldAutoReportError(error);
    
    if (shouldAutoReport) {
      // Report automatically without user intervention
      ErrorReportingService()
          .reportError(
            appError: error,
            questionId: questionId,
            additionalInfo: additionalInfo,
          )
          .then((_) {
            AppLogger.info('Error automatically reported to Supabase: ${error.userMessage}');
          })
          .catchError((e) {
            AppLogger.warning('Failed to auto-report error to Supabase: $e');
          });
    } else {
      // For other errors, still report but with lower priority
      ErrorReportingService()
          .reportError(
            appError: error,
            questionId: questionId,
            additionalInfo: additionalInfo,
          )
          .catchError((e) {
            AppLogger.warning('Failed to report error to Supabase: $e');
          });
    }
  }

  /// Determines if an error should be automatically reported without user intervention
  bool _shouldAutoReportError(AppError error) {
    // Auto-report errors related to critical features
    switch (error.type) {
      case AppErrorType.api:
      case AppErrorType.network:
      case AppErrorType.dataLoading:
        return true;
      
      case AppErrorType.validation:
        // Auto-report validation errors that might affect core functionality
        if (error.technicalMessage.toLowerCase().contains('biblical') ||
            error.technicalMessage.toLowerCase().contains('reference') ||
            error.technicalMessage.toLowerCase().contains('book') ||
            error.technicalMessage.toLowerCase().contains('verses')) {
          return true;
        }
        return false;
      
      case AppErrorType.storage:
        // Auto-report storage errors as they can affect user progress
        return true;
      
      case AppErrorType.unknown:
        // For unknown errors, check if they're related to critical features
        final message = error.technicalMessage.toLowerCase();
        if (message.contains('biblical') ||
            message.contains('reference') ||
            message.contains('api') ||
            message.contains('network') ||
            message.contains('database')) {
          return true;
        }
        return false;
      
      default:
        // For other error types, don't auto-report unless specifically handled
        return false;
    }
  }

  /// Creates an AppError from a generic exception
  AppError fromException(
    Object exception, {
    AppErrorType type = AppErrorType.unknown,
    String? userMessage,
    String? errorCode,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
    String? questionId,
    Map<String, dynamic>? additionalInfo,
  }) {
    String technicalMessage = exception.toString();
    String finalUserMessage = userMessage ?? _getDefaultUserMessage(type);

    // Handle specific exception types
    if (exception is String) {
      technicalMessage = exception;
      finalUserMessage = userMessage ?? exception;
    } else if (exception is Exception) {
      technicalMessage = exception.toString();
    }

    return AppError(
      type: type,
      technicalMessage: technicalMessage,
      userMessage: finalUserMessage,
      errorCode: errorCode,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// Logs the error to the application logger
  void _logError(AppError error) {
    // Use the centralized AppLogger to ensure consistent sanitization
    AppLogger.severe(
      'AppError: ${error.type} - ${error.technicalMessage}',
    );
  }

  /// Builds a user-friendly error message
  String _buildUserErrorMessage(AppError error, bool showTechnicalDetails) {
    if (!showTechnicalDetails) {
      return error.userMessage;
    }
    
    // If showing technical details, include both user and technical messages
    if (error.technicalMessage != error.userMessage) {
      return '${error.userMessage}\n\nTechnical: ${error.technicalMessage}';
    }
    return error.userMessage;
  }

  /// Gets default user-friendly message based on error type
  String _getDefaultUserMessage(AppErrorType type) {
    switch (type) {
      case AppErrorType.network:
        return strings_en.AppStrings.connectionError;
      case AppErrorType.dataLoading:
        return strings_en.AppStrings.errorLoadQuestions;
      case AppErrorType.authentication:
        return strings_en.AppStrings.activationError;
      case AppErrorType.permission:
        return strings_en.AppStrings.permissionDenied;
      case AppErrorType.validation:
        return strings_en.AppStrings.pleaseEnterValidString;
      case AppErrorType.payment:
        return strings_en.AppStrings.purchaseError;
      case AppErrorType.ai:
        return strings_en.AppStrings.aiError; // Note: this might not exist, will add to localization later
      case AppErrorType.api:
        return strings_en.AppStrings.apiError; // Note: this might not exist, will add to localization later
      case AppErrorType.storage:
        return strings_en.AppStrings.storageError; // Note: this might not exist, will add to localization later
      case AppErrorType.sync:
        return strings_en.AppStrings.syncError; // Note: this might not exist, will add to localization later
      case AppErrorType.unknown:
        return strings_en.AppStrings.unknownError;
    }
  }
}

/// Extension to make error handling more convenient
extension ErrorHandlerExtension on BuildContext {
  /// Shows an error using the centralized error handler
  void showError(AppError error, {bool showTechnicalDetails = false, String? questionId, Map<String, dynamic>? additionalInfo}) {
    ErrorHandler().showError(
      context: this,
      error: error,
      showTechnicalDetails: showTechnicalDetails,
      questionId: questionId,
      additionalInfo: additionalInfo,
    );
  }

  /// Shows an error dialog using the centralized error handler
  Future<void> showErrorDialog(AppError error,
      {bool showTechnicalDetails = false, String? title, String? questionId, Map<String, dynamic>? additionalInfo}) {
    return ErrorHandler().showErrorDialog(
      context: this,
      error: error,
      showTechnicalDetails: showTechnicalDetails,
      title: title,
      questionId: questionId,
      additionalInfo: additionalInfo,
    );
  }
}