import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../l10n/strings_nl.dart' as strings;
import '../constants/urls.dart';

class BiblicalReferenceDialog extends StatefulWidget {
  final String reference;
  
  const BiblicalReferenceDialog({super.key, required this.reference});

  @override
  State<BiblicalReferenceDialog> createState() => _BiblicalReferenceDialogState();
}

class _BiblicalReferenceDialogState extends State<BiblicalReferenceDialog> {
  bool _isLoading = true;
  String _content = '';
  String _error = '';
  
  // Create a secure HTTP client with timeout and validation
  final http.Client _client = http.Client();

  @override
  void initState() {
    super.initState();
    _loadBiblicalReference();
  }
  
  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  Future<void> _loadBiblicalReference() async {
    try {
      // Parse the reference to extract book, chapter, and verse
      final parsed = _parseReference(widget.reference);
      if (parsed == null) {
        throw Exception('Ongeldige bijbelverwijzing');
      }

      final book = parsed['book'];
      final chapter = parsed['chapter'];
      final startVerse = parsed['startVerse'];
      final endVerse = parsed['endVerse'];

      // Validate book name to prevent injection attacks
      if (!_isValidBookName(book)) {
        throw Exception('Ongeldig boeknaam');
      }

      String url;
      if (startVerse != null && endVerse != null) {
        // Multiple verses
        url = '${AppUrls.scripturaApiBase}/passage?book=$book&chapter=$chapter&start=$startVerse&end=$endVerse&version=statenvertaling';
      } else if (startVerse != null) {
        // Single verse
        url = '${AppUrls.scripturaApiBase}/verse?book=$book&chapter=$chapter&verse=$startVerse&version=statenvertaling';
      } else {
        // Entire chapter
        url = '${AppUrls.scripturaApiBase}/chapter?book=$book&chapter=$chapter&version=statenvertaling';
      }

      // Validate URL to ensure it's from our trusted domain
      final uri = Uri.parse(url);
      if (uri.host != Uri.parse(AppUrls.scripturaApiBase).host) {
        throw Exception('Ongeldige API URL');
      }

      // Make HTTP request with timeout
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Time-out bij het laden van de bijbeltekst');
        },
      );
      
      if (response.statusCode == 200) {
        // Validate content type
        final contentType = response.headers['content-type'];
        if (contentType == null || !contentType.startsWith('application/json')) {
          throw Exception('Ongeldig antwoord van de server');
        }
        
        // Parse and validate JSON response
        final dynamic data = json.decode(response.body);
        String content = '';
        
        if (data is List) {
          // Multiple verses
          for (final verse in data) {
            if (verse is Map<String, dynamic> && 
                verse.containsKey('verse') && 
                verse.containsKey('text')) {
              // Sanitize text to prevent XSS
              final sanitizedText = _sanitizeText(verse['text'].toString());
              content += '${verse['verse']}. $sanitizedText\n';
            }
          }
        } else if (data is Map<String, dynamic>) {
          if (data.containsKey('text')) {
            // Single verse
            final sanitizedText = _sanitizeText(data['text'].toString());
            content = '${data['verse']}. $sanitizedText';
          } else if (data.containsKey('verses') && data['verses'] is List) {
            // Chapter with verses array
            for (final verse in data['verses']) {
              if (verse is Map<String, dynamic> && 
                  verse.containsKey('verse') && 
                  verse.containsKey('text')) {
                // Sanitize text to prevent XSS
                final sanitizedText = _sanitizeText(verse['text'].toString());
                content += '${verse['verse']}. $sanitizedText\n';
              }
            }
          }
        }
        
        if (mounted) {
          setState(() {
            _content = content;
            _isLoading = false;
          });
        }
      } else if (response.statusCode == 429) {
        throw Exception('Te veel verzoeken. Probeer het later opnieuw.');
      } else {
        throw Exception('Fout bij het laden van de bijbeltekst (status: ${response.statusCode})');
      }
    } on SocketException {
      if (mounted) {
        setState(() {
          _error = 'Netwerkfout. Controleer uw internetverbinding.';
          _isLoading = false;
        });
      }
    } on Exception catch (e) {
      if (e.toString().contains('Time-out')) {
        if (mounted) {
          setState(() {
            _error = 'Time-out bij het laden van de bijbeltekst. Probeer het later opnieuw.';
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _error = 'Fout bij het laden: ${e.toString()}';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Fout bij het laden: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }
  
  // Validate book name to prevent injection attacks
  bool _isValidBookName(String book) {
    final validBooks = {
      // Old Testament
      'Genesis', 'Exodus', 'Leviticus', 'Numeri', 'Deuteronomium',
      'Jozua', 'Richteren', 'Ruth', '1 Samuel', '2 Samuel',
      '1 Koningen', '2 Koningen', '1 Kronieken', '2 Kronieken',
      'Ezra', 'Nehemia', 'Ester', 'Job', 'Psalmen', 'Spreuken',
      'Prediker', 'Hooglied', 'Jesaja', 'Jeremia', 'Klaagliederen',
      'Ezechiël', 'Daniël', 'Hosea', 'Joël', 'Amos', 'Obadja',
      'Jona', 'Micha', 'Nahum', 'Habakuk', 'Zefanja', 'Haggai',
      'Zacharia', 'Maleachi',
      
      // New Testament
      'Matteüs', 'Marcus', 'Lukas', 'Johannes', 'Handelingen',
      'Romeinen', '1 Korintiërs', '2 Korintiërs', 'Galaten',
      'Efeziërs', 'Filippenzen', 'Kolossenzen', '1 Tessalonicenzen',
      '2 Tessalonicenzen', '1 Timoteüs', '2 Timoteüs', 'Titus',
      'Filemon', 'Hebreeën', 'Jakobus', '1 Petrus', '2 Petrus',
      '1 Johannes', '2 Johannes', '3 Johannes', 'Judas', 'Openbaring'
    };
    
    return validBooks.contains(book);
  }
  
  // Simple text sanitization to prevent XSS
  String _sanitizeText(String text) {
    // First decode Unicode escape sequences
    String decodedText = _decodeUnicodeEscapes(text);
    
    return decodedText
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');
  }
  
  // Decode Unicode escape sequences like \u00ebl
  String _decodeUnicodeEscapes(String text) {
    final RegExp unicodeRegex = RegExp(r'\u([0-9a-fA-F]{4})');
    return text.replaceAllMapped(unicodeRegex, (Match match) {
      final String hexCode = match.group(1)!;
      final int charCode = int.parse(hexCode, radix: 16);
      return String.fromCharCode(charCode);
    });
  }

  Map<String, dynamic>? _parseReference(String reference) {
    try {
      // Handle different reference formats:
      // "Genesis 1:1" -> book: Genesis, chapter: 1, startVerse: 1
      // "Genesis 1:1-3" -> book: Genesis, chapter: 1, startVerse: 1, endVerse: 3
      // "Genesis 1" -> book: Genesis, chapter: 1
      
      // Remove extra spaces and split by space
      reference = reference.trim();
      final parts = reference.split(' ');
      
      if (parts.length < 2) return null;
      
      // Extract book name (everything except the last part)
      final book = parts.sublist(0, parts.length - 1).join(' ');
      final chapterAndVerses = parts.last;
      
      // Split chapter and verses by colon
      final chapterVerseParts = chapterAndVerses.split(':');
      
      if (chapterVerseParts.isEmpty) return null;
      
      final chapter = int.tryParse(chapterVerseParts[0]);
      if (chapter == null) return null;
      
      int? startVerse;
      int? endVerse;
      
      if (chapterVerseParts.length > 1) {
        // Has verse information
        final versePart = chapterVerseParts[1];
        if (versePart.contains('-')) {
          // Range of verses
          final verseRange = versePart.split('-');
          startVerse = int.tryParse(verseRange[0]);
          endVerse = int.tryParse(verseRange[1]);
        } else {
          // Single verse
          startVerse = int.tryParse(versePart);
        }
      }
      
      return {
        'book': book,
        'chapter': chapter,
        'startVerse': startVerse,
        'endVerse': endVerse,
      };
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(strings.AppStrings.biblicalReference),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error.isNotEmpty
                ? Text(_error)
                : SingleChildScrollView(
                    child: Text(_content),
                  ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(strings.AppStrings.close),
        ),
      ],
    );
  }
}