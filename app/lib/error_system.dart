/// Centralized error handling system for the BijbelQuiz app
/// 
/// This library provides a unified approach to error handling with user-friendly
/// messages and consistent error display across the application.
/// 
/// Usage:
/// ```dart
/// import 'package:bijbelquiz/error/error_system.dart';
/// 
/// // In your widget or service:
/// final error = ErrorHandler().fromException(
///   exception,
///   type: AppErrorType.network,
///   userMessage: 'Failed to connect to the internet',
/// );
/// 
/// // Show error with snackbar
/// ErrorHandler().showError(context: context, error: error);
/// 
/// // Or show as dialog
/// await ErrorHandler().showErrorDialog(context: context, error: error);
/// ```

library;

export 'error/error_types.dart';
export 'error/error_handler.dart';
export 'error/error_messages.dart';
export 'error/error_display.dart';
export 'error/error_compat.dart';