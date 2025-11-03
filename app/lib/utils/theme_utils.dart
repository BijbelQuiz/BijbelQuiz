import 'package:flutter/material.dart';
import '../providers/settings_provider.dart';
import '../theme/theme_manager.dart';
import '../theme/app_theme.dart'; // Keep for fallback

/// Utility class for theme management and switching logic using centralized theme system
class ThemeUtils {
  /// Gets the appropriate light theme based on settings
  static ThemeData getLightTheme(SettingsProvider settings) {
    if (settings.selectedCustomThemeKey != null) {
      // Check if it's an AI theme first
      final aiTheme = settings.getAITheme(settings.selectedCustomThemeKey!);
      if (aiTheme != null) {
        return aiTheme.lightTheme;
      }
      
      // Use the theme manager for JSON-defined themes
      try {
        return ThemeManager().getLightThemeData(settings.selectedCustomThemeKey!);
      } catch (e) {
        // Fallback to hardcoded theme if JSON theme is not found
        return _getHardcodedTheme(settings.selectedCustomThemeKey!);
      }
    }
    return appLightTheme;
  }

  /// Gets the appropriate dark theme based on settings
  static ThemeData getDarkTheme(SettingsProvider settings) {
    if (settings.selectedCustomThemeKey != null) {
      // Check if it's an AI theme first
      final aiTheme = settings.getAITheme(settings.selectedCustomThemeKey!);
      if (aiTheme != null) {
        // For AI themes, return the dark version if available, otherwise light
        return aiTheme.darkTheme ?? aiTheme.lightTheme;
      }
      
      // Use the theme manager for JSON-defined themes
      try {
        return ThemeManager().getDarkThemeData(settings.selectedCustomThemeKey!);
      } catch (e) {
        // Fallback to hardcoded theme if JSON theme is not found
        return _getHardcodedTheme(settings.selectedCustomThemeKey!);
      }
    }
    return appDarkTheme;
  }

  /// Gets the appropriate theme mode based on settings
  static ThemeMode getThemeMode(SettingsProvider settings) {
    // Check if the selected custom theme is a dark theme
    if (settings.selectedCustomThemeKey != null) {
      // Check if it's an AI theme first
      if (settings.hasAITheme(settings.selectedCustomThemeKey!)) {
        return settings.getAITheme(settings.selectedCustomThemeKey!)!.darkTheme != null 
            ? ThemeMode.dark 
            : ThemeMode.light;
      }
      
      // Use theme manager to determine if theme is dark
      final themeDef = ThemeManager().getThemeDefinition(settings.selectedCustomThemeKey!);
      if (themeDef != null) {
        return themeDef.type.toLowerCase() == 'dark' ? ThemeMode.dark : ThemeMode.light;
      }
      
      // Fallback to hardcoded theme logic
      switch (settings.selectedCustomThemeKey) {
        case 'grey':
        case 'oled':
        case 'dark':
          return ThemeMode.dark;
        default:
          return ThemeMode.light;
      }
    }
    // Use system preference when no custom theme
    return settings.themeMode;
  }

  /// Gets a hardcoded theme by key (fallback for when JSON theme is not found)
  static ThemeData _getHardcodedTheme(String themeKey) {
    switch (themeKey) {
      case 'oled':
        return oledTheme;
      case 'green':
        return greenTheme;
      case 'orange':
        return orangeTheme;
      case 'grey':
        return greyTheme;
      case 'light':
        return appLightTheme;
      case 'dark':
        return appDarkTheme;
      default:
        return appLightTheme;
    }
  }

  /// Gets all available themes as a map
  static Map<String, ThemeData> getAllThemes({SettingsProvider? settings}) {
    final themes = <String, ThemeData>{};
    
    // Add themes from the centralized theme manager
    final themeDefinitions = ThemeManager().getAvailableThemes();
    for (final entry in themeDefinitions.entries) {
      try {
        themes[entry.key] = ThemeManager().getThemeData(entry.key);
      } catch (e) {
        // Fallback to hardcoded theme if JSON theme fails
        themes[entry.key] = _getHardcodedTheme(entry.key);
      }
    }

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
    final displayNames = <String, String>{};
    
    // Get names from the theme manager
    final themeDefinitions = ThemeManager().getAvailableThemes();
    for (final entry in themeDefinitions.entries) {
      displayNames[entry.key] = entry.value.name;
    }

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
    if (themeKey == 'light' || themeKey == 'dark' || themeKey == 'grey') {
      return true;
    }
    // AI themes are always unlocked (they're user-created)
    if (settings.hasAITheme(themeKey)) {
      return true;
    }
    // Check if it's a JSON-defined theme (which would be unlocked by default)
    if (ThemeManager().getThemeDefinition(themeKey) != null) {
      return true; // All JSON themes are considered unlocked
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

/// Utility function to check if the current theme is dark mode
extension ThemeModeExtension on SettingsProvider {
  bool get isDarkMode {
    // Check if the selected custom theme is a dark theme
    if (selectedCustomThemeKey != null) {
      // Check if it's an AI theme first
      if (hasAITheme(selectedCustomThemeKey!)) {
        return getAITheme(selectedCustomThemeKey!)!.darkTheme != null;
      }
      
      // Use theme manager to determine if theme is dark
      final themeDef = ThemeManager().getThemeDefinition(selectedCustomThemeKey!);
      if (themeDef != null) {
        return themeDef.type.toLowerCase() == 'dark';
      }
      
      // Fallback to hardcoded theme logic
      switch (selectedCustomThemeKey) {
        case 'grey':
        case 'oled':
        case 'dark':
          return true;
        default:
          return false;
      }
    }
    
    // If no custom theme is selected, check the system theme mode
    switch (themeMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        // For system mode, we can't determine without context, so default to false
        // In practice, this would be determined by MediaQuery.of(context).platformBrightness
        return false;
    }
  }
}