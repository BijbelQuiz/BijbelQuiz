import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_question.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'logger.dart';

 // Simplified memory cache: store QuizQuestion directly; access tracked via LRU list

/// Configuration for question loading and caching
class QuestionCacheConfig {
  static const int defaultBatchSize = 10;
  static const int maxMemoryCacheSize = 25; // Reduced from 50 to 25 for very low-end devices
  static const Duration cacheExpiry = Duration(days: 7);
  static const int maxPersistentCacheSize = 25; // Reduced from 50 to 25 for very low-end devices
}

/// A service for caching and lazy loading quiz questions with optimized memory usage
/// for low-end devices.
class QuestionCacheService {
  static const String _cacheKey = 'cached_questions';
  static const String _cacheTimestampKey = 'cache_timestamp';
  static const String _metadataCacheKey = 'cached_metadata';
  static const String _appVersionKey = 'app_version';
  
  // Enhanced LRU Cache implementation with predictive loading
  final Map<String, QuizQuestion> _memoryCache = {};
  final List<String> _lruList = [];
  final Map<String, int> _accessFrequency = {}; // Track access frequency for smarter eviction
  final Map<String, DateTime> _lastAccessTime = {}; // Track access time for temporal patterns
  final Set<String> _predictiveLoadCandidates = {}; // Questions to load preemptively
  
  late SharedPreferences _prefs;
  bool _isInitialized = false;
  
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
      AppLogger.info('QuestionCacheService initialized in ${initDuration.inMilliseconds}ms');

      // Log memory usage after initialization
      final memoryUsage = getMemoryUsage();
      AppLogger.info('QuestionCacheService memory usage after init: $memoryUsage');
      
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
  
  /// Check if cached questions need to be refreshed based on app version
  Future<bool> _shouldRefreshCache() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final savedVersion = _prefs.getString(_appVersionKey);
      
      // If no saved version or version has changed, we should refresh
      return savedVersion == null || savedVersion != currentVersion;
    } catch (e) {
      AppLogger.error('Error checking if cache should be refreshed', e);
      return true; // Better to refresh on error than use potentially stale data
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
    
    // Determine the end index. If `count` is provided we respect it; otherwise we
    // load every remaining question starting from `startIndex`.
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
      final String response = language == 'en'
          ? await rootBundle.loadString('assets/questions-en.json')
          : await rootBundle.loadString('assets/questions-nl-sv.json');
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
            'biblicalReference': json['biblicalReference'] is String ? json['biblicalReference'] as String : null,
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
        final int da = int.tryParse(a['difficulty']?.toString() ?? '') ?? 3;
        final int db = int.tryParse(b['difficulty']?.toString() ?? '') ?? 3;
        return da.compareTo(db);
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
      // Try to load from cache if available and valid
      if (await _isCacheValid(language)) {
        final cachedQuestions = await _loadQuestionsFromCache(language, indices);
        if (cachedQuestions != null) {
          return cachedQuestions;
        }
      }
      
      // Load the full questions from assets
      final String response = language == 'en'
          ? await rootBundle.loadString('assets/questions-en.json')
          : await rootBundle.loadString('assets/questions-nl-sv.json');
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
  
  
  /// Load questions from offline cache
  Future<List<QuizQuestion>?> _loadQuestionsFromCache(String language, List<int> indices) async {
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
          _updateLru(language, index);
          _loadedQuestionIndices.putIfAbsent(language, () => <int>{}).add(index);
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
      final isExpired = DateTime.now().difference(cacheTime) > QuestionCacheConfig.cacheExpiry;
      
      return !isExpired;
    } catch (e) {
      AppLogger.error('Error checking cache validity', e);
      return false;
    }
  }
  
  /// Cache downloaded questions for offline use
  Future<void> _cacheDownloadedQuestions(String language, List<dynamic> questions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Create a simplified representation for caching to save space
      final simplifiedQuestions = questions.map((question) {
        if (question is Map<String, dynamic>) {
          return {
            'id': question['id'],
            'vraag': question['vraag'],
            'juisteAntwoord': question['juisteAntwoord'],
            'fouteAntwoorden': question['fouteAntwoorden'],
            'moeilijkheidsgraad': question['moeilijkheidsgraad'],
            'type': question['type'],
            'categories': question['categories'],
            'biblicalReference': question['biblicalReference'],
          };
        }
        return question;
      }).toList();
      
      final jsonString = json.encode(simplifiedQuestions);
      final cacheKey = '${_cacheKey}_$language';
      final timestampKey = '${_cacheTimestampKey}_$language';
      
      await prefs.setString(cacheKey, jsonString);
      await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
      
      AppLogger.info('Cached ${questions.length} questions for offline use');
    } catch (e) {
      AppLogger.error('Failed to cache downloaded questions', e);
    }
  }
  
  /// Update the LRU list and access tracking for a question
  void _updateLru(String language, int index) {
    final cacheKey = _getQuestionCacheKey(language, index);

    // Remove existing entry if it exists
    _lruList.remove(cacheKey);

    // Add to end (most recently used)
    _lruList.add(cacheKey);

    // Update access frequency and time
    _accessFrequency[cacheKey] = (_accessFrequency[cacheKey] ?? 0) + 1;
    _lastAccessTime[cacheKey] = DateTime.now();
  }
  
  /// Add a question to the memory cache with enhanced LRU eviction
  void _addToMemoryCache(String language, int index, QuizQuestion question) {
    final cacheKey = _getQuestionCacheKey(language, index);

    // Check if we need to evict using smart eviction strategy
    if (_memoryCache.length >= QuestionCacheConfig.maxMemoryCacheSize && _lruList.isNotEmpty) {
      _performSmartEviction();
    }

    // Add to cache
    _memoryCache[cacheKey] = question;
    _updateLru(language, index);

    // Update predictive loading candidates based on access patterns
    _updatePredictiveCandidates(language, index);
  }

  /// Check if a question is in memory
  bool _isQuestionInMemory(String language, int index) {
    final cacheKey = _getQuestionCacheKey(language, index);
    return _memoryCache.containsKey(cacheKey);
  }
  
  /// Get a question from memory cache
  QuizQuestion? _getQuestionFromMemory(String language, int index) {
    final cacheKey = _getQuestionCacheKey(language, index);
    final question = _memoryCache[cacheKey];
    if (question != null) {
      _updateLru(language, index);
      return question;
    }
    return null;
  }
  
  /// Generate a unique cache key for a question
  String _getQuestionCacheKey(String language, int index) {
    return '${language}_$index';
  }

  /// Perform smart eviction based on access patterns and temporal data
  void _performSmartEviction() {
    if (_lruList.isEmpty) return;

    // Find the best candidate for eviction using multiple criteria
    String bestCandidate = _lruList.first;
    double lowestScore = double.infinity;

    for (final candidate in _lruList) {
      double score = _calculateEvictionScore(candidate);
      if (score < lowestScore) {
        lowestScore = score;
        bestCandidate = candidate;
      }
    }

    // Remove the best candidate
    _lruList.remove(bestCandidate);
    _memoryCache.remove(bestCandidate);
    _accessFrequency.remove(bestCandidate);
    _lastAccessTime.remove(bestCandidate);

    AppLogger.info('Smart evicted question: $bestCandidate');
  }

  /// Calculate eviction score for a cache entry (lower is better to evict)
  double _calculateEvictionScore(String cacheKey) {
    final frequency = _accessFrequency[cacheKey] ?? 0;
    final lastAccess = _lastAccessTime[cacheKey];
    final timeSinceAccess = lastAccess != null
        ? DateTime.now().difference(lastAccess).inMinutes
        : double.infinity;

    // Score combines recency, frequency, and temporal patterns
    // Lower frequency + older access = better candidate for eviction
    // Higher frequency + recent access = worse candidate for eviction
    final recencyScore = timeSinceAccess / 60.0; // Normalize to hours
    final frequencyScore = 1.0 / (frequency + 1.0); // Inverse frequency

    return recencyScore + frequencyScore;
  }

  /// Update predictive loading candidates based on access patterns
  void _updatePredictiveCandidates(String language, int index) {
    // Add neighboring questions as candidates for predictive loading
    final baseIndex = index ~/ 10 * 10; // Round to nearest 10
    for (int i = -2; i <= 2; i++) {
      final candidateIndex = baseIndex + i * 10;
      if (candidateIndex >= 0 && candidateIndex != index) {
        final candidateKey = _getQuestionCacheKey(language, candidateIndex);
        if (!_memoryCache.containsKey(candidateKey)) {
          _predictiveLoadCandidates.add(candidateKey);
        }
      }
    }
  }

  /// Get predictive loading candidates for background loading
  List<String> getPredictiveLoadCandidates() {
    final candidates = _predictiveLoadCandidates.toList();
    _predictiveLoadCandidates.clear(); // Clear after returning
    return candidates;
  }

  /// Public method to load questions by indices (used by ProgressiveQuestionSelector)
  Future<List<QuizQuestion>> loadQuestionsByIndices(String language, List<int> indices) async {
    return _loadQuestionsByIndices(language, indices);
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


  /// Clear all cached data
  Future<void> clearCache() async {
    await initialize();
    try {
      // Clear memory caches
      _memoryCache.clear();
      _lruList.clear();
      _questionMetadata.clear();
      _loadedQuestionIndices.clear();

      // Clear enhanced LRU tracking
      _accessFrequency.clear();
      _lastAccessTime.clear();
      _predictiveLoadCandidates.clear();

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

  /// Dispose of resources
  void dispose() {
    // No resources to dispose
  }

  /// Get memory usage information with performance optimizations
  Map<String, dynamic> getMemoryUsage() {
    // PERFORMANCE OPTIMIZATION: Sample only a subset of questions for size calculation
    int questionCount = _memoryCache.length;
    int totalQuestionSize = 0;

    // Sample every 10th question to reduce calculation time
    int sampleCount = 0;
    _memoryCache.forEach((key, question) {
      if (sampleCount % 10 == 0) { // Sample every 10th item
        try {
          totalQuestionSize += question.question.length * 2; // UTF-16 chars
          totalQuestionSize += question.correctAnswer.length * 2;
          totalQuestionSize += question.incorrectAnswers.fold<int>(
            0, (sum, ans) => sum + ans.length * 2);
        } catch (e) {
          AppLogger.error('Error calculating question size', e);
        }
      }
      sampleCount++;
    });

    // Extrapolate total size based on sample
    if (sampleCount > 10) {
      totalQuestionSize = (totalQuestionSize * sampleCount) ~/ (sampleCount ~/ 10 + 1);
    }

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
      totalMetadataSize = (totalMetadataSize * metadataCount) ~/ (metadataCount ~/ 10 + 1);
    }

    return <String, dynamic>{
      'memoryCache': <String, dynamic>{
        'questionCount': questionCount,
        'totalSizeKB': (totalQuestionSize / 1024).toStringAsFixed(2),
        'maxSize': QuestionCacheConfig.maxMemoryCacheSize,
        'cacheUtilizationPercent': ((questionCount / QuestionCacheConfig.maxMemoryCacheSize) * 100).toStringAsFixed(1),
      },
      'metadata': <String, dynamic>{
        'languageCount': _questionMetadata.length,
        'totalQuestions': metadataCount,
        'totalSizeKB': (totalMetadataSize / 1024).toStringAsFixed(2),
      },
      'lruList': <String, dynamic>{
        'size': _lruList.length,
      },
      'enhancedTracking': <String, dynamic>{
        'accessFrequencyEntries': _accessFrequency.length,
        'lastAccessTimeEntries': _lastAccessTime.length,
        'predictiveCandidates': _predictiveLoadCandidates.length,
      },
      'loadedIndices': {
        for (final k in _loadedQuestionIndices.keys)
          k: _loadedQuestionIndices[k]?.length ?? 0,
      },
    };
  }

  /// Clear memory cache if memory usage is too high
  void optimizeMemoryUsage() {
    final memoryInfo = getMemoryUsage();
    final cacheUtilization = double.tryParse(memoryInfo['memoryCache']['cacheUtilizationPercent'] as String) ?? 0.0;

    if (cacheUtilization > 90.0) {
      // Clear 30% of the cache to free up memory
      final itemsToRemove = (_memoryCache.length * 0.3).round();
      for (int i = 0; i < itemsToRemove && _lruList.isNotEmpty; i++) {
        final lruKey = _lruList.removeAt(0);
        _memoryCache.remove(lruKey);
      }
      AppLogger.info('Optimized memory usage by clearing $itemsToRemove cached questions');
    }
  }

  /// Returns a map of category -> frequency for the given language.
  /// Frequencies are computed from metadata without loading full questions.
  Future<Map<String, int>> getCategoryFrequencies(String language) async {
    await initialize();
    await _ensureMetadataLoaded(language);

    final Map<String, int> counts = {};
    final metadata = _questionMetadata[language] ?? const <Map<String, dynamic>>[];
    for (int i = 0; i < metadata.length; i++) {
      final item = metadata[i];
      try {
        final cats = (item['categories'] as List?)?.map((e) => e.toString()).toList() ?? const <String>[];
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
  /// This uses metadata to find matching indices and only loads those items.
  Future<List<QuizQuestion>> getQuestionsByCategory(
    String language,
    String category, {
    int startIndex = 0,
    int? count,
  }) async {
    await initialize();
    await _ensureMetadataLoaded(language);

    final List<int> indices = [];
    final metadata = _questionMetadata[language] ?? const <Map<String, dynamic>>[];
    for (int i = 0; i < metadata.length; i++) {
      try {
        final cats = (metadata[i]['categories'] as List?)?.map((e) => e.toString()).toList() ?? const <String>[];
        if (cats.contains(category)) {
          indices.add(i);
        }
      } catch (e) {
        AppLogger.error('Error processing metadata at $i for category filter', e);
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