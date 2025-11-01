import '../l10n/strings_en.dart' as strings_en;

/// Utility class that provides standardized error messages for common scenarios
class ErrorMessages {
  /// Gets a standardized network error message
  static String getNetworkError() {
    return strings_en.AppStrings.connectionError;
  }

  /// Gets a standardized data loading error message
  static String getDataLoadingError() {
    return strings_en.AppStrings.errorLoadQuestions;
  }

  /// Gets a standardized payment error message
  static String getPaymentError() {
    return strings_en.AppStrings.purchaseError;
  }

  /// Gets a standardized AI error message
  static String getAiError() {
    return strings_en.AppStrings.aiError;
  }

  /// Gets a standardized validation error message
  static String getValidationError(String fieldName) {
    return 'Invalid $fieldName. Please enter a valid value.';
  }

  /// Gets a standardized permission error message
  static String getPermissionError() {
    return strings_en.AppStrings.permissionDenied;
  }

  /// Gets a standardized unknown error message
  static String getUnknownError() {
    return strings_en.AppStrings.unknownError;
  }

  /// Gets a standardized sync error message
  static String getSyncError() {
    return strings_en.AppStrings.syncError;
  }

  /// Gets a standardized storage error message
  static String getStorageError() {
    return strings_en.AppStrings.storageError;
  }

  /// Gets a standardized API error message
  static String getApiError() {
    return strings_en.AppStrings.apiError;
  }
}