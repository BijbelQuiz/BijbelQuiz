import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lesson.dart';
import '../services/logger.dart';
import '../services/sync_service.dart';

/// Tracks per-lesson unlock state and best stars earned.
/// Simple linear progression: lesson at index 0 starts unlocked; completing a lesson unlocks the next.
class LessonProgressProvider extends ChangeNotifier {
  static const String _storageKey = 'lesson_progress_v1';
  static const String _unlockedCountKey = 'lesson_unlocked_count_v1';

  SharedPreferences? _prefs;
  bool _isLoading = true;
  String? _error;

  /// Number of lessons unlocked from the start (sequential from index 0)
  int _unlockedCount = 1;

  /// Map: lessonId -> bestStars (0..3)
  final Map<String, int> _bestStarsByLesson = {};
  late SyncService syncService;
  String? _profileId;

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unlockedCount => _unlockedCount;

  String _getProfileKey(String key) {
    return 'user_${_profileId}_$key';
  }

  LessonProgressProvider({String? profileId}) : _profileId = profileId {
    syncService = SyncService();
    _initializeSyncService();
    _load();
  }

  Future<void> _initializeSyncService() async {
    await syncService.initialize();
  }

  Future<void> _migrateLegacyData() async {
    final keysToMigrate = {
      _unlockedCountKey: (value) => _prefs!.setInt(_getProfileKey(_unlockedCountKey), value as int),
      _storageKey: (value) => _prefs!.setString(_getProfileKey(_storageKey), value as String),
    };

    for (final key in keysToMigrate.keys) {
      final value = _prefs!.get(key);
      if (value != null) {
        await keysToMigrate[key]!(value);
        await _prefs!.remove(key);
      }
    }
  }

  Future<void> _load() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _prefs = await SharedPreferences.getInstance();
      if (_profileId != null && _prefs!.containsKey(_unlockedCountKey)) {
        await _migrateLegacyData();
      }

      _unlockedCount = _prefs?.getInt(_getProfileKey(_unlockedCountKey)) ?? 1;
      final raw = _prefs?.getString(_getProfileKey(_storageKey));
      if (raw != null && raw.isNotEmpty) {
        final Map data = json.decode(raw) as Map;
        _bestStarsByLesson.clear();
        data.forEach((k, v) {
          final stars = (v is int) ? v : int.tryParse(v.toString()) ?? 0;
          _bestStarsByLesson[k.toString()] = stars.clamp(0, 3);
        });
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
      await _prefs?.setInt(_getProfileKey(_unlockedCountKey), _unlockedCount);
      final jsonMap = _bestStarsByLesson.map((k, v) => MapEntry(k, v));
      await _prefs?.setString(_getProfileKey(_storageKey), json.encode(jsonMap));
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

    // Sync data if in a room
    if (syncService.isInRoom) {
      await syncService.syncData('lesson_progress', getExportData());
    }
  }

  /// Ensures at least [count] lessons are unlocked (used when lesson list shorter/longer changes).
  Future<void> ensureUnlockedCountAtLeast(int count) async {
    if (count > _unlockedCount) {
      _unlockedCount = count;
      await _persist();
      notifyListeners();
    }
  
    /// Joins a sync room
    Future<bool> joinSyncRoom(String code) async {
      return await syncService.joinRoom(code);
    }
  
    /// Leaves the sync room
    Future<void> leaveSyncRoom() async {
      await syncService.leaveRoom();
    }
  
    /// Sets up sync listener
    void setupSyncListener() {
      syncService.addListener('lesson_progress', (data) {
        loadImportData(data);
      });
    }
  }

  /// Resets all lesson progress.
  Future<void> resetAll() async {
    _unlockedCount = 1;
    _bestStarsByLesson.clear();
    await _persist();
    notifyListeners();
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
    _unlockedCount = data['unlockedCount'] ?? 1;
    _bestStarsByLesson.clear();
    final bestStars = Map<String, int>.from(data['bestStarsByLesson'] ?? {});
    bestStars.forEach((k, v) {
      _bestStarsByLesson[k] = v.clamp(0, 3);
    });

    await _persist();
    notifyListeners();
  }
}