import 'package:flutter/material.dart';
import 'error_handler.dart';
import 'error_types.dart';
import '../services/logger.dart';

/// Test widget to demonstrate the new error handling system
class ErrorHandlingTestWidget extends StatelessWidget {
  const ErrorHandlingTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Handling Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
                'This screen demonstrates the new error handling system'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _testErrorHandling(context),
              child: const Text('Test Error Handling'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _testErrorDialog(context),
              child: const Text('Test Error Dialog'),
            ),
          ],
        ),
      ),
    );
  }

  void _testErrorHandling(BuildContext context) {
    final error = ErrorHandler().fromException(
      'This is a test network error',
      type: AppErrorType.network,
      userMessage:
          'Could not connect to the server. Please check your internet connection.',
      errorCode: 'NET_001',
      context: {'screen': 'QuizScreen', 'operation': 'loadQuestions'},
    );

    ErrorHandler().showError(context: context, error: error);
  }

  void _testErrorDialog(BuildContext context) {
    final error = ErrorHandler().fromException(
      'This is a test storage error',
      type: AppErrorType.storage,
      userMessage: 'Could not save your progress. Please try again.',
      errorCode: 'STORAGE_002',
      context: {'operation': 'saveProgress'},
    );

    ErrorHandler().showErrorDialog(
      context: context,
      error: error,
      title: 'Storage Error',
    );
  }
}

/// Function to test the error handling system in the app
void testErrorHandlingSystem() {
  // Create different types of errors to validate the system
  final networkError = ErrorHandler().fromException(
    'Connection timeout',
    type: AppErrorType.network,
    userMessage: 'Could not connect to the server',
  );

  final dataLoadError = ErrorHandler().fromException(
    'Invalid data format',
    type: AppErrorType.dataLoading,
    userMessage: 'Error loading questions',
  );

  final storageError = ErrorHandler().fromException(
    'Permission denied',
    type: AppErrorType.storage,
    userMessage: 'Could not save settings',
  );

  AppLogger.info('Error handling system test completed. Created errors:');
  AppLogger.info('- Network Error: ${networkError.userMessage}');
  AppLogger.info('- Data Load Error: ${dataLoadError.userMessage}');
  AppLogger.info('- Storage Error: ${storageError.userMessage}');
}
