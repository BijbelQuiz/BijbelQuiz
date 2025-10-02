/// Simple logger service for the Bible bot app
class AppLogger {
  static const String _tag = 'BijbelBot';

  /// Log info messages
  static void info(String message) {
    print('$_tag INFO: $message');
  }

  /// Log warning messages
  static void warning(String message) {
    print('$_tag WARNING: $message');
  }

  /// Log error messages
  static void error(String message, [Object? error]) {
    print('$_tag ERROR: $message');
    if (error != null) {
      print('$_tag ERROR DETAILS: $error');
    }
  }

  /// Log debug messages
  static void debug(String message) {
    print('$_tag DEBUG: $message');
  }
}