import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as path;
import 'logger.dart';
import '../utils/color_parser.dart';

/// Configuration for Gemini API service
class GeminiConfig {
  static const String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const Duration requestTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
}

/// Model class for color palette responses
class ColorPalette {
  final String primary;
  final String secondary;
  final String tertiary;
  final String background;
  final String surface;
  final String onPrimary;
  final String onSecondary;
  final String onBackground;
  final String onSurface;

  const ColorPalette({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.background,
    required this.surface,
    required this.onPrimary,
    required this.onSecondary,
    required this.onBackground,
    required this.onSurface,
  });

  factory ColorPalette.fromJson(Map<String, dynamic> json) {
    return ColorPalette(
      primary: json['primary'] as String? ?? '#2563EB',
      secondary: json['secondary'] as String? ?? '#7C3AED',
      tertiary: json['tertiary'] as String? ?? '#DC2626',
      background: json['background'] as String? ?? '#FFFFFF',
      surface: json['surface'] as String? ?? '#F8FAFC',
      onPrimary: json['onPrimary'] as String? ?? '#FFFFFF',
      onSecondary: json['onSecondary'] as String? ?? '#FFFFFF',
      onBackground: json['onBackground'] as String? ?? '#1F2937',
      onSurface: json['onSurface'] as String? ?? '#1F2937',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primary': primary,
      'secondary': secondary,
      'tertiary': tertiary,
      'background': background,
      'surface': surface,
      'onPrimary': onPrimary,
      'onSecondary': onSecondary,
      'onBackground': onBackground,
      'onSurface': onSurface,
    };
  }

  /// Creates a ColorPalette from parsed colors with validation
  factory ColorPalette.fromParsedColors(Map<String, Color> colors) {
    // Generate on-colors if not provided
    final onColors = ColorParser.generateOnColors(colors);

    return ColorPalette(
      primary:
          ColorParser.normalizeColorToHex(colors['primary'] ?? Colors.blue),
      secondary:
          ColorParser.normalizeColorToHex(colors['secondary'] ?? Colors.purple),
      tertiary:
          ColorParser.normalizeColorToHex(colors['tertiary'] ?? Colors.red),
      background:
          ColorParser.normalizeColorToHex(colors['background'] ?? Colors.white),
      surface: ColorParser.normalizeColorToHex(
          colors['surface'] ?? Colors.grey.shade50),
      onPrimary: ColorParser.normalizeColorToHex(
          onColors['onPrimary'] ?? Colors.white),
      onSecondary: ColorParser.normalizeColorToHex(
          onColors['onSecondary'] ?? Colors.white),
      onBackground: ColorParser.normalizeColorToHex(
          onColors['onBackground'] ?? Colors.black),
      onSurface: ColorParser.normalizeColorToHex(
          onColors['onSurface'] ?? Colors.black),
    );
  }
}

/// Model class for Gemini API error responses
class GeminiError implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const GeminiError({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  @override
  String toString() =>
      'GeminiError: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// A service that provides an interface to the Gemini API for generating custom color themes.
///
/// This service is a singleton and follows the established patterns used by other services
/// in the BijbelQuiz app, including proper error handling, logging, and async operations.
class GeminiService {
  static GeminiService? _instance;
  late final String _apiKey;
  late final http.Client _httpClient;
  bool _initialized = false;

  // Rate limiting
  DateTime? _lastRequestTime;
  static const Duration _minRequestInterval = Duration(seconds: 1);

  /// Private constructor for singleton pattern
  GeminiService._internal() {
    _httpClient = http.Client();
  }

  /// Gets the singleton instance of the service
  static GeminiService get instance {
    _instance ??= GeminiService._internal();
    return _instance!;
  }

  /// Ensures the service is initialized before use
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }

  /// Checks if the service is properly initialized and ready to use
  bool get isInitialized => _initialized;

  /// Gets the current initialization status of the service
  /// Returns true if the service is ready to use, false otherwise
  bool get isReady => _initialized && _apiKey.isNotEmpty;

  /// Gets the API key for external access
  String get apiKey => _apiKey;

  /// Gets the HTTP client for external access
  http.Client get httpClient => _httpClient;

  /// Initializes the Gemini service by loading the API key from environment variables
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing Gemini API service...');

      String? apiKey;

      try {
        // Try to get API key from environment variables loaded by main app
        apiKey = dotenv.env['GEMINI_API_KEY'];
        
        if (apiKey != null && apiKey.isNotEmpty) {
          AppLogger.info('API key loaded from environment variables');
        } else {
          AppLogger.warning('GEMINI_API_KEY not found in environment variables');
          
          // Fallback to compile-time environment variables (for web builds)
          try {
            apiKey = const String.fromEnvironment('GEMINI_API_KEY');
            if (apiKey.isNotEmpty) {
              AppLogger.info('API key loaded from compile-time environment');
            }
          } catch (e) {
            AppLogger.warning('Could not load API key from compile-time environment: $e');
          }

          // If still no API key, try Platform.environment (for desktop platforms)
          if (apiKey == null || apiKey.isEmpty) {
            try {
              const platform = MethodChannel('app.bijbelquiz.play/env');
              apiKey = await platform.invokeMethod('getEnv', {'key': 'GEMINI_API_KEY'});
              AppLogger.info('API key loaded from system environment');
            } catch (e) {
              AppLogger.warning('Could not load API key from system environment: $e');
            }
          }
        }
      } catch (e) {
        AppLogger.warning('Unexpected error loading API key: $e');
      }

      if (apiKey == null || apiKey.isEmpty) {
        throw const GeminiError(
          message:
              'GEMINI_API_KEY not found in environment variables. Please ensure your .env file contains GEMINI_API_KEY=your_api_key_here or set it as a system environment variable.',
        );
      }

      // Validate API key format (basic check)
      if (apiKey.length < 20) {
        AppLogger.warning(
            'GEMINI_API_KEY appears to be too short - please verify it is correct');
      }

      _apiKey = apiKey;
      _initialized = true;
      AppLogger.info('Gemini API service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize Gemini API service', e);
      _initialized = false;
      rethrow;
    }
  }

  /// Generates a color palette based on the provided text description
  ///
  /// [description] - A text description of the desired theme (e.g., "ocean sunset", "forest morning")
  /// Returns a [ColorPalette] with hex color codes for different UI elements
  Future<ColorPalette> generateColorsFromText(String description) async {
    if (description.trim().isEmpty) {
      throw const GeminiError(message: 'Description cannot be empty');
    }

    // Ensure service is initialized before making API calls
    try {
      await _ensureInitialized();
    } catch (e) {
      AppLogger.error('Gemini service initialization failed', e);
      if (e is GeminiError) {
        throw GeminiError(
          message:
              'Failed to initialize Gemini API service: ${e.message}. Please check your API key configuration.',
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        );
      } else {
        throw const GeminiError(
          message:
              'Failed to initialize Gemini API service. Please check your API key configuration.',
        );
      }
    }

    // Double-check that we're properly initialized
    if (!_initialized || _apiKey.isEmpty) {
      throw const GeminiError(
        message:
            'Gemini API service is not properly configured. Please check your GEMINI_API_KEY in the .env file.',
      );
    }

    await _ensureRateLimit();

    AppLogger.info('Generating color palette for description: $description');

    try {
      final response = await _makeApiRequest(description);

      if (response.statusCode == 200) {
        final colorPalette = await _parseResponse(response.body);
        AppLogger.info('Successfully generated color palette');
        return colorPalette;
      } else {
        throw await _handleErrorResponse(response);
      }
    } catch (e) {
      AppLogger.error('Failed to generate color palette', e);
      rethrow;
    }
  }

  /// Ensures requests respect rate limiting
  Future<void> _ensureRateLimit() async {
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest < _minRequestInterval) {
        final delay = _minRequestInterval - timeSinceLastRequest;
        AppLogger.info('Rate limiting: waiting ${delay.inMilliseconds}ms');
        await Future.delayed(delay);
      }
    }
    _lastRequestTime = DateTime.now();
  }

  /// Makes the HTTP request to the Gemini API
  Future<http.Response> _makeApiRequest(String description) async {
    final url = Uri.parse(
        '${GeminiConfig.baseUrl}/models/gemini-flash-latest:generateContent?key=$_apiKey');

    final prompt = _buildPrompt(description);
    final requestBody = json.encode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'topK': 40,
        'topP': 0.95,
        'maxOutputTokens': 2048,
      }
    });

    AppLogger.info('Making request to Gemini API');

    for (int attempt = 1; attempt <= GeminiConfig.maxRetries; attempt++) {
      try {
        final response = await _httpClient
            .post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: requestBody,
            )
            .timeout(GeminiConfig.requestTimeout);

        if (response.statusCode == 200) {
          return response;
        } else if (response.statusCode == 429 &&
            attempt < GeminiConfig.maxRetries) {
          // Rate limited, wait and retry
          final delay = GeminiConfig.retryDelay * attempt;
          AppLogger.warning(
              'Rate limited, retrying in ${delay.inSeconds}s (attempt $attempt)');
          await Future.delayed(delay);
          continue;
        } else {
          return response;
        }
      } catch (e) {
        if (attempt == GeminiConfig.maxRetries) {
          throw GeminiError(
            message: 'Network request failed after $attempt attempts: $e',
          );
        }
        AppLogger.warning('Request attempt $attempt failed: $e');
        await Future.delayed(GeminiConfig.retryDelay * attempt);
      }
    }

    throw const GeminiError(message: 'All retry attempts exhausted');
  }

  /// Builds a structured prompt for the Gemini API
  String _buildPrompt(String description) {
    return '''
You are a professional UI/UX designer specializing in color theory and theme creation. Given the following description, create a cohesive color palette for a mobile app interface.

Description: "$description"

Please respond with a JSON object containing hex color codes for the following UI elements:
- primary: Main brand color for buttons, links, and key elements
- secondary: Supporting color for secondary buttons and elements
- tertiary: Alternative color for less prominent elements
- background: Main background color
- surface: Color for cards, dialogs, and elevated surfaces
- onPrimary: Text/icon color on primary background (for contrast)
- onSecondary: Text/icon color on secondary background (for contrast)
- onBackground: Text/icon color on background (for contrast)
- onSurface: Text/icon color on surface (for contrast)

Requirements:
- All colors should work well together harmoniously
- Ensure proper contrast ratios for accessibility (WCAG AA guidelines)
- Colors should be appropriate for a mobile app interface
- Return valid hex color codes (e.g., "#FF5733")
- Ensure the JSON is valid and contains all required fields
- Consider both light and dark theme compatibility

Example response format:
{
  "primary": "#2563EB",
  "secondary": "#7C3AED",
  "tertiary": "#DC2626",
  "background": "#FFFFFF",
  "surface": "#F8FAFC",
  "onPrimary": "#FFFFFF",
  "onSecondary": "#FFFFFF",
  "onBackground": "#1F2937",
  "onSurface": "#1F2937"
}
''';
  }

  /// Parses the API response to extract color information
  Future<ColorPalette> _parseResponse(String responseBody) async {
    try {
      final Map<String, dynamic> response = json.decode(responseBody);

      // Extract the generated text from Gemini's response
      final candidates = response['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        throw const GeminiError(message: 'No response candidates received');
      }

      final content = candidates[0]['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) {
        throw const GeminiError(message: 'No content parts in response');
      }

      final generatedText = parts[0]['text'] as String?;
      if (generatedText == null || generatedText.trim().isEmpty) {
        throw const GeminiError(message: 'Empty response text');
      }

      // Use ColorParser to extract and validate colors from the response
      final extractedColors =
          ColorParser.extractColorsFromGeminiResponse(generatedText);

      // Validate accessibility compliance
      final validation = ColorParser.validateColorPalette(extractedColors);

      // Log any accessibility issues
      if (!validation.values.every((isValid) => isValid)) {
        AppLogger.warning('Color palette may not meet accessibility standards');
        validation.forEach((component, isValid) {
          if (!isValid) {
            AppLogger.warning('Accessibility issue: $component');
          }
        });
      }

      // Create ColorPalette from parsed colors with proper validation
      return ColorPalette.fromParsedColors(extractedColors);
    } catch (e) {
      if (e is GeminiError) rethrow;

      AppLogger.error(
          'Failed to parse API response, using fallback colors: $e');

      // Return a palette with fallback colors if parsing fails
      final fallbackColors = ColorParser.getFallbackColorPalette();
      return ColorPalette.fromParsedColors(fallbackColors);
    }
  }

  /// Handles error responses from the API
  Future<GeminiError> _handleErrorResponse(http.Response response) async {
    try {
      final Map<String, dynamic> errorBody = json.decode(response.body);
      final error = errorBody['error'] as Map<String, dynamic>?;

      return GeminiError(
        message: error?['message'] as String? ?? 'Unknown API error',
        statusCode: response.statusCode,
        errorCode: error?['code'] as String?,
      );
    } catch (e) {
      return GeminiError(
        message: 'HTTP ${response.statusCode}: ${response.body}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Disposes of resources used by the service
  void dispose() {
    _httpClient.close();
    _instance = null;
    AppLogger.info('Gemini service disposed');
  }
}
