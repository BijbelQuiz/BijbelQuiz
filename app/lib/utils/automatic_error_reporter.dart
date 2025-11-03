import '../services/error_reporting_service.dart';
import '../error/error_types.dart';

/// Utility class for automatic error reporting in specific app features
class AutomaticErrorReporter {
  /// Reports errors related to biblical reference functionality
  static Future<void> reportBiblicalReferenceError({
    required String message,
    required String reference,
    String? userMessage,
    String? questionId,
    Map<String, dynamic>? additionalInfo,
  }) async {
    try {
      await ErrorReportingService().reportSimpleError(
        message: message,
        type: AppErrorType.api, // Most biblical reference issues are API related
        userMessage: userMessage ?? 'Biblical reference error',
        questionId: questionId,
        additionalInfo: {
          'feature': 'biblical_reference',
          'reference': reference,
          ...?additionalInfo,
        },
      );
    } catch (e) {
      // If error reporting itself fails, we just log it locally but don't break functionality
      print('Failed to auto-report biblical reference error: $e');
    }
  }

  /// Reports errors related to question loading/data issues
  static Future<void> reportQuestionError({
    required String message,
    String? userMessage,
    required String questionId,
    String? questionText,
    Map<String, dynamic>? additionalInfo,
  }) async {
    try {
      await ErrorReportingService().reportSimpleError(
        message: message,
        type: AppErrorType.dataLoading,
        userMessage: userMessage ?? 'Question data error',
        questionId: questionId,
        additionalInfo: {
          'feature': 'question_system',
          'question_text': questionText,
          ...?additionalInfo,
        },
      );
    } catch (e) {
      print('Failed to auto-report question error: $e');
    }
  }

  /// Reports errors related to network/API functionality
  static Future<void> reportNetworkError({
    required String message,
    String? userMessage,
    String? url,
    int? statusCode,
    String? questionId,
    Map<String, dynamic>? additionalInfo,
  }) async {
    try {
      await ErrorReportingService().reportSimpleError(
        message: message,
        type: AppErrorType.network,
        userMessage: userMessage ?? 'Network error',
        questionId: questionId,
        additionalInfo: {
          'feature': 'network',
          'url': url,
          'status_code': statusCode,
          ...?additionalInfo,
        },
      );
    } catch (e) {
      print('Failed to auto-report network error: $e');
    }
  }

  /// Reports errors related to storage functionality
  static Future<void> reportStorageError({
    required String message,
    String? userMessage,
    String? operation,
    String? filePath,
    String? questionId,
    Map<String, dynamic>? additionalInfo,
  }) async {
    try {
      await ErrorReportingService().reportSimpleError(
        message: message,
        type: AppErrorType.storage,
        userMessage: userMessage ?? 'Storage error',
        questionId: questionId,
        additionalInfo: {
          'feature': 'storage',
          'operation': operation,
          'file_path': filePath,
          ...?additionalInfo,
        },
      );
    } catch (e) {
      print('Failed to auto-report storage error: $e');
    }
  }
}