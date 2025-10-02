import 'package:flutter/material.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';

/// Utility class for theme management and switching logic
class ThemeUtils {
  /// Gets the appropriate light theme based on settings
  static ThemeData getLightTheme(SettingsProvider settings) {
    if (settings.selectedCustomThemeKey != null) {
      return _getCustomTheme(settings.selectedCustomThemeKey!, settings);
    }
    return appLightTheme;
  }

  /// Gets the appropriate dark theme based on settings
  static ThemeData getDarkTheme(SettingsProvider settings) {
    if (settings.selectedCustomThemeKey != null) {
      return _getCustomTheme(settings.selectedCustomThemeKey!, settings);
    }
    return appDarkTheme;
  }

  /// Gets the appropriate theme mode based on settings
  static ThemeMode getThemeMode(SettingsProvider settings) {
    if (settings.selectedCustomThemeKey != null) {
      // Custom themes are always applied as light theme
      return ThemeMode.light;
    }
    // Use system preference when no custom theme
    return settings.themeMode;
  }

  /// Gets a custom theme by key
  static ThemeData _getCustomTheme(String themeKey, SettingsProvider settings) {
    // Check if it's an AI theme first
    final aiTheme = settings.getAITheme(themeKey);
    if (aiTheme != null) {
      return aiTheme.lightTheme;
    }

    // Handle static themes
    switch (themeKey) {
      case 'oled':
        return oledTheme;
      case 'green':
        return greenTheme;
      case 'orange':
        return orangeTheme;
      default:
        return appLightTheme;
    }
  }

  /// Gets all available themes as a map
  static Map<String, ThemeData> getAllThemes({SettingsProvider? settings}) {
    final themes = {
      'light': appLightTheme,
      'dark': appDarkTheme,
      'oled': oledTheme,
      'green': greenTheme,
      'orange': orangeTheme,
    };

    // Add AI themes if settings provider is available
    if (settings != null) {
      for (final aiTheme in settings.aiThemes.values) {
        themes[aiTheme.id] = aiTheme.lightTheme;
      }
    }

    return themes;
  }

  /// Gets theme display names
  static Map<String, String> getThemeDisplayNames({SettingsProvider? settings}) {
    final displayNames = {
      'light': 'Licht',
      'dark': 'Donker',
      'oled': 'OLED',
      'green': 'Groen',
      'orange': 'Oranje',
    };

    // Add AI theme display names if settings provider is available
    if (settings != null) {
      for (final aiTheme in settings.aiThemes.values) {
        displayNames[aiTheme.id] = aiTheme.name;
      }
    }

    return displayNames;
  }

  /// Checks if a theme is unlocked for the user
  static bool isThemeUnlocked(String themeKey, SettingsProvider settings) {
    // Default themes are always unlocked
    if (themeKey == 'light' || themeKey == 'dark') {
      return true;
    }
    // AI themes are always unlocked (they're user-created)
    if (settings.hasAITheme(themeKey)) {
      return true;
    }
    // Static custom themes require unlocking
    return settings.isThemeUnlocked(themeKey);
  }

  /// Gets the current theme data based on context and settings
  static ThemeData getCurrentTheme(BuildContext context, SettingsProvider settings) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final themeMode = getThemeMode(settings);

    switch (themeMode) {
      case ThemeMode.light:
        return getLightTheme(settings);
      case ThemeMode.dark:
        return getDarkTheme(settings);
      case ThemeMode.system:
        return brightness == Brightness.dark ? getDarkTheme(settings) : getLightTheme(settings);
    }
  }

  /// Gets theme-specific colors that adapt to the current theme
  static Color getThemeAwareColor({
    required BuildContext context,
    required Color lightColor,
    required Color darkColor,
  }) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkColor : lightColor;
  }

  /// Gets theme-specific text style that adapts to the current theme
  static TextStyle getThemeAwareTextStyle({
    required BuildContext context,
    required TextStyle lightStyle,
    required TextStyle darkStyle,
  }) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkStyle : lightStyle;
  }

  /// Applies theme-aware opacity to a color
  static Color getThemeAwareOpacity({
    required BuildContext context,
    required Color color,
    required double lightOpacity,
    required double darkOpacity,
  }) {
    final brightness = Theme.of(context).brightness;
    final opacity = brightness == Brightness.dark ? darkOpacity : lightOpacity;
    return color.withValues(alpha: opacity);
  }
}

/// Extension methods for easier theme access
extension ThemeContext on BuildContext {
  ThemeData getCurrentTheme(SettingsProvider settings) => ThemeUtils.getCurrentTheme(this, settings);

  Color themeAwareColor({required Color light, required Color dark}) =>
      ThemeUtils.getThemeAwareColor(context: this, lightColor: light, darkColor: dark);

  TextStyle themeAwareTextStyle({required TextStyle light, required TextStyle dark}) =>
      ThemeUtils.getThemeAwareTextStyle(context: this, lightStyle: light, darkStyle: dark);

  Color themeAwareOpacity({required Color color, required double lightOpacity, required double darkOpacity}) =>
      ThemeUtils.getThemeAwareOpacity(context: this, color: color, lightOpacity: lightOpacity, darkOpacity: darkOpacity);
}