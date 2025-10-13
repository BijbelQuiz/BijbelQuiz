import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bijbelquiz/utils/color_parser.dart';

void main() {
  group('ColorParser', () {
    group('parseColor', () {
      test('should parse Color object', () {
        const color = Colors.blue;
        final result = ColorParser.parseColor(color);
        expect(result, color);
      });

      test('should parse integer ARGB', () {
        const color = Color(0xFF0000FF); // Blue
        final result = ColorParser.parseColor(0xFF0000FF);
        expect(result, color);
      });

      test('should parse hex color string', () {
        const color = Color(0xFF0000FF); // Blue
        final result = ColorParser.parseColor('#0000FF');
        expect(result, color);
      });

      test('should parse rgb color string', () {
        const color = Color.fromARGB(255, 255, 0, 0); // Red
        final result = ColorParser.parseColor('rgb(255, 0, 0)');
        expect(result, color);
      });

      test('should parse rgba color string', () {
        const color = Color.fromARGB(128, 255, 0, 0); // Red with alpha
        final result = ColorParser.parseColor('rgba(255, 0, 0, 0.5)');
        expect(result, color);
      });

      test('should parse hsl color string', () {
        // Should parse without error
        final result = ColorParser.parseColor('hsl(240, 100%, 50%)');
        expect(result, isNotNull);
      });

      test('should parse color name', () {
        const color = Color(0xFF0000FF); // Blue
        final result = ColorParser.parseColor('blue');
        expect(result, color);
      });

      test('should return fallback color for null input', () {
        final result = ColorParser.parseColor(null, component: 'primary');
        expect(result, isNotNull);
      });

      test('should return fallback color for invalid input', () {
        final result = ColorParser.parseColor('invalid-color', component: 'primary');
        expect(result, isNotNull);
      });
    });

    group('Color format parsing', () {
      test('should parse various hex formats', () {
        // Test 3-digit hex
        const red3 = Color.fromARGB(255, 255, 0, 0);
        expect(ColorParser.parseColor('#F00'), red3);

        // Test 6-digit hex
        const red6 = Color.fromARGB(255, 255, 0, 0);
        expect(ColorParser.parseColor('#FF0000'), red6);

        // Test 8-digit hex with alpha
        const redAlpha = Color.fromARGB(128, 255, 0, 0);
        expect(ColorParser.parseColor('#80FF0000'), redAlpha);
      });

      test('should parse various rgb formats', () {
        // Test rgb format
        const redRgb = Color.fromARGB(255, 255, 0, 0);
        expect(ColorParser.parseColor('rgb(255, 0, 0)'), redRgb);

        // Test rgba format
        const redRgba = Color.fromARGB(128, 255, 0, 0);
        expect(ColorParser.parseColor('rgba(255, 0, 0, 0.5)'), redRgba);

        // Test rgb with spaces
        const redSpaced = Color.fromARGB(255, 255, 0, 0);
        expect(ColorParser.parseColor('rgb( 255 , 0 , 0 )'), redSpaced);
      });

      test('should parse hsl formats', () {
        // Test hsl format - should parse without error
        final blueHsl = ColorParser.parseColor('hsl(240, 100%, 50%)');
        expect(blueHsl, isNotNull);

        // Test hsla format - should parse without error
        final redHsla = ColorParser.parseColor('hsla(0, 100%, 50%, 0.5)');
        expect(redHsla, isNotNull);
      });

      test('should handle invalid color formats gracefully', () {
        final fallback = ColorParser.parseColor('invalid-color', component: 'primary');
        expect(fallback, isNotNull);
      });
    });

    group('Color name parsing', () {
      test('should parse basic color names', () {
        final red = ColorParser.parseColor('red');
        final blue = ColorParser.parseColor('blue');
        final green = ColorParser.parseColor('green');

        expect(red, const Color(0xFFFF0000));
        expect(blue, const Color(0xFF0000FF));
        expect(green, const Color(0xFF00FF00));
      });

      test('should parse extended color names', () {
        final aliceBlue = ColorParser.parseColor('aliceblue');
        final crimson = ColorParser.parseColor('crimson');

        expect(aliceBlue, const Color(0xFFF0F8FF));
        expect(crimson, const Color(0xFFDC143C));
      });

      test('should handle case insensitive color names', () {
        final red1 = ColorParser.parseColor('RED');
        final red2 = ColorParser.parseColor('red');
        final red3 = ColorParser.parseColor('Red');

        expect(red1, red2);
        expect(red2, red3);
        expect(red1, const Color(0xFFFF0000));
      });
    });

    group('normalizeColorToHex', () {
      test('should convert color to hex string', () {
        const color = Color(0xFF2563EB);
        final result = ColorParser.normalizeColorToHex(color);
        expect(result, '#FF2563EB');
      });

      test('should handle transparent colors', () {
        const color = Color(0x802563EB);
        final result = ColorParser.normalizeColorToHex(color);
        expect(result, '#802563EB');
      });
    });

    group('validateContrast', () {
      test('should validate good contrast', () {
        const white = Colors.white;
        const black = Colors.black;
        final result = ColorParser.validateContrast(black, white);
        expect(result, isTrue);
      });

      test('should validate poor contrast', () {
        const lightGray = Color(0xFFE0E0E0);
        const lighterGray = Color(0xFFF0F0F0);
        final result = ColorParser.validateContrast(lightGray, lighterGray);
        expect(result, isFalse);
      });

      test('should use custom minimum ratio', () {
        const darkGray = Color(0xFF404040);
        const mediumGray = Color(0xFF707070);
        final result = ColorParser.validateContrast(darkGray, mediumGray, minRatio: 2.0);
        expect(result, isTrue);
      });
    });

    group('extractColorsFromGeminiResponse', () {
      test('should extract colors from valid JSON response', () {
        const response = '''
        Here are some colors for your theme:
        {
          "primary": "#2563EB",
          "secondary": "#7C3AED",
          "background": "#FFFFFF"
        }
        ''';

        final colors = ColorParser.extractColorsFromGeminiResponse(response);

        expect(colors.containsKey('primary'), isTrue);
        expect(colors.containsKey('secondary'), isTrue);
        expect(colors.containsKey('background'), isTrue);
        expect(colors['primary'], const Color(0xFF2563EB));
      });

      test('should return fallback colors for invalid response', () {
        const response = 'This is not a valid JSON response with colors.';

        final colors = ColorParser.extractColorsFromGeminiResponse(response);

        expect(colors.containsKey('primary'), isTrue);
        expect(colors.containsKey('background'), isTrue);
      });

      test('should handle malformed JSON gracefully', () {
        const response = '''
        Here are colors:
        {
          "primary": "#2563EB",
          "secondary": "#7C3AED"
        '''; // Missing closing brace

        final colors = ColorParser.extractColorsFromGeminiResponse(response);

        expect(colors.containsKey('primary'), isTrue);
        expect(colors.containsKey('background'), isTrue);
      });
    });

    group('getFallbackColorPalette', () {
      test('should return complete color palette', () {
        final palette = ColorParser.getFallbackColorPalette();

        expect(palette.containsKey('primary'), isTrue);
        expect(palette.containsKey('secondary'), isTrue);
        expect(palette.containsKey('background'), isTrue);
        expect(palette.containsKey('surface'), isTrue);
        expect(palette.containsKey('onPrimary'), isTrue);
        expect(palette.containsKey('onSecondary'), isTrue);
        expect(palette.containsKey('onBackground'), isTrue);
        expect(palette.containsKey('onSurface'), isTrue);
      });

      test('should have valid colors for all components', () {
        final palette = ColorParser.getFallbackColorPalette();

        for (final color in palette.values) {
          expect(color, isNotNull);
          expect(color.alpha, greaterThanOrEqualTo(0));
          expect(color.alpha, lessThanOrEqualTo(255));
          expect(color.red, greaterThanOrEqualTo(0));
          expect(color.red, lessThanOrEqualTo(255));
          expect(color.green, greaterThanOrEqualTo(0));
          expect(color.green, lessThanOrEqualTo(255));
          expect(color.blue, greaterThanOrEqualTo(0));
          expect(color.blue, lessThanOrEqualTo(255));
        }
      });
    });

    group('validateColorPalette', () {
      test('should validate good contrast palette', () {
        final palette = {
          'primary': Colors.black,
          'background': Colors.white,
          'secondary': Colors.blue,
          'surface': Colors.white,
          'onPrimary': Colors.white,
          'onSecondary': Colors.white,
          'onBackground': Colors.black,
          'onSurface': Colors.black,
        };

        final validation = ColorParser.validateColorPalette(palette);

        expect(validation.containsKey('primaryContrast'), isTrue);
        expect(validation['primaryContrast'], isTrue);
      });

      test('should validate poor contrast palette', () {
        final palette = {
          'primary': const Color(0xFFE0E0E0),
          'background': const Color(0xFFF0F0F0),
        };

        final validation = ColorParser.validateColorPalette(palette);

        expect(validation.containsKey('primaryContrast'), isTrue);
        expect(validation['primaryContrast'], isFalse);
      });
    });

    group('generateOnColors', () {
      test('should generate appropriate contrast colors', () {
        final palette = {
          'primary': const Color(0xFF2563EB), // Blue
          'secondary': const Color(0xFF7C3AED), // Purple
          'background': const Color(0xFFFFFFFF), // White
          'surface': const Color(0xFFF8FAFC), // Light gray
        };

        final onColors = ColorParser.generateOnColors(palette);

        expect(onColors.containsKey('onPrimary'), isTrue);
        expect(onColors.containsKey('onSecondary'), isTrue);
        expect(onColors.containsKey('onBackground'), isTrue);
        expect(onColors.containsKey('onSurface'), isTrue);

        // Primary and secondary should have white text (dark backgrounds)
        expect(onColors['onPrimary'], Colors.white);
        expect(onColors['onSecondary'], Colors.white);

        // Background and surface should have dark text (light backgrounds)
        expect(onColors['onBackground'], Colors.black);
        expect(onColors['onSurface'], Colors.black);
      });

      test('should handle dark background', () {
        final palette = {
          'background': const Color(0xFF1F2937), // Dark gray
        };

        final onColors = ColorParser.generateOnColors(palette);

        expect(onColors['onBackground'], Colors.white);
      });
    });

    group('Edge cases', () {
      test('should handle empty string input', () {
        final result = ColorParser.parseColor('', component: 'primary');
        expect(result, isNotNull);
      });

      test('should handle whitespace only input', () {
        final result = ColorParser.parseColor('   ', component: 'primary');
        expect(result, isNotNull);
      });

      test('should handle very dark colors', () {
        const darkColor = Color(0xFF000000);
        const lightBg = Color(0xFFFFFFFF);

        // Test contrast validation which uses luminance internally
        final goodContrast = ColorParser.validateContrast(darkColor, lightBg);
        expect(goodContrast, isTrue);
      });

      test('should handle very light colors', () {
        const lightColor = Color(0xFFFFFFFF);
        const darkBg = Color(0xFF000000);

        // Test contrast validation which uses luminance internally
        final goodContrast = ColorParser.validateContrast(lightColor, darkBg);
        expect(goodContrast, isTrue);
      });

      test('should handle alpha values correctly', () {
        const color = Color(0x80FF0000); // Semi-transparent red
        final hex = ColorParser.normalizeColorToHex(color);
        expect(hex, '#80FF0000');
      });
    });
  });
}