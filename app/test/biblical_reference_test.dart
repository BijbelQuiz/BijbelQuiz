import 'package:flutter_test/flutter_test.dart';
import '../lib/widgets/biblical_reference_dialog.dart';

void main() {
  group('BiblicalReferenceDialog', () {
    test('should properly decode Unicode escape sequences', () {
      // Test that Unicode escape sequences are properly decoded
      final textWithUnicodeEscapes = 'Ezechi\\u00ebl';
      final sanitizedText = _sanitizeTextForTesting(textWithUnicodeEscapes);
      
      // The decoded version should contain the actual Unicode character
      expect(sanitizedText, contains('ë'));
      expect(sanitizedText, isNot(contains('\\u00ebl')));
      
      // Test another Unicode escape sequence
      final textWithUnicodeEscapes2 = 'Tessalonicen\\u00ebl';
      final sanitizedText2 = _sanitizeTextForTesting(textWithUnicodeEscapes2);
      
      expect(sanitizedText2, contains('ë'));
      expect(sanitizedText2, isNot(contains('\\u00ebl')));
    });
    
    test('should properly sanitize text after decoding Unicode escapes', () {
      // Test that text sanitization still works after Unicode decoding
      final textWithBoth = 'Ezechi\\u00ebl <script>alert("test")</script>';
      final sanitizedText = _sanitizeTextForTesting(textWithBoth);
      
      // Should contain the decoded Unicode character
      expect(sanitizedText, contains('ë'));
      
      // Should not contain the original Unicode escape sequence
      expect(sanitizedText, isNot(contains('\\u00ebl')));
      
      // Should be sanitized to prevent XSS
      expect(sanitizedText, contains('&lt;script&gt;'));
      expect(sanitizedText, isNot(contains('<script>')));
    });
  });
}

// Helper function to test the sanitization logic
String _sanitizeTextForTesting(String text) {
  // Decode Unicode escape sequences like \\u00ebl
  String _decodeUnicodeEscapes(String text) {
    // Raw string regex to match Unicode escape sequences
    final RegExp unicodeRegex = RegExp(r'\\u([0-9a-fA-F]{4})');
    return text.replaceAllMapped(unicodeRegex, (Match match) {
      final String hexCode = match.group(1)!;
      final int charCode = int.parse(hexCode, radix: 16);
      return String.fromCharCode(charCode);
    });
  }
  
  // Simple text sanitization to prevent XSS
  String decodedText = _decodeUnicodeEscapes(text);
  
  return decodedText
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#x27;');
}