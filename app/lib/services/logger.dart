import 'package:logging/logging.dart';
import 'dart:async';
import 'dart:convert';

/// Provides logging functionality for the BijbelQuiz app.
class AppLogger {
  /// The underlying logger instance.
  static final Logger _logger = Logger('BijbelQuiz');

  /// Stores the subscription to the log record stream.
  static StreamSubscription<LogRecord>? _subscription;

  /// Regex pattern to identify sensitive data patterns
  static final List<String> _sensitivePatterns = [
    r'api[_-]?key',
    r'authorization',
    r'password',
    r'secret',
    r'token',
    r'auth[_-]?bearer',
    r'x[_-]?api[_-]?key',
    r'access[_-]?token',
    r'refresh[_-]?token',
    r'client[_-]?secret',
    r'private[_-]?key',
    r'session',
    r'cookie',
    r'jwt',
  ];

  /// Initializes the logger with the given [level].
  ///
  /// Listens to log records and prints them to the console.
  static void init({Level level = Level.ALL}) {
    Logger.root.level = level;
    _subscription?.cancel();
    _subscription = Logger.root.onRecord.listen((record) {
      // Don't log if the record level is below the configured minimum level
      if (record.level.value < Logger.root.level.value) {
        return;
      }

      final buffer = StringBuffer();
      buffer.write('[${record.level.name}] ');
      buffer.write('${record.time.toIso8601String()} ');
      buffer.write('${record.loggerName}: ');

      // Sanitize the message before logging
      String sanitizedMessage = _sanitizeLogMessage(record.message);
      buffer.write(sanitizedMessage);

      if (record.error != null) {
        String sanitizedError = _sanitizeLogMessage(record.error.toString());
        buffer.write('\n  Error: $sanitizedError');
      }
      if (record.stackTrace != null) {
        // Only log stack traces for levels more verbose than INFO to avoid exposing internal data in production
        if (level.value > Level.INFO.value) {
          buffer.write('\n  StackTrace: ${record.stackTrace.toString()}');
        } else {
          buffer.write('\n  StackTrace: [STACK TRACE REMOVED FOR SECURITY]');
        }
      }
    });
    _logger.info('Logger initialized at level: ${level.name}');
  }

  /// Sanitizes log messages by removing sensitive information
  static String _sanitizeLogMessage(String message) {
    String sanitized = message;

    // Sanitize JSON strings that might contain sensitive data
    sanitized = _sanitizeJsonStrings(sanitized);

    // Remove sensitive data patterns using regex
    for (String pattern in _sensitivePatterns) {
      // Match the pattern with possible values after it (case insensitive)
      String fullPattern = '$pattern[\\s:=]*[\'"]?([^&\\s\'",}\\]]+)[\'"]?';
      RegExp regExp = RegExp(fullPattern, caseSensitive: false);
      sanitized = sanitized.replaceAllMapped(regExp, (match) {
        String matchedString = match.group(0) ?? '';
        // Extract the key part (before the value)
        List<String> parts = matchedString
            .split(RegExp('[=:\'"]')); // Fixed: Non-raw string for regex
        String key = parts.isNotEmpty ? parts[0].trim() : 'sensitive';
        return '$key: [REDACTED]';
      });
    }

    // Additional sanitization for common patterns
    // Remove email addresses
    sanitized = sanitized.replaceAll(
        RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w+\b'), '[EMAIL REDACTED]');

    // Remove IP addresses
    sanitized = sanitized.replaceAll(
        RegExp(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'), '[IP REDACTED]');

    // Remove potential phone numbers
    sanitized = sanitized.replaceAll(
        RegExp(r'\b(\+\d{1,3}[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}\b'),
        '[PHONE REDACTED]');

    // Sanitize URLs to remove query parameters that might contain sensitive data
    sanitized = _sanitizeUrls(sanitized);

    return sanitized;
  }

  /// Sanitizes JSON strings by redacting sensitive keys
  static String _sanitizeJsonStrings(String input) {
    // Try to identify and sanitize JSON-like strings
    try {
      // Find potential JSON strings in the input
      RegExp jsonRegexp = RegExp(r'\{[^{}]*\}');
      Iterable<Match> matches = jsonRegexp.allMatches(input);

      String result = input;
      for (Match match in matches) {
        String jsonString = match.group(0)!;
        try {
          // Attempt to parse as JSON
          var parsed = json.decode(jsonString);
          if (parsed is Map<String, dynamic>) {
            // Sanitize sensitive keys in the parsed object
            _sanitizeJsonMap(parsed);
            // Convert back to JSON string
            String sanitizedJson = json.encode(parsed);
            result = result.replaceRange(match.start, match.end, sanitizedJson);
          }
        } catch (e) {
          // If JSON parsing fails, treat as regular string and continue
          continue;
        }
      }
      return result;
    } catch (e) {
      // If anything goes wrong, return the original string
      return input;
    }
  }

  /// Sanitizes a JSON-like map object by redacting sensitive keys
  static void _sanitizeJsonMap(Map<String, dynamic> map) {
    map.forEach((key, value) {
      String lowerKey = key.toLowerCase();

      // Check if the key matches any sensitive pattern
      bool isSensitive = _sensitivePatterns.any((pattern) =>
          lowerKey.contains(RegExp(pattern, caseSensitive: false)));

      if (isSensitive) {
        // Redact sensitive values
        map[key] = '[REDACTED]';
      } else if (value is Map<String, dynamic>) {
        // Recursively sanitize nested maps
        _sanitizeJsonMap(value);
      } else if (value is List) {
        // Sanitize lists that might contain maps
        for (int i = 0; i < value.length; i++) {
          if (value[i] is Map<String, dynamic>) {
            _sanitizeJsonMap(value[i]);
          }
        }
      }
    });
  }

  /// Sanitizes URLs by removing query parameters that might contain sensitive data
  static String _sanitizeUrls(String input) {
    // Find URLs and redact sensitive query parameters
    RegExp urlRegexp = RegExp(
      r'https?://[^\s<>"{}|\\^`\[\]]*',
      caseSensitive: false,
    );

    return input.replaceAllMapped(urlRegexp, (match) {
      String url = match.group(0)!;
      try {
        Uri parsedUrl = Uri.parse(url);

        // Check if the URL has query parameters that need sanitizing
        if (parsedUrl.hasQuery) {
          Map<String, String> queryParams = Map.from(parsedUrl.queryParameters);
          bool modified = false;

          queryParams.forEach((key, value) {
            String lowerKey = key.toLowerCase();

            // Check if the query parameter key matches any sensitive pattern
            bool isSensitive = _sensitivePatterns.any((pattern) =>
                lowerKey.contains(RegExp(pattern, caseSensitive: false)));

            if (isSensitive) {
              queryParams[key] = '[REDACTED]';
              modified = true;
            }
          });

          if (modified) {
            Uri sanitizedUrl = Uri(
              scheme: parsedUrl.scheme,
              host: parsedUrl.host,
              path: parsedUrl.path,
              queryParameters: queryParams,
            );
            return sanitizedUrl.toString();
          }
        }
      } catch (e) {
        // If URL parsing fails, return the original URL
      }
      return url;
    });
  }

  /// Sanitizes a map by redacting sensitive keys (for use with tracking/error reporting)
  static Map<String, dynamic> sanitizeMap(Map<String, dynamic> input) {
    Map<String, dynamic> sanitized = Map.from(input);
    _sanitizeJsonMap(sanitized);
    return sanitized;
  }

  /// Public method to sanitize log messages - allows other classes to sanitize data before logging
  static String sanitizeLogMessage(String message) {
    return _sanitizeLogMessage(message);
  }

  /// Changes the log level at runtime.
  static void setLevel(Level level) {
    Logger.root.level = level;
    _logger.info('Log level changed to: ${level.name}');
  }

  /// Sets a secure log level appropriate for the current environment.
  /// In production, this limits logging to reduce exposure of sensitive data.
  static void setSecureLevel(
      {bool isProduction = false,
      Level? productionLevel,
      Level? developmentLevel}) {
    Level levelToUse = isProduction
        ? (productionLevel ??
            Level
                .INFO) // Default to INFO in production to reduce sensitive data exposure
        : (developmentLevel ??
            Level.ALL); // Default to ALL in development for debugging

    Logger.root.level = levelToUse;
    _logger.info(
        'Secure log level set to: ${levelToUse.name} (Production: $isProduction)');
  }

  /// Detaches the log listener.
  static void close() {
    _subscription?.cancel();
    _subscription = null;
    _logger.info('Logger listener closed.');
  }

  /// Logs an info message.
  static void info(String message) =>
      _logger.info(_sanitizeLogMessage(message));

  /// Logs a warning message, optionally with an [error] and [stackTrace].
  static void warning(String message,
          [Object? error, StackTrace? stackTrace]) =>
      _logger.warning(_sanitizeLogMessage(message), error, stackTrace);

  /// Logs an error message, optionally with an [error] and [stackTrace].
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(_sanitizeLogMessage(message), error, stackTrace);
  }

  /// Logs a debug message.
  static void debug(String message) =>
      _logger.fine(_sanitizeLogMessage(message));

  /// Logs a fine-grained (verbose) message.
  static void fine(String message) =>
      _logger.fine(_sanitizeLogMessage(message));

  /// Logs a severe error message.
  static void severe(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.severe(_sanitizeLogMessage(message), error, stackTrace);

  /// Logs a message at a custom [level].
  static void log(Level level, String message,
      {Object? error, StackTrace? stackTrace}) {
    _logger.log(level, _sanitizeLogMessage(message), error, stackTrace);
  }
}
