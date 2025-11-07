import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lesson.dart';
import '../services/logger.dart';
import '../services/centralized_sync_service.dart';

/// Enhanced LessonProgressProvider using the centralized sync service
class LessonProgressProvider extends ChangeNotifier {
  static const String _storageKey = 'lesson_progress_v2';
  static const String _unlockedCountKey = 'lesson_unlocked_count_v2';

  SharedPreferences? _prefs;
  bool _isLoading = true;
  String? _error;

  /// Number of lessons unlocked from the start (sequential from index 0)
  int _unlockedCount = 1;

  /// Map: lessonId -> bestStars (0..3)
  final Map<String, int> _bestStarsByLesson = {};

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unlockedCount => _unlockedCount;

  LessonProgressProvider() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    await CentralizedSyncService.instance.initialize();
    await _load();
    _setupSyncListener();
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
      
      AppLogger.info('Lesson progress loaded: unlockedCount=$_unlockedCount, progressData=${_bestStarsByLesson.length} lessons');
      
      // Sync current data to the room after loading
      if (CentralizedSyncService.instance.isInRoom) {
        await CentralizedSyncService.instance.syncData('lesson_progress', getExportData());
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
    try {
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
      
      AppLogger.info('Lesson completed: ${lesson.id}, stars: $stars (was: $prev), unlockedCount: $_unlockedCount');

      // Sync data using centralized service
      if (CentralizedSyncService.instance.isInRoom) {
        await CentralizedSyncService.instance.syncData('lesson_progress', getExportData());
        AppLogger.debug('Lesson progress synced to room');
      }
    } catch (e) {
      AppLogger.error('Failed to mark lesson as completed: ${lesson.id}', e);
      _error = 'Failed to save lesson progress';
      notifyListeners();
    }
  }

  /// Ensures at least [count] lessons are unlocked (used when lesson list shorter/longer changes).
  Future<void> ensureUnlockedCountAtLeast(int count) async {
    if (count > _unlockedCount) {
      _unlockedCount = count;
      await _persist();
      notifyListeners();
      
      AppLogger.info('Ensured unlocked count: $_unlockedCount');
      
      // Sync the updated data
      if (CentralizedSyncService.instance.isInRoom) {
        await CentralizedSyncService.instance.syncData('lesson_progress', getExportData());
      }
    }
  }

  /// Resets all lesson progress.
  Future<void> resetAll() async {
    try {
      _unlockedCount = 1;
      _bestStarsByLesson.clear();
      await _persist();
      notifyListeners();
      
      AppLogger.info('All lesson progress reset');
      
      // Sync reset data
      if (CentralizedSyncService.instance.isInRoom) {
        await CentralizedSyncService.instance.syncData('lesson_progress', getExportData());
      }
    } catch (e) {
      AppLogger.error('Failed to reset lesson progress', e);
      _error = 'Failed to reset lesson progress';
      notifyListeners();
    }
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
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Loads lesson progress data from import (for sync)
  Future<void> loadImportData(Map<String, dynamic> data) async {
    try {
      final oldUnlockedCount = _unlockedCount;
      final oldBestStars = Map<String, int>.from(_bestStarsByLesson);
      
      _unlockedCount = data['unlockedCount'] ?? 1;
      _bestStarsByLesson.clear();
      final bestStars = Map<String, int>.from(data['bestStarsByLesson'] ?? {});
      bestStars.forEach((k, v) {
        _bestStarsByLesson[k] = v.clamp(0, 3);
      });

      await _persist();
      notifyListeners();
      
      AppLogger.info('Lesson progress loaded from sync: unlockedCount changed from $oldUnlockedCount to $_unlockedCount, progressData changed from ${oldBestStars.length} to ${_bestStarsByLesson.length} lessons');
    } catch (e) {
      AppLogger.error('Failed to load lesson progress from sync data', e);
    }
  }

  /// Sets up sync listener for real-time updates
  void _setupSyncListener() {
    CentralizedSyncService.instance.addListener('lesson_progress', loadImportData);
  }

  /// Joins a sync room
  Future<bool> joinSyncRoom(String code) async {
    return await CentralizedSyncService.instance.joinRoom(code);
  }

  /// Leaves the sync room
  Future<void> leaveSyncRoom() async {
    await CentralizedSyncService.instance.leaveRoom();
  }

  /// Forces immediate sync of current progress
  Future<void> forceSync() async {
    if (CentralizedSyncService.instance.isInRoom) {
      await CentralizedSyncService.instance.syncData('lesson_progress', getExportData());
      AppLogger.info('Forced sync of lesson progress');
    }
  }
}