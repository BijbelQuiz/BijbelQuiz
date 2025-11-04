import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'error_types.dart';
import '../widgets/top_snackbar.dart';
import '../l10n/strings_en.dart' as strings_en;
import '../l10n/strings_nl.dart' as strings_nl;

/// Centralized error handling service that provides user-friendly error messages
/// and consistent error handling across the application
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  static final Logger _logger = Logger('ErrorHandler');

  /// Displays a user-friendly error message using snackbar
  void showError({
    required BuildContext context,
    required AppError error,
    bool showTechnicalDetails = false,
  }) {
    _logError(error);
    
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
  }) async {
    _logError(error);
    
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
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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

  /// Creates an AppError from a generic exception
  AppError fromException(
    Object exception, {
    AppErrorType type = AppErrorType.unknown,
    String? userMessage,
    String? errorCode,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
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
    _logger.severe(
      'AppError: ${error.type} - ${error.technicalMessage}',
      error.technicalMessage,
      error.stackTrace,
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
      default:
        return strings_en.AppStrings.unknownError;
    }
  }
}

/// Extension to make error handling more convenient
extension ErrorHandlerExtension on BuildContext {
  /// Shows an error using the centralized error handler
  void showError(AppError error, {bool showTechnicalDetails = false}) {
    ErrorHandler().showError(
      context: this,
      error: error,
      showTechnicalDetails: showTechnicalDetails,
    );
  }

  /// Shows an error dialog using the centralized error handler
  Future<void> showErrorDialog(AppError error,
      {bool showTechnicalDetails = false, String? title}) {
    return ErrorHandler().showErrorDialog(
      context: this,
      error: error,
      showTechnicalDetails: showTechnicalDetails,
      title: title,
    );
  }
}