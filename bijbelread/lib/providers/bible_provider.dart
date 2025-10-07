import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bible_book.dart';
import '../models/bible_chapter.dart';
import '../models/bible_verse.dart';
import '../models/search_result.dart';
import '../models/bookmark.dart';
import '../models/database_verse.dart';
import '../models/offline_content.dart';
import '../services/bible_service.dart';
import '../services/offline_bible_service.dart';
import '../services/download_service.dart';
import '../services/connection_service.dart';
import '../services/logger.dart';

/// Internal class to represent a navigation location in the Bible
class _BibleLocation {
  final String bookId;
  final int chapter;
  final int? verse;

  const _BibleLocation({
    required this.bookId,
    required this.chapter,
    this.verse,
  });

  @override
  String toString() => 'BibleLocation(bookId: $bookId, chapter: $chapter, verse: $verse)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _BibleLocation &&
      runtimeType == other.runtimeType &&
      bookId == other.bookId &&
      chapter == other.chapter &&
      verse == other.verse;

  @override
  int get hashCode => bookId.hashCode ^ chapter.hashCode ^ (verse?.hashCode ?? 0);
}

/// Provider for Bible reading state management with offline support
class BibleProvider extends ChangeNotifier {
  final BibleService _bibleService;
  final OfflineBibleService _offlineBibleService;
  final DownloadService _downloadService;
  final ConnectionService _connectionService;

  // State
  List<BibleBook> _books = [];
  List<BibleChapter> _chapters = [];
  List<BibleVerse> _verses = [];
  List<SearchResult> _searchResults = [];
  List<SearchHistoryEntry> _searchHistory = [];
  List<Bookmark> _bookmarks = [];
  List<BookmarkCategory> _bookmarkCategories = [];
  List<OfflineContent> _offlineContent = [];
  bool _isLoading = false;
  String? _error;

  // Current selection
  BibleBook? _selectedBook;
  BibleChapter? _selectedChapter;

  // Navigation history for back button functionality
  final List<_BibleLocation> _navigationHistory = [];

  // Search and filter state
  String _currentSearchQuery = '';
  List<SearchFilter> _activeFilters = [];

  // Offline state
  bool _isOfflineMode = false;
  bool _hasOfflineContent = false;
  String? _offlineMessage;

  // Stream subscriptions
  StreamSubscription? _offlineContentSubscription;
  StreamSubscription? _connectionSubscription;

  BibleProvider(
    this._bibleService,
    this._offlineBibleService,
    this._downloadService,
    this._connectionService,
  ) {
    // Load stored data when provider is created
    loadStoredData();
    _setupOfflineListeners();
  }

  // Getters
  List<BibleBook> get books => _books;
  List<BibleChapter> get chapters => _chapters;
  List<BibleVerse> get verses => _verses;
  List<SearchResult> get searchResults => _searchResults;
  List<SearchHistoryEntry> get searchHistory => _searchHistory;
  List<Bookmark> get bookmarks => _bookmarks;
  List<BookmarkCategory> get bookmarkCategories => _bookmarkCategories;
  List<OfflineContent> get offlineContent => _offlineContent;
  bool get isLoading => _isLoading;
  String? get error => _error;
  BibleBook? get selectedBook => _selectedBook;
  BibleChapter? get selectedChapter => _selectedChapter;
  String get currentSearchQuery => _currentSearchQuery;
  List<SearchFilter> get activeFilters => _activeFilters;

  // Offline state getters
  bool get isOfflineMode => _isOfflineMode;
  bool get hasOfflineContent => _hasOfflineContent;
  String? get offlineMessage => _offlineMessage;

  /// Load all Bible books
  Future<void> loadBooks() async {
    if (_books.isNotEmpty) return; // Already loaded

    _setLoading(true);
    _clearError();

    try {
      AppLogger.info('Loading Bible books...');
      _books = await _bibleService.getBooks();
      notifyListeners();
      AppLogger.info('Bible books loaded successfully');
    } catch (e) {
      _setError('Failed to load Bible books: $e');
      AppLogger.error('Error loading Bible books: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load chapters for a specific book
  Future<void> loadChapters(String bookId) async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.info('Loading chapters for book: $bookId');
      _chapters = await _bibleService.getChapters(bookId);

      // Update selected book
      _selectedBook = _books.firstWhere((book) => book.id == bookId);
      _selectedChapter = null; // Reset chapter selection

      notifyListeners();
      AppLogger.info('Chapters loaded successfully');
    } catch (e) {
      _setError('Failed to load chapters: $e');
      AppLogger.error('Error loading chapters: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load verses for a specific chapter with offline fallback
  Future<void> loadVerses(String bookId, int chapter, {int? startVerse, int? endVerse}) async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.info('Loading verses for $bookId chapter $chapter');

      // Try to load from offline storage first if offline mode is active
      if (_isOfflineMode || !_connectionService.isOnline) {
        try {
          _verses = await _offlineBibleService.getVerses(bookId, chapter);
          _offlineMessage = 'Offline modus - verzen geladen uit lokale opslag';

          // Update selected chapter
          _selectedChapter = _chapters.firstWhere(
            (chap) => chap.bookId == bookId && chap.chapter == chapter,
          );

          notifyListeners();
          AppLogger.info('Verses loaded from offline storage');
          return;
        } catch (e) {
          _offlineMessage = 'Offline modus - geen lokale verzen gevonden';
          AppLogger.warning('No offline verses found for $bookId:$chapter');
        }
      }

      // Load from online service
      _verses = await _bibleService.getVerses(bookId, chapter, startVerse: startVerse, endVerse: endVerse);

      // Update selected chapter - handle case where chapters might not be loaded
      try {
        _selectedChapter = _chapters.firstWhere(
          (chap) => chap.bookId == bookId && chap.chapter == chapter,
        );
      } catch (e) {
        // If chapter not found in list, create a temporary one for navigation
        AppLogger.info('Chapter $chapter not found in chapters list for book $bookId, creating temporary for navigation');
        _selectedChapter = BibleChapter(
          bookId: bookId,
          chapter: chapter,
          verseCount: _verses.length, // Use actual loaded verses count
        );
      }

      // Clear offline message if successfully loaded online
      if (_connectionService.isOnline) {
        _offlineMessage = null;
      }

      notifyListeners();
      AppLogger.info('Verses loaded successfully');
    } catch (e) {
      _setError('Failed to load verses: $e');
      AppLogger.error('Error loading verses: $e');

      // If online loading fails and we have offline content, suggest offline mode
      if (_hasOfflineContent) {
        _offlineMessage = 'Online laden mislukt - probeer offline modus';
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Search for text in the Bible
  Future<void> searchBible(String query) async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.info('Searching Bible for: $query');

      // Perform the search
      final bibleVerses = await _bibleService.searchBible(query);

      // Convert BibleVerse results to SearchResult objects
      _searchResults = await _convertToSearchResults(bibleVerses, query);

      // Add to search history
      _addToSearchHistory(query, _searchResults.length);

      _currentSearchQuery = query;
      notifyListeners();
      AppLogger.info('Bible search completed');
    } catch (e) {
      _setError('Search failed: $e');
      AppLogger.error('Error searching Bible: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Select a book
  void selectBook(BibleBook book) {
    _selectedBook = book;
    _selectedChapter = null;
    _chapters = [];
    _verses = [];
    notifyListeners();
  }

  /// Select a chapter
  void selectChapter(BibleChapter chapter) {
    _selectedChapter = chapter;
    _verses = [];
    notifyListeners();
  }

  /// Clear search results
  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  /// Clear error state
  void clearError() {
    _clearError();
  }

  /// Navigate to a specific chapter and verse
  void navigateToChapter(String bookId, int chapter, {int? verse}) {
    // Add current location to history if we have one
    if (_selectedBook != null && _selectedChapter != null) {
      _navigationHistory.add(_BibleLocation(
        bookId: _selectedBook!.id,
        chapter: _selectedChapter!.chapter,
      ));
    }

    // Load the new chapter
    loadVerses(bookId, chapter);

    // Update selection
    _selectedBook = _books.firstWhere((book) => book.id == bookId);
    _selectedChapter = _chapters.firstWhere(
      (chap) => chap.bookId == bookId && chap.chapter == chapter,
    );

    notifyListeners();
  }

  /// Navigate to the previous location in history
  _BibleLocation? getPreviousLocation() {
    return _navigationHistory.isNotEmpty ? _navigationHistory.removeLast() : null;
  }

  /// Check if we can go back in navigation history
  bool get canGoBack => _navigationHistory.isNotEmpty;

  /// Get current location for external reference
  _BibleLocation? get currentLocation {
    if (_selectedBook != null && _selectedChapter != null) {
      return _BibleLocation(
        bookId: _selectedBook!.id,
        chapter: _selectedChapter!.chapter,
      );
    }
    return null;
  }

  /// Clear navigation history
  void clearNavigationHistory() {
    _navigationHistory.clear();
    notifyListeners();
  }

  // Bookmark management methods
  /// Add a bookmark for the current verse
  Future<void> addBookmark(BibleVerse verse, String bookName, {String? notes, List<String> tags = const []}) async {
    final bookmark = Bookmark.fromBibleVerse(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bibleVerse: verse,
      bookName: bookName,
      notes: notes,
      tags: tags,
    );

    _bookmarks.add(bookmark);
    await _saveBookmarksToStorage();
    notifyListeners();
    AppLogger.info('Bookmark added for ${verse.reference}');
  }

  /// Remove a bookmark
  Future<void> removeBookmark(String bookmarkId) async {
    _bookmarks.removeWhere((bookmark) => bookmark.id == bookmarkId);
    await _saveBookmarksToStorage();
    notifyListeners();
    AppLogger.info('Bookmark removed: $bookmarkId');
  }

  /// Update a bookmark
  Future<void> updateBookmark(Bookmark updatedBookmark) async {
    final index = _bookmarks.indexWhere((bookmark) => bookmark.id == updatedBookmark.id);
    if (index != -1) {
      _bookmarks[index] = updatedBookmark;
      await _saveBookmarksToStorage();
      notifyListeners();
      AppLogger.info('Bookmark updated: ${updatedBookmark.id}');
    }
  }

  /// Get bookmarks by tag
  List<Bookmark> getBookmarksByTag(String tag) {
    return _bookmarks.where((bookmark) => bookmark.tags.contains(tag)).toList();
  }

  /// Check if a verse is bookmarked
  bool isVerseBookmarked(String bookId, int chapter, int verse) {
    return _bookmarks.any((bookmark) =>
      bookmark.bookId == bookId &&
      bookmark.chapter == chapter &&
      bookmark.verse == verse
    );
  }

  // Search functionality methods
  /// Add search to history
  void _addToSearchHistory(String query, int resultCount) {
    // Remove existing entry if it exists
    _searchHistory.removeWhere((entry) => entry.query == query);

    // Add new entry at the beginning
    _searchHistory.insert(0, SearchHistoryEntry(
      query: query,
      timestamp: DateTime.now(),
      resultCount: resultCount,
    ));

    // Keep only the last 50 searches
    if (_searchHistory.length > 50) {
      _searchHistory = _searchHistory.take(50).toList();
    }

    _saveSearchHistoryToStorage();
  }

  /// Clear search history
  void clearSearchHistory() {
    _searchHistory.clear();
    _saveSearchHistoryToStorage();
    notifyListeners();
  }

  /// Remove a specific search from history
  void removeFromSearchHistory(String query) {
    _searchHistory.removeWhere((entry) => entry.query == query);
    _saveSearchHistoryToStorage();
    notifyListeners();
  }

  /// Apply search filters
  void applySearchFilters(List<SearchFilter> filters) {
    _activeFilters = filters;
    notifyListeners();
  }

  /// Clear search filters
  void clearSearchFilters() {
    _activeFilters = [];
    notifyListeners();
  }

  /// Get filtered search results
  List<SearchResult> getFilteredSearchResults() {
    if (_activeFilters.isEmpty) {
      return _searchResults;
    }

    return _searchResults.where((result) {
      return _activeFilters.every((filter) {
        switch (filter.type) {
          case 'testament':
            return result.testament == filter.value;
          case 'book':
            return result.bookId == filter.value;
          default:
            return true;
        }
      });
    }).toList();
  }

  /// Convert BibleVerse results to SearchResult objects
  Future<List<SearchResult>> _convertToSearchResults(List<BibleVerse> bibleVerses, String query) async {
    final searchResults = <SearchResult>[];

    for (final verse in bibleVerses) {
      // Get book information to determine testament and book name
      String bookName = verse.bookId; // Fallback to ID if name not found
      String testament = 'old'; // Default to old testament

      try {
        final books = await _bibleService.getBooks();
        final book = books.firstWhere((book) => book.id == verse.bookId);
        bookName = book.name;
        testament = book.testament;
      } catch (e) {
        AppLogger.warning('Could not get book info for ${verse.bookId}: $e');
      }

      final searchResult = SearchResult.fromBibleVerse(verse, query, bookName, testament);
      searchResults.add(searchResult);
    }

    return searchResults;
  }

  // Storage methods
  /// Save bookmarks to local storage
  Future<void> _saveBookmarksToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarksJson = _bookmarks.map((b) => b.toJson()).toList();
      await prefs.setString('bijbelread_bookmarks', json.encode(bookmarksJson));
    } catch (e) {
      AppLogger.error('Error saving bookmarks: $e');
    }
  }

  /// Load bookmarks from local storage
  Future<void> _loadBookmarksFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarksString = prefs.getString('bijbelread_bookmarks');
      if (bookmarksString != null) {
        final bookmarksJson = json.decode(bookmarksString) as List<dynamic>;
        _bookmarks = bookmarksJson.map((json) => Bookmark.fromJson(json)).toList();
      }
    } catch (e) {
      AppLogger.error('Error loading bookmarks: $e');
    }
  }

  /// Save search history to local storage
  Future<void> _saveSearchHistoryToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = _searchHistory.map((entry) => {
        'query': entry.query,
        'timestamp': entry.timestamp.toIso8601String(),
        'resultCount': entry.resultCount,
      }).toList();
      await prefs.setString('bijbelread_search_history', json.encode(historyJson));
    } catch (e) {
      AppLogger.error('Error saving search history: $e');
    }
  }

  /// Load search history from local storage
  Future<void> _loadSearchHistoryFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyString = prefs.getString('bijbelread_search_history');
      if (historyString != null) {
        final historyJson = json.decode(historyString) as List<dynamic>;
        _searchHistory = historyJson.map((json) => SearchHistoryEntry(
          query: json['query'] as String,
          timestamp: DateTime.parse(json['timestamp'] as String),
          resultCount: json['resultCount'] as int,
        )).toList();
      }
    } catch (e) {
      AppLogger.error('Error loading search history: $e');
    }
  }

  /// Initialize bookmark categories
  void _initializeBookmarkCategories() {
    _bookmarkCategories = BookmarkCategory.defaultCategories;
  }

  /// Load data from storage during initialization
  Future<void> loadStoredData() async {
    await _loadBookmarksFromStorage();
    await _loadSearchHistoryFromStorage();
    await _loadOfflineContent();
    _initializeBookmarkCategories();
    notifyListeners();
  }

  /// Setup offline-related stream listeners
  void _setupOfflineListeners() {
    _offlineContentSubscription = _offlineBibleService.contentStream.listen((content) {
      _updateOfflineContent(content);
    });

    _connectionSubscription = _connectionService.connectionStream.listen((isOnline) {
      _handleConnectionChange(isOnline);
    });
  }

  /// Load offline content
  Future<void> _loadOfflineContent() async {
    try {
      final content = await _offlineBibleService.getOfflineContent();
      _offlineContent = content;
      _hasOfflineContent = content.isNotEmpty;
      notifyListeners();
    } catch (e) {
      AppLogger.error('Error loading offline content: $e');
    }
  }

  /// Update offline content
  void _updateOfflineContent(OfflineContent content) {
    final index = _offlineContent.indexWhere((c) => c.id == content.id);
    if (index >= 0) {
      _offlineContent[index] = content;
    } else {
      _offlineContent.add(content);
    }
    _hasOfflineContent = _offlineContent.isNotEmpty;
    notifyListeners();
  }

  /// Handle connection state changes
  void _handleConnectionChange(bool isOnline) {
    if (!isOnline && _hasOfflineContent) {
      _isOfflineMode = true;
      _offlineMessage = 'Offline modus actief - gebruikt gedownloade inhoud';
    } else if (isOnline) {
      _isOfflineMode = false;
      _offlineMessage = null;
    }
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Offline functionality methods
  /// Check if content is available offline
  bool isContentAvailableOffline(String bookId, {int? chapter}) {
    return _offlineContent.any((content) {
      if (content.bookId != bookId) return false;
      if (chapter == null) {
        // Check if entire book is available
        return content.isComplete;
      } else {
        // Check if specific chapter is available
        return content.chapter == chapter && content.isComplete;
      }
    });
  }

  /// Get offline content for a book
  OfflineContent? getOfflineContentForBook(String bookId) {
    try {
      return _offlineContent.firstWhere((content) => content.bookId == bookId);
    } catch (e) {
      return null;
    }
  }

  /// Enable offline mode
  void enableOfflineMode() {
    if (!_hasOfflineContent) {
      _offlineMessage = 'Geen offline inhoud beschikbaar';
      return;
    }

    _isOfflineMode = true;
    _offlineMessage = 'Offline modus ingeschakeld';
    notifyListeners();
    AppLogger.info('Offline mode enabled');
  }

  /// Disable offline mode
  void disableOfflineMode() {
    _isOfflineMode = false;
    _offlineMessage = null;
    notifyListeners();
    AppLogger.info('Offline mode disabled');
  }

  /// Search in offline content
  Future<List<DatabaseSearchResult>> searchOffline(String query) async {
    if (!_hasOfflineContent) {
      return [];
    }

    try {
      return await _offlineBibleService.searchVerses(query);
    } catch (e) {
      AppLogger.error('Error searching offline content: $e');
      return [];
    }
  }

  /// Get offline statistics
  Future<DatabaseStats> getOfflineStats() async {
    try {
      return await _offlineBibleService.getDatabaseStats();
    } catch (e) {
      AppLogger.error('Error getting offline stats: $e');
      rethrow;
    }
  }

  /// Clear all offline data
  Future<void> clearOfflineData() async {
    try {
      await _offlineBibleService.clearAllData();
      _offlineContent.clear();
      _hasOfflineContent = false;

      if (_isOfflineMode) {
        _isOfflineMode = false;
        _offlineMessage = 'Offline gegevens gewist - offline modus uitgeschakeld';
      }

      notifyListeners();
      AppLogger.info('All offline data cleared');
    } catch (e) {
      AppLogger.error('Error clearing offline data: $e');
      rethrow;
    }
  }

  /// Refresh offline content
  Future<void> refreshOfflineContent() async {
    await _loadOfflineContent();
    notifyListeners();
  }

  /// Check if we should use offline content
  bool shouldUseOfflineContent() {
    return _isOfflineMode || (!_connectionService.isOnline && _hasOfflineContent);
  }

  /// Get current data source description
  String getCurrentDataSource() {
    if (_isOfflineMode) {
      return 'Offline (lokale opslag)';
    } else if (!_connectionService.isOnline) {
      return 'Offline (automatische fallback)';
    } else {
      return 'Online';
    }
  }

  @override
  void dispose() {
    _offlineContentSubscription?.cancel();
    _connectionSubscription?.cancel();
    _bibleService.dispose();
    _offlineBibleService.dispose();
    _downloadService.dispose();
    _connectionService.dispose();
    super.dispose();
  }
}