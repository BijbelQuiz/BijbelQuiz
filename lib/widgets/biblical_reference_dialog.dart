import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../l10n/strings_nl.dart' as strings;
import 'top_snackbar.dart';

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

  @override
  void initState() {
    super.initState();
    _loadBiblicalReference();
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

      String url;
      if (startVerse != null && endVerse != null) {
        // Multiple verses
        url = 'https://www.scriptura-api.com/api/passage?book=$book&chapter=$chapter&start=$startVerse&end=$endVerse&version=statenvertaling';
      } else if (startVerse != null) {
        // Single verse
        url = 'https://www.scriptura-api.com/api/verse?book=$book&chapter=$chapter&verse=$startVerse&version=statenvertaling';
      } else {
        // Entire chapter
        url = 'https://www.scriptura-api.com/api/chapter?book=$book&chapter=$chapter&version=statenvertaling';
      }

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String content = '';
        
        if (data is List) {
          // Multiple verses
          for (final verse in data) {
            if (verse is Map<String, dynamic>) {
              content += '${verse['verse']}. ${verse['text']}\n';
            }
          }
        } else if (data is Map<String, dynamic>) {
          if (data.containsKey('text')) {
            // Single verse
            content = '${data['verse']}. ${data['text']}';
          } else if (data.containsKey('verses') && data['verses'] is List) {
            // Chapter with verses array
            for (final verse in data['verses']) {
              if (verse is Map<String, dynamic>) {
                content += '${verse['verse']}. ${verse['text']}\n';
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
      } else {
        throw Exception('Fout bij het laden van de bijbeltekst');
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