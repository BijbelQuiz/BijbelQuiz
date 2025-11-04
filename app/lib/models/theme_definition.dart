import 'dart:convert';
import 'package:flutter/material.dart';

/// Model class representing a theme definition loaded from JSON
class ThemeDefinition {
  final String id;
  final String name;
  final String type; // 'light' or 'dark'
  final Map<String, String> colors;
  final Map<String, dynamic> textStyles;
  final Map<String, dynamic> buttonStyles;
  final Map<String, dynamic> cardStyles;
  final Map<String, dynamic> appBarStyles;
  final Map<String, dynamic> pageTransitions;

  ThemeDefinition({
    required this.id,
    required this.name,
    required this.type,
    required this.colors,
    required this.textStyles,
    required this.buttonStyles,
    required this.cardStyles,
    required this.appBarStyles,
    required this.pageTransitions,
  });

  factory ThemeDefinition.fromJson(Map<String, dynamic> json) {
    return ThemeDefinition(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      colors: Map<String, String>.from(json['colors'] as Map<String, dynamic>? ?? {}),
      textStyles: json['textTheme'] as Map<String, dynamic>? ?? {},
      buttonStyles: json['buttonTheme'] as Map<String, dynamic>? ?? {},
      cardStyles: json['cardTheme'] as Map<String, dynamic>? ?? {},
      appBarStyles: json['appBarTheme'] as Map<String, dynamic>? ?? {},
      pageTransitions: json['pageTransitionsTheme'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'colors': colors,
      'textTheme': textStyles,
      'buttonTheme': buttonStyles,
      'cardTheme': cardStyles,
      'appBarTheme': appBarStyles,
      'pageTransitionsTheme': pageTransitions,
    };
  }

  @override
  String toString() {
    return 'ThemeDefinition(id: $id, name: $name, type: $type)';
  }
}

/// Model class representing the entire theme configuration
class ThemeConfiguration {
  final Map<String, ThemeDefinition> themes;

  ThemeConfiguration({required this.themes});

  factory ThemeConfiguration.fromJson(Map<String, dynamic> json) {
    final themeMap = <String, ThemeDefinition>{};
    final themesJson = json['themes'] as Map<String, dynamic>? ?? {};

    themesJson.forEach((key, value) {
      themeMap[key] = ThemeDefinition.fromJson(value as Map<String, dynamic>);
    });

    return ThemeConfiguration(themes: themeMap);
  }

  Map<String, dynamic> toJson() {
    final themesJson = <String, dynamic>{};
    themes.forEach((key, theme) {
      themesJson[key] = theme.toJson();
    });
    return {'themes': themesJson};
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}