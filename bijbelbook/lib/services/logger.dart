import 'package:logging/logging.dart';

class AppLogger {
  static late Logger _logger;
  static bool _secureMode = false;

  static void init() {
    _logger = Logger('BijbelBook');
  }

  static void setSecureLevel({
    required bool isProduction,
    Level? productionLevel,
    Level? developmentLevel,
  }) {
    _secureMode = isProduction;
    Logger.root.level = isProduction
        ? (productionLevel ?? Level.WARNING)
        : (developmentLevel ?? Level.ALL);
  }

  static void _log(
    Level level,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (_secureMode && level.value < Level.WARNING.value) {
      return;
    }
    _logger.log(level, message, error, stackTrace);
  }

  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    _log(Level.INFO, message, error, stackTrace);
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _log(Level.WARNING, message, error, stackTrace);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(Level.SEVERE, message, error, stackTrace);
  }

  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _log(Level.FINE, message, error, stackTrace);
  }
}
