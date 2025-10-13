import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bijbelquiz/providers/settings_provider.dart';

void main() {
  late SettingsProvider provider;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    provider.dispose();
  });

  group('SettingsProvider', () {
    test('should initialize with default values', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();

      // Wait for initialization
      await Future.delayed(Duration.zero);

      expect(provider.language, 'nl');
      expect(provider.themeMode, ThemeMode.system);
      expect(provider.gameSpeed, 'medium');
      expect(provider.slowMode, false);
      expect(provider.hasSeenGuide, false);
      expect(provider.mute, false);
      expect(provider.notificationEnabled, true);
      expect(provider.hasDonated, false);
      expect(provider.hasCheckedForUpdate, false);
      expect(provider.isLoading, false);
      expect(provider.error, null);
    });

    test('should load settings from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': 2, // ThemeMode.dark
        'game_speed': 'slow',
        'has_seen_guide': true,
        'mute': true,
        'notification_enabled': false,
        'has_donated': true,
        'has_checked_for_update': true,
        'unlocked_themes': ['theme1', 'theme2'],
        'custom_theme': 'selected_theme',
      });

      provider = SettingsProvider();

      // Wait for initialization
      await Future.delayed(Duration.zero);

      expect(provider.themeMode, ThemeMode.dark);
      expect(provider.gameSpeed, 'slow');
      expect(provider.slowMode, true);
      expect(provider.hasSeenGuide, true);
      expect(provider.mute, true);
      expect(provider.notificationEnabled, false);
      expect(provider.hasDonated, true);
      expect(provider.hasCheckedForUpdate, true);
      expect(provider.unlockedThemes, {'theme1', 'theme2'});
      expect(provider.selectedCustomThemeKey, 'selected_theme');
    });

    test('should set theme mode correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.setThemeMode(ThemeMode.dark);

      expect(provider.themeMode, ThemeMode.dark);
    });

    test('should set game speed correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.setGameSpeed('fast');

      expect(provider.gameSpeed, 'fast');
    });

    test('should throw error for invalid game speed', () async {
      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      expect(
        () => provider.setGameSpeed('invalid'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should set slow mode correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.setSlowMode(true);

      expect(provider.gameSpeed, 'slow');
      expect(provider.slowMode, true);
    });

    test('should set mute correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.setMute(true);

      expect(provider.mute, true);
    });

    test('should set notification enabled correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.setNotificationEnabled(false);

      expect(provider.notificationEnabled, false);
    });

    test('should mark as donated correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.markAsDonated();

      expect(provider.hasDonated, true);
    });

    test('should set has checked for update correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.setHasCheckedForUpdate(true);

      expect(provider.hasCheckedForUpdate, true);
    });

    test('should mark guide as seen correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.markGuideAsSeen();

      expect(provider.hasSeenGuide, true);
    });

    test('should reset guide status correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.resetGuideStatus();

      expect(provider.hasSeenGuide, false);
    });

    test('should reset check for update status correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.resetCheckForUpdateStatus();

      expect(provider.hasCheckedForUpdate, false);
    });

    test('should set language (always nl)', () async {
      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.setLanguage('nl');

      expect(provider.language, 'nl');
    });

    test('should throw error for non-nl language', () async {
      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      expect(
        () => provider.setLanguage('en'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should set custom theme correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      provider.setCustomTheme('new_theme');

      expect(provider.selectedCustomThemeKey, 'new_theme');
    });

    test('should set custom theme to null correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      provider.setCustomTheme(null);

      expect(provider.selectedCustomThemeKey, null);
    });

    test('should unlock theme correctly', () async {
      SharedPreferences.setMockInitialValues({
        'unlocked_themes': [],
      });

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.unlockTheme('new_theme');

      expect(provider.unlockedThemes.contains('new_theme'), true);
    });

    test('should not unlock already unlocked theme', () async {
      SharedPreferences.setMockInitialValues({
        'unlocked_themes': ['existing_theme'],
      });

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.unlockTheme('existing_theme');

      expect(provider.unlockedThemes.contains('existing_theme'), true);
    });

    test('should check if theme is unlocked correctly', () async {
      SharedPreferences.setMockInitialValues({
        'unlocked_themes': ['theme1', 'theme2'],
      });

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      expect(provider.isThemeUnlocked('theme1'), true);
      expect(provider.isThemeUnlocked('theme3'), false);
    });

    test('should export data correctly', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': 2,
        'game_speed': 'slow',
        'has_seen_guide': true,
        'mute': true,
        'notification_enabled': false,
        'has_donated': true,
        'has_checked_for_update': true,
        'unlocked_themes': ['theme1'],
        'custom_theme': 'selected',
      });

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      final data = provider.getExportData();

      expect(data['themeMode'], 2);
      expect(data['gameSpeed'], 'slow');
      expect(data['hasSeenGuide'], true);
      expect(data['mute'], true);
      expect(data['notificationEnabled'], false);
      expect(data['hasDonated'], true);
      expect(data['hasCheckedForUpdate'], true);
      expect(data['unlockedThemes'], ['theme1']);
      expect(data['selectedCustomThemeKey'], 'selected');
    });

    test('should load import data correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      final importData = {
        'themeMode': 2,
        'gameSpeed': 'fast',
        'hasSeenGuide': true,
        'mute': true,
        'notificationEnabled': false,
        'hasDonated': true,
        'hasCheckedForUpdate': true,
        'unlockedThemes': ['imported_theme'],
        'selectedCustomThemeKey': 'imported',
      };

      await provider.loadImportData(importData);

      expect(provider.themeMode, ThemeMode.dark);
      expect(provider.gameSpeed, 'fast');
      expect(provider.hasSeenGuide, true);
      expect(provider.mute, true);
      expect(provider.notificationEnabled, false);
      expect(provider.hasDonated, true);
      expect(provider.hasCheckedForUpdate, true);
      expect(provider.unlockedThemes, {'imported_theme'});
      expect(provider.selectedCustomThemeKey, 'imported');
    });

    test('should handle boolean settings correctly', () async {
      // Test with boolean value
      SharedPreferences.setMockInitialValues({
        'mute': true,
      });

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      expect(provider.mute, true);

      // Test with string value for game speed
      SharedPreferences.setMockInitialValues({
        'game_speed': 'slow',
      });

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      expect(provider.gameSpeed, 'slow');
      expect(provider.slowMode, true);
    });

    test('should handle theme mode changes correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      // Test all theme modes
      await provider.setThemeMode(ThemeMode.light);
      expect(provider.themeMode, ThemeMode.light);

      await provider.setThemeMode(ThemeMode.dark);
      expect(provider.themeMode, ThemeMode.dark);

      await provider.setThemeMode(ThemeMode.system);
      expect(provider.themeMode, ThemeMode.system);
    });

    test('should handle game speed changes correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      // Test all valid game speeds
      await provider.setGameSpeed('slow');
      expect(provider.gameSpeed, 'slow');
      expect(provider.slowMode, true);

      await provider.setGameSpeed('medium');
      expect(provider.gameSpeed, 'medium');
      expect(provider.slowMode, false);

      await provider.setGameSpeed('fast');
      expect(provider.gameSpeed, 'fast');
      expect(provider.slowMode, false);
    });

    test('should handle theme unlocking correctly', () async {
      SharedPreferences.setMockInitialValues({
        'unlocked_themes': ['theme1'],
      });

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      // Initially only theme1 is unlocked
      expect(provider.isThemeUnlocked('theme1'), true);
      expect(provider.isThemeUnlocked('theme2'), false);

      // Unlock theme2
      await provider.unlockTheme('theme2');
      expect(provider.isThemeUnlocked('theme2'), true);

      // Try to unlock theme1 again (should not cause issues)
      await provider.unlockTheme('theme1');
      expect(provider.isThemeUnlocked('theme1'), true);
    });

    test('should handle notification settings correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      // Test enabling notifications
      await provider.setNotificationEnabled(true);
      expect(provider.notificationEnabled, true);

      // Test disabling notifications
      await provider.setNotificationEnabled(false);
      expect(provider.notificationEnabled, false);
    });

    test('should handle donation status correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      // Initially not donated
      expect(provider.hasDonated, false);

      // Mark as donated
      await provider.markAsDonated();
      expect(provider.hasDonated, true);

      // Should remain donated (can't undo donation)
      expect(provider.hasDonated, true);
    });

    test('should handle guide status correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      // Initially hasn't seen guide
      expect(provider.hasSeenGuide, false);

      // Mark guide as seen
      await provider.markGuideAsSeen();
      expect(provider.hasSeenGuide, true);

      // Reset guide status
      await provider.resetGuideStatus();
      expect(provider.hasSeenGuide, false);
    });

    test('should handle update check status correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      // Initially hasn't checked for update
      expect(provider.hasCheckedForUpdate, false);

      // Mark as checked
      await provider.setHasCheckedForUpdate(true);
      expect(provider.hasCheckedForUpdate, true);

      // Reset check status
      await provider.resetCheckForUpdateStatus();
      expect(provider.hasCheckedForUpdate, false);
    });

    test('should handle custom theme selection correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      // Initially no custom theme selected
      expect(provider.selectedCustomThemeKey, null);

      // Set custom theme
      provider.setCustomTheme('dark_theme');
      expect(provider.selectedCustomThemeKey, 'dark_theme');

      // Change custom theme
      provider.setCustomTheme('light_theme');
      expect(provider.selectedCustomThemeKey, 'light_theme');

      // Clear custom theme
      provider.setCustomTheme(null);
      expect(provider.selectedCustomThemeKey, null);
    });

    test('should handle loading states correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();

      // Should be loading initially
      expect(provider.isLoading, true);

      // Wait for loading to complete
      await Future.delayed(Duration.zero);

      // Should not be loading anymore
      expect(provider.isLoading, false);
    });

    test('should handle error states correctly', () async {
      SharedPreferences.setMockInitialValues({});

      provider = SettingsProvider();

      // Initially no error
      expect(provider.error, null);

      // Wait for initialization
      await Future.delayed(Duration.zero);

      // Should still have no error
      expect(provider.error, null);
    });
  });
}