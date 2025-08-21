import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the app's settings including language and theme preferences
class SettingsProvider extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  static const String _customThemeKey = 'custom_theme';
  static const String _unlockedThemesKey = 'unlocked_themes';
  static const String _slowModeKey = 'game_speed';
  static const String _hasSeenGuideKey = 'has_seen_guide';
  static const String _muteKey = 'mute';
  static const String _hapticFeedbackKey = 'haptic_feedback';
  static const String _notificationEnabledKey = 'notification_enabled';
  static const String _hasDonatedKey = 'has_donated';
  static const String _hasCheckedForUpdateKey = 'has_checked_for_update';
  
  SharedPreferences? _prefs;
  String _language = 'nl';
  ThemeMode _themeMode = ThemeMode.system;
  String _gameSpeed = 'medium'; // 'slow', 'medium', 'fast'
  bool _hasSeenGuide = false;
  bool _mute = false;
  String _hapticFeedback = 'medium'; // 'disabled', 'soft', 'medium'
  bool _notificationEnabled = true;
  bool _hasDonated = false;
  bool _hasCheckedForUpdate = false;
  bool _isLoading = true;
  String? _error;
  String? _selectedCustomThemeKey;
  Set<String> _unlockedThemes = {};
  


  SettingsProvider() {
    _loadSettings();
  }

  /// De huidige taalinstelling (altijd 'nl')
  String get language => _language;
  
  /// The current theme mode setting
  ThemeMode get themeMode => _themeMode;
  
  /// The current game speed setting
  String get gameSpeed => _gameSpeed;
  
  /// Whether slow mode is enabled (backward compatibility)
  bool get slowMode => _gameSpeed == 'slow';

  /// Whether the user has seen the guide
  bool get hasSeenGuide => _hasSeenGuide;

  /// Whether sound effects are muted
  bool get mute => _mute;

  /// The current haptic feedback setting
  String get hapticFeedback => _hapticFeedback;
  
  /// Whether settings are currently being loaded
  bool get isLoading => _isLoading;
  
  /// Any error that occurred while loading settings
  String? get error => _error;

  /// Whether notifications are enabled
  bool get notificationEnabled => _notificationEnabled;
  bool get hasDonated => _hasDonated;
  bool get hasCheckedForUpdate => _hasCheckedForUpdate;

  String? get selectedCustomThemeKey => _selectedCustomThemeKey;
  Set<String> get unlockedThemes => _unlockedThemes;

  bool isThemeUnlocked(String key) => _unlockedThemes.contains(key);

  Future<void> unlockTheme(String key) async {
    if (!_unlockedThemes.contains(key)) {
      _unlockedThemes.add(key);
      await _prefs?.setStringList(_unlockedThemesKey, _unlockedThemes.toList());
      notifyListeners();
    }
  }

  Future<void> setCustomTheme(String? key) async {
    _selectedCustomThemeKey = key;
    await _prefs?.setString(_customThemeKey, key ?? '');
    notifyListeners();
  }

  /// Loads settings from persistent storage
  Future<void> _loadSettings() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _prefs = await SharedPreferences.getInstance();
      // Altijd Nederlands forceren
      _language = 'nl';
      final themeModeIndex = _prefs?.getInt(_themeModeKey) ?? 0;
      _themeMode = ThemeMode.values[themeModeIndex];
      // Load old boolean slow mode setting for backward compatibility
      final oldSlowMode = _getBoolSetting(_slowModeKey, defaultValue: false);
      _gameSpeed = oldSlowMode ? 'slow' : 'medium';
      
      // Migrate to new string-based setting if needed
      if (oldSlowMode) {
        await _prefs?.setString(_slowModeKey, 'slow');
      }
      // Safely load boolean settings with type checking
      _hasSeenGuide = _getBoolSetting(_hasSeenGuideKey, defaultValue: false);
      _mute = _getBoolSetting(_muteKey, defaultValue: false);
      _hapticFeedback = _prefs?.getString(_hapticFeedbackKey) ?? 'medium';
      _notificationEnabled = _getBoolSetting(_notificationEnabledKey, defaultValue: true);
      _hasDonated = _getBoolSetting(_hasDonatedKey, defaultValue: false);
      _hasCheckedForUpdate = _getBoolSetting(_hasCheckedForUpdateKey, defaultValue: false);
      final unlocked = _prefs?.getStringList(_unlockedThemesKey);
      if (unlocked != null) {
        _unlockedThemes = unlocked.toSet();
      } else {
        _unlockedThemes = {};
      }
      // Fix: treat empty string as null for custom theme
      final loadedCustomTheme = _prefs?.getString(_customThemeKey);
      _selectedCustomThemeKey = (loadedCustomTheme == null || loadedCustomTheme.isEmpty) ? null : loadedCustomTheme;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update de taalinstelling (alleen 'nl' toegestaan)
  Future<void> setLanguage(String language) async {
    if (language != 'nl') {
      throw ArgumentError('Taal moet "nl" zijn (alleen Nederlands toegestaan)');
    }
    // Geen effect, altijd Nederlands
    notifyListeners();
  }

  /// Updates the theme mode setting
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      _themeMode = mode;
      await _prefs?.setInt(_themeModeKey, mode.index);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save theme setting: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  /// Updates the slow mode setting (backward compatibility)
  Future<void> setSlowMode(bool enabled) async {
    try {
      _gameSpeed = enabled ? 'slow' : 'medium';
      await _prefs?.setString(_slowModeKey, _gameSpeed);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save slow mode setting: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }
  
  /// Updates the game speed setting
  Future<void> setGameSpeed(String speed) async {
    if (speed != 'slow' && speed != 'medium' && speed != 'fast') {
      throw ArgumentError('Game speed must be "slow", "medium", or "fast"');
    }

    try {
      _gameSpeed = speed;
      await _prefs?.setString(_slowModeKey, speed);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save game speed setting: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  /// Updates the mute setting
  /// Marks that the user has made a donation
  Future<void> markAsDonated() async {
    try {
      _hasDonated = true;
      await _prefs?.setBool(_hasDonatedKey, true);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update donation status: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  /// Marks that we've checked for updates
  Future<void> setHasCheckedForUpdate(bool checked) async {
    try {
      _hasCheckedForUpdate = checked;
      await _prefs?.setBool(_hasCheckedForUpdateKey, checked);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update check for update status: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> setMute(bool enabled) async {
    try {
      _mute = enabled;
      await _prefs?.setBool(_muteKey, enabled);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save mute setting: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  /// Updates the haptic feedback setting
  Future<void> setHapticFeedback(String level) async {
    if (level != 'disabled' && level != 'soft' && level != 'medium') {
      throw ArgumentError('Haptic feedback level must be "disabled", "soft", or "medium"');
    }

    try {
      _hapticFeedback = level;
      await _prefs?.setString(_hapticFeedbackKey, level);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save haptic feedback setting: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }



  /// Marks the guide as seen
  Future<void> markGuideAsSeen() async {
    try {
      _prefs ??= await SharedPreferences.getInstance(); // Ensure _prefs is initialized
      _hasSeenGuide = true;
      await _prefs!.setBool(_hasSeenGuideKey, true);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save guide status: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  /// Resets the guide status so it can be shown again
  Future<void> resetGuideStatus() async {
    try {
      _prefs ??= await SharedPreferences.getInstance(); // Ensure _prefs is initialized
      _hasSeenGuide = false;
      await _prefs!.setBool(_hasSeenGuideKey, false);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to reset guide status: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }



  /// Reloads settings from persistent storage
  Future<void> reloadSettings() async {
    await _loadSettings();
  }

  /// Resets the check for update status so it can check again
  Future<void> resetCheckForUpdateStatus() async {
    try {
      _hasCheckedForUpdate = false;
      await _prefs?.setBool(_hasCheckedForUpdateKey, false);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to reset check for update status: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    try {
      _notificationEnabled = enabled;
      await _prefs?.setBool(_notificationEnabledKey, enabled);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save notification setting: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }
  
  // Helper method to safely get a boolean setting with type checking
  bool _getBoolSetting(String key, {required bool defaultValue}) {
    try {
      final value = _prefs?.get(key);
      if (value is bool) {
        return value;
      } else if (value is String) {
        // Handle case where boolean was saved as a string
        return value.toLowerCase() == 'true';
      } else if (value is int) {
        // Handle case where boolean was saved as an integer (0 or 1)
        return value == 1;
      }
      return defaultValue;
    } catch (e) {
      // If there's any error, return the default value
      return defaultValue;
    }
  }
} 