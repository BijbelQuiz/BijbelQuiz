import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_question.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'logger.dart';
import '../config/supabase_config.dart';
import 'connection_service.dart';

/// Simplified LRU cache for questions with proper memory management
class QuestionCacheEntry {
  final QuizQuestion question;
  late DateTime accessTime;

  QuestionCacheEntry(this.question) : accessTime = DateTime.now();

  void touch() {
    accessTime = DateTime.now();
  }
}

/// Configuration for simplified question cache
class QuestionCacheConfig {
  static const int defaultBatchSize = 10;
  static const int maxMemoryCacheSize = 25; // Reduced for low-end devices
  static const Duration cacheExpiry = Duration(days: 7);
  static const int maxPersistentCacheSize = 25; // Reduced for low-end devices
}

/// A simplified service for caching and lazy loading quiz questions with optimized memory usage
/// for low-end devices. Uses single LRU structure instead of multiple tracking structures.
class QuestionCacheService {
  static const String _cacheKey = 'cached_questions';
  static const String _cacheTimestampKey = 'cache_timestamp';
  static const String _metadataCacheKey = 'cached_metadata';
  static const String _appVersionKey = 'app_version';

  // SIMPLIFIED: Single LRU cache structure instead of multiple tracking structures
  final Map<String, QuestionCacheEntry> _memoryCache = {};

  // SIMPLIFIED: Single list for LRU order (keys only)
  final List<String> _lruList = [];

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // Connection service for checking online status
  final ConnectionService _connectionService;

  QuestionCacheService(this._connectionService);

  // Track loading state per language
  final Map<String, Completer<void>> _loadingCompleters = {};

  // Track question metadata (simplified - no extra tracking)
  final Map<String, List<Map<String, dynamic>>> _questionMetadata = {};

  /// Initialize the cache service
  Future<void> initialize() async {
    if (_isInitialized) return;

    final initStartTime = DateTime.now();
    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      // Defer version check to not block initialization
      _clearCacheOnAppUpdate().then((_) {
        AppLogger.info('Cache cleared on app update if needed');
      }).catchError((e) {
        AppLogger.error('Error in deferred cache clear', e);
      });
      final initDuration = DateTime.now().difference(initStartTime);
      AppLogger.info(
          'QuestionCacheService initialized in ${initDuration.inMilliseconds}ms');

      // Log memory usage after initialization
      final memoryUsage = getMemoryUsage();
      AppLogger.info(
          'QuestionCacheService memory usage after init: $memoryUsage');
    } catch (e) {
      AppLogger.error('Failed to initialize QuestionCacheService', e);
      // Continue without persistent cache if SharedPreferences fails
    }
  }

  /// Clear cache if app version has changed
  Future<void> _clearCacheOnAppUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final savedVersion = _prefs.getString(_appVersionKey);
      if (savedVersion == null || savedVersion != currentVersion) {
        await clearCache();
        await _prefs.setString(_appVersionKey, currentVersion);
        AppLogger.info('Cache cleared on app update: $currentVersion');
      }
    } catch (e) {
      AppLogger.error('Error checking app version for cache clear', e);
      // Ignore version check errors
    }
  }

  /// Get questions for a specific language with lazy loading
  Future<List<QuizQuestion>> getQuestions(
    String language, {
    int startIndex = 0,
    int? count,
  }) async {
    await initialize();

    // Ensure we have metadata loaded first
    await _ensureMetadataLoaded(language);

    // Determine the end index
    final int endIndex;
    if (count != null) {
      endIndex = startIndex + count;
    } else {
      endIndex = _questionMetadata[language]?.length ?? 0;
    }

    // Check which questions need to be loaded
    final questionsToLoad = <int>[];
    final loadedQuestions = <QuizQuestion>[];

    for (int i = startIndex; i < endIndex; i++) {
      if (i >= (_questionMetadata[language]?.length ?? 0)) break;

      final question = _getQuestionFromMemory(language, i);
      if (question != null) {
        loadedQuestions.add(question);
      } else {
        questionsToLoad.add(i);
      }
    }

    // Load any missing questions
    if (questionsToLoad.isNotEmpty) {
      final loaded = await _loadQuestionsByIndices(language, questionsToLoad);
      loadedQuestions.addAll(loaded);
    }

    return loadedQuestions;
  }

  /// Get a batch of questions for a specific language
  Future<List<QuizQuestion>> getQuestionBatch(
    String language,
    int batchSize,
    int offset,
  ) async {
    return getQuestions(
      language,
      startIndex: offset,
      count: batchSize,
    );
  }

  /// Load question metadata from assets if not already loaded
  Future<void> _ensureMetadataLoaded(String language) async {
    if (_questionMetadata.containsKey(language)) return;

    // If another request is already loading this language, wait for it
    if (_loadingCompleters.containsKey(language)) {
      await _loadingCompleters[language]!.future;
      return;
    }

    final completer = Completer<void>();
    _loadingCompleters[language] = completer;

    try {
      // Try to load from cache first
      final cachedMetadata = await _getCachedMetadata(language);
      if (cachedMetadata != null && cachedMetadata.isNotEmpty) {
        _questionMetadata[language] = cachedMetadata;
        completer.complete();
        return;
      }

      // Try to load from database first, fallback to JSON if offline or failed
      List<Map<String, dynamic>> metadata;
      try {
        final isOnline = _connectionService.isConnected;
        if (isOnline) {
          metadata = await _loadMetadataFromDatabase(language);
          AppLogger.info(
              'Loaded ${metadata.length} metadata entries from database for language: $language');
        } else {
          metadata = await _loadMetadataFromJson(language);
          AppLogger.info(
              'Loaded ${metadata.length} metadata entries from JSON (offline) for language: $language');
        }
      } catch (e) {
        AppLogger.warning(
            'Failed to load metadata from database, falling back to JSON: $e');
        metadata = await _loadMetadataFromJson(language);
        AppLogger.info(
            'Loaded ${metadata.length} metadata entries from JSON (fallback) for language: $language');
      }

      if (metadata.isEmpty) {
        throw Exception('No valid questions found');
      }

      // Sort questions by difficulty for better performance
      metadata.sort((a, b) {
        final int da = int.tryParse(a['difficulty']?.toString() ?? '') ?? 3;
        final int db = int.tryParse(b['difficulty']?.toString() ?? '') ?? 3;
        return da.compareTo(db);
      });

      _questionMetadata[language] = metadata;

      // Cache the metadata for faster startup next time
      await _cacheMetadata(language, metadata);

      completer.complete();
    } catch (e) {
      completer.completeError('Failed to load questions: $e');
      rethrow;
    } finally {
      _loadingCompleters.remove(language);
    }
  }

  /// Load specific questions by their indices
  Future<List<QuizQuestion>> _loadQuestionsByIndices(
    String language,
    List<int> indices,
  ) async {
    if (indices.isEmpty) return [];

    try {
      // Try to load from cache if available and valid
      if (await _isCacheValid(language)) {
        final cachedQuestions =
            await _loadQuestionsFromCache(language, indices);
        if (cachedQuestions != null) {
          return cachedQuestions;
        }
      }

      // Try to load from database first, fallback to JSON if offline or failed
      List<QuizQuestion> loadedQuestions = [];
      try {
        final isOnline = _connectionService.isConnected;
        if (isOnline) {
          loadedQuestions =
              await _loadQuestionsFromDatabaseByIndices(language, indices);
          AppLogger.info(
              'Loaded ${loadedQuestions.length} questions from database for indices: $indices');
        } else {
          loadedQuestions =
              await _loadQuestionsFromJsonByIndices(language, indices);
          AppLogger.info(
              'Loaded ${loadedQuestions.length} questions from JSON (offline) for indices: $indices');
        }
      } catch (e) {
        AppLogger.warning(
            'Failed to load from database, falling back to JSON: $e');
        loadedQuestions =
            await _loadQuestionsFromJsonByIndices(language, indices);
        AppLogger.info(
            'Loaded ${loadedQuestions.length} questions from JSON (fallback) for indices: $indices');
      }

      // Add loaded questions to memory cache with LRU tracking
      for (int i = 0; i < loadedQuestions.length; i++) {
        final question = loadedQuestions[i];
        final index = indices[i];
        _addToMemoryCache(language, index, question);
      }

      return loadedQuestions;
    } catch (e) {
      AppLogger.error('Failed to load questions by indices', e);
      rethrow;
    }
  }

  /// Load questions from offline cache
  Future<List<QuizQuestion>?> _loadQuestionsFromCache(
      String language, List<int> indices) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '${_cacheKey}_$language';

      final cachedData = prefs.getString(cacheKey);
      if (cachedData == null) return null;

      final List<dynamic> data = json.decode(cachedData);
      if (data.isEmpty) return null;

      final loadedQuestions = <QuizQuestion>[];

      for (final index in indices) {
        if (index < 0 || index >= data.length) continue;

        try {
          final questionData = data[index] as Map<String, dynamic>;
          final question = QuizQuestion.fromJson(questionData);
          _addToMemoryCache(language, index, question);
          loadedQuestions.add(question);
        } catch (e) {
          AppLogger.error('Error parsing cached question at index $index', e);
        }
      }

      AppLogger.info('Loaded ${loadedQuestions.length} questions from cache');
      return loadedQuestions;
    } catch (e) {
      AppLogger.error('Failed to load questions from cache', e);
      return null;
    }
  }

  /// Check if cached questions are still valid
  Future<bool> _isCacheValid(String language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestampKey = '${_cacheTimestampKey}_$language';

      final timestamp = prefs.getInt(timestampKey);
      if (timestamp == null) return false;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final isExpired = DateTime.now().difference(cacheTime) >
          QuestionCacheConfig.cacheExpiry;

      return !isExpired;
    } catch (e) {
      AppLogger.error('Error checking cache validity', e);
      return false;
    }
  }

  /// SIMPLIFIED: Add question to memory cache with LRU eviction
  void _addToMemoryCache(String language, int index, QuizQuestion question) {
    final cacheKey = _getQuestionCacheKey(language, index);

    // Check if we need to evict oldest entries
    if (_memoryCache.length >= QuestionCacheConfig.maxMemoryCacheSize &&
        !_memoryCache.containsKey(cacheKey)) {
      _evictOldestEntry();
    }

    // Add or update entry
    if (_memoryCache.containsKey(cacheKey)) {
      // Update existing entry - just touch it
      _memoryCache[cacheKey]!.touch();
      // Move to end of LRU list
      _lruList.remove(cacheKey);
      _lruList.add(cacheKey);
    } else {
      // Add new entry
      _memoryCache[cacheKey] = QuestionCacheEntry(question);
      _lruList.add(cacheKey);
    }
  }

  /// SIMPLIFIED: Evict the oldest accessed entry (first in LRU list)
  void _evictOldestEntry() {
    if (_lruList.isEmpty) return;

    final oldestKey = _lruList.removeAt(0);
    _memoryCache.remove(oldestKey);

    AppLogger.debug('Evicted cache entry: $oldestKey');
  }

  /// Get a question from memory cache
  QuizQuestion? _getQuestionFromMemory(String language, int index) {
    final cacheKey = _getQuestionCacheKey(language, index);
    final entry = _memoryCache[cacheKey];
    if (entry != null) {
      // Touch the entry to mark as recently used
      entry.touch();
      // Move to end of LRU list (most recently used)
      _lruList.remove(cacheKey);
      _lruList.add(cacheKey);
      return entry.question;
    }
    return null;
  }

  /// Generate a unique cache key for a question
  String _getQuestionCacheKey(String language, int index) {
    return '${language}_$index';
  }

  /// Public method to load questions by indices (used by ProgressiveQuestionSelector)
  Future<List<QuizQuestion>> loadQuestionsByIndices(
      String language, List<int> indices) async {
    return _loadQuestionsByIndices(language, indices);
  }

  /// Get cached metadata for a language
  Future<List<Map<String, dynamic>>?> _getCachedMetadata(
      String language) async {
    if (!_isInitialized) return null;

    try {
      final cacheKey = '${_metadataCacheKey}_$language';
      final timestampKey = '${_cacheTimestampKey}_$language';

      final cachedData = _prefs.getString(cacheKey);
      final timestamp = _prefs.getInt(timestampKey);

      if (cachedData == null || timestamp == null) {
        return null;
      }

      // Check if cache is expired
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) >
          QuestionCacheConfig.cacheExpiry) {
        return null;
      }

      final List<dynamic> data = json.decode(cachedData);
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      AppLogger.error('Error loading cached metadata', e);
      return null;
    }
  }

  /// Cache metadata for a language
  Future<void> _cacheMetadata(
    String language,
    List<Map<String, dynamic>> metadata,
  ) async {
    if (!_isInitialized) return;

    try {
      final cacheKey = '${_metadataCacheKey}_$language';
      final timestampKey = '${_cacheTimestampKey}_$language';

      final jsonData = json.encode(metadata);
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await _prefs.setString(cacheKey, jsonData);
      await _prefs.setInt(timestampKey, timestamp);
    } catch (e) {
      AppLogger.error('Error caching metadata', e);
    }
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await initialize();
    try {
      // Clear simplified memory cache
      _memoryCache.clear();
      _lruList.clear();
      _questionMetadata.clear();

      // Clear persistent caches
      final keys = _prefs.getKeys().where((key) =>
          key.startsWith(_cacheKey) ||
          key.startsWith(_cacheTimestampKey) ||
          key.startsWith(_metadataCacheKey));

      for (final key in keys) {
        await _prefs.remove(key);
      }

      AppLogger.info('Cache cleared successfully');
    } catch (e) {
      AppLogger.error('Failed to clear cache', e);
    }
  }

  /// Load questions from database by indices
  Future<List<QuizQuestion>> _loadQuestionsFromDatabaseByIndices(
      String language, List<int> indices) async {
    try {
      final client = SupabaseConfig.getClient();
      final ids = indices
          .map((index) => '000${(index + 1).toString().padLeft(3, '0')}')
          .toList();

      final response = await client
          .from('questions')
          .select(
              'id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference')
          .inFilter('id', ids);

      final questions = <QuizQuestion>[];
      for (final row in response) {
        try {
          final question = QuizQuestion.fromJson({
            'id': row['id'],
            'vraag': row['vraag'],
            'juisteAntwoord': row['juiste_antwoord'],
            'fouteAntwoorden': row['foute_antwoorden'] ?? [],
            'moeilijkheidsgraad': row['moeilijkheidsgraad'],
            'type': row['type'] ?? 'mc',
            'categories': row['categories'] ?? [],
            'biblicalReference': row['biblical_reference'],
          });
          questions.add(question);
        } catch (e) {
          AppLogger.error('Error parsing database question: $e', e);
        }
      }

      return questions;
    } catch (e) {
      AppLogger.error('Failed to load questions from database', e);
      rethrow;
    }
  }

  /// Load questions from JSON by indices
  Future<List<QuizQuestion>> _loadQuestionsFromJsonByIndices(
      String language, List<int> indices) async {
    final String response =
        await rootBundle.loadString('assets/questions-nl-sv.json');
    final List<dynamic> data = json.decode(response) as List;

    if (data.isEmpty) {
      throw Exception('Question file is empty');
    }

    final loadedQuestions = <QuizQuestion>[];

    for (final index in indices) {
      if (index < 0 || index >= data.length) continue;

      try {
        final questionData = data[index] as Map<String, dynamic>;
        final question = QuizQuestion.fromJson(questionData);
        loadedQuestions.add(question);
      } catch (e) {
        AppLogger.error('Error parsing question at index $index', e);
      }
    }

    return loadedQuestions;
  }

  /// Load metadata from database
  Future<List<Map<String, dynamic>>> _loadMetadataFromDatabase(
      String language) async {
    try {
      final client = SupabaseConfig.getClient();
      final response = await client
          .from('questions')
          .select(
              'id, moeilijkheidsgraad, categories, type, biblical_reference')
          .order('moeilijkheidsgraad');

      final metadata = <Map<String, dynamic>>[];
      for (final row in response) {
        metadata.add({
          'id': row['id'],
          'difficulty': row['moeilijkheidsgraad']?.toString() ?? '',
          'categories':
              (row['categories'] as List<dynamic>?)?.cast<String>() ?? [],
          'type': row['type']?.toString() ?? 'mc',
          'biblicalReference': row['biblical_reference'] is String
              ? row['biblical_reference'] as String
              : null,
        });
      }

      return metadata;
    } catch (e) {
      AppLogger.error('Failed to load metadata from database', e);
      rethrow;
    }
  }

  /// Load metadata from JSON
  Future<List<Map<String, dynamic>>> _loadMetadataFromJson(
      String language) async {
    final String response =
        await rootBundle.loadString('assets/questions-nl-sv.json');
    final List<dynamic> data = json.decode(response);

    if (data.isEmpty) {
      throw Exception('Question file is empty');
    }

    // Extract and store just the metadata (much smaller memory footprint)
    final metadata = data.map<Map<String, dynamic>>((json) {
      try {
        return {
          'id': json['id'] ?? '',
          'difficulty': json['moeilijkheidsgraad']?.toString() ?? '',
          'categories':
              (json['categories'] as List<dynamic>?)?.cast<String>() ?? [],
          'type': json['type']?.toString() ?? 'mc',
          'biblicalReference': json['biblicalReference'] is String
              ? json['biblicalReference'] as String
              : null,
        };
      } catch (e) {
        throw Exception('Invalid question format: $e');
      }
    }).toList();

    return metadata;
  }

  /// Dispose of resources
  void dispose() {
    // Clear all caches
    _memoryCache.clear();
    _lruList.clear();
    _questionMetadata.clear();
    _loadingCompleters.clear();
  }

  /// Get memory usage information - simplified for single cache structure
  Map<String, dynamic> getMemoryUsage() {
    int questionCount = _memoryCache.length;
    int totalQuestionSize = 0;

    // Calculate size for cached questions
    _memoryCache.forEach((key, entry) {
      try {
        final question = entry.question;
        totalQuestionSize += question.question.length * 2; // UTF-16 chars
        totalQuestionSize += question.correctAnswer.length * 2;
        totalQuestionSize += question.incorrectAnswers
            .fold<int>(0, (sum, ans) => sum + ans.length * 2);
      } catch (e) {
        AppLogger.error('Error calculating question size', e);
      }
    });

    // Calculate metadata size
    int metadataCount = 0;
    int totalMetadataSize = 0;

    _questionMetadata.forEach((lang, metadata) {
      metadataCount += metadata.length;
      // Sample metadata size calculation for performance
      for (int i = 0; i < metadata.length; i += 10) {
        try {
          totalMetadataSize += json.encode(metadata[i]).length;
        } catch (e) {
          AppLogger.error('Error calculating metadata size', e);
        }
      }
    });

    // Extrapolate metadata size
    if (metadataCount > 10) {
      totalMetadataSize =
          (totalMetadataSize * metadataCount) ~/ (metadataCount ~/ 10 + 1);
    }

    return <String, dynamic>{
      'memoryCache': <String, dynamic>{
        'questionCount': questionCount,
        'totalSizeKB': (totalQuestionSize / 1024).toStringAsFixed(2),
        'maxSize': QuestionCacheConfig.maxMemoryCacheSize,
        'cacheUtilizationPercent':
            ((questionCount / QuestionCacheConfig.maxMemoryCacheSize) * 100)
                .toStringAsFixed(1),
      },
      'metadata': <String, dynamic>{
        'languageCount': _questionMetadata.length,
        'totalQuestions': metadataCount,
        'totalSizeKB': (totalMetadataSize / 1024).toStringAsFixed(2),
      },
      'simplifiedLRU': <String, dynamic>{
        'lruListSize': _lruList.length,
      },
    };
  }

  /// Clear memory cache if memory usage is too high - simplified eviction
  void optimizeMemoryUsage() {
    final memoryInfo = getMemoryUsage();
    final cacheUtilization = double.tryParse(
            memoryInfo['memoryCache']['cacheUtilizationPercent'] as String) ??
        0.0;

    if (cacheUtilization > 90.0) {
      // Clear 30% of the cache to free up memory using simple LRU
      final itemsToRemove = (_memoryCache.length * 0.3).round();
      for (int i = 0; i < itemsToRemove && _lruList.isNotEmpty; i++) {
        _evictOldestEntry();
      }
      AppLogger.info(
          'Optimized memory usage by clearing $itemsToRemove cached questions');
    }
  }

  /// Returns a map of category -> frequency for the given language.
  Future<Map<String, int>> getCategoryFrequencies(String language) async {
    await initialize();
    await _ensureMetadataLoaded(language);

    final Map<String, int> counts = {};
    final metadata =
        _questionMetadata[language] ?? const <Map<String, dynamic>>[];
    for (int i = 0; i < metadata.length; i++) {
      final item = metadata[i];
      try {
        final cats =
            (item['categories'] as List?)?.map((e) => e.toString()).toList() ??
                const <String>[];
        for (final c in cats) {
          if (c.isEmpty) continue;
          counts[c] = (counts[c] ?? 0) + 1;
        }
      } catch (e) {
        // Skip malformed rows but continue
        AppLogger.error('Error reading categories for metadata index $i', e);
      }
    }
    return counts;
  }

  /// Returns all categories sorted by frequency (desc), then alphabetically.
  Future<List<String>> getAllCategories(String language) async {
    final counts = await getCategoryFrequencies(language);
    final cats = counts.keys.toList();
    cats.sort((a, b) {
      final cmp = (counts[b] ?? 0).compareTo(counts[a] ?? 0);
      if (cmp != 0) return cmp;
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    return cats;
  }

  /// Loads questions that belong to a specific category.
  Future<List<QuizQuestion>> getQuestionsByCategory(
    String language,
    String category, {
    int startIndex = 0,
    int? count,
  }) async {
    await initialize();
    await _ensureMetadataLoaded(language);

    final List<int> indices = [];
    final metadata =
        _questionMetadata[language] ?? const <Map<String, dynamic>>[];
    for (int i = 0; i < metadata.length; i++) {
      try {
        final cats = (metadata[i]['categories'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            const <String>[];
        if (cats.contains(category)) {
          indices.add(i);
        }
      } catch (e) {
        AppLogger.error(
            'Error processing metadata at $i for category filter', e);
      }
    }

    if (indices.isEmpty) return const [];

    // Apply slicing
    int endExclusive;
    if (count != null) {
      endExclusive = (startIndex + count).clamp(0, indices.length);
    } else {
      endExclusive = indices.length;
    }
    final sliced = (startIndex < indices.length)
        ? indices.sublist(startIndex, endExclusive)
        : const <int>[];

    if (sliced.isEmpty) return const [];

    final loaded = await _loadQuestionsByIndices(language, sliced);
    // Keep original order
    return loaded;
  }
}
