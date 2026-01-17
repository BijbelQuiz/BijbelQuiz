import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import '../services/logger.dart';
import '../l10n/strings_nl.dart' as strings;

class AddBookScreen extends StatefulWidget {
  final Book? book;

  const AddBookScreen({super.key, this.book});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final BookService _bookService = BookService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _coverUrlController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  bool? _isChristianContent;
  bool? _hasBadWords;
  bool? _hasViolentContent;
  bool? _hasMatureThemes;
  bool? _isSuitableForAllAges;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _descriptionController.text = widget.book!.description ?? '';
      _coverUrlController.text = widget.book!.coverImageUrl ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _coverUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();
    final description = _descriptionController.text.trim();
    final coverUrl = _coverUrlController.text.trim();

    if (title.isEmpty || author.isEmpty) {
      setState(() {
        _error = strings.AppStrings.fillAllFields;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      Book book;

      if (widget.book != null) {
        book = await _bookService.updateBook(
          bookId: widget.book!.id,
          title: title,
          author: author,
          description: description.isEmpty ? null : description,
          coverImageUrl: coverUrl.isEmpty ? null : coverUrl,
        );
        AppLogger.info('Book updated successfully');
      } else {
        book = await _bookService.createBook(
          title: title,
          author: author,
          description: description.isEmpty ? null : description,
          coverImageUrl: coverUrl.isEmpty ? null : coverUrl,
        );
        AppLogger.info('Book created successfully');
      }

      await _bookService.createOrUpdateReview(
        bookId: book.id,
        isChristianContent: _isChristianContent,
        hasBadWords: _hasBadWords,
        hasViolentContent: _hasViolentContent,
        hasMatureThemes: _hasMatureThemes,
        isSuitableForAllAges: _isSuitableForAllAges,
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.book != null
                ? strings.AppStrings.bookUpdated
                : strings.AppStrings.bookCreated),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Error saving book', e);
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book != null
            ? strings.AppStrings.edit
            : strings.AppStrings.createBook),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.error),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: colorScheme.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(color: colorScheme.onErrorContainer),
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              widget.book != null
                  ? strings.AppStrings.bookDetails
                  : strings.AppStrings.addBook,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: strings.AppStrings.title,
                hintText: strings.AppStrings.enterTitle,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: strings.AppStrings.author,
                hintText: strings.AppStrings.enterAuthor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: strings.AppStrings.description,
                hintText: strings.AppStrings.enterDescription,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 3,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _coverUrlController,
              decoration: InputDecoration(
                labelText: strings.AppStrings.coverImage,
                hintText: strings.AppStrings.enterCoverUrl,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 24),
            Text(
              'Beoordeling',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildYesNoToggle(
              label: strings.AppStrings.christianContent,
              question: strings.AppStrings.christianContentQuestion,
              value: _isChristianContent,
              onChanged: (value) => setState(() => _isChristianContent = value),
            ),
            const SizedBox(height: 12),
            _buildYesNoToggle(
              label: strings.AppStrings.badWords,
              question: strings.AppStrings.badWordsQuestion,
              value: _hasBadWords,
              onChanged: (value) => setState(() => _hasBadWords = value),
            ),
            const SizedBox(height: 12),
            _buildYesNoToggle(
              label: strings.AppStrings.violentContent,
              question: strings.AppStrings.violentContentQuestion,
              value: _hasViolentContent,
              onChanged: (value) => setState(() => _hasViolentContent = value),
            ),
            const SizedBox(height: 12),
            _buildYesNoToggle(
              label: strings.AppStrings.matureThemes,
              question: strings.AppStrings.matureThemesQuestion,
              value: _hasMatureThemes,
              onChanged: (value) => setState(() => _hasMatureThemes = value),
            ),
            const SizedBox(height: 12),
            _buildYesNoToggle(
              label: strings.AppStrings.suitableForAllAges,
              question: strings.AppStrings.suitableForAllAgesQuestion,
              value: _isSuitableForAllAges,
              onChanged: (value) =>
                  setState(() => _isSuitableForAllAges = value),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveBook,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      strings.AppStrings.save,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYesNoToggle({
    required String label,
    required String question,
    required bool? value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          question,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(
              value: true,
              label: Text(strings.AppStrings.yes),
              icon: const Icon(Icons.check),
            ),
            ButtonSegment(
              value: false,
              label: Text(strings.AppStrings.no),
              icon: const Icon(Icons.close),
            ),
          ],
          selected: value == null ? {} : {value},
          onSelectionChanged: (Set<bool> selected) {
            onChanged(selected.isEmpty ? null : selected.first);
          },
        ),
      ],
    );
  }
}
