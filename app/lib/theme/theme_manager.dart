import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/theme_definition.dart';
import '../services/logger.dart';

/// Centralized theme manager that loads themes from a JSON file
class ThemeManager {
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();

  ThemeConfiguration? _themeConfiguration;
  Map<String, ThemeData>? _themeDataCache;

  /// Initializes the theme manager by loading themes from the JSON file
  Future<void> initialize() async {
    AppLogger.info('Initializing theme manager...');
    try {
      await _loadThemesFromJson();
      AppLogger.info('Theme manager initialized successfully with ${_themeConfiguration?.themes.length ?? 0} themes');
    } catch (e) {
      AppLogger.error('Failed to initialize theme manager', e);
      // Fallback to empty configuration
      _themeConfiguration = ThemeConfiguration(themes: {});
    }
  }

  /// Loads themes from the JSON file
  Future<void> _loadThemesFromJson() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/themes/themes.json');
      final Map<String, dynamic> json = jsonDecode(jsonString);
      _themeConfiguration = ThemeConfiguration.fromJson(json);
      
      // Clear cache to rebuild themes with new configuration
      _themeDataCache = null;
      
      AppLogger.info('Loaded themes from JSON: ${_themeConfiguration?.themes.keys.join(', ')}');
    } catch (e) {
      AppLogger.error('Failed to load themes from JSON', e);
      rethrow;
    }
  }

  /// Gets the theme configuration
  ThemeConfiguration? get themeConfiguration => _themeConfiguration;

  /// Gets all available theme definitions
  Map<String, ThemeDefinition> getAvailableThemes() {
    return _themeConfiguration?.themes ?? {};
  }

  /// Gets a specific theme definition by ID
  ThemeDefinition? getThemeDefinition(String themeId) {
    return _themeConfiguration?.themes[themeId];
  }

  /// Converts a theme definition to a ThemeData object
  ThemeData _buildThemeData(ThemeDefinition themeDef) {
    final isDark = themeDef.type.toLowerCase() == 'dark';
    final brightness = isDark ? Brightness.dark : Brightness.light;

    // Parse colors from hex strings
    final colorScheme = _buildColorScheme(themeDef, brightness);
    final scaffoldBackgroundColor = _parseColor(themeDef.colors['scaffoldBackgroundColor']) ?? 
        (isDark ? Colors.grey[900] : Colors.grey[50]);

    // Build text theme
    final textTheme = _buildTextTheme(brightness, themeDef.textStyles);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      elevatedButtonTheme: _buildButtonTheme(themeDef.buttonStyles),
      cardTheme: _buildCardTheme(themeDef.cardStyles),
      appBarTheme: _buildAppBarTheme(themeDef.appBarStyles),
      pageTransitionsTheme: _buildPageTransitionsTheme(themeDef.pageTransitions),
    );
  }

  /// Builds ColorScheme from theme definition
  ColorScheme _buildColorScheme(ThemeDefinition themeDef, Brightness brightness) {
    final seedColor = _parseColor(themeDef.colors['primary']) ?? (brightness == Brightness.dark ? Colors.blue.shade200 : Colors.blue.shade600);
    
    ColorScheme baseScheme;
    baseScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
  
    // Override with specific colors from the theme definition
    return baseScheme.copyWith(
      primary: _parseColor(themeDef.colors['primary']) ?? baseScheme.primary,
      secondary: _parseColor(themeDef.colors['secondary']) ?? baseScheme.secondary,
      tertiary: _parseColor(themeDef.colors['tertiary']) ?? baseScheme.tertiary,
      surface: _parseColor(themeDef.colors['surface']) ?? baseScheme.surface,
      surfaceContainerHighest: _parseColor(themeDef.colors['surfaceContainerHighest']) ?? baseScheme.surfaceContainerHighest,
      onSurface: _parseColor(themeDef.colors['onSurface']) ?? baseScheme.onSurface,
      outline: _parseColor(themeDef.colors['outline']) ?? baseScheme.outline,
      outlineVariant: _parseColor(themeDef.colors['outlineVariant']) ?? baseScheme.outlineVariant,
      shadow: _parseColor(themeDef.colors['shadow']) ?? baseScheme.shadow,
    );
  }

  /// Builds TextTheme from theme definition
  TextTheme _buildTextTheme(Brightness brightness, Map<String, dynamic> textStyles) {
    final baseTheme = brightness == Brightness.dark 
        ? ThemeData.dark().textTheme 
        : ThemeData.light().textTheme;

    final baseTextTheme = baseTheme.apply(
      fontFamily: 'Quicksand',
      bodyColor: brightness == Brightness.dark 
          ? const Color(0xFFF8FAFC) 
          : const Color(0xFF0F172A),
      displayColor: brightness == Brightness.dark 
          ? const Color(0xFFF8FAFC) 
          : const Color(0xFF0F172A),
    );

    return baseTextTheme.copyWith(
      headlineLarge: _parseTextStyle(
        textStyles['headlineLarge'], 
        baseTextTheme.headlineLarge,
      ),
      headlineMedium: _parseTextStyle(
        textStyles['headlineMedium'], 
        baseTextTheme.headlineMedium,
      ),
      headlineSmall: _parseTextStyle(
        textStyles['headlineSmall'], 
        baseTextTheme.headlineSmall,
      ),
      titleLarge: _parseTextStyle(
        textStyles['titleLarge'], 
        baseTextTheme.titleLarge,
      ),
      titleMedium: _parseTextStyle(
        textStyles['titleMedium'], 
        baseTextTheme.titleMedium,
      ),
      titleSmall: _parseTextStyle(
        textStyles['titleSmall'], 
        baseTextTheme.titleSmall,
      ),
      bodyLarge: _parseTextStyle(
        textStyles['bodyLarge'], 
        baseTextTheme.bodyLarge,
      ),
      bodyMedium: _parseTextStyle(
        textStyles['bodyMedium'], 
        baseTextTheme.bodyMedium,
      ),
      labelLarge: _parseTextStyle(
        textStyles['labelLarge'], 
        baseTextTheme.labelLarge,
      ),
    );
  }

  /// Builds ElevatedButtonThemeData from theme definition
  ElevatedButtonThemeData _buildButtonTheme(Map<String, dynamic> buttonStyles) {
    final paddingData = buttonStyles['padding'] as Map<String, dynamic>? ?? {};
    final borderRadius = (buttonStyles['borderRadius'] as num?)?.toDouble() ?? 16;
    final elevation = (buttonStyles['elevation'] as num?)?.toDouble() ?? 2;
    final backgroundColor = _parseColor(buttonStyles['backgroundColor']);
    final foregroundColor = _parseColor(buttonStyles['foregroundColor']);
    
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: (paddingData['horizontal'] as num?)?.toDouble() ?? 24,
          vertical: (paddingData['vertical'] as num?)?.toDouble() ?? 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: elevation,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        textStyle: _parseTextStyle(
          buttonStyles['textStyle'], 
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }

  /// Builds CardThemeData from theme definition
  CardThemeData _buildCardTheme(Map<String, dynamic> cardStyles) {
    final borderRadius = (cardStyles['borderRadius'] as num?)?.toDouble() ?? 20;
    final elevation = (cardStyles['elevation'] as num?)?.toDouble() ?? 2;
    final color = _parseColor(cardStyles['color']);
    
    return CardThemeData(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      color: color,
      surfaceTintColor: Colors.transparent,
    );
  }

  /// Builds AppBarTheme from theme definition
  AppBarTheme _buildAppBarTheme(Map<String, dynamic> appBarStyles) {
    final backgroundColor = _parseColor(appBarStyles['backgroundColor']);
    final foregroundColor = _parseColor(appBarStyles['foregroundColor']);
    final elevation = (appBarStyles['elevation'] as num?)?.toDouble();
    final scrolledUnderElevation = (appBarStyles['scrolledUnderElevation'] as num?)?.toDouble();
    
    return AppBarTheme(
      centerTitle: appBarStyles['centerTitle'] as bool? ?? true,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: _parseTextStyle(
        appBarStyles['titleTextStyle'], 
        const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F172A),
          letterSpacing: -0.1,
        ),
      ),
    );
  }

  /// Builds PageTransitionsTheme from theme definition
  PageTransitionsTheme _buildPageTransitionsTheme(Map<String, dynamic> pageTransitions) {
    // Currently using default page transitions
    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    );
  }

  /// Parses a hex color string to Color
  Color? _parseColor(String? colorString) {
    if (colorString == null) return null;
    
    try {
      // Remove the # if present
      var color = colorString.replaceAll('#', '');
      
      // Handle both 6-digit (#RRGGBB) and 8-digit (#AARRGGBB) formats
      if (color.length == 6) {
        color = 'FF$color'; // Add full opacity
      } else if (color.length == 8) {
        // Already has alpha
      } else {
        AppLogger.warning('Invalid color format: $colorString');
        return null;
      }
      
      return Color(int.parse(color, radix: 16));
    } catch (e) {
      AppLogger.error('Failed to parse color: $colorString', e);
      return null;
    }
  }

  /// Parses text style from theme definition
  TextStyle? _parseTextStyle(dynamic styleData, TextStyle? defaultStyle) {
    if (styleData == null) return defaultStyle;
    
    final styleMap = styleData as Map<String, dynamic>;
    
    final fontSize = (styleMap['fontSize'] as num?)?.toDouble();
    final fontWeight = styleMap['fontWeight'] as String?;
    final letterSpacing = (styleMap['letterSpacing'] as num?)?.toDouble();
    final color = _parseColor(styleMap['color'] as String?);
    final decoration = styleMap['decoration'] as String?;
    
    // Convert font weight string to FontWeight
    FontWeight? fontWeightEnum;
    if (fontWeight != null) {
      switch (fontWeight.toLowerCase()) {
        case 'w100':
          fontWeightEnum = FontWeight.w100;
          break;
        case 'w200':
          fontWeightEnum = FontWeight.w200;
          break;
        case 'w300':
          fontWeightEnum = FontWeight.w300;
          break;
        case 'w400':
          fontWeightEnum = FontWeight.w400;
          break;
        case 'w500':
          fontWeightEnum = FontWeight.w500;
          break;
        case 'w600':
          fontWeightEnum = FontWeight.w600;
          break;
        case 'w700':
          fontWeightEnum = FontWeight.w700;
          break;
        case 'w800':
          fontWeightEnum = FontWeight.w800;
          break;
        case 'w900':
          fontWeightEnum = FontWeight.w900;
          break;
      }
    }

    // Convert decoration string to TextDecoration
    TextDecoration? textDecoration;
    if (decoration != null) {
      switch (decoration.toLowerCase()) {
        case 'underline':
          textDecoration = TextDecoration.underline;
          break;
        case 'overline':
          textDecoration = TextDecoration.overline;
          break;
        case 'lineThrough':
          textDecoration = TextDecoration.lineThrough;
          break;
      }
    }

    return (defaultStyle ?? const TextStyle()).copyWith(
      fontSize: fontSize,
      fontWeight: fontWeightEnum,
      letterSpacing: letterSpacing,
      color: color,
      decoration: textDecoration,
    );
  }

  /// Gets the ThemeData for a specific theme ID
  ThemeData getThemeData(String themeId) {
    // Initialize cache if needed
    _themeDataCache ??= {};

    // Return cached theme if available
    if (_themeDataCache!.containsKey(themeId)) {
      return _themeDataCache![themeId]!;
    }

    // Get theme definition
    final themeDef = getThemeDefinition(themeId);
    if (themeDef == null) {
      AppLogger.warning('Theme not found: $themeId, returning default theme');
      // Return default theme based on whether it should be dark or light
      return themeId.contains('dark') || themeId.contains('oled') || themeId.contains('grey')
          ? _getDefaultDarkTheme()
          : _getDefaultLightTheme();
    }

    // Build and cache the theme
    final themeData = _buildThemeData(themeDef);
    _themeDataCache![themeId] = themeData;
    
    return themeData;
  }

  /// Gets the light version of a theme
  ThemeData getLightThemeData(String themeId) {
    final themeDef = getThemeDefinition(themeId);
    if (themeDef == null) {
      return _getDefaultLightTheme();
    }
    
    // Create a light variant if the theme is dark
    if (themeDef.type.toLowerCase() == 'dark') {
      // Return the theme with light brightness but keep the same colors
      final modifiedDef = ThemeDefinition(
        id: themeDef.id,
        name: themeDef.name,
        type: 'light',
        colors: themeDef.colors,
        textStyles: themeDef.textStyles,
        buttonStyles: themeDef.buttonStyles,
        cardStyles: themeDef.cardStyles,
        appBarStyles: themeDef.appBarStyles,
        pageTransitions: themeDef.pageTransitions,
      );
      
      return _buildThemeData(modifiedDef);
    }
    
    return getThemeData(themeId);
  }

  /// Gets the dark version of a theme
  ThemeData getDarkThemeData(String themeId) {
    final themeDef = getThemeDefinition(themeId);
    if (themeDef == null) {
      return _getDefaultDarkTheme();
    }
    
    // Create a dark variant if the theme is light
    if (themeDef.type.toLowerCase() != 'dark') {
      // Return the theme with dark brightness but keep the same colors
      final modifiedDef = ThemeDefinition(
        id: themeDef.id,
        name: themeDef.name,
        type: 'dark',
        colors: themeDef.colors,
        textStyles: themeDef.textStyles,
        buttonStyles: themeDef.buttonStyles,
        cardStyles: themeDef.cardStyles,
        appBarStyles: themeDef.appBarStyles,
        pageTransitions: themeDef.pageTransitions,
      );
      
      return _buildThemeData(modifiedDef);
    }
    
    return getThemeData(themeId);
  }

  /// Gets the default light theme
  ThemeData _getDefaultLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB),
        brightness: Brightness.light,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Quicksand',
        bodyColor: const Color(0xFF0F172A),
        displayColor: const Color(0xFF0F172A),
      ),
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    );
  }

  /// Gets the default dark theme
  ThemeData _getDefaultDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB),
        brightness: Brightness.dark,
      ),
      textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'Quicksand',
        bodyColor: const Color(0xFFF8FAFC),
        displayColor: const Color(0xFFF8FAFC),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
    );
  }

  /// Reloads themes from the JSON file
  Future<void> reloadThemes() async {
    AppLogger.info('Reloading themes...');
    _themeDataCache = null; // Clear cache
    await _loadThemesFromJson();
    AppLogger.info('Themes reloaded successfully');
  }
}