import 'package:logging/logging.dart';
import '../config/supabase_config.dart';
import '../error/error_types.dart';
import '../services/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Data class that represents an error report to be sent to Supabase
class ErrorReport {
  final String id;
  final String? userId;
  final String errorType;
  final String errorMessage;
  final String? userMessage;
  final String? errorCode;
  final String? stackTrace;
  final String? context;
  final String? questionId;
  final String? additionalInfo;
  final DateTime timestamp;
  final String? deviceInfo;
  final String? appVersion;
  final String? buildNumber;

  ErrorReport({
    required this.id,
    this.userId,
    required this.errorType,
    required this.errorMessage,
    this.userMessage,
    this.errorCode,
    this.stackTrace,
    this.context,
    this.questionId,
    this.additionalInfo,
    required this.timestamp,
    this.deviceInfo,
    this.appVersion,
    this.buildNumber,
  });

  /// Convert the ErrorReport to a map for Supabase insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'error_type': errorType,
      'error_message': errorMessage,
      'user_message': userMessage,
      'error_code': errorCode,
      'stack_trace': stackTrace,
      'context': context,
      'question_id': questionId,
      'additional_info': additionalInfo,
      'timestamp': timestamp.toIso8601String(),
      'device_info': deviceInfo,
      'app_version': appVersion,
      'build_number': buildNumber,
    };
  }

  /// Create an ErrorReport from a map (for reading from Supabase)
  static ErrorReport fromMap(Map<String, dynamic> map) {
    return ErrorReport(
      id: map['id'] ?? '',
      userId: map['user_id'],
      errorType: map['error_type'] ?? '',
      errorMessage: map['error_message'] ?? '',
      userMessage: map['user_message'],
      errorCode: map['error_code'],
      stackTrace: map['stack_trace'],
      context: map['context'],
      questionId: map['question_id'],
      additionalInfo: map['additional_info'],
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      deviceInfo: map['device_info'],
      appVersion: map['app_version'],
      buildNumber: map['build_number'],
    );
  }
}

/// Centralized error reporting service that allows reporting bugs from anywhere in the app
/// The reported errors get stored in a Supabase database for debugging and monitoring
class ErrorReportingService {
  static final ErrorReportingService _instance = ErrorReportingService._internal();
  factory ErrorReportingService() => _instance;
  ErrorReportingService._internal();

  static final Logger _logger = Logger('ErrorReportingService');

  /// Reports an error to the Supabase database
  /// 
  /// [appError] The AppError object to report
  /// [questionId] Optional question ID associated with the error
  /// [additionalInfo] Additional context about the error
  /// [userId] Optional user ID of the user experiencing the error
  /// [deviceInfo] Optional device information
  /// [appVersion] Optional app version (if not provided, will be auto-detected)
  /// [buildNumber] Optional build number (if not provided, will be auto-detected)
  Future<void> reportError({
    required AppError appError,
    String? questionId,
    Map<String, dynamic>? additionalInfo,
    String? userId,
    String? deviceInfo,
    String? appVersion,
    String? buildNumber,
  }) async {
    try {
      AppLogger.info('Attempting to report error to Supabase: ${appError.userMessage}');

      // Get app version and build number if not provided
      String actualAppVersion = appVersion ?? '';
      String actualBuildNumber = buildNumber ?? '';
      
      if (appVersion == null || buildNumber == null) {
        try {
          final packageInfo = await PackageInfo.fromPlatform();
          if (appVersion == null) actualAppVersion = packageInfo.version;
          if (buildNumber == null) actualBuildNumber = packageInfo.buildNumber;
        } catch (e) {
          AppLogger.warning('Could not retrieve app version info: $e');
          actualAppVersion = 'unknown';
          actualBuildNumber = 'unknown';
        }
      }

      // Create error report object with sanitized sensitive data
      final errorReport = ErrorReport(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Using timestamp as ID
        userId: userId, // This should be an anonymous user ID, not PII
        errorType: appError.type.toString(),
        errorMessage: _sanitizeErrorMessage(appError.technicalMessage),
        userMessage: appError.userMessage,
        errorCode: appError.errorCode,
        stackTrace: _sanitizeStackTrace(appError.stackTrace?.toString()),
        context: _serializeAndSanitizeContext(appError.context),
        questionId: questionId,
        additionalInfo: _serializeAndSanitizeAdditionalInfo(additionalInfo),
        timestamp: DateTime.now(),
        deviceInfo: deviceInfo,
        appVersion: actualAppVersion,
        buildNumber: actualBuildNumber,
      );

      // Insert the error report into Supabase
      final response = await SupabaseConfig.getClient()
          .from('error_reports')
          .insert(errorReport.toMap());

      if (response.error != null) {
        AppLogger.severe('Failed to report error to Supabase: ${response.error?.message}');
        // Even if Supabase fails, we still log locally
        AppLogger.warning('Error saved locally but failed to send to database: ${appError.userMessage}');
      } else {
        AppLogger.info('Error successfully reported to Supabase: ${appError.userMessage}');
      }
    } catch (e) {
      AppLogger.severe('Failed to report error due to exception: $e');
    }
  }

  /// Reports a simple error message to the Supabase database
  /// 
  /// [message] The error message to report
  /// [type] The type of error
  /// [questionId] Optional question ID associated with the error
  /// [additionalInfo] Additional context about the error
  /// [userId] Optional user ID of the user experiencing the error
  /// [deviceInfo] Optional device information
  /// [appVersion] Optional app version (if not provided, will be auto-detected)
  /// [buildNumber] Optional build number (if not provided, will be auto-detected)
  Future<void> reportSimpleError({
    required String message,
    AppErrorType type = AppErrorType.unknown,
    String? userMessage,
    String? errorCode,
    String? questionId,
    Map<String, dynamic>? additionalInfo,
    String? userId,
    String? deviceInfo,
    String? appVersion,
    String? buildNumber,
  }) async {
    final appError = AppError(
      type: type,
      technicalMessage: message,
      userMessage: userMessage ?? message,
      errorCode: errorCode,
    );

    await reportError(
      appError: appError,
      questionId: questionId,
      additionalInfo: additionalInfo,
      userId: userId,
      deviceInfo: deviceInfo,
      appVersion: appVersion,
      buildNumber: buildNumber,
    );
  }

  /// Sanitizes error messages to remove sensitive information
  String _sanitizeErrorMessage(String errorMessage) {
    return AppLogger.sanitizeLogMessage(errorMessage);
  }

  /// Sanitizes stack trace to remove sensitive information
  String? _sanitizeStackTrace(String? stackTrace) {
    if (stackTrace == null) return null;
    
    // In production, we might want to avoid sending full stack traces
    // For now, we'll sanitize them by removing potential file paths and sensitive data
    String sanitized = stackTrace;
    
    // Remove file paths that might contain sensitive information
    sanitized = sanitized.replaceAll(RegExp(r'/[a-zA-Z0-9_/\-.]+/[a-zA-Z0-9_\-]+\.dart'), '[FILE PATH REDACTED]');
    
    // Sanitize any additional sensitive patterns
    sanitized = AppLogger.sanitizeLogMessage(sanitized);
    
    return sanitized;
  }

  /// Serializes and sanitizes the context map to remove sensitive information
  String? _serializeAndSanitizeContext(Map<String, dynamic>? context) {
    if (context == null) return null;
    
    try {
      // Sanitize the context map to remove sensitive information
      Map<String, dynamic> sanitizedContext = AppLogger.sanitizeMap(context);
      return _mapToJson(sanitizedContext);
    } catch (e) {
      AppLogger.warning('Failed to serialize context: $e');
      return null;
    }
  }

  /// Serializes and sanitizes additional info to remove sensitive information
  String? _serializeAndSanitizeAdditionalInfo(Map<String, dynamic>? additionalInfo) {
    if (additionalInfo == null) return null;
    
    try {
      // Sanitize the additional info map to remove sensitive information
      Map<String, dynamic> sanitizedAdditionalInfo = AppLogger.sanitizeMap(additionalInfo);
      return _mapToJson(sanitizedAdditionalInfo);
    } catch (e) {
      AppLogger.warning('Failed to serialize additional info: $e');
      return null;
    }
  }

  /// Converts a map to a JSON-like string representation
  String _mapToJson(Map<String, dynamic> map) {
    final entries = <String>[];
    map.forEach((key, value) {
      String valueStr;
      if (value is Map<String, dynamic>) {
        valueStr = _mapToJson(value);
      } else if (value is List) {
        valueStr = _listToJson(value);
      } else {
        valueStr = value.toString();
      }
      entries.add('"$key": "$valueStr"');
    });
    return '{${entries.join(', ')}}';
  }

  /// Converts a list to a JSON-like string representation
  String _listToJson(List list) {
    final items = <String>[];
    for (final item in list) {
      if (item is Map<String, dynamic>) {
        items.add(_mapToJson(item));
      } else {
        items.add(item.toString());
      }
    }
    return '[${items.join(', ')}]';
  }
}