import 'package:flutter/material.dart';
import '../utils/color_parser.dart';

/// Represents an AI-generated theme with metadata and color information
class AITheme {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final ThemeData lightTheme;
  final ThemeData? darkTheme; // Optional dark variant
  final Map<String, dynamic>
      colorPalette; // Store original color palette from Gemini
  final String? prompt; // Optional prompt used to generate the theme

  AITheme({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.lightTheme,
    this.darkTheme,
    required this.colorPalette,
    this.prompt,
  });

  /// Creates a copy of this theme with updated properties
  AITheme copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    Map<String, dynamic>? colorPalette,
    String? prompt,
  }) {
    return AITheme(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
      colorPalette: colorPalette ?? this.colorPalette,
      prompt: prompt ?? this.prompt,
    );
  }

  /// Converts the theme to a JSON-serializable map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'colorPalette': colorPalette,
      'prompt': prompt,
      'hasDarkTheme': darkTheme != null,
    };
  }

  /// Creates an AITheme from JSON data
  factory AITheme.fromJson(Map<String, dynamic> json, ThemeData lightTheme,
      {ThemeData? darkTheme}) {
    return AITheme(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      lightTheme: lightTheme,
      darkTheme: darkTheme,
      colorPalette: Map<String, dynamic>.from(json['colorPalette'] as Map),
      prompt: json['prompt'] as String?,
    );
  }

  @override
  String toString() {
    return 'AITheme(id: $id, name: $name, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AITheme && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Utility class for creating AI themes from color palettes
class AIThemeBuilder {
  /// Creates a light theme from a color palette
  static ThemeData createLightThemeFromPalette(Map<String, dynamic> palette) {
    final Color primary = _parseColor(palette['primary']);
    final Color secondary = _parseColor(palette['secondary']);
    final Color tertiary = _parseColor(palette['tertiary']);
    final Color background = _parseColor(palette['background']);
    final Color surface = _parseColor(palette['surface']);
    final Color onPrimary = _parseColor(palette['onPrimary']);
    final Color onSecondary = _parseColor(palette['onSecondary']);
    final Color onBackground = _parseColor(palette['onBackground']);
    final Color onSurface = _parseColor(palette['onSurface']);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ).copyWith(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        surface: surface,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
        onSurface: onSurface,
      ),
      textTheme: ThemeData.light().textTheme.apply(
            fontFamily: 'Quicksand',
            bodyColor: onBackground,
            displayColor: onBackground,
          ),
      scaffoldBackgroundColor: background,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
        ),
      ),
    );
  }

  /// Creates a dark theme from a color palette
  static ThemeData createDarkThemeFromPalette(Map<String, dynamic> palette) {
    final Color primary = _parseColor(palette['primary']);
    final Color secondary = _parseColor(palette['secondary']);
    final Color tertiary = _parseColor(palette['tertiary']);
    final Color background = _parseColor(palette['background']);
    final Color surface = _parseColor(palette['surface']);
    final Color onPrimary = _parseColor(palette['onPrimary']);
    final Color onSecondary = _parseColor(palette['onSecondary']);
    final Color onBackground = _parseColor(palette['onBackground']);
    final Color onSurface = _parseColor(palette['onSurface']);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
      ).copyWith(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        surface: surface,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
        onSurface: onSurface,
      ),
      textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'Quicksand',
            bodyColor: onBackground,
            displayColor: onBackground,
          ),
      scaffoldBackgroundColor: background,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
        ),
      ),
    );
  }

  /// Parses a color using the comprehensive ColorParser
  static Color _parseColor(dynamic colorValue) {
    return ColorParser.parseColor(colorValue, component: 'theme');
  }

  /// Generates a unique ID for a theme
  static String generateThemeId() {
    return 'ai_${DateTime.now().millisecondsSinceEpoch}_${_randomString(4)}';
  }

  /// Generates a random string of specified length
  static String _randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(Iterable.generate(
        length,
        (_) => chars
            .codeUnitAt(DateTime.now().microsecondsSinceEpoch % chars.length)));
  }
}
