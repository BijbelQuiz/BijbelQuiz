import 'dart:convert';
import 'package:flutter/services.dart';

/// Test to verify that the themes JSON is valid and can be loaded
void main() async {
  try {
    // Load and verify the themes JSON file
    final String jsonString = await rootBundle.loadString('assets/themes/themes.json');
    final Map<String, dynamic> json = jsonDecode(jsonString);
    
    print('✓ Themes JSON loaded successfully');
    print('✓ Found ${json['themes'].length} themes:');
    
    final themes = json['themes'] as Map<String, dynamic>;
    for (final entry in themes.entries) {
      print('  - ${entry.key}: ${entry.value['name']} (${entry.value['type']} theme)');
    }
    
    print('\n✓ Centralized theme system is ready!');
    print('✓ You can now add/remove themes by just updating assets/themes/themes.json');
  } catch (e) {
    print('✗ Error loading themes: $e');
  }
}