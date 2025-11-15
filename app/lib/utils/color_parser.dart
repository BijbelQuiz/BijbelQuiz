import 'dart:math';
import 'package:flutter/material.dart';
import '../services/logger.dart';

/// Comprehensive color parsing utility for handling various color formats
/// from Gemini API responses and normalizing them for the AI theme system.
class ColorParser {
  // Color name mappings for common color names
  static const Map<String, String> _colorNames = {
    // Basic colors
    'black': '#000000',
    'white': '#FFFFFF',
    'red': '#FF0000',
    'green': '#00FF00',
    'blue': '#0000FF',
    'yellow': '#FFFF00',
    'cyan': '#00FFFF',
    'magenta': '#FF00FF',
    'gray': '#808080',
    'grey': '#808080',
    'orange': '#FFA500',
    'purple': '#800080',
    'pink': '#FFC0CB',
    'brown': '#A52A2A',
    'lime': '#00FF00',
    'teal': '#008080',
    'navy': '#000080',
    'maroon': '#800000',
    'olive': '#808000',
    'silver': '#C0C0C0',
    'gold': '#FFD700',

    // Extended color names
    'aliceblue': '#F0F8FF',
    'antiquewhite': '#FAEBD7',
    'aqua': '#00FFFF',
    'aquamarine': '#7FFFD4',
    'azure': '#F0FFFF',
    'beige': '#F5F5DC',
    'bisque': '#FFE4C4',
    'blanchedalmond': '#FFEBCD',
    'blueviolet': '#8A2BE2',
    'burlywood': '#DEB887',
    'cadetblue': '#5F9EA0',
    'chartreuse': '#7FFF00',
    'chocolate': '#D2691E',
    'coral': '#FF7F50',
    'cornflowerblue': '#6495ED',
    'cornsilk': '#FFF8DC',
    'crimson': '#DC143C',
    'darkblue': '#00008B',
    'darkcyan': '#008B8B',
    'darkgoldenrod': '#B8860B',
    'darkgray': '#A9A9A9',
    'darkgreen': '#006400',
    'darkkhaki': '#BDB76B',
    'darkmagenta': '#8B008B',
    'darkolivegreen': '#556B2F',
    'darkorange': '#FF8C00',
    'darkorchid': '#9932CC',
    'darkred': '#8B0000',
    'darksalmon': '#E9967A',
    'darkseagreen': '#8FBC8F',
    'darkslateblue': '#483D8B',
    'darkslategray': '#2F4F4F',
    'darkturquoise': '#00CED1',
    'darkviolet': '#9400D3',
    'deeppink': '#FF1493',
    'deepskyblue': '#00BFFF',
    'dimgray': '#696969',
    'dodgerblue': '#1E90FF',
    'firebrick': '#B22222',
    'floralwhite': '#FFFAF0',
    'forestgreen': '#228B22',
    'fuchsia': '#FF00FF',
    'gainsboro': '#DCDCDC',
    'ghostwhite': '#F8F8FF',
    'goldenrod': '#DAA520',
    'greenyellow': '#ADFF2F',
    'honeydew': '#F0FFF0',
    'hotpink': '#FF69B4',
    'indianred': '#CD5C5C',
    'indigo': '#4B0082',
    'ivory': '#FFFFF0',
    'khaki': '#F0E68C',
    'lavender': '#E6E6FA',
    'lavenderblush': '#FFF0F5',
    'lawngreen': '#7CFC00',
    'lemonchiffon': '#FFFACD',
    'lightblue': '#ADD8E6',
    'lightcoral': '#F08080',
    'lightcyan': '#E0FFFF',
    'lightgoldenrodyellow': '#FAFAD2',
    'lightgray': '#D3D3D3',
    'lightgreen': '#90EE90',
    'lightpink': '#FFB6C1',
    'lightsalmon': '#FFA07A',
    'lightseagreen': '#20B2AA',
    'lightskyblue': '#87CEFA',
    'lightslategray': '#778899',
    'lightsteelblue': '#B0C4DE',
    'lightyellow': '#FFFFE0',
    'limegreen': '#32CD32',
    'linen': '#FAF0E6',
    'mediumaquamarine': '#66CDAA',
    'mediumblue': '#0000CD',
    'mediumorchid': '#BA55D3',
    'mediumpurple': '#9370DB',
    'mediumseagreen': '#3CB371',
    'mediumslateblue': '#7B68EE',
    'mediumspringgreen': '#00FA9A',
    'mediumturquoise': '#48D1CC',
    'mediumvioletred': '#C71585',
    'midnightblue': '#191970',
    'mintcream': '#F5FFFA',
    'mistyrose': '#FFE4E1',
    'moccasin': '#FFE4B5',
    'navajowhite': '#FFDEAD',
    'oldlace': '#FDF5E6',
    'olivedrab': '#6B8E23',
    'orangered': '#FF4500',
    'orchid': '#DA70D6',
    'palegoldenrod': '#EEE8AA',
    'palegreen': '#98FB98',
    'paleturquoise': '#AFEEEE',
    'palevioletred': '#DB7093',
    'papayawhip': '#FFEFD5',
    'peachpuff': '#FFDAB9',
    'peru': '#CD853F',
    'plum': '#DDA0DD',
    'powderblue': '#B0E0E6',
    'rosybrown': '#BC8F8F',
    'royalblue': '#4169E1',
    'saddlebrown': '#8B4513',
    'salmon': '#FA8072',
    'sandybrown': '#F4A460',
    'seagreen': '#2E8B57',
    'seashell': '#FFF5EE',
    'sienna': '#A0522D',
    'skyblue': '#87CEEB',
    'slateblue': '#6A5ACD',
    'slategray': '#708090',
    'snow': '#FFFAFA',
    'springgreen': '#00FF7F',
    'steelblue': '#4682B4',
    'tan': '#D2B48C',
    'thistle': '#D8BFD8',
    'tomato': '#FF6347',
    'turquoise': '#40E0D0',
    'violet': '#EE82EE',
    'wheat': '#F5DEB3',
    'whitesmoke': '#F5F5F5',
    'yellowgreen': '#9ACD32',
  };

  /// Default fallback colors for each theme component
  static const Map<String, String> _fallbackColors = {
    'primary': '#2563EB',
    'secondary': '#7C3AED',
    'tertiary': '#DC2626',
    'background': '#FFFFFF',
    'surface': '#F8FAFC',
    'onPrimary': '#FFFFFF',
    'onSecondary': '#FFFFFF',
    'onBackground': '#1F2937',
    'onSurface': '#1F2937',
  };

  /// Parses a color from various input formats and returns a normalized Color object
  static Color parseColor(dynamic input, {String component = 'unknown'}) {
    if (input == null) {
      return _getFallbackColor(component);
    }

    try {
      // Handle Color objects
      if (input is Color) {
        return input;
      }

      // Handle integer values (ARGB)
      if (input is int) {
        return Color(input);
      }

      // Handle string inputs
      if (input is String) {
        return _parseColorString(input, component);
      }

      throw const FormatException('Unsupported color format');
    } catch (e) {
      AppLogger.warning(
          'Failed to parse color for $component: $e. Using fallback.');
      return _getFallbackColor(component);
    }
  }

  /// Parses color strings in various formats
  static Color _parseColorString(String input, String component) {
    final cleanInput = input.trim().toLowerCase();

    // Handle hex colors (#RGB, #RRGGBB, #RRGGBBAA)
    if (cleanInput.startsWith('#')) {
      return _parseHexColor(cleanInput);
    }

    // Handle rgb() and rgba() formats
    if (cleanInput.startsWith('rgb')) {
      return _parseRgbColor(cleanInput);
    }

    // Handle hsl() and hsla() formats
    if (cleanInput.startsWith('hsl')) {
      return _parseHslColor(cleanInput);
    }

    // Handle color names
    if (_colorNames.containsKey(cleanInput)) {
      return _parseHexColor(_colorNames[cleanInput]!);
    }

    throw const FormatException('Unknown color format');
  }

  /// Parses hex color strings
  static Color _parseHexColor(String hex) {
    // Remove # if present
    String cleanHex = hex.replaceFirst('#', '');

    // Handle different hex formats
    switch (cleanHex.length) {
      case 3: // #RGB
        final r = int.parse(cleanHex[0] + cleanHex[0], radix: 16);
        final g = int.parse(cleanHex[1] + cleanHex[1], radix: 16);
        final b = int.parse(cleanHex[2] + cleanHex[2], radix: 16);
        return Color.fromARGB(255, r, g, b);

      case 4: // #ARGB
        final a = int.parse(cleanHex[0] + cleanHex[0], radix: 16);
        final r = int.parse(cleanHex[1] + cleanHex[1], radix: 16);
        final g = int.parse(cleanHex[2] + cleanHex[2], radix: 16);
        final b = int.parse(cleanHex[3] + cleanHex[3], radix: 16);
        return Color.fromARGB(a, r, g, b);

      case 6: // #RRGGBB
        final r = int.parse(cleanHex.substring(0, 2), radix: 16);
        final g = int.parse(cleanHex.substring(2, 4), radix: 16);
        final b = int.parse(cleanHex.substring(4, 6), radix: 16);
        return Color.fromARGB(255, r, g, b);

      case 8: // #RRGGBBAA
        final a = int.parse(cleanHex.substring(0, 2), radix: 16);
        final r = int.parse(cleanHex.substring(2, 4), radix: 16);
        final g = int.parse(cleanHex.substring(4, 6), radix: 16);
        final b = int.parse(cleanHex.substring(6, 8), radix: 16);
        return Color.fromARGB(a, r, g, b);

      default:
        throw const FormatException('Invalid hex color format');
    }
  }

  /// Parses RGB color strings (rgb() and rgba() formats)
  static Color _parseRgbColor(String rgb) {
    // Handle various spacing patterns - be more permissive
    final normalized = rgb.replaceAll(RegExp(r'\s+'), '');
    final match = RegExp(r'rgba?\((\d+),(\d+),(\d+)(?:,([\d.]+))?\)')
        .firstMatch(normalized);

    if (match == null) {
      // Try with more flexible pattern that allows spaces
      final flexibleMatch = RegExp(
              r'rgba?\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)(?:\s*,\s*([\d.]+))?\s*\)')
          .firstMatch(rgb);
      if (flexibleMatch == null) {
        throw const FormatException('Invalid RGB format');
      }
      final r = int.parse(flexibleMatch.group(1)!).clamp(0, 255);
      final g = int.parse(flexibleMatch.group(2)!).clamp(0, 255);
      final b = int.parse(flexibleMatch.group(3)!).clamp(0, 255);
      final a = flexibleMatch.group(4) != null
          ? (double.parse(flexibleMatch.group(4)!) * 255).round().clamp(0, 255)
          : 255;
      return Color.fromARGB(a, r, g, b);
    }

    final r = int.parse(match.group(1)!).clamp(0, 255);
    final g = int.parse(match.group(2)!).clamp(0, 255);
    final b = int.parse(match.group(3)!).clamp(0, 255);
    final a = match.group(4) != null
        ? (double.parse(match.group(4)!) * 255).round().clamp(0, 255)
        : 255;

    return Color.fromARGB(a, r, g, b);
  }

  /// Parses HSL color strings (hsl() and hsla() formats)
  static Color _parseHslColor(String hsl) {
    final match = RegExp(
            r'hsla?\(\s*(\d+)\s*,\s*(\d+)%\s*,\s*(\d+)%(?:\s*,\s*([\d.]+))?\s*\)')
        .firstMatch(hsl);

    if (match == null) {
      throw const FormatException('Invalid HSL format');
    }

    final h = double.parse(match.group(1)!) % 360;
    final s = double.parse(match.group(2)!) / 100;
    final l = double.parse(match.group(3)!) / 100;
    final a = match.group(4) != null ? double.parse(match.group(4)!) : 1.0;

    return _hslToColor(h, s, l, a);
  }

  /// Converts HSL values to Color object
  static Color _hslToColor(double h, double s, double l, double a) {
    double r, g, b;

    if (s == 0) {
      r = g = b = l; // Achromatic
    } else {
      double hue2rgb(double p, double q, double t) {
        if (t < 0) t += 1;
        if (t > 1) t -= 1;
        if (t < 1 / 6) return p + (q - p) * 6 * t;
        if (t < 1 / 2) return q;
        if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
        return p;
      }

      final q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      final p = 2 * l - q;
      r = hue2rgb(p, q, h + 1 / 3);
      g = hue2rgb(p, q, h);
      b = hue2rgb(p, q, h - 1 / 3);
    }

    return Color.fromARGB(
      (a * 255).round().clamp(0, 255),
      (r * 255).round().clamp(0, 255),
      (g * 255).round().clamp(0, 255),
      (b * 255).round().clamp(0, 255),
    );
  }

  /// Gets fallback color for a component
  static Color _getFallbackColor(String component) {
    final hexColor = _fallbackColors[component] ?? _fallbackColors['primary']!;
    return _parseHexColor(hexColor);
  }

  /// Normalizes a Color object to hex string format
  static String normalizeColorToHex(Color color) {
    return '#${(color.a * 255.0).round().toRadixString(16).padLeft(2, '0').toUpperCase()}${(color.r * 255.0).round().toRadixString(16).padLeft(2, '0').toUpperCase()}${(color.g * 255.0).round().toRadixString(16).padLeft(2, '0').toUpperCase()}${(color.b * 255.0).round().toRadixString(16).padLeft(2, '0').toUpperCase()}';
  }

  /// Validates if a color meets accessibility contrast requirements
  static bool validateContrast(Color foreground, Color background,
      {double minRatio = 4.5}) {
    final luminance1 = _calculateLuminance(foreground);
    final luminance2 = _calculateLuminance(background);

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    final ratio = (lighter + 0.05) / (darker + 0.05);

    return ratio >= minRatio;
  }

  /// Calculates the relative luminance of a color
  static double _calculateLuminance(Color color) {
    double rsRGB = (color.r * 255.0).round() / 255;
    double gsRGB = (color.g * 255.0).round() / 255;
    double bsRGB = (color.b * 255.0).round() / 255;

    double r = rsRGB <= 0.03928
        ? rsRGB / 12.92
        : pow((rsRGB + 0.055) / 1.055, 2.4).toDouble();
    double g = gsRGB <= 0.03928
        ? gsRGB / 12.92
        : pow((gsRGB + 0.055) / 1.055, 2.4).toDouble();
    double b = bsRGB <= 0.03928
        ? bsRGB / 12.92
        : pow((bsRGB + 0.055) / 1.055, 2.4).toDouble();

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Extracts and parses colors from Gemini API response
  static Map<String, Color> extractColorsFromGeminiResponse(
      String responseText) {
    try {
      // Try to extract JSON from the response - look for content between curly braces
      final jsonMatch = RegExp(r'\{[^{}]*(?:\{[^{}]*\}[^{}]*)*\}', dotAll: true)
          .firstMatch(responseText);
      if (jsonMatch == null) {
        throw const FormatException('No JSON found in response');
      }

      final jsonText = jsonMatch.group(0)!;
      final Map<String, dynamic> colorData = _parseJsonSafely(jsonText);

      return _parseColorPalette(colorData);
    } catch (e) {
      AppLogger.warning(
          'Failed to parse Gemini response: $e. Using fallback colors.');
      return getFallbackColorPalette();
    }
  }

  /// Safely parses JSON with error handling
  static Map<String, dynamic> _parseJsonSafely(String jsonText) {
    try {
      return Map<String, dynamic>.from(_simpleJsonDecode(jsonText));
    } catch (e) {
      throw const FormatException('Invalid JSON format');
    }
  }

  /// Simple JSON decoder that handles common formatting issues
  static Map<String, dynamic> _simpleJsonDecode(String jsonText) {
    // This is a simplified JSON parser for basic color palette objects
    // In a production app, you'd use the json.decode() method
    final cleaned = jsonText
        .replaceAll(RegExp(r'[\r\n\s]+'), ' ')
        .replaceAll(RegExp(r'\s*:\s*'), ':')
        .replaceAll(RegExp(r'\s*,\s*'), ',')
        .replaceAll(RegExp(r'\s*\{\s*'), '{')
        .replaceAll(RegExp(r'\s*\}\s*'), '}');

    // Extract key-value pairs
    final pairs = <String, dynamic>{};

    // Simple regex to match "key": "value" patterns (including numeric values)
    final matches = RegExp(r'"([^"]+)":\s*"([^"]+)"').allMatches(cleaned);
    for (final match in matches) {
      final key = match.group(1);
      final value = match.group(2);
      if (key != null && value != null) {
        pairs[key] = value;
      }
    }

    // Also try to match "key": "value" patterns with single quotes
    final singleQuoteMatches =
        RegExp(r"'([^']+)':\s*'([^']+)'").allMatches(cleaned);
    for (final match in singleQuoteMatches) {
      final key = match.group(1);
      final value = match.group(2);
      if (key != null && value != null) {
        pairs[key] = value;
      }
    }

    return pairs;
  }

  /// Parses color palette from extracted data
  static Map<String, Color> _parseColorPalette(Map<String, dynamic> colorData) {
    final colors = <String, Color>{};

    // Define expected color components in order of priority
    final components = [
      'primary',
      'secondary',
      'tertiary',
      'accent',
      'background',
      'surface',
      'onPrimary',
      'onSecondary',
      'onBackground',
      'onSurface'
    ];

    for (final component in components) {
      if (colorData.containsKey(component)) {
        colors[component] =
            parseColor(colorData[component], component: component);
      }
    }

    // Ensure we have at least primary and background colors
    if (!colors.containsKey('primary')) {
      colors['primary'] = _getFallbackColor('primary');
    }
    if (!colors.containsKey('background')) {
      colors['background'] = _getFallbackColor('background');
    }

    return colors;
  }

  /// Gets fallback color palette with all required colors
  static Map<String, Color> getFallbackColorPalette() {
    final colors = <String, Color>{};
    for (final component in _fallbackColors.keys) {
      colors[component] = _getFallbackColor(component);
    }
    return colors;
  }

  /// Validates that a color palette meets accessibility requirements
  static Map<String, bool> validateColorPalette(Map<String, Color> colors) {
    final validation = <String, bool>{};

    // Check primary contrast against background
    if (colors.containsKey('primary') && colors.containsKey('background')) {
      validation['primaryContrast'] = validateContrast(
        colors['primary']!,
        colors['background']!,
      );
    }

    // Check secondary contrast against background
    if (colors.containsKey('secondary') && colors.containsKey('background')) {
      validation['secondaryContrast'] = validateContrast(
        colors['secondary']!,
        colors['background']!,
      );
    }

    // Check surface contrast against onSurface
    if (colors.containsKey('surface') && colors.containsKey('onSurface')) {
      validation['surfaceContrast'] = validateContrast(
        colors['onSurface']!,
        colors['surface']!,
      );
    }

    return validation;
  }

  /// Generates appropriate on-colors for a color palette
  static Map<String, Color> generateOnColors(Map<String, Color> colors) {
    final onColors = <String, Color>{};

    // Generate onPrimary (contrast color for primary)
    if (colors.containsKey('primary')) {
      onColors['onPrimary'] = _generateContrastColor(colors['primary']!);
    }

    // Generate onSecondary (contrast color for secondary)
    if (colors.containsKey('secondary')) {
      onColors['onSecondary'] = _generateContrastColor(colors['secondary']!);
    }

    // Generate onBackground (contrast color for background)
    if (colors.containsKey('background')) {
      onColors['onBackground'] = _generateContrastColor(colors['background']!);
    }

    // Generate onSurface (contrast color for surface)
    if (colors.containsKey('surface')) {
      onColors['onSurface'] = _generateContrastColor(colors['surface']!);
    }

    return onColors;
  }

  /// Generates a contrast color (black or white) for the given color
  static Color _generateContrastColor(Color color) {
    // Use luminance to determine whether to use black or white text
    final luminance = _calculateLuminance(color);
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
