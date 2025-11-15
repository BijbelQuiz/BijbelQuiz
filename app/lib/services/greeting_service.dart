import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'logger.dart';

class GreetingService {
  static final GreetingService _instance = GreetingService._internal();
  factory GreetingService() => _instance;
  GreetingService._internal();

  Map<String, dynamic>? _greetingsData;
  bool _isLoaded = false;

  /// Load greetings from the JSON file
  Future<void> _loadGreetings() async {
    if (_isLoaded) return;

    try {
      final String jsonString =
          await rootBundle.loadString('assets/greetings.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _greetingsData = jsonData['greetings'] as Map<String, dynamic>;
      _isLoaded = true;
    } catch (e) {
      // Fallback to default greeting if loading fails
      _greetingsData = null;
      _isLoaded = true;
      // Print error for debugging
      AppLogger.warning('Failed to load greetings: $e');
    }
  }

  /// Get a random greeting based on the time of day
  Future<String> getTimeBasedGreeting() async {
    await _loadGreetings();

    final String timeGreeting = _getTimeOfDayGreeting();
    final List<dynamic>? greetings =
        _greetingsData?[timeGreeting] as List<dynamic>?;

    if (greetings != null && greetings.isNotEmpty) {
      final List<String> stringGreetings = greetings.cast<String>();
      return stringGreetings[_getRandomIndex(stringGreetings.length)];
    }

    // Fallback to general greeting if time-based ones fail
    return getGeneralGreeting();
  }

  /// Get a random general greeting
  Future<String> getGeneralGreeting() async {
    await _loadGreetings();

    final List<dynamic>? greetings =
        _greetingsData?['general'] as List<dynamic>?;

    if (greetings != null && greetings.isNotEmpty) {
      final List<String> stringGreetings = greetings.cast<String>();
      return stringGreetings[_getRandomIndex(stringGreetings.length)];
    }

    // Ultimate fallback
    return 'Jouw voortgang';
  }

  /// Determine time of day greeting key
  String _getTimeOfDayGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'morning';
    } else if (hour >= 12 && hour < 17) {
      return 'afternoon';
    } else if (hour >= 17 && hour < 22) {
      return 'evening';
    } else {
      return 'night';
    }
  }

  /// Get random index
  int _getRandomIndex(int length) {
    // Use the Dart math library to get a proper random index
    final random = Random();
    return random.nextInt(length);
  }

  /// Clear cached data (useful for testing)
  void clearCache() {
    _greetingsData = null;
    _isLoaded = false;
  }
}
