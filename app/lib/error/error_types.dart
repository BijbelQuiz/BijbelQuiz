/// Enum that categorizes different types of errors in the application
enum AppErrorType {
  /// Network/connection related errors
  network,

  /// Data loading errors
  dataLoading,

  /// Authentication errors
  authentication,

  /// Permission errors
  permission,

  /// Validation errors
  validation,

  /// Payment/transaction errors
  payment,

  /// AI/Generation errors
  ai,

  /// API errors
  api,

  /// Storage errors
  storage,

  /// Sync errors
  sync,

  /// Unknown/Unexpected errors
  unknown,
}

/// Data class that represents an application error with user-friendly details
class AppError {
  /// Type of error that occurred
  final AppErrorType type;

  /// Technical error message (for debugging)
  final String technicalMessage;

  /// User-friendly error message
  final String userMessage;

  /// Optional error code
  final String? errorCode;

  /// Optional stack trace
  final StackTrace? stackTrace;

  /// Optional additional context
  final Map<String, dynamic>? context;

  AppError({
    required this.type,
    required this.technicalMessage,
    required this.userMessage,
    this.errorCode,
    this.stackTrace,
    this.context,
  });

  @override
  String toString() {
    return 'AppError{type: $type, userMessage: $userMessage, technicalMessage: $technicalMessage, errorCode: $errorCode}';
  }
}
