import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'logger.dart';

/// Configuration for Gemini API service
class GeminiConfig {
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const Duration requestTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
}

/// Model class for Bible Q&A responses
class BibleQAResponse {
  final String answer;
  final List<BibleReference> references;

  const BibleQAResponse({
    required this.answer,
    required this.references,
  });
}

/// Model class for Bible reference extraction
class BibleReference {
  final String book;
  final int chapter;
  final int verse;
  final int? endVerse;

  const BibleReference({
    required this.book,
    required this.chapter,
    required this.verse,
    this.endVerse,
  });

  @override
  String toString() {
    return '$book $chapter:$verse${endVerse != null ? '-$endVerse' : ''}';
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
  String toString() => 'GeminiError: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// A service that provides an interface to the Gemini API for Bible Q&A.
/// This is a standalone version specifically for the BijbelBot app.
class GeminiService {
  static GeminiService? _instance;
  late final String _apiKey;
  late final GenerativeModel _model;
  bool _initialized = false;

  // Rate limiting
  DateTime? _lastRequestTime;
  static const Duration _minRequestInterval = Duration(seconds: 1);

  /// Private constructor for singleton pattern
  GeminiService._internal();

  /// Gets the singleton instance of the service
  static GeminiService get instance {
    _instance ??= GeminiService._internal();
    return _instance!;
  }

  /// Checks if the service is properly initialized and ready to use
  bool get isInitialized => _initialized;

  /// Gets the current initialization status of the service
  bool get isReady => _initialized && _apiKey.isNotEmpty;

  /// Gets the API key for external access
  String get apiKey => _apiKey;

  /// Initializes the Gemini service by loading the API key from environment variables
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing Gemini API service for BijbelBot...');

      // Try to get API key from already loaded dotenv
      String? apiKey = dotenv.env['GEMINI_API_KEY'];

      // If .env didn't work, try system environment variables
      if (apiKey == null || apiKey.isEmpty) {
        apiKey = const String.fromEnvironment('GEMINI_API_KEY');
      }

      // If still no API key, try to load .env file directly
      if (apiKey == null || apiKey.isEmpty) {
        try {
          await dotenv.load(fileName: '.env');
          apiKey = dotenv.env['GEMINI_API_KEY'];
        } catch (e) {
          AppLogger.warning('Could not load .env file in Gemini service: $e');
        }
      }

      if (apiKey == null || apiKey.isEmpty) {
        throw const GeminiError(
          message: 'GEMINI_API_KEY not found. Please add GEMINI_API_KEY=your_api_key_here to the .env file in the bijbelbot directory.',
        );
      }

      // Validate API key format (basic check)
      if (apiKey.length < 20) {
        AppLogger.warning('GEMINI_API_KEY appears to be too short - please verify it is correct');
      }

      _apiKey = apiKey;

      // Initialize the Gemini model
      _model = GenerativeModel(
        model: 'gemini-2.0-flash-exp',
        apiKey: _apiKey,
      );

      _initialized = true;
      AppLogger.info('Gemini API service initialized successfully for BijbelBot');
    } catch (e) {
      AppLogger.error('Failed to initialize Gemini API service', e);
      _initialized = false;
      rethrow;
    }
  }

  /// Ensures the service is initialized before use
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }

  /// Answers a Bible-related question using Gemini AI
  Future<BibleQAResponse> askBibleQuestion(String question) async {
    if (question.trim().isEmpty) {
      throw const GeminiError(message: 'Question cannot be empty');
    }

    // Ensure service is initialized
    await _ensureInitialized();

    if (!_initialized || _apiKey.isEmpty) {
      throw const GeminiError(
        message: 'Gemini API service is not properly configured. Please check your GEMINI_API_KEY in the .env file.',
      );
    }

    await _ensureRateLimit();

    AppLogger.info('Asking Bible question: $question');

    try {
      final prompt = _buildBiblePrompt(question);
      final response = await _model.generateContent([Content.text(prompt)]);

      if (response.text == null || response.text!.isEmpty) {
        throw const GeminiError(message: 'Empty response from Gemini API');
      }

      final bibleResponse = _parseBibleResponse(response.text!);
      AppLogger.info('Successfully received Bible answer');
      return bibleResponse;
    } catch (e) {
      AppLogger.error('Failed to get Bible answer', e);
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

  /// Builds a structured prompt for Bible Q&A
  String _buildBiblePrompt(String question) {
    return '''
You are a knowledgeable Bible scholar and teacher. Please answer the following question about the Bible in Dutch.

Question: "$question"

Guidelines for your response:
1. Provide accurate, biblically-based answers
2. Be respectful and educational in tone
3. Include relevant Bible references when applicable
4. Keep explanations clear and accessible
5. If the question is about specific Bible passages, quote them when relevant
6. Respond in Dutch language
7. If you're unsure about something, admit it rather than speculate

Please structure your response as:
1. A clear, direct answer to the question
2. Any relevant Bible references in the format "Book Chapter:Verse"
3. Additional explanation or context if helpful

Example format:
Answer: [Your answer here]

References: Genesis 1:1, John 3:16

Explanation: [Additional context if needed]
''';
  }

  /// Parses the Gemini response to extract Bible answer and references
  BibleQAResponse _parseBibleResponse(String response) {
    try {
      // Extract answer (everything before references)
      String answer;
      List<BibleReference> references = [];

      // Look for references section
      final lines = response.split('\n');
      List<String> answerLines = [];
      List<String> referenceLines = [];
      bool inReferencesSection = false;

      for (final line in lines) {
        final trimmedLine = line.trim();
        if (trimmedLine.toLowerCase().contains('references:') ||
            trimmedLine.toLowerCase().contains('referenties:')) {
          inReferencesSection = true;
          continue;
        }

        if (inReferencesSection) {
          referenceLines.add(trimmedLine);
        } else {
          answerLines.add(trimmedLine);
        }
      }

      answer = answerLines.where((line) => line.isNotEmpty).join('\n').trim();

      // Parse references
      for (final line in referenceLines) {
        final refs = _extractBibleReferences(line);
        references.addAll(refs);
      }

      // If no references found in dedicated section, try to extract from entire response
      if (references.isEmpty) {
        references = _extractBibleReferences(response);
      }

      return BibleQAResponse(
        answer: answer.isNotEmpty ? answer : response,
        references: references,
      );
    } catch (e) {
      AppLogger.warning('Failed to parse Bible response, using raw response: $e');
      return BibleQAResponse(
        answer: response,
        references: [],
      );
    }
  }

  /// Extracts Bible references from text using regex patterns
  List<BibleReference> _extractBibleReferences(String text) {
    List<BibleReference> references = [];

    // Common Bible reference patterns
    final patterns = [
      // Genesis 1:1, Genesis 1:1-3
      RegExp(r'(\w+)\s+(\d+):(\d+)(?:-(\d+))?'),
      // Gen 1:1, Gen 1:1-3
      RegExp(r'(\w{3})\s+(\d+):(\d+)(?:-(\d+))?'),
    ];

    for (final pattern in patterns) {
      final matches = pattern.allMatches(text);

      for (final match in matches) {
        if (match.groupCount >= 3) {
          final book = match.group(1) ?? '';
          final chapter = int.tryParse(match.group(2) ?? '0') ?? 0;
          final verse = int.tryParse(match.group(3) ?? '0') ?? 0;
          final endVerse = match.group(4) != null ? int.tryParse(match.group(4)!) : null;

          if (book.isNotEmpty && chapter > 0 && verse > 0) {
            references.add(BibleReference(
              book: book,
              chapter: chapter,
              verse: verse,
              endVerse: endVerse,
            ));
          }
        }
      }
    }

    return references;
  }

  /// Disposes of resources used by the service
  void dispose() {
    _instance = null;
    AppLogger.info('Gemini service disposed');
  }
}