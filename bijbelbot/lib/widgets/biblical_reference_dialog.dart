import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:xml/xml.dart' as xml;
import '../l10n/strings_nl.dart' as strings;
import '../constants/urls.dart';
import '../utils/bible_book_mapper.dart';

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
        throw Exception('Ongeldige bijbelverwijzing: "${widget.reference}"');
      }

      final book = parsed['book'];
      final chapter = parsed['chapter'];
      final startVerse = parsed['startVerse'];
      final endVerse = parsed['endVerse'];

      // Convert book name to book number for the new API
      final bookNumber = BibleBookMapper.getBookNumber(book);
      if (bookNumber == null) {
        // Debug: show what book name was received and what valid names are available
        final validBooks = BibleBookMapper.getAllBookNames();
        throw Exception('Ongeldig boeknaam: "$book". Geldige boeken: ${validBooks.take(10).join(", ")}...');
      }

      String url;
      if (startVerse != null && endVerse != null) {
        // Multiple verses - format as "startVerse-endVerse"
        url = '${AppUrls.bibleApiBase}?b=$bookNumber&h=$chapter&v=$startVerse-$endVerse';
      } else if (startVerse != null) {
        // Single verse
        url = '${AppUrls.bibleApiBase}?b=$bookNumber&h=$chapter&v=$startVerse';
      } else {
        // Entire chapter - request a reasonable sample (first 10 verses)
        url = '${AppUrls.bibleApiBase}?b=$bookNumber&h=$chapter&v=1-10';
      }

      // Validate URL to ensure it's from our trusted domain
      final uri = Uri.parse(url);
      if (uri.host != Uri.parse(AppUrls.bibleApiBase).host) {
        throw Exception(strings.AppStrings.invalidApiUrl);
      }

      // Make HTTP request with timeout
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception(strings.AppStrings.timeoutError);
        },
      );

      if (response.statusCode == 200) {
        // Validate content type - be more flexible
        final contentType = response.headers['content-type'];
        if (contentType == null || (!contentType.contains('xml') && !contentType.contains('text'))) {
          throw Exception('${strings.AppStrings.invalidContentType}. Content-Type: $contentType. Response: ${response.body.substring(0, 300)}...');
        }

        // Parse XML response
        String content = '';
        try {
          // Clean the response body first (remove BOM or other artifacts)
          String cleanBody = response.body.trim();
          if (cleanBody.startsWith('\uFEFF')) {
            cleanBody = cleanBody.substring(1);
          }

          final document = xml.XmlDocument.parse(cleanBody);

          // Find all verse elements in the XML structure: bijbel > bijbelboek > hoofdstuk > vers
          final verses = document.findAllElements('vers');

          for (final verse in verses) {
            final verseNumber = verse.getAttribute('name');
            final verseText = verse.innerText.trim();

            if (verseNumber != null && verseText.isNotEmpty) {
              // Sanitize text to prevent XSS
              final sanitizedText = _sanitizeText(verseText);
              content += '$verseNumber. $sanitizedText\n';
            }
          }

          // If no verses found with 'vers' elements, try alternative element names
          if (content.isEmpty) {
            final alternativeVerseElements = document.findAllElements('verse');
            for (final verse in alternativeVerseElements) {
              final verseNumber = verse.getAttribute('name') ?? verse.getAttribute('number');
              final verseText = verse.innerText.trim();

              if (verseNumber != null && verseText.isNotEmpty) {
                final sanitizedText = _sanitizeText(verseText);
                content += '$verseNumber. $sanitizedText\n';
              }
            }
          }

          // If still no content, try to extract any meaningful text
          if (content.isEmpty) {
            final allElements = <xml.XmlElement>[];
            _collectAllElements(document.rootElement, allElements);

            for (final element in allElements) {
              final elementText = element.innerText.trim();
              // Look for elements that contain actual Bible text (not just markup)
              if (elementText.isNotEmpty &&
                  elementText.length > 10 &&
                  !elementText.contains('<') &&
                  !elementText.contains('xml') &&
                  !elementText.contains('bijbel')) {
                final sanitizedText = _sanitizeText(elementText);
                content += '$sanitizedText\n';
              }
            }
          }

          // If still no content, show debug info
          if (content.isEmpty) {
            throw Exception('${strings.AppStrings.noTextFound}. XML length: ${response.body.length}, First 300 chars: ${response.body.substring(0, 300)}');
          }
        } catch (e) {
          // If XML parsing fails, try to extract text directly from response
          String extractedText = _extractTextFromResponse(response.body);
          if (extractedText.isNotEmpty) {
            content = _sanitizeText(extractedText);
          } else {
            throw Exception('${strings.AppStrings.xmlParsingFailed}: $e');
          }
        }

        if (mounted) {
          setState(() {
            _content = content;
            _isLoading = false;
          });
        }
      } else if (response.statusCode == 429) {
        throw Exception(strings.AppStrings.tooManyRequests);
      } else {
        throw Exception('${strings.AppStrings.serverError} ${response.statusCode})');
      }
    } on SocketException {
      if (mounted) {
        setState(() {
          _error = strings.AppStrings.networkError;
          _isLoading = false;
        });
      }
    } on Exception catch (e) {
      if (e.toString().contains('Time-out')) {
        if (mounted) {
          setState(() {
            _error = strings.AppStrings.timeoutError;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _error = '${strings.AppStrings.errorLoadingWithDetails} ${e.toString()}';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '${strings.AppStrings.errorLoadingWithDetails} ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }


  // Simple text sanitization to prevent XSS
  String _sanitizeText(String text) {
    // First decode Unicode escape sequences
    String decodedText = _decodeUnicodeEscapes(text);

    return decodedText
        .replaceAll('&', '&')
        .replaceAll('<', '<')
        .replaceAll('>', '>')
        .replaceAll('"', '"')
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

  void _collectAllElements(xml.XmlElement element, List<xml.XmlElement> collection) {
    collection.add(element);
    for (final child in element.childElements) {
      _collectAllElements(child, collection);
    }
  }

  String _extractTextFromResponse(String responseBody) {
    // Try to extract meaningful text from various response formats
    try {
      // If it's XML, try to parse and extract text content
      if (responseBody.contains('<') && responseBody.contains('>')) {
        final document = xml.XmlDocument.parse(responseBody);
        final allElements = <xml.XmlElement>[];
        _collectAllElements(document.rootElement, allElements);

        for (final element in allElements) {
          final text = element.innerText.trim();
          if (text.isNotEmpty && text.length > 10) {
            return text;
          }
        }
      }

      // If not XML or no text found, return the whole body (it might be plain text)
      return responseBody.trim();
    } catch (e) {
      // If all parsing fails, return the original body
      return responseBody.trim();
    }
  }

  Map<String, dynamic>? _parseReference(String reference) {
    try {
      // Handle different reference formats:
      // "Genesis 1:1" -> book: Genesis, chapter: 1, startVerse: 1
      // "Genesis 1:1-3" -> book: Genesis, chapter: 1, startVerse: 1, endVerse: 3
      // "Genesis 1" -> book: Genesis, chapter: 1
      // "Genesis 2 en 3" -> book: Genesis, chapter: 2, startVerse: 3 (special case)
      // "Psalmen" -> book: Psalmen, chapter: 1 (whole book)

      reference = reference.trim();

      // Special case for "book chapter en chapter" format
      if (reference.contains(' en ')) {
        final parts = reference.split(' en ');
        if (parts.length == 2) {
          final firstPart = parts[0].trim();
          final secondPart = parts[1].trim();

          // Parse first reference
          final firstMatch = RegExp(r'(\w+)\s+(\d+)').firstMatch(firstPart);
          if (firstMatch != null) {
            final book = firstMatch.group(1)!;
            final chapter = int.tryParse(firstMatch.group(2)!);

            // Parse second reference
            final secondMatch = RegExp(r'(\d+)').firstMatch(secondPart);
            if (secondMatch != null) {
              // For "book chapter en chapter" format, we treat it as a single chapter reference
              return {
                'book': book,
                'chapter': chapter,
                'startVerse': null,
                'endVerse': null,
              };
            }
          }
        }
      }

      // Standard parsing for "Book chapter:verse" format
      final parts = reference.split(' ');
      if (parts.length < 2) {
        // Handle single word references like "Psalmen"
        if (BibleBookMapper.isValidBookName(reference)) {
          return {
            'book': reference,
            'chapter': 1,
            'startVerse': null,
            'endVerse': null,
          };
        }
        return null;
      }

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