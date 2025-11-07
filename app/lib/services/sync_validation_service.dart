import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/logger.dart';
import '../error/error_handler.dart';
import '../error/error_types.dart';

/// Service for data validation and error recovery in sync operations
class SyncValidationService {
  static const int MAX_DATA_SIZE = 1024 * 1024; // 1MB max data size
  static const int MAX_STRING_LENGTH = 10000; // Max string length
  static const int MAX_MAP_ENTRIES = 1000; // Max map entries
  
  /// Validates data before sync to prevent corruption
  static bool validateDataForSync(Map<String, dynamic> data, String dataType) {
    try {
      // Basic null check
      if (data == null) {
        AppLogger.warning('Data is null for sync: $dataType');
        return false;
      }
      
      // Check data size
      final jsonString = json.encode(data);
      if (jsonString.length > MAX_DATA_SIZE) {
        AppLogger.warning('Data too large for sync: $dataType, size: ${jsonString.length} bytes');
        return false;
      }
      
      // Type-specific validation
      switch (dataType) {
        case 'game_stats':
          return _validateGameStats(data);
        case 'lesson_progress':
          return _validateLessonProgress(data);
        case 'settings':
          return _validateSettings(data);
        default:
          AppLogger.debug('Unknown data type for validation: $dataType');
          return _validateGenericData(data);
      }
    } catch (e) {
      AppLogger.error('Error during data validation: $e');
      return false;
    }
  }
  
  /// Validates game stats data
  static bool _validateGameStats(Map<String, dynamic> data) {
    try {
      // Check required fields
      final score = data['score'];
      final currentStreak = data['currentStreak'];
      final longestStreak = data['longestStreak'];
      final incorrectAnswers = data['incorrectAnswers'];
      
      if (score == null || currentStreak == null || longestStreak == null || incorrectAnswers == null) {
        AppLogger.warning('Missing required fields in game stats');
        return false;
      }
      
      // Validate types
      if (score is! int || currentStreak is! int || longestStreak is! int || incorrectAnswers is! int) {
        AppLogger.warning('Invalid types in game stats');
        return false;
      }
      
      // Validate ranges
      if (score < 0 || currentStreak < 0 || longestStreak < 0 || incorrectAnswers < 0) {
        AppLogger.warning('Negative values in game stats');
        return false;
      }
      
      // Business logic validation
      if (currentStreak > longestStreak) {
        AppLogger.warning('Current streak cannot be greater than longest streak');
        return false;
      }
      
      // Reasonable limits
      if (score > 1000000 || longestStreak > 10000 || incorrectAnswers > 10000) {
        AppLogger.warning('Unreasonable values in game stats');
        return false;
      }
      
      return true;
    } catch (e) {
      AppLogger.error('Error validating game stats', e);
      return false;
    }
  }
  
  /// Validates lesson progress data
  static bool _validateLessonProgress(Map<String, dynamic> data) {
    try {
      final unlockedCount = data['unlockedCount'];
      final bestStarsByLesson = data['bestStarsByLesson'];
      
      if (unlockedCount == null || bestStarsByLesson == null) {
        AppLogger.warning('Missing required fields in lesson progress');
        return false;
      }
      
      // Validate types
      if (unlockedCount is! int || bestStarsByLesson is! Map) {
        AppLogger.warning('Invalid types in lesson progress');
        return false;
      }
      
      // Validate ranges
      if (unlockedCount < 0 || unlockedCount > 1000) {
        AppLogger.warning('Invalid unlocked count: $unlockedCount');
        return false;
      }
      
      // Validate best stars data
      final Map<String, int> starsMap = Map<String, int>.from(bestStarsByLesson);
      for (final entry in starsMap.entries) {
        final lessonId = entry.key;
        final stars = entry.value;
        
        // Check lesson ID
        if (lessonId.isEmpty || lessonId.length > 100) {
          AppLogger.warning('Invalid lesson ID: $lessonId');
          return false;
        }
        
        // Check stars range
        if (stars < 0 || stars > 3) {
          AppLogger.warning('Invalid stars value for lesson $lessonId: $stars');
          return false;
        }
      }
      
      // Check map size
      if (starsMap.length > MAX_MAP_ENTRIES) {
        AppLogger.warning('Too many lessons in progress data: ${starsMap.length}');
        return false;
      }
      
      return true;
    } catch (e) {
      AppLogger.error('Error validating lesson progress', e);
      return false;
    }
  }
  
  /// Validates settings data
  static bool _validateSettings(Map<String, dynamic> data) {
    try {
      // Validate theme mode
      final themeMode = data['themeMode'];
      if (themeMode != null && (themeMode is! int || themeMode < 0 || themeMode > 2)) {
        AppLogger.warning('Invalid theme mode: $themeMode');
        return false;
      }
      
      // Validate game speed
      final gameSpeed = data['gameSpeed'];
      if (gameSpeed != null && gameSpeed is! String) {
        AppLogger.warning('Invalid game speed type: ${gameSpeed.runtimeType}');
        return false;
      }
      if (gameSpeed != null && !['slow', 'medium', 'fast'].contains(gameSpeed)) {
        AppLogger.warning('Invalid game speed value: $gameSpeed');
        return false;
      }
      
      // Validate string fields
      final stringFields = ['selectedCustomThemeKey', 'difficultyPreference', 'apiKey'];
      for (final field in stringFields) {
        final value = data[field];
        if (value != null && (value is! String || value.length > MAX_STRING_LENGTH)) {
          AppLogger.warning('Invalid $field: ${value?.runtimeType}');
          return false;
        }
      }
      
      // Validate API port
      final apiPort = data['apiPort'];
      if (apiPort != null && (apiPort is! int || apiPort < 1024 || apiPort > 65535)) {
        AppLogger.warning('Invalid API port: $apiPort');
        return false;
      }
      
      // Validate boolean fields
      final boolFields = [
        'hasSeenGuide', 'mute', 'notificationEnabled', 'hasDonated',
        'hasCheckedForUpdate', 'hasClickedDonationLink', 'hasClickedFollowLink',
        'hasClickedSatisfactionLink', 'hasClickedDifficultyLink', 'analyticsEnabled',
        'apiEnabled', 'showNavigationLabels', 'colorfulMode', 'hidePromoCard'
      ];
      
      for (final field in boolFields) {
        final value = data[field];
        if (value != null && value is! bool) {
          AppLogger.warning('Invalid boolean field $field: ${value?.runtimeType}');
          return false;
        }
      }
      
      // Validate unlocked themes
      final unlockedThemes = data['unlockedThemes'];
      if (unlockedThemes != null) {
        if (unlockedThemes is! List) {
          AppLogger.warning('Invalid unlocked themes type: ${unlockedThemes.runtimeType}');
          return false;
        }
        
        for (final theme in unlockedThemes) {
          if (theme is! String || theme.isEmpty || theme.length > 100) {
            AppLogger.warning('Invalid theme in unlocked list: $theme');
            return false;
          }
        }
      }
      
      return true;
    } catch (e) {
      AppLogger.error('Error validating settings', e);
      return false;
    }
  }
  
  /// Validates generic data structure
  static bool _validateGenericData(Map<String, dynamic> data) {
    try {
      // Check for null values
      for (final entry in data.entries) {
        if (entry.value == null) {
          AppLogger.warning('Null value found in generic data for key: ${entry.key}');
          return false;
        }
        
        // Check string length
        if (entry.value is String && entry.value.length > MAX_STRING_LENGTH) {
          AppLogger.warning('String too long for key: ${entry.key}');
          return false;
        }
        
        // Check map depth
        if (entry.value is Map) {
          if (!_validateMapDepth(entry.value, 5)) { // Max 5 levels deep
            AppLogger.warning('Map too deep for key: ${entry.key}');
            return false;
          }
        }
      }
      
      return true;
    } catch (e) {
      AppLogger.error('Error validating generic data', e);
      return false;
    }
  }
  
  /// Validates map depth to prevent infinite nesting
  static bool _validateMapDepth(dynamic data, int maxDepth) {
    if (maxDepth <= 0) return false;
    
    if (data is Map) {
      for (final value in data.values) {
        if (value is Map) {
          if (!_validateMapDepth(value, maxDepth - 1)) {
            return false;
          }
        }
      }
    }
    
    return true;
  }
  
  /// Sanitizes data to fix common issues
  static Map<String, dynamic>? sanitizeData(Map<String, dynamic> data, String dataType) {
    try {
      switch (dataType) {
        case 'game_stats':
          return _sanitizeGameStats(data);
        case 'lesson_progress':
          return _sanitizeLessonProgress(data);
        case 'settings':
          return _sanitizeSettings(data);
        default:
          return _sanitizeGenericData(data);
      }
    } catch (e) {
      AppLogger.error('Error sanitizing data: $dataType', e);
      return null;
    }
  }
  
  /// Sanitizes game stats data
  static Map<String, dynamic>? _sanitizeGameStats(Map<String, dynamic> data) {
    try {
      final sanitized = Map<String, dynamic>.from(data);
      
      // Ensure all required fields exist with safe defaults
      sanitized['score'] = _sanitizeInt(data['score'], 0, 0, 1000000);
      sanitized['currentStreak'] = _sanitizeInt(data['currentStreak'], 0, 0, 10000);
      sanitized['longestStreak'] = _sanitizeInt(data['longestStreak'], 0, 0, 10000);
      sanitized['incorrectAnswers'] = _sanitizeInt(data['incorrectAnswers'], 0, 0, 10000);
      
      // Ensure current streak doesn't exceed longest streak
      if (sanitized['currentStreak'] > sanitized['longestStreak']) {
        sanitized['currentStreak'] = sanitized['longestStreak'];
      }
      
      return sanitized;
    } catch (e) {
      AppLogger.error('Error sanitizing game stats', e);
      return null;
    }
  }
  
  /// Sanitizes lesson progress data
  static Map<String, dynamic>? _sanitizeLessonProgress(Map<String, dynamic> data) {
    try {
      final sanitized = Map<String, dynamic>.from(data);
      
      // Sanitize unlocked count
      sanitized['unlockedCount'] = _sanitizeInt(data['unlockedCount'], 1, 0, 1000);
      
      // Sanitize best stars by lesson
      final bestStarsByLesson = data['bestStarsByLesson'];
      if (bestStarsByLesson is Map) {
        final sanitizedStars = <String, int>{};
        
        for (final entry in bestStarsByLesson.entries) {
          final lessonId = _sanitizeString(entry.key, 100);
          final stars = _sanitizeInt(entry.value, 0, 0, 3);
          
          if (lessonId != null) {
            sanitizedStars[lessonId] = stars;
          }
        }
        
        sanitized['bestStarsByLesson'] = sanitizedStars;
      } else {
        sanitized['bestStarsByLesson'] = <String, int>{};
      }
      
      return sanitized;
    } catch (e) {
      AppLogger.error('Error sanitizing lesson progress', e);
      return null;
    }
  }
  
  /// Sanitizes settings data
  static Map<String, dynamic>? _sanitizeSettings(Map<String, dynamic> data) {
    try {
      final sanitized = Map<String, dynamic>.from(data);
      
      // Sanitize theme mode
      final themeMode = data['themeMode'];
      if (themeMode is int && themeMode >= 0 && themeMode <= 2) {
        sanitized['themeMode'] = themeMode;
      } else {
        sanitized['themeMode'] = 0; // Default to system
      }
      
      // Sanitize game speed
      final gameSpeed = data['gameSpeed'];
      if (gameSpeed is String && ['slow', 'medium', 'fast'].contains(gameSpeed)) {
        sanitized['gameSpeed'] = gameSpeed;
      } else {
        sanitized['gameSpeed'] = 'medium'; // Default
      }
      
      // Sanitize string fields
      final stringFields = ['selectedCustomThemeKey', 'difficultyPreference', 'apiKey'];
      for (final field in stringFields) {
        final value = data[field];
        if (value is String) {
          sanitized[field] = _sanitizeString(value, MAX_STRING_LENGTH);
        } else {
          sanitized[field] = null;
        }
      }
      
      // Sanitize API port
      final apiPort = data['apiPort'];
      if (apiPort is int && apiPort >= 1024 && apiPort <= 65535) {
        sanitized['apiPort'] = apiPort;
      } else {
        sanitized['apiPort'] = 7777; // Default
      }
      
      // Sanitize boolean fields
      final boolFields = [
        'hasSeenGuide', 'mute', 'notificationEnabled', 'hasDonated',
        'hasCheckedForUpdate', 'hasClickedDonationLink', 'hasClickedFollowLink',
        'hasClickedSatisfactionLink', 'hasClickedDifficultyLink', 'analyticsEnabled',
        'apiEnabled', 'showNavigationLabels', 'colorfulMode', 'hidePromoCard'
      ];
      
      for (final field in boolFields) {
        final value = data[field];
        sanitized[field] = (value is bool) ? value : false;
      }
      
      // Sanitize unlocked themes
      final unlockedThemes = data['unlockedThemes'];
      if (unlockedThemes is List) {
        final sanitizedThemes = <String>[];
        for (final theme in unlockedThemes) {
          if (theme is String) {
            final sanitizedTheme = _sanitizeString(theme, 100);
            if (sanitizedTheme != null && sanitizedTheme.isNotEmpty) {
              sanitizedThemes.add(sanitizedTheme);
            }
          }
        }
        sanitized['unlockedThemes'] = sanitizedThemes;
      } else {
        sanitized['unlockedThemes'] = <String>[];
      }
      
      return sanitized;
    } catch (e) {
      AppLogger.error('Error sanitizing settings', e);
      return null;
    }
  }
  
  /// Sanitizes generic data
  static Map<String, dynamic>? _sanitizeGenericData(Map<String, dynamic> data) {
    try {
      final sanitized = <String, dynamic>{};
      
      for (final entry in data.entries) {
        final key = _sanitizeString(entry.key, 100);
        if (key != null) {
          final value = entry.value;
          
          if (value is String) {
            final sanitizedValue = _sanitizeString(value, MAX_STRING_LENGTH);
            if (sanitizedValue != null) {
              sanitized[key] = sanitizedValue;
            }
          } else if (value is int) {
            sanitized[key] = value.clamp(-1000000, 1000000);
          } else if (value is double) {
            sanitized[key] = value.clamp(-1000000.0, 1000000.0);
          } else if (value is bool) {
            sanitized[key] = value;
          } else if (value is List) {
            sanitized[key] = value.take(1000).toList(); // Limit list size
          } else if (value is Map) {
            // Recursively sanitize nested maps with depth limit
            if (_validateMapDepth(value, 3)) {
              final sanitizedMap = _sanitizeGenericData(Map<String, dynamic>.from(value));
              if (sanitizedMap != null) {
                sanitized[key] = sanitizedMap;
              }
            }
          }
        }
      }
      
      return sanitized;
    } catch (e) {
      AppLogger.error('Error sanitizing generic data', e);
      return null;
    }
  }
  
  /// Sanitizes an integer value
  static int _sanitizeInt(dynamic value, int defaultValue, int min, int max) {
    if (value is int) {
      return value.clamp(min, max);
    } else if (value is double) {
      return value.round().clamp(min, max);
    } else if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) {
        return parsed.clamp(min, max);
      }
    }
    return defaultValue.clamp(min, max);
  }
  
  /// Sanitizes a string value
  static String? _sanitizeString(dynamic value, int maxLength) {
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty && trimmed.length <= maxLength) {
        return trimmed;
      }
    }
    return null;
  }
  
  /// Creates a backup of data before syncing
  static Map<String, dynamic>? createBackup(Map<String, dynamic> data, String dataType) {
    try {
      return {
        'original_data': data,
        'timestamp': DateTime.now().toIso8601String(),
        'data_type': dataType,
        'size': json.encode(data).length,
      };
    } catch (e) {
      AppLogger.error('Failed to create backup', e);
      return null;
    }
  }
  
  /// Restores data from backup if sync fails
  static Map<String, dynamic>? restoreFromBackup(Map<String, dynamic> backup) {
    try {
      final originalData = backup['original_data'];
      if (originalData is Map<String, dynamic>) {
        AppLogger.info('Restored data from backup');
        return originalData;
      }
      return null;
    } catch (e) {
      AppLogger.error('Failed to restore from backup', e);
      return null;
    }
  }
  
  /// Reports sync data issues to the error reporting system
  static void reportDataIssue(String operation, String dataType, String issue, Map<String, dynamic>? data) {
    final context = {
      'operation': operation,
      'data_type': dataType,
      'issue': issue,
      'data_size': data != null ? json.encode(data).length : 0,
    };
    
    AppLogger.warning('Sync data issue: $operation - $dataType - $issue');
    
    // Use the error reporting system if available
    try {
      final errorHandler = ErrorHandler();
      // Note: This would need to be adapted based on the actual error reporting interface
    } catch (e) {
      AppLogger.error('Failed to report data issue', e);
    }
  }
}