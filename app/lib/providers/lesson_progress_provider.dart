import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/supabase_config.dart';
import '../models/lesson.dart';
import '../services/logger.dart';
import '../services/sync_service_v2.dart';

/// Tracks per-lesson unlock state and best stars earned.
/// Simple linear progression: lesson at index 0 starts unlocked; completing a lesson unlocks the next.
class LessonProgressProvider extends ChangeNotifier {
  static const String _storageKey = 'lesson_progress_v1';
  static const String _unlockedCountKey = 'lesson_unlocked_count_v1';

  SharedPreferences? _prefs;
  bool _isLoading = true;
  String? _error;
  bool _syncListenerSetup = false;
  void Function(Map<String, dynamic>)? _syncCallback;

  /// Number of lessons unlocked from start (sequential from index 0)
  int _unlockedCount = 1;

  /// Map: lessonId -> bestStars (0..3)
  final Map<String, int> _bestStarsByLesson = {};
  SyncServiceV2 get syncService => SyncServiceV2.instance;

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unlockedCount => _unlockedCount;

  LessonProgressProvider() {
    _initializeSyncService();
    _load();
  }

  Future<void> _initializeSyncService() async {
    await syncService.initialize();
    // Set up error callbacks for user notifications
    syncService.registerCallbacks(
      'lesson_progress',
      onSyncError: (key, error) {
        if (key == 'lesson_progress') {
          _error = 'Synchronisatie mislukt: ${error.message}';
          notifyListeners();
        }
      },
      onSyncSuccess: (key) {
        if (key == 'lesson_progress') {
          AppLogger.debug('Lesson progress sync successful');
        }
      },
    );

    final client = SupabaseConfig.maybeClient;
    if (client == null) return;

    // Listen for auth changes to reload data
    client.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session?.user != null) {
        AppLogger.info(
            'User signed in (LessonProgressProvider), reloading data...');
        // Small delay to ensure SyncService has processed the user update
        Future.delayed(const Duration(milliseconds: 500), () {
          _load();
          setupSyncListener();
        });
      }
    });
  }

  Future<void> _load() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _prefs = await SharedPreferences.getInstance();

      _unlockedCount = _prefs?.getInt(_unlockedCountKey) ?? 1;
      final raw = _prefs?.getString(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        final Map data = json.decode(raw) as Map;
        _bestStarsByLesson.clear();
        data.forEach((k, v) {
          final stars = (v is int) ? v : int.tryParse(v.toString()) ?? 0;
          _bestStarsByLesson[k.toString()] = stars.clamp(0, 3);
        });
      }

      // Check for synced data and merge if available
      if (syncService.isAuthenticated) {
        AppLogger.info('User authenticated, fetching synced data from server');
        final allData = await syncService.fetchAllData();

        if (allData != null && allData.containsKey('lesson_progress')) {
          final syncedEntry = allData['lesson_progress'];
          final syncedData = syncedEntry?.data;
          AppLogger.info(
              'Found synced lesson progress, merging with local data');

          if (syncedData != null) {
            // Merge: take maximum unlocked count and best stars
            final syncedUnlockedCount =
                syncedData['unlockedCount'] as int? ?? 1;
            if (syncedUnlockedCount > _unlockedCount) {
              _unlockedCount = syncedUnlockedCount;
            }

            final syncedBestStars =
                Map<String, int>.from(syncedData['bestStarsByLesson'] ?? {});
            syncedBestStars.forEach((lessonId, stars) {
              final currentStars = _bestStarsByLesson[lessonId] ?? 0;
              if (stars > currentStars) {
                _bestStarsByLesson[lessonId] = stars;
              }
            });

            // Save merged data
            await _persist();
            AppLogger.info(
                'Merged lesson progress: unlocked $_unlockedCount, stars for ${_bestStarsByLesson.length} lessons');
          }
        }
      }
    } catch (e) {
      _error = 'Failed to load lesson progress: $e';
      AppLogger.error(_error!, e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _persist() async {
    try {
      await _prefs?.setInt(_unlockedCountKey, _unlockedCount);
      final jsonMap = _bestStarsByLesson.map((k, v) => MapEntry(k, v));
      await _prefs?.setString(_storageKey, json.encode(jsonMap));
    } catch (e) {
      AppLogger.error('Failed to save lesson progress', e);
    }
  }

  /// Returns whether the lesson at [index] is unlocked.
  bool isLessonUnlocked(int index) => index < _unlockedCount;

  /// Returns best stars earned for the [lessonId] (0..3).
  int bestStarsFor(String lessonId) => _bestStarsByLesson[lessonId] ?? 0;

  /// Marks completion and updates stars if improved. Also unlocks the next lesson when stars > 0.
  Future<void> markCompleted({
    required Lesson lesson,
    required int correct,
    required int total,
  }) async {
    final stars = computeStars(correct: correct, total: total);
    final prev = _bestStarsByLesson[lesson.id] ?? 0;
    if (stars > prev) {
      _bestStarsByLesson[lesson.id] = stars;
    }

    // Unlock next if any stars achieved
    if (stars > 0 && _unlockedCount <= lesson.index + 1) {
      _unlockedCount = lesson.index + 2; // unlock next index (count is 1-based)
    }

    await _persist();
    notifyListeners();

    // Trigger sync
    triggerSync();
  }

  /// Ensures at least [count] lessons are unlocked (used when lesson list shorter/longer changes).
  Future<void> ensureUnlockedCountAtLeast(int count) async {
    if (count > _unlockedCount) {
      _unlockedCount = count;
      await _persist();
      notifyListeners();
    }
  }

  /// Resets all lesson progress.
  Future<void> resetAll() async {
    _unlockedCount = 1;
    _bestStarsByLesson.clear();
    await _persist();
    notifyListeners();

    // Trigger sync
    triggerSync();
  }

  /// Stars rubric
  /// 3 ⭐: ≥ 90%
  /// 2 ⭐: ≥ 70%
  /// 1 ⭐: ≥ 50%
  /// 0 ⭐: otherwise
  int computeStars({required int correct, required int total}) {
    if (total <= 0) return 0;
    final pct = correct / total;
    if (pct >= 0.9) return 3;
    if (pct >= 0.7) return 2;
    if (pct >= 0.5) return 1;
    return 0;
  }

  /// Gets all lesson progress data for export
  Map<String, dynamic> getExportData() {
    return {
      'unlockedCount': _unlockedCount,
      'bestStarsByLesson': Map<String, int>.from(_bestStarsByLesson),
    };
  }

  /// Loads lesson progress data from import
  Future<void> loadImportData(Map<String, dynamic> data) async {
    final oldUnlockedCount = _unlockedCount;
    _unlockedCount = data['unlockedCount'] ?? 1;
    _bestStarsByLesson.clear();
    final bestStars = Map<String, int>.from(data['bestStarsByLesson'] ?? {});
    bestStars.forEach((k, v) {
      _bestStarsByLesson[k] = v.clamp(0, 3);
    });

    await _persist();
    notifyListeners();
    AppLogger.info(
        'Loaded synced lesson progress: unlocked $_unlockedCount (was $oldUnlockedCount)');
  }

  /// Sets up sync listener
  void setupSyncListener() {
    if (_syncListenerSetup) {
      AppLogger.debug('Lesson progress sync listener already set up, skipping');
      return;
    }
    _syncListenerSetup = true;
    AppLogger.info('Setting up lesson progress sync listener');
    _syncCallback = (data) {
      AppLogger.info('Received synced lesson progress update');
      loadImportData(data);
    };
    syncService.addListener('lesson_progress', _syncCallback!);
  }

  /// Triggers immediate sync of lesson progress to server
  Future<void> triggerSync() async {
    AppLogger.info('Triggering lesson progress sync');
    await syncService.syncData('lesson_progress', getExportData());
  }

  /// Cleans up resources and listeners
  @override
  void dispose() {
    // Remove sync listeners to prevent memory leaks
    if (_syncCallback != null) {
      syncService.removeListener('lesson_progress', _syncCallback!);
    }
    _syncListenerSetup = false;
    _syncCallback = null;
    AppLogger.debug('LessonProgressProvider disposed - listeners cleaned up');
    super.dispose();
  }
}
