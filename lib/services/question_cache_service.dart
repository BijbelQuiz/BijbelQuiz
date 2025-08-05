import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import '../models/quiz_question.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'logger.dart';

/// Cache entry for storing questions with access time
class _QuestionCacheEntry {
  final QuizQuestion question;
  final int lastAccessed;
  
  _QuestionCacheEntry(this.question) : lastAccessed = DateTime.now().millisecondsSinceEpoch;
  
  void updateAccessTime() {
    // No need to update lastAccessed as we use the LRU list for tracking
  }
}

/// Configuration for question loading and caching
class QuestionCacheConfig {
  static const int defaultBatchSize = 10;
  static const int maxMemoryCacheSize = 50; // Reduced from 100 to 50 for low-end devices
  static const Duration cacheExpiry = Duration(days: 7);
  static const int maxPersistentCacheSize = 50; // Reduced from 100 to 50 for low-end devices
}

/// A service for caching and lazy loading quiz questions with optimized memory usage
/// for low-end devices.
class QuestionCacheService {
  static const String _cacheKey = 'cached_questions';
  static const String _cacheTimestampKey = 'cache_timestamp';
  static const String _metadataCacheKey = 'cached_metadata';
  static const String _appVersionKey = 'app_version';
  
  // LRU Cache implementation
  final Map<String, _QuestionCacheEntry> _memoryCache = {};
  final List<String> _lruList = [];
  
  late SharedPreferences _prefs;
  bool _isInitialized = false;
  bool _isLoading = false;
  
  // Track loading state per language
  final Map<String, Completer<void>> _loadingCompleters = {};
  
  // Track question metadata
  final Map<String, List<Map<String, dynamic>>> _questionMetadata = {};
  
  // Track which questions are loaded in memory
  final Map<String, Set<int>> _loadedQuestionIndices = {};
  
  // LRU cache implementation

  /// Initialize the cache service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      await _clearCacheOnAppUpdate();
      AppLogger.info('QuestionCacheService initialized');
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
  /// [startIndex] - The starting index of questions to load
  /// [count] - Number of questions to load (defaults to batch size)
  Future<List<QuizQuestion>> getQuestions(
    String language, {
    int startIndex = 0,
    int? count,
  }) async {
    await initialize();
    
    // Ensure we have metadata loaded first
    await _ensureMetadataLoaded(language);
    
    // Default to batch size if count not specified
    final batchSize = count ?? QuestionCacheConfig.defaultBatchSize;
    final endIndex = startIndex + batchSize;
    
    // Check which questions need to be loaded
    final questionsToLoad = <int>[];
    final loadedQuestions = <QuizQuestion>[];
    
    for (int i = startIndex; i < endIndex; i++) {
      if (i >= (_questionMetadata[language]?.length ?? 0)) break;
      
      if (_isQuestionInMemory(language, i)) {
        final question = _getQuestionFromMemory(language, i);
        if (question != null) {
          loadedQuestions.add(question);
        } else {
          questionsToLoad.add(i);
        }
      } else {
        questionsToLoad.add(i);
      }
    }
    
    // Load any missing questions
    if (questionsToLoad.isNotEmpty) {
      final loaded = await _loadQuestionsByIndices(language, questionsToLoad);
      loadedQuestions.addAll(loaded);
    }
    
    // Update LRU
    for (final index in questionsToLoad) {
      _updateLru(language, index);
    }
    
    return loadedQuestions;
  }

  /// Get a batch of questions for a specific language with lazy loading
  /// This is now an alias for getQuestions with offset/count parameters
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
        _loadedQuestionIndices[language] = {};
        completer.complete();
        return;
      }
      
      // If no cache, load from assets
      final String response = await rootBundle.loadString('assets/questions-nl-sv.json');
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
            'categories': (json['categories'] as List<dynamic>?)?.cast<String>() ?? [],
            'type': json['type']?.toString() ?? 'mc',
          };
        } catch (e) {
          throw Exception('Invalid question format: $e');
        }
      }).toList();
      
      if (metadata.isEmpty) {
        throw Exception('No valid questions found');
      }
      
      // Sort questions by difficulty for better performance
      metadata.sort((a, b) {
        final difficultyOrder = {'MAKKELIJK': 0, 'GEMIDDELD': 1, 'MOEILIJK': 2};
        return (difficultyOrder[a['difficulty']] ?? 0)
            .compareTo(difficultyOrder[b['difficulty']] ?? 0);
      });
      
      _questionMetadata[language] = metadata;
      _loadedQuestionIndices[language] = {};
      
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
      // Load the full questions from assets
      final String response = await rootBundle.loadString('assets/questions-nl-sv.json');
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
          _addToMemoryCache(language, index, question);
          _updateLru(language, index);
          _loadedQuestionIndices.putIfAbsent(language, () => <int>{}).add(index);
          loadedQuestions.add(question);
        } catch (e) {
          AppLogger.error('Error parsing question at index $index', e);
        }
      }
      
      return loadedQuestions;
    } catch (e) {
      AppLogger.error('Failed to load questions by indices', e);
      rethrow;
    }
  }
  
  /// Add a question to the memory cache with LRU eviction if needed
  void _addToMemoryCache(String language, int index, QuizQuestion question) {
    final cacheKey = _getQuestionCacheKey(language, index);
    
    // Check if we need to evict
    if (_memoryCache.length >= QuestionCacheConfig.maxMemoryCacheSize && _lruList.isNotEmpty) {
      // Remove least recently used
      final lruKey = _lruList.removeAt(0);
      _memoryCache.remove(lruKey);
    }
    
    // Add to cache
    _memoryCache[cacheKey] = _QuestionCacheEntry(question);
    _updateLru(language, index);
  }
  
  /// Update the LRU list for a question
  void _updateLru(String language, int index) {
    final cacheKey = _getQuestionCacheKey(language, index);
    
    // Remove existing entry if it exists
    _lruList.remove(cacheKey);
    
    // Add to end (most recently used)
    _lruList.add(cacheKey);
  }
  
  /// Check if a question is in memory
  bool _isQuestionInMemory(String language, int index) {
    final cacheKey = _getQuestionCacheKey(language, index);
    return _memoryCache.containsKey(cacheKey);
  }
  
  /// Get a question from memory cache
  QuizQuestion? _getQuestionFromMemory(String language, int index) {
    final cacheKey = _getQuestionCacheKey(language, index);
    final entry = _memoryCache[cacheKey];
    if (entry != null) {
      _updateLru(language, index);
      return entry.question;
    }
    return null;
  }
  
  /// Generate a unique cache key for a question
  String _getQuestionCacheKey(String language, int index) {
    return '${language}_$index';
  }
  
  /// Convert QuestionType to string
  String _questionTypeToString(QuestionType type) {
    switch (type) {
      case QuestionType.mc:
        return 'mc';
      case QuestionType.fitb:
        return 'fitb';
      case QuestionType.tf:
        return 'tf';
    }
  }

  /// Get cached metadata for a language
  Future<List<Map<String, dynamic>>?> _getCachedMetadata(String language) async {
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
      if (DateTime.now().difference(cacheTime) > QuestionCacheConfig.cacheExpiry) {
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

  /// Cache questions to persistent storage
  Future<void> _cacheQuestions(String language, List<QuizQuestion> questions) async {
    if (!_isInitialized) return;
    
    try {
      // Only cache a limited number of questions to avoid storage issues
      final questionsToCache = questions.length > QuestionCacheConfig.maxPersistentCacheSize
          ? questions.sublist(0, QuestionCacheConfig.maxPersistentCacheSize)
          : questions;
          
      // Update metadata cache
      final metadata = questionsToCache.map((q) => <String, dynamic>{
        'difficulty': q.difficulty,
        'categories': q.categories,
        'type': _questionTypeToString(q.type),
      }).toList();
      
      await _cacheMetadata(language, metadata);
      
      // Cache individual questions
      for (int i = 0; i < questionsToCache.length; i++) {
        final question = questionsToCache[i];
        final questionKey = '${_cacheKey}_${language}_$i';
        await _prefs.setString(questionKey, json.encode(question.toJson()));
      }
      
      AppLogger.info('Cached ${questionsToCache.length} questions for $language');
    } catch (e) {
      AppLogger.error('Error caching questions', e);
    }
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await initialize();
    try {
      // Clear memory caches
      _memoryCache.clear();
      _lruList.clear();
      _questionMetadata.clear();
      _loadedQuestionIndices.clear();
      
      // Clear persistent caches
      final keys = _prefs.getKeys().where((key) => 
        key.startsWith(_cacheKey) || 
        key.startsWith(_cacheTimestampKey) ||
        key.startsWith(_metadataCacheKey)
      );
      
      for (final key in keys) {
        await _prefs.remove(key);
      }
      
      AppLogger.info('Cache cleared successfully');
    } catch (e) {
      AppLogger.error('Failed to clear cache', e);
    }
  }

  /// Get memory usage information
  Map<String, dynamic> getMemoryUsage() {
    // Calculate memory usage of cached questions
    int questionCount = _memoryCache.length;
    int totalQuestionSize = 0;
    
    _memoryCache.forEach((key, entry) {
      try {
        // Safely access question properties
        final question = entry.question;
        totalQuestionSize += question.question.length * 2; // UTF-16 chars
        totalQuestionSize += question.correctAnswer.length * 2;
        totalQuestionSize += question.incorrectAnswers.fold<int>(
          0, (sum, ans) => sum + ans.length * 2);
      } catch (e) {
        AppLogger.error('Error calculating question size', e);
      }
    });
    
    // Calculate metadata size
    int metadataCount = 0;
    int totalMetadataSize = 0;
    
    _questionMetadata.forEach((lang, metadata) {
      metadataCount += metadata.length;
      for (final item in metadata) {
        try {
          totalMetadataSize += json.encode(item).length;
        } catch (e) {
          AppLogger.error('Error calculating metadata size', e);
        }
      }
    });
    
    return <String, dynamic>{
      'memoryCache': <String, dynamic>{
        'questionCount': questionCount,
        'totalSizeKB': (totalQuestionSize / 1024).toStringAsFixed(2),
        'maxSize': QuestionCacheConfig.maxMemoryCacheSize,
      },
      'metadata': <String, dynamic>{
        'languageCount': _questionMetadata.length,
        'totalQuestions': metadataCount,
        'totalSizeKB': (totalMetadataSize / 1024).toStringAsFixed(2),
      },
      'lruList': <String, dynamic>{
        'size': _lruList.length,
      },
      'loadedIndices': Map<String, int>.fromIterable(
        _loadedQuestionIndices.keys,
        key: (k) => k,
        value: (k) => _loadedQuestionIndices[k]?.length ?? 0,
      ),
    };
  }
}