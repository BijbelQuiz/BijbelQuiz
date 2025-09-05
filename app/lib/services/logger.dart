import 'package:logging/logging.dart';
import 'dart:async';

/// Provides logging functionality for the BijbelQuiz app.
class AppLogger {
  /// The underlying logger instance.
  static final Logger _logger = Logger('BijbelQuiz');

  /// Stores the subscription to the log record stream.
  static StreamSubscription<LogRecord>? _subscription;

  /// Initializes the logger with the given [level].
  ///
  /// Listens to log records and prints them to the console.
  static void init({Level level = Level.INFO}) {
    Logger.root.level = level;
    _subscription?.cancel();
    _subscription = Logger.root.onRecord.listen((record) {
      final buffer = StringBuffer();
      buffer.write('[${record.level.name}] ');
      buffer.write('${record.time.toIso8601String()} ');
      buffer.write('${record.loggerName}: ');
      buffer.write(record.message);
      if (record.error != null) buffer.write('\n  Error: ${record.error}');
      if (record.stackTrace != null) buffer.write('\n  StackTrace: ${record.stackTrace}');
    });
    _logger.info('Logger initialized at level: ${level.name}');
  }

  /// Changes the log level at runtime.
  static void setLevel(Level level) {
    Logger.root.level = level;
    _logger.info('Log level changed to: ${level.name}');
  }

  /// Detaches the log listener.
  static void close() {
    _subscription?.cancel();
    _subscription = null;
    _logger.info('Logger listener closed.');
  }

  /// Logs an info message.
  static void info(String message) => _logger.info(message);

  /// Logs a warning message, optionally with an [error] and [stackTrace].
  static void warning(String message, [Object? error, StackTrace? stackTrace]) => _logger.warning(message, error, stackTrace);

  /// Logs an error message, optionally with an [error] and [stackTrace].
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }

  /// Logs a debug message.
  static void debug(String message) => _logger.fine(message);

  /// Logs a fine-grained (verbose) message.
  static void fine(String message) => _logger.fine(message);

  /// Logs a severe error message.
  static void severe(String message, [Object? error, StackTrace? stackTrace]) => _logger.severe(message, error, stackTrace);

  /// Logs a message at a custom [level].
  static void log(Level level, String message, {Object? error, StackTrace? stackTrace}) {
    _logger.log(level, message, error, stackTrace);
  }
} 