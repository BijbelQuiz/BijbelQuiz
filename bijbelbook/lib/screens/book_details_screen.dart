import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/book.dart';
import '../models/book_review.dart';
import '../services/book_service.dart';
import '../services/logger.dart';
import '../l10n/strings_nl.dart' as strings;
import 'add_book_screen.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final BookService _bookService = BookService();

  Book? _book;
  BookReview? _userReview;
  List<BookReview> _allReviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;

      final book = await _bookService.getBookById(widget.book.id);
      BookReview? userReview;
      List<BookReview> allReviews = [];

      if (user != null) {
        userReview = await _bookService.getBookReview(book.id);
      }

      allReviews = await _bookService.getBookReviews(book.id);

      if (mounted) {
        setState(() {
          _book = book;
          _userReview = userReview;
          _allReviews = allReviews;
          _isLoading = false;
        });
      }
    } catch (e) {
      AppLogger.error('Error loading book details', e);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading || _book == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(strings.AppStrings.bookDetails),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final book = _book!;
    final isOwner =
        book.createdBy == Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.AppStrings.bookDetails),
        actions: [
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (book.coverImageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  book.coverImageUrl!,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.book,
                        size: 64,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              book.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.author,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
            if (book.description != null && book.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                book.description!,
                style: theme.textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 24),
            _buildReviewStats(book, theme, colorScheme),
            const SizedBox(height: 24),
            if (_userReview != null)
              _buildUserReview(_userReview!, theme, colorScheme)
            else
              _buildAddReviewButton(),
            const SizedBox(height: 24),
            _buildCommunityReviews(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewStats(
      Book book, ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.AppStrings.reviewStats,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (book.avgRating != null)
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    '${book.avgRating!.toStringAsFixed(1)} (${book.reviewCount ?? 0} ${strings.AppStrings.totalReviews})',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            const SizedBox(height: 12),
            _buildStatBar(
              label: strings.AppStrings.christianContent,
              yesPercentage: book.christianContentPercentage,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _buildStatBar(
              label: strings.AppStrings.badWords,
              yesPercentage: book.noBadWordsPercentage,
              colorScheme: colorScheme,
              invert: true,
            ),
            const SizedBox(height: 12),
            _buildStatBar(
              label: strings.AppStrings.violentContent,
              yesPercentage: book.noViolentContentPercentage,
              colorScheme: colorScheme,
              invert: true,
            ),
            const SizedBox(height: 12),
            _buildStatBar(
              label: strings.AppStrings.matureThemes,
              yesPercentage: book.noMatureThemesPercentage,
              colorScheme: colorScheme,
              invert: true,
            ),
            const SizedBox(height: 12),
            _buildStatBar(
              label: strings.AppStrings.suitableForAllAges,
              yesPercentage: book.suitableForAllAgesPercentage,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar({
    required String label,
    required double? yesPercentage,
    required ColorScheme colorScheme,
    bool invert = false,
  }) {
    final percentage = yesPercentage ?? 0;
    final displayPercentage = invert ? (100 - percentage) : percentage;
    final barColor = invert ? Colors.red : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            Text(
              '${displayPercentage.toStringAsFixed(0)}%',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: displayPercentage / 100,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildUserReview(
      BookReview review, ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strings.AppStrings.yourReview,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _editReview(review),
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text(strings.AppStrings.edit),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildReviewItem(review, theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildAddReviewButton() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              strings.AppStrings.yourReview,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _addReview(),
              icon: const Icon(Icons.add),
              label: Text(strings.AppStrings.editReview),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityReviews(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.AppStrings.communityReviews,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (_allReviews.isEmpty)
          Text(
            strings.AppStrings.noReviews,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
          )
        else
          ..._allReviews.map((review) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: _buildReviewItem(review, theme, colorScheme),
                  ),
                ),
              )),
      ],
    );
  }

  Widget _buildReviewItem(
      BookReview review, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (review.isChristianContent != null)
          _buildChip(
            label: strings.AppStrings.christianContent,
            value: review.isChristianContent!,
            colorScheme: colorScheme,
          ),
        if (review.hasBadWords != null)
          _buildChip(
            label: strings.AppStrings.badWords,
            value: !review.hasBadWords!,
            colorScheme: colorScheme,
            invert: true,
          ),
        if (review.hasViolentContent != null)
          _buildChip(
            label: strings.AppStrings.violentContent,
            value: !review.hasViolentContent!,
            colorScheme: colorScheme,
            invert: true,
          ),
        if (review.hasMatureThemes != null)
          _buildChip(
            label: strings.AppStrings.matureThemes,
            value: !review.hasMatureThemes!,
            colorScheme: colorScheme,
            invert: true,
          ),
        if (review.isSuitableForAllAges != null)
          _buildChip(
            label: strings.AppStrings.suitableForAllAges,
            value: review.isSuitableForAllAges!,
            colorScheme: colorScheme,
          ),
        if (review.notes != null && review.notes!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            review.notes!,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Widget _buildChip({
    required String label,
    required bool value,
    required ColorScheme colorScheme,
    bool invert = false,
  }) {
    final displayValue = invert ? !value : value;
    final chipColor = displayValue ? Colors.green : Colors.red;
    final text = displayValue ? strings.AppStrings.yes : strings.AppStrings.no;

    return Chip(
      label: Text('$label: $text'),
      backgroundColor: chipColor.withValues(alpha: 0.1),
      labelStyle: TextStyle(
        color: chipColor,
        fontSize: 12,
      ),
    );
  }

  Future<void> _editReview(BookReview review) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBookScreen(
          book: _book,
        ),
      ),
    );
    _loadData();
  }

  Future<void> _addReview() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBookScreen(
          book: _book,
        ),
      ),
    );
    _loadData();
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.AppStrings.deleteBookConfirm),
        content: Text(strings.AppStrings.thisActionCannotBeUndone),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _bookService.deleteBook(_book!.id);
                if (mounted) {
                  Navigator.pop(context, true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(strings.AppStrings.bookDeleted),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                AppLogger.error('Error deleting book', e);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
            child: Text(
              strings.AppStrings.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
