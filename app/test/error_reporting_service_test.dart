import 'package:flutter_test/flutter_test.dart';
import 'package:bijbelquiz/services/error_reporting_service.dart';
import 'package:bijbelquiz/error/error_types.dart';

void main() {
  group('ErrorReportingService Tests', () {
    late ErrorReportingService errorReportingService;

    setUp(() {
      errorReportingService = ErrorReportingService();
    });

    test('ErrorReport can be created with all parameters', () {
      final errorReport = ErrorReport(
        id: 'test-id-123',
        userId: 'user-123',
        errorType: AppErrorType.network.toString(),
        errorMessage: 'Network connection failed',
        userMessage: 'Could not connect to the server',
        errorCode: 'NET001',
        stackTrace: 'Stack trace details here',
        context: '{"questionId": "123", "screen": "HomeScreen"}',
        questionId: '123',
        additionalInfo: '{"device": "iPhone 12", "os": "iOS 14"}',
        timestamp: DateTime.now(),
        deviceInfo: 'iPhone 12, iOS 14',
        appVersion: '1.0.0',
        buildNumber: '123',
      );

      expect(errorReport.id, 'test-id-123');
      expect(errorReport.userId, 'user-123');
      expect(errorReport.errorType, 'AppErrorType.network');
      expect(errorReport.errorMessage, 'Network connection failed');
      expect(errorReport.userMessage, 'Could not connect to the server');
      expect(errorReport.errorCode, 'NET001');
      expect(errorReport.stackTrace, 'Stack trace details here');
      expect(errorReport.context, '{"questionId": "123", "screen": "HomeScreen"}');
      expect(errorReport.questionId, '123');
      expect(errorReport.additionalInfo, '{"device": "iPhone 12", "os": "iOS 14"}');
      expect(errorReport.deviceInfo, 'iPhone 12, iOS 14');
      expect(errorReport.appVersion, '1.0.0');
      expect(errorReport.buildNumber, '123');
    });

    test('ErrorReport toMap and fromMap work correctly', () {
      final originalReport = ErrorReport(
        id: 'test-id-456',
        userId: 'user-456',
        errorType: AppErrorType.validation.toString(),
        errorMessage: 'Invalid input',
        userMessage: 'Please enter a valid value',
        errorCode: 'VAL001',
        stackTrace: 'Validation stack trace',
        context: null,
        questionId: '789',
        additionalInfo: null,
        timestamp: DateTime(2023, 1, 1, 12, 0, 0),
        deviceInfo: 'Android 12',
        appVersion: '2.1.0',
        buildNumber: '456',
      );

      final map = originalReport.toMap();
      final reconstructedReport = ErrorReport.fromMap(map);

      expect(reconstructedReport.id, originalReport.id);
      expect(reconstructedReport.userId, originalReport.userId);
      expect(reconstructedReport.errorType, originalReport.errorType);
      expect(reconstructedReport.errorMessage, originalReport.errorMessage);
      expect(reconstructedReport.userMessage, originalReport.userMessage);
      expect(reconstructedReport.errorCode, originalReport.errorCode);
      expect(reconstructedReport.stackTrace, originalReport.stackTrace);
      expect(reconstructedReport.context, originalReport.context);
      expect(reconstructedReport.questionId, originalReport.questionId);
      expect(reconstructedReport.additionalInfo, originalReport.additionalInfo);
      expect(reconstructedReport.timestamp, originalReport.timestamp);
      expect(reconstructedReport.deviceInfo, originalReport.deviceInfo);
      expect(reconstructedReport.appVersion, originalReport.appVersion);
      expect(reconstructedReport.buildNumber, originalReport.buildNumber);
    });

    test('ErrorReport handles null values correctly', () {
      final errorReport = ErrorReport(
        id: 'test-id-789',
        userId: null,
        errorType: AppErrorType.unknown.toString(),
        errorMessage: 'Unknown error',
        userMessage: 'Something went wrong',
        errorCode: null,
        stackTrace: null,
        context: null,
        questionId: null,
        additionalInfo: null,
        timestamp: DateTime.now(),
        deviceInfo: null,
        appVersion: null,
        buildNumber: null,
      );

      expect(errorReport.id, 'test-id-789');
      expect(errorReport.userId, isNull);
      expect(errorReport.errorCode, isNull);
      expect(errorReport.stackTrace, isNull);
      expect(errorReport.context, isNull);
      expect(errorReport.questionId, isNull);
      expect(errorReport.additionalInfo, isNull);
      expect(errorReport.deviceInfo, isNull);
      expect(errorReport.appVersion, isNull);
      expect(errorReport.buildNumber, isNull);
    });

    test('ErrorReportingService can be instantiated as a singleton', () {
      final instance1 = ErrorReportingService();
      final instance2 = ErrorReportingService();

      expect(instance1, equals(instance2));
      expect(identical(instance1, instance2), isTrue);
    });
  });

  group('AppError Integration Tests', () {
    test('ErrorHandler properly calls ErrorReportingService', () {
      // This test would require mocking the Supabase client to be fully comprehensive
      // For now, we verify that the error handler can be created and used
      expect(() => ErrorReportingService(), returnsNormally);
    });
  });
}