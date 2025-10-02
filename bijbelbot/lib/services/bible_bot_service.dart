import '../services/logger.dart';
import 'gemini_service.dart';

// Re-export types for convenience
export 'gemini_service.dart' show BibleReference, BibleQAResponse;

/// Service for handling Bible bot interactions
class BibleBotService {
  static BibleBotService? _instance;
  bool _isInitialized = false;

  static BibleBotService get instance {
    _instance ??= BibleBotService._();
    return _instance!;
  }

  BibleBotService._();

  bool get isInitialized => _isInitialized;

  /// Initialize the Bible bot service
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing BibleBot service...');

      // Initialize Gemini service
      await GeminiService.instance.initialize();

      _isInitialized = true;
      AppLogger.info('BibleBot service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize BibleBot service', e);
      throw Exception('Failed to initialize BibleBot service: $e');
    }
  }

  /// Ask a question to the Bible bot
  Future<BibleQAResponse> askQuestion({
    required String question,
    required String questionType,
    String? conversationId,
  }) async {
    try {
      AppLogger.info('Asking Bible question: $question');

      // Use Gemini service to get Bible answer
      final response = await GeminiService.instance.askBibleQuestion(question);

      return response;
    } catch (e) {
      AppLogger.error('Failed to get answer from Bible bot', e);
      throw Exception('Failed to get answer: $e');
    }
  }
}
