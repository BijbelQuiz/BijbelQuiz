import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/book.dart';
import '../models/book_review.dart';
import 'logger.dart';

class BookService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Book>> getBooks({
    String? searchQuery,
    String? authorFilter,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      AppLogger.info(
        'Fetching books with filters: search=$searchQuery, author=$authorFilter',
      );

      final response = await _client.rpc(
        'get_books_with_stats',
        params: {
          'search_query': searchQuery,
          'author_filter': authorFilter,
          'limit_count': limit,
          'offset_count': offset,
        },
      );

      final List<dynamic> data = response as List<dynamic>;
      final books = data
          .map((json) => Book.fromJson(json as Map<String, dynamic>))
          .toList();

      AppLogger.info('Successfully fetched ${books.length} books');
      return books;
    } catch (e) {
      AppLogger.error('Error fetching books', e);
      rethrow;
    }
  }

  Future<List<String>> getUniqueAuthors() async {
    try {
      AppLogger.info('Fetching unique authors');

      final response = await _client.rpc('get_unique_authors');
      final List<dynamic> data = response as List<dynamic>;
      final authors = data.map((json) => json as String).toList();

      AppLogger.info('Successfully fetched ${authors.length} unique authors');
      return authors;
    } catch (e) {
      AppLogger.error('Error fetching unique authors', e);
      rethrow;
    }
  }

  Future<Book> getBookById(String bookId) async {
    try {
      AppLogger.info('Fetching book by ID: $bookId');

      final response = await _client
          .from('books')
          .select()
          .eq('id', bookId)
          .single();

      final book = Book.fromJson(response);
      AppLogger.info('Successfully fetched book: ${book.title}');
      return book;
    } catch (e) {
      AppLogger.error('Error fetching book by ID', e);
      rethrow;
    }
  }

  Future<Book> createBook({
    required String title,
    required String author,
    String? description,
    String? coverImageUrl,
  }) async {
    try {
      AppLogger.info('Creating book: $title by $author');

      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await _client
          .from('books')
          .insert({
            'title': title,
            'author': author,
            'description': description,
            'cover_image_url': coverImageUrl,
            'created_by': user.id,
          })
          .select()
          .single();

      final book = Book.fromJson(response);
      AppLogger.info('Successfully created book: ${book.title}');
      return book;
    } catch (e) {
      AppLogger.error('Error creating book', e);
      rethrow;
    }
  }

  Future<Book> updateBook({
    required String bookId,
    String? title,
    String? author,
    String? description,
    String? coverImageUrl,
  }) async {
    try {
      AppLogger.info('Updating book ID: $bookId');

      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await _client
          .from('books')
          .update({
            if (title != null) 'title': title,
            if (author != null) 'author': author,
            if (description != null) 'description': description,
            if (coverImageUrl != null) 'cover_image_url': coverImageUrl,
          })
          .eq('id', bookId)
          .eq('created_by', user.id)
          .select()
          .single();

      final book = Book.fromJson(response);
      AppLogger.info('Successfully updated book: ${book.title}');
      return book;
    } catch (e) {
      AppLogger.error('Error updating book', e);
      rethrow;
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      AppLogger.info('Soft deleting book ID: $bookId');

      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _client
          .from('books')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', bookId)
          .eq('created_by', user.id);

      AppLogger.info('Successfully deleted book ID: $bookId');
    } catch (e) {
      AppLogger.error('Error deleting book', e);
      rethrow;
    }
  }

  Future<BookReview?> getBookReview(String bookId) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        return null;
      }

      AppLogger.info(
        'Fetching review for book ID: $bookId by user: ${user.id}',
      );

      final response = await _client
          .from('book_reviews')
          .select()
          .eq('book_id', bookId)
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      final review = BookReview.fromJson(response);
      AppLogger.info('Successfully fetched review');
      return review;
    } catch (e) {
      AppLogger.error('Error fetching book review', e);
      rethrow;
    }
  }

  Future<BookReview> createOrUpdateReview({
    required String bookId,
    bool? isChristianContent,
    bool? hasBadWords,
    bool? hasViolentContent,
    bool? hasMatureThemes,
    bool? isSuitableForAllAges,
    String? notes,
    int? rating,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      AppLogger.info('Creating/updating review for book ID: $bookId');

      final existingReview = await _client
          .from('book_reviews')
          .select()
          .eq('book_id', bookId)
          .eq('user_id', user.id)
          .maybeSingle();

      BookReview review;

      if (existingReview != null) {
        final response = await _client
            .from('book_reviews')
            .update({
              if (isChristianContent != null)
                'is_christian_content': isChristianContent,
              if (hasBadWords != null) 'has_bad_words': hasBadWords,
              if (hasViolentContent != null)
                'has_violent_content': hasViolentContent,
              if (hasMatureThemes != null) 'has_mature_themes': hasMatureThemes,
              if (isSuitableForAllAges != null)
                'is_suitable_for_all_ages': isSuitableForAllAges,
              if (notes != null) 'notes': notes,
              if (rating != null) 'rating': rating,
            })
            .eq('book_id', bookId)
            .eq('user_id', user.id)
            .select()
            .single();

        review = BookReview.fromJson(response);
        AppLogger.info('Successfully updated review');
      } else {
        final response = await _client
            .from('book_reviews')
            .insert({
              'book_id': bookId,
              'user_id': user.id,
              if (isChristianContent != null)
                'is_christian_content': isChristianContent,
              if (hasBadWords != null) 'has_bad_words': hasBadWords,
              if (hasViolentContent != null)
                'has_violent_content': hasViolentContent,
              if (hasMatureThemes != null) 'has_mature_themes': hasMatureThemes,
              if (isSuitableForAllAges != null)
                'is_suitable_for_all_ages': isSuitableForAllAges,
              if (notes != null) 'notes': notes,
              if (rating != null) 'rating': rating,
            })
            .select()
            .single();

        review = BookReview.fromJson(response);
        AppLogger.info('Successfully created review');
      }

      return review;
    } catch (e) {
      AppLogger.error('Error creating/updating book review', e);
      rethrow;
    }
  }

  Future<List<BookReview>> getBookReviews(String bookId) async {
    try {
      AppLogger.info('Fetching all reviews for book ID: $bookId');

      final response = await _client
          .from('book_reviews')
          .select()
          .eq('book_id', bookId);

      final List<dynamic> data = response as List<dynamic>;
      final reviews = data
          .map((json) => BookReview.fromJson(json as Map<String, dynamic>))
          .toList();

      AppLogger.info('Successfully fetched ${reviews.length} reviews');
      return reviews;
    } catch (e) {
      AppLogger.error('Error fetching book reviews', e);
      rethrow;
    }
  }
}
