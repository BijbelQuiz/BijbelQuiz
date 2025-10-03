import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bible_provider.dart';
import '../models/bible_book.dart';
import '../models/bible_chapter.dart';
import 'chapter_selection_screen.dart';
import 'search_screen.dart';
import 'bookmarks_screen.dart';
import 'settings_screen.dart';
import '../l10n/strings_nl.dart' as strings;

/// Main navigation screen for Bible reading
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Form state for quick navigation
  final _formKey = GlobalKey<FormState>();
  BibleBook? _selectedBook;
  final _chapterController = TextEditingController();
  final _verseController = TextEditingController();
  final _endVerseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load books when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BibleProvider>().loadBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: _showBookmarks,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Lezen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Zoeken',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bladwijzers',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildReaderTab();
      case 1:
        return _buildSearchTab();
      case 2:
        return _buildBookmarksTab();
      default:
        return _buildReaderTab();
    }
  }

  Widget _buildReaderTab() {
    return Consumer<BibleProvider>(
      builder: (context, bibleProvider, child) {
        if (bibleProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (bibleProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bibleProvider.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => bibleProvider.loadBooks(),
                  child: const Text('Opnieuw proberen'),
                ),
              ],
            ),
          );
        }

        if (bibleProvider.books.isEmpty) {
          return const Center(
            child: Text('Geen boeken beschikbaar'),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Navigeer naar bijbeltekst',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Book dropdown with proper width handling
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          width: double.infinity,
                          child: DropdownButtonFormField<BibleBook>(
                            decoration: const InputDecoration(
                              labelText: 'Bijbelboek',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            initialValue: _selectedBook,
                            hint: const Text('Kies een bijbelboek'),
                            items: bibleProvider.books.map((book) {
                              return DropdownMenuItem(
                                value: book,
                                child: Container(
                                  width: constraints.maxWidth - 60, // Account for dropdown arrow and padding
                                  child: Text(
                                    '${book.name} (${book.chapterCount} hoofdstukken)',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBook = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Selecteer een bijbelboek';
                              }
                              return null;
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Chapter and verse inputs in a row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _chapterController,
                            decoration: const InputDecoration(
                              labelText: 'Hoofdstuk',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vul hoofdstuk in';
                              }
                              final chapter = int.tryParse(value);
                              if (chapter == null || chapter < 1) {
                                return 'Ongeldig hoofdstuk';
                              }
                              if (_selectedBook != null && chapter > _selectedBook!.chapterCount) {
                                return 'Hoofdstuk bestaat niet';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _verseController,
                            decoration: const InputDecoration(
                              labelText: 'Vers',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vul vers in';
                              }
                              final verse = int.tryParse(value);
                              if (verse == null || verse < 1) {
                                return 'Ongeldig vers';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // End verse input
                    TextFormField(
                      controller: _endVerseController,
                      decoration: const InputDecoration(
                        labelText: 'Eind vers (optioneel)',
                        hintText: 'Laat leeg voor enkel vers',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final endVerse = int.tryParse(value);
                          if (endVerse == null || endVerse < 1) {
                            return 'Ongeldig eind vers';
                          }
                          final startVerse = int.tryParse(_verseController.text);
                          if (startVerse != null && endVerse < startVerse) {
                            return 'Eind vers moet na begin vers zijn';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Navigate button
                    ElevatedButton.icon(
                      onPressed: () => _navigateToVerse(),
                      icon: const Icon(Icons.menu_book),
                      label: const Text('Ga naar bijbeltekst'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchTab() {
    return const SearchScreen();
  }

  Widget _buildBookmarksTab() {
    return const BookmarksScreen();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showSearchDialog() {
    // Navigate directly to search tab
    setState(() => _selectedIndex = 1);
  }

  void _navigateToBookSelection(BibleBook book) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChapterSelectionScreen(book: book),
      ),
    );
  }

  void _showBookmarks() {
    // Navigate directly to bookmarks tab
    setState(() => _selectedIndex = 2);
  }

  void _showSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _navigateToVerse() {
    if (!_formKey.currentState!.validate() || _selectedBook == null) {
      return;
    }

    final chapter = int.parse(_chapterController.text);
    final startVerse = int.parse(_verseController.text);
    final endVerseText = _endVerseController.text.trim();
    final endVerse = endVerseText.isNotEmpty ? int.parse(endVerseText) : startVerse;

    // Create a BibleChapter object for navigation
    final chapterObj = BibleChapter(
      bookId: _selectedBook!.id,
      chapter: chapter,
      verseCount: 0, // Will be loaded from API
    );

    // Navigate to the reader screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _BibleReaderScreen(
          book: _selectedBook!,
          chapter: chapterObj,
          startVerse: startVerse,
          endVerse: endVerse,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chapterController.dispose();
    _verseController.dispose();
    _endVerseController.dispose();
    super.dispose();
  }
}

/// Internal Bible reader screen for verse-specific navigation
class _BibleReaderScreen extends StatelessWidget {
  final BibleBook book;
  final BibleChapter chapter;
  final int startVerse;
  final int endVerse;

  const _BibleReaderScreen({
    required this.book,
    required this.chapter,
    required this.startVerse,
    required this.endVerse,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${book.name} ${chapter.chapter}:${startVerse}${endVerse != startVerse ? '-$endVerse' : ''}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {
              // Placeholder for bookmark functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Bladwijzer functie komt later')),
              );
            },
          ),
        ],
      ),
      body: Consumer<BibleProvider>(
        builder: (context, bibleProvider, child) {
          if (bibleProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (bibleProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    bibleProvider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => bibleProvider.loadVerses(book.id, chapter.chapter,
                      startVerse: startVerse,
                      endVerse: endVerse != startVerse ? endVerse : null,
                    ),
                    child: Text(strings.AppStrings.submit),
                  ),
                ],
              ),
            );
          }

          if (bibleProvider.verses.isEmpty) {
            // Load verses when screen opens
            WidgetsBinding.instance.addPostFrameCallback((_) {
              bibleProvider.loadVerses(book.id, chapter.chapter,
                startVerse: startVerse,
                endVerse: endVerse != startVerse ? endVerse : null,
              );
            });
            return const Center(
              child: Text('Verzen laden...'),
            );
          }

          return _buildBibleText(bibleProvider.verses, context);
        },
      ),
      bottomNavigationBar: _buildChapterNavigation(context),
    );
  }

  Widget _buildBibleText(List verses, BuildContext context) {
    // Filter verses based on start and end verse
    final filteredVerses = verses.where((verse) {
      final verseNumber = verse.verse as int;
      return verseNumber >= startVerse && verseNumber <= endVerse;
    }).toList();

    if (filteredVerses.isEmpty) {
      return const Center(
        child: Text('Geen verzen gevonden voor het opgegeven bereik'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredVerses.length,
      itemBuilder: (context, index) {
        final verse = filteredVerses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Verse number
              Container(
                width: 32,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 8, top: 2),
                child: Text(
                  '${verse.verse}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              // Verse text
              Expanded(
                child: Text(
                  verse.text,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChapterNavigation(BuildContext context) {
    return Consumer<BibleProvider>(
      builder: (context, bibleProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous chapter
              if (chapter.chapter > 1)
                ElevatedButton(
                  onPressed: () => _navigateToChapter(chapter.chapter - 1, context),
                  child: const Text('Vorige'),
                )
              else
                const SizedBox(width: 80),

              // Chapter info
              Text(
                '${strings.AppStrings.chapter} ${chapter.chapter}',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              // Next chapter
              if (chapter.chapter < book.chapterCount)
                ElevatedButton(
                  onPressed: () => _navigateToChapter(chapter.chapter + 1, context),
                  child: const Text('Volgende'),
                )
              else
                const SizedBox(width: 80),
            ],
          ),
        );
      },
    );
  }

  void _navigateToChapter(int chapterNumber, BuildContext context) {
    final chapterObj = BibleChapter(
      bookId: book.id,
      chapter: chapterNumber,
      verseCount: 0, // Will be loaded from API
    );

    // Replace current route with new chapter
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => _BibleReaderScreen(
          book: book,
          chapter: chapterObj,
          startVerse: 1, // Start from beginning of new chapter
          endVerse: 1, // Show all verses (same as start to show whole chapter)
        ),
      ),
    );
  }
}