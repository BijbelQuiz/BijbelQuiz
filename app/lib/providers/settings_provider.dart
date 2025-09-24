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
  static const String _notificationEnabledKey = 'notification_enabled';
  static const String _hasDonatedKey = 'has_donated';
  static const String _hasCheckedForUpdateKey = 'has_checked_for_update';
  static const String _lastDonationPopupKey = 'last_donation_popup';
  static const String _lastFollowPopupKey = 'last_follow_popup';
  static const String _lastSatisfactionPopupKey = 'last_satisfaction_popup';
  static const String _hasClickedDonationLinkKey = 'has_clicked_donation_link';
  static const String _hasClickedFollowLinkKey = 'has_clicked_follow_link';
  static const String _hasClickedSatisfactionLinkKey = 'has_clicked_satisfaction_link';
  static const String _lastDifficultyPopupKey = 'last_difficulty_popup';
  static const String _hasClickedDifficultyLinkKey = 'has_clicked_difficulty_link';
  static const String _difficultyPreferenceKey = 'difficulty_preference';
  static const String _analyticsEnabledKey = 'analytics_enabled';
  
  SharedPreferences? _prefs;
  String _language = 'nl';
  ThemeMode _themeMode = ThemeMode.system;
  String _gameSpeed = 'medium'; // 'slow', 'medium', 'fast'
  bool _hasSeenGuide = false;
  bool _mute = false;
  bool _notificationEnabled = true;
  bool _hasDonated = false;
  bool _hasCheckedForUpdate = false;
  DateTime? _lastDonationPopup;
  DateTime? _lastFollowPopup;
  DateTime? _lastSatisfactionPopup;
  DateTime? _lastDifficultyPopup;
  String? _difficultyPreference;
  bool _hasClickedDonationLink = false;
  bool _hasClickedFollowLink = false;
  bool _hasClickedSatisfactionLink = false;
  bool _hasClickedDifficultyLink = false;
  bool _analyticsEnabled = true; // Default to true to maintain current behavior
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

  /// Whether settings are currently being loaded
  bool get isLoading => _isLoading;
  
  /// Any error that occurred while loading settings
  String? get error => _error;

  /// Whether notifications are enabled
  bool get notificationEnabled => _notificationEnabled;
  bool get hasDonated => _hasDonated;
  bool get hasCheckedForUpdate => _hasCheckedForUpdate;
  DateTime? get lastDonationPopup => _lastDonationPopup;
  DateTime? get lastFollowPopup => _lastFollowPopup;
  DateTime? get lastSatisfactionPopup => _lastSatisfactionPopup;
  DateTime? get lastDifficultyPopup => _lastDifficultyPopup;
  String? get difficultyPreference => _difficultyPreference;
  bool get hasClickedDonationLink => _hasClickedDonationLink;
  bool get hasClickedFollowLink => _hasClickedFollowLink;
  bool get hasClickedSatisfactionLink => _hasClickedSatisfactionLink;
  bool get hasClickedDifficultyLink => _hasClickedDifficultyLink;
  
  /// Whether analytics are enabled
  bool get analyticsEnabled => _analyticsEnabled;

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

  /// Helper method to safely save settings with error handling
  Future<void> _saveSetting({
    required Future<void> Function() action,
    required String errorMessage,
  }) async {
    try {
      await action();
      notifyListeners();
    } catch (e) {
      _error = '$errorMessage: ${e.toString()}';
      notifyListeners();
      rethrow;
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
      
      // Load new string-based game speed setting if it exists
      final storedGameSpeed = _prefs?.getString(_slowModeKey);
      if (storedGameSpeed != null && storedGameSpeed.isNotEmpty) {
        // Validate the game speed value
        if (storedGameSpeed == 'slow' || storedGameSpeed == 'medium' || storedGameSpeed == 'fast') {
          _gameSpeed = storedGameSpeed;
        }
      }
      // Safely load boolean settings with type checking
      _hasSeenGuide = _getBoolSetting(_hasSeenGuideKey, defaultValue: false);
      _mute = _getBoolSetting(_muteKey, defaultValue: false);
      _notificationEnabled = _getBoolSetting(_notificationEnabledKey, defaultValue: true);
      _hasDonated = _getBoolSetting(_hasDonatedKey, defaultValue: false);
      _hasCheckedForUpdate = _getBoolSetting(_hasCheckedForUpdateKey, defaultValue: false);
      _analyticsEnabled = _getBoolSetting(_analyticsEnabledKey, defaultValue: true); // Default to true
      
      // Load popup tracking data
      final lastDonationPopupMs = _prefs?.getInt(_lastDonationPopupKey);
      _lastDonationPopup = lastDonationPopupMs != null ? DateTime.fromMillisecondsSinceEpoch(lastDonationPopupMs) : null;
      
      final lastFollowPopupMs = _prefs?.getInt(_lastFollowPopupKey);
      _lastFollowPopup = lastFollowPopupMs != null ? DateTime.fromMillisecondsSinceEpoch(lastFollowPopupMs) : null;
      
      final lastSatisfactionPopupMs = _prefs?.getInt(_lastSatisfactionPopupKey);
      _lastSatisfactionPopup = lastSatisfactionPopupMs != null ? DateTime.fromMillisecondsSinceEpoch(lastSatisfactionPopupMs) : null;
      
      final lastDifficultyPopupMs = _prefs?.getInt(_lastDifficultyPopupKey);
      _lastDifficultyPopup = lastDifficultyPopupMs != null ? DateTime.fromMillisecondsSinceEpoch(lastDifficultyPopupMs) : null;
      
      _difficultyPreference = _prefs?.getString(_difficultyPreferenceKey);
      
      _hasClickedDonationLink = _getBoolSetting(_hasClickedDonationLinkKey, defaultValue: false);
      _hasClickedFollowLink = _getBoolSetting(_hasClickedFollowLinkKey, defaultValue: false);
      _hasClickedSatisfactionLink = _getBoolSetting(_hasClickedSatisfactionLinkKey, defaultValue: false);
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
    await _saveSetting(
      action: () async {
        _themeMode = mode;
        await _prefs?.setInt(_themeModeKey, mode.index);
      },
      errorMessage: 'Failed to save theme setting',
    );
  }

  /// Updates the slow mode setting (backward compatibility)
  Future<void> setSlowMode(bool enabled) async {
    await _saveSetting(
      action: () async {
        _gameSpeed = enabled ? 'slow' : 'medium';
        await _prefs?.setString(_slowModeKey, _gameSpeed);
      },
      errorMessage: 'Failed to save slow mode setting',
    );
  }

  /// Updates the game speed setting
  Future<void> setGameSpeed(String speed) async {
    if (speed != 'slow' && speed != 'medium' && speed != 'fast') {
      throw ArgumentError('Game speed must be "slow", "medium", or "fast"');
    }

    await _saveSetting(
      action: () async {
        _gameSpeed = speed;
        await _prefs?.setString(_slowModeKey, speed);
      },
      errorMessage: 'Failed to save game speed setting',
    );
  }

  /// Updates the mute setting
  Future<void> setMute(bool enabled) async {
    await _saveSetting(
      action: () async {
        _mute = enabled;
        await _prefs?.setBool(_muteKey, enabled);
      },
      errorMessage: 'Failed to save mute setting',
    );
  }

  /// Marks that the user has made a donation
  Future<void> markAsDonated() async {
    await _saveSetting(
      action: () async {
        _hasDonated = true;
        await _prefs?.setBool(_hasDonatedKey, true);
      },
      errorMessage: 'Failed to update donation status',
    );
  }

  /// Marks that we've checked for updates
  Future<void> setHasCheckedForUpdate(bool checked) async {
    await _saveSetting(
      action: () async {
        _hasCheckedForUpdate = checked;
        await _prefs?.setBool(_hasCheckedForUpdateKey, checked);
      },
      errorMessage: 'Failed to update check for update status',
    );
  }

  /// Marks the guide as seen
  Future<void> markGuideAsSeen() async {
    await _saveSetting(
      action: () async {
        _prefs ??= await SharedPreferences.getInstance(); // Ensure _prefs is initialized
        _hasSeenGuide = true;
        await _prefs!.setBool(_hasSeenGuideKey, true);
      },
      errorMessage: 'Failed to save guide status',
    );
  }

  /// Resets the guide status so it can be shown again
  Future<void> resetGuideStatus() async {
    await _saveSetting(
      action: () async {
        _prefs ??= await SharedPreferences.getInstance(); // Ensure _prefs is initialized
        _hasSeenGuide = false;
        await _prefs!.setBool(_hasSeenGuideKey, false);
      },
      errorMessage: 'Failed to reset guide status',
    );
  }



  /// Reloads settings from persistent storage
  Future<void> reloadSettings() async {
    await _loadSettings();
  }

  /// Resets the check for update status so it can check again
  Future<void> resetCheckForUpdateStatus() async {
    await _saveSetting(
      action: () async {
        _hasCheckedForUpdate = false;
        await _prefs?.setBool(_hasCheckedForUpdateKey, false);
      },
      errorMessage: 'Failed to reset check for update status',
    );
  }

  /// Updates the last donation popup timestamp
  Future<void> updateLastDonationPopup() async {
    await _saveSetting(
      action: () async {
        _lastDonationPopup = DateTime.now();
        await _prefs?.setInt(_lastDonationPopupKey, _lastDonationPopup!.millisecondsSinceEpoch);
      },
      errorMessage: 'Failed to update donation popup timestamp',
    );
  }

  /// Updates the last follow popup timestamp
  Future<void> updateLastFollowPopup() async {
    await _saveSetting(
      action: () async {
        _lastFollowPopup = DateTime.now();
        await _prefs?.setInt(_lastFollowPopupKey, _lastFollowPopup!.millisecondsSinceEpoch);
      },
      errorMessage: 'Failed to update follow popup timestamp',
    );
  }

  /// Updates the last satisfaction popup timestamp
  Future<void> updateLastSatisfactionPopup() async {
    await _saveSetting(
      action: () async {
        _lastSatisfactionPopup = DateTime.now();
        await _prefs?.setInt(_lastSatisfactionPopupKey, _lastSatisfactionPopup!.millisecondsSinceEpoch);
      },
      errorMessage: 'Failed to update satisfaction popup timestamp',
    );
  }

  /// Updates the last difficulty popup timestamp
  Future<void> updateLastDifficultyPopup() async {
    await _saveSetting(
      action: () async {
        _lastDifficultyPopup = DateTime.now();
        await _prefs?.setInt(_lastDifficultyPopupKey, _lastDifficultyPopup!.millisecondsSinceEpoch);
      },
      errorMessage: 'Failed to update difficulty popup timestamp',
    );
  }

  /// Marks that the user has clicked the donation link
  Future<void> markDonationLinkAsClicked() async {
    await _saveSetting(
      action: () async {
        _hasClickedDonationLink = true;
        await _prefs?.setBool(_hasClickedDonationLinkKey, true);
      },
      errorMessage: 'Failed to update donation link status',
    );
  }

  /// Marks that the user has clicked a follow link
  Future<void> markFollowLinkAsClicked() async {
    await _saveSetting(
      action: () async {
        _hasClickedFollowLink = true;
        await _prefs?.setBool(_hasClickedFollowLinkKey, true);
      },
      errorMessage: 'Failed to update follow link status',
    );
  }

  /// Marks that the user has clicked the satisfaction survey link
  Future<void> markSatisfactionLinkAsClicked() async {
    await _saveSetting(
      action: () async {
        _hasClickedSatisfactionLink = true;
        await _prefs?.setBool(_hasClickedSatisfactionLinkKey, true);
      },
      errorMessage: 'Failed to update satisfaction link status',
    );
  }

  /// Marks that the user has clicked the difficulty feedback link
  Future<void> markDifficultyLinkAsClicked() async {
    await _saveSetting(
      action: () async {
        _hasClickedDifficultyLink = true;
        await _prefs?.setBool(_hasClickedDifficultyLinkKey, true);
      },
      errorMessage: 'Failed to update difficulty link status',
    );
  }

  /// Sets the user's difficulty preference
  Future<void> setDifficultyPreference(String? preference) async {
    await _saveSetting(
      action: () async {
        _difficultyPreference = preference;
        if (preference != null) {
          await _prefs?.setString(_difficultyPreferenceKey, preference);
        } else {
          await _prefs?.remove(_difficultyPreferenceKey);
        }
      },
      errorMessage: 'Failed to update difficulty preference',
    );
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    await _saveSetting(
      action: () async {
        _notificationEnabled = enabled;
        await _prefs?.setBool(_notificationEnabledKey, enabled);
      },
      errorMessage: 'Failed to save notification setting',
    );
  }

  /// Updates the analytics enabled setting
  Future<void> setAnalyticsEnabled(bool enabled) async {
    await _saveSetting(
      action: () async {
        _analyticsEnabled = enabled;
        await _prefs?.setBool(_analyticsEnabledKey, enabled);
      },
      errorMessage: 'Failed to save analytics setting',
    );
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

  /// Gets all settings data for export
  Map<String, dynamic> getExportData() {
    return {
      'themeMode': _themeMode.index,
      'gameSpeed': _gameSpeed,
      'hasSeenGuide': _hasSeenGuide,
      'mute': _mute,
      'notificationEnabled': _notificationEnabled,
      'hasDonated': _hasDonated,
      'hasCheckedForUpdate': _hasCheckedForUpdate,
      'selectedCustomThemeKey': _selectedCustomThemeKey,
      'unlockedThemes': _unlockedThemes.toList(),
      'lastDonationPopup': _lastDonationPopup?.millisecondsSinceEpoch,
      'lastFollowPopup': _lastFollowPopup?.millisecondsSinceEpoch,
      'lastSatisfactionPopup': _lastSatisfactionPopup?.millisecondsSinceEpoch,
      'hasClickedDonationLink': _hasClickedDonationLink,
      'hasClickedFollowLink': _hasClickedFollowLink,
      'hasClickedSatisfactionLink': _hasClickedSatisfactionLink,
      'lastDifficultyPopup': _lastDifficultyPopup?.millisecondsSinceEpoch,
      'hasClickedDifficultyLink': _hasClickedDifficultyLink,
      'difficultyPreference': _difficultyPreference,
      'analyticsEnabled': _analyticsEnabled,
    };
  }

  /// Loads settings data from import
  Future<void> loadImportData(Map<String, dynamic> data) async {
    _themeMode = ThemeMode.values[data['themeMode'] ?? 0];
    _gameSpeed = data['gameSpeed'] ?? 'medium';
    _hasSeenGuide = data['hasSeenGuide'] ?? false;
    _mute = data['mute'] ?? false;
    _notificationEnabled = data['notificationEnabled'] ?? true;
    _hasDonated = data['hasDonated'] ?? false;
    _hasCheckedForUpdate = data['hasCheckedForUpdate'] ?? false;
    _analyticsEnabled = data['analyticsEnabled'] ?? true;
    _selectedCustomThemeKey = data['selectedCustomThemeKey'];
    _unlockedThemes = Set<String>.from(data['unlockedThemes'] ?? []);
    
    // Load popup tracking data
    final lastDonationPopupMs = data['lastDonationPopup'];
    _lastDonationPopup = lastDonationPopupMs != null ? DateTime.fromMillisecondsSinceEpoch(lastDonationPopupMs) : null;
    
    final lastFollowPopupMs = data['lastFollowPopup'];
    _lastFollowPopup = lastFollowPopupMs != null ? DateTime.fromMillisecondsSinceEpoch(lastFollowPopupMs) : null;
    
    final lastSatisfactionPopupMs = data['lastSatisfactionPopup'];
    _lastSatisfactionPopup = lastSatisfactionPopupMs != null ? DateTime.fromMillisecondsSinceEpoch(lastSatisfactionPopupMs) : null;
    
    _hasClickedDonationLink = data['hasClickedDonationLink'] ?? false;
    _hasClickedFollowLink = data['hasClickedFollowLink'] ?? false;
    _hasClickedSatisfactionLink = data['hasClickedSatisfactionLink'] ?? false;
    _hasClickedDifficultyLink = data['hasClickedDifficultyLink'] ?? false;
    _difficultyPreference = data['difficultyPreference'];
    
    final lastDifficultyPopupMs = data['lastDifficultyPopup'];
    _lastDifficultyPopup = lastDifficultyPopupMs != null ? DateTime.fromMillisecondsSinceEpoch(lastDifficultyPopupMs) : null;

    await _prefs?.setInt(_themeModeKey, _themeMode.index);
    await _prefs?.setString(_slowModeKey, _gameSpeed);
    await _prefs?.setBool(_hasSeenGuideKey, _hasSeenGuide);
    await _prefs?.setBool(_muteKey, _mute);
    await _prefs?.setBool(_notificationEnabledKey, _notificationEnabled);
    await _prefs?.setBool(_hasDonatedKey, _hasDonated);
    await _prefs?.setBool(_hasCheckedForUpdateKey, _hasCheckedForUpdate);
    await _prefs?.setBool(_analyticsEnabledKey, _analyticsEnabled);
    await _prefs?.setString(_customThemeKey, _selectedCustomThemeKey ?? '');
    await _prefs?.setStringList(_unlockedThemesKey, _unlockedThemes.toList());
    
    // Save popup tracking data
    if (_lastDonationPopup != null) {
      await _prefs?.setInt(_lastDonationPopupKey, _lastDonationPopup!.millisecondsSinceEpoch);
    }
    if (_lastFollowPopup != null) {
      await _prefs?.setInt(_lastFollowPopupKey, _lastFollowPopup!.millisecondsSinceEpoch);
    }
    if (_lastSatisfactionPopup != null) {
      await _prefs?.setInt(_lastSatisfactionPopupKey, _lastSatisfactionPopup!.millisecondsSinceEpoch);
    }
    await _prefs?.setBool(_hasClickedDonationLinkKey, _hasClickedDonationLink);
    await _prefs?.setBool(_hasClickedFollowLinkKey, _hasClickedFollowLink);
    await _prefs?.setBool(_hasClickedSatisfactionLinkKey, _hasClickedSatisfactionLink);
    await _prefs?.setBool(_hasClickedDifficultyLinkKey, _hasClickedDifficultyLink);
    if (_difficultyPreference != null) {
      await _prefs?.setString(_difficultyPreferenceKey, _difficultyPreference!);
    }
    
    // Save difficulty popup tracking data
    if (_lastDifficultyPopup != null) {
      await _prefs?.setInt(_lastDifficultyPopupKey, _lastDifficultyPopup!.millisecondsSinceEpoch);
    }
    
    notifyListeners();
  }
}