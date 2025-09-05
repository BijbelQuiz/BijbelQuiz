import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bijbelquiz/providers/settings_provider.dart';

// Generate mocks
@GenerateMocks([SharedPreferences])
import 'settings_provider_test.mocks.dart';

void main() {
  late MockSharedPreferences mockPrefs;
  late SettingsProvider provider;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    provider.dispose();
  });

  group('SettingsProvider', () {
    test('should initialize with default values', () async {
      when(mockPrefs.getInt('theme_mode')).thenReturn(null);
      when(mockPrefs.getString('game_speed')).thenReturn(null);
      when(mockPrefs.getBool(any)).thenReturn(null);
      when(mockPrefs.getStringList('unlocked_themes')).thenReturn(null);
      when(mockPrefs.getString('custom_theme')).thenReturn(null);

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
      when(mockPrefs.getInt('theme_mode')).thenReturn(1); // ThemeMode.dark
      when(mockPrefs.getString('game_speed')).thenReturn('slow');
      when(mockPrefs.getBool('has_seen_guide')).thenReturn(true);
      when(mockPrefs.getBool('mute')).thenReturn(true);
      when(mockPrefs.getBool('notification_enabled')).thenReturn(false);
      when(mockPrefs.getBool('has_donated')).thenReturn(true);
      when(mockPrefs.getBool('has_checked_for_update')).thenReturn(true);
      when(mockPrefs.getStringList('unlocked_themes')).thenReturn(['theme1', 'theme2']);
      when(mockPrefs.getString('custom_theme')).thenReturn('selected_theme');

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
      when(mockPrefs.setInt(any, any)).thenAnswer((_) async => true);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.setThemeMode(ThemeMode.dark);

      expect(provider.themeMode, ThemeMode.dark);
      verify(mockPrefs.setInt('theme_mode', 1)).called(1);
    });

    test('should set game speed correctly', () async {
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.setGameSpeed('fast');

      expect(provider.gameSpeed, 'fast');
      verify(mockPrefs.setString('game_speed', 'fast')).called(1);
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
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.setSlowMode(true);

      expect(provider.gameSpeed, 'slow');
      expect(provider.slowMode, true);
      verify(mockPrefs.setString('game_speed', 'slow')).called(1);
    });

    test('should set mute correctly', () async {
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.setMute(true);

      expect(provider.mute, true);
      verify(mockPrefs.setBool('mute', true)).called(1);
    });

    test('should set notification enabled correctly', () async {
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.setNotificationEnabled(false);

      expect(provider.notificationEnabled, false);
      verify(mockPrefs.setBool('notification_enabled', false)).called(1);
    });

    test('should mark as donated correctly', () async {
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.markAsDonated();

      expect(provider.hasDonated, true);
      verify(mockPrefs.setBool('has_donated', true)).called(1);
    });

    test('should set has checked for update correctly', () async {
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.setHasCheckedForUpdate(true);

      expect(provider.hasCheckedForUpdate, true);
      verify(mockPrefs.setBool('has_checked_for_update', true)).called(1);
    });

    test('should mark guide as seen correctly', () async {
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.markGuideAsSeen();

      expect(provider.hasSeenGuide, true);
      verify(mockPrefs.setBool('has_seen_guide', true)).called(1);
    });

    test('should reset guide status correctly', () async {
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.resetGuideStatus();

      expect(provider.hasSeenGuide, false);
      verify(mockPrefs.setBool('has_seen_guide', false)).called(1);
    });

    test('should reset check for update status correctly', () async {
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.resetCheckForUpdateStatus();

      expect(provider.hasCheckedForUpdate, false);
      verify(mockPrefs.setBool('has_checked_for_update', false)).called(1);
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
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      provider.setCustomTheme('new_theme');

      expect(provider.selectedCustomThemeKey, 'new_theme');
      verify(mockPrefs.setString('custom_theme', 'new_theme')).called(1);
    });

    test('should set custom theme to null correctly', () async {
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      provider.setCustomTheme(null);

      expect(provider.selectedCustomThemeKey, null);
      verify(mockPrefs.setString('custom_theme', '')).called(1);
    });

    test('should unlock theme correctly', () async {
      when(mockPrefs.getStringList('unlocked_themes')).thenReturn([]);
      when(mockPrefs.setStringList(any, any)).thenAnswer((_) async => true);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.unlockTheme('new_theme');

      expect(provider.unlockedThemes.contains('new_theme'), true);
      verify(mockPrefs.setStringList('unlocked_themes', ['new_theme'])).called(1);
    });

    test('should not unlock already unlocked theme', () async {
      when(mockPrefs.getStringList('unlocked_themes')).thenReturn(['existing_theme']);
      when(mockPrefs.setStringList(any, any)).thenAnswer((_) async => true);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.unlockTheme('existing_theme');

      expect(provider.unlockedThemes.contains('existing_theme'), true);
      verifyNever(mockPrefs.setStringList(any, any));
    });

    test('should check if theme is unlocked correctly', () async {
      when(mockPrefs.getStringList('unlocked_themes')).thenReturn(['theme1', 'theme2']);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      expect(provider.isThemeUnlocked('theme1'), true);
      expect(provider.isThemeUnlocked('theme3'), false);
    });

    test('should export data correctly', () async {
      when(mockPrefs.getInt('theme_mode')).thenReturn(1);
      when(mockPrefs.getString('game_speed')).thenReturn('slow');
      when(mockPrefs.getBool('has_seen_guide')).thenReturn(true);
      when(mockPrefs.getBool('mute')).thenReturn(true);
      when(mockPrefs.getBool('notification_enabled')).thenReturn(false);
      when(mockPrefs.getBool('has_donated')).thenReturn(true);
      when(mockPrefs.getBool('has_checked_for_update')).thenReturn(true);
      when(mockPrefs.getStringList('unlocked_themes')).thenReturn(['theme1']);
      when(mockPrefs.getString('custom_theme')).thenReturn('selected');

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      final data = provider.getExportData();

      expect(data['themeMode'], 1);
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
      when(mockPrefs.setInt(any, any)).thenAnswer((_) async => true);
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);
      when(mockPrefs.setStringList(any, any)).thenAnswer((_) async => true);

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

      expect(provider.themeMode, ThemeMode.light);
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
      when(mockPrefs.getBool('mute')).thenReturn(true);
      when(mockPrefs.getBool(any)).thenReturn(false);
      when(mockPrefs.getInt(any)).thenReturn(0);
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getStringList(any)).thenReturn(null);

      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      expect(provider.mute, true);

      // Test with string value for game speed
      when(mockPrefs.getString('game_speed')).thenReturn('slow');
      provider = SettingsProvider();
      await Future.delayed(Duration.zero);

      expect(provider.gameSpeed, 'slow');
      expect(provider.slowMode, true);
    });
  });
}