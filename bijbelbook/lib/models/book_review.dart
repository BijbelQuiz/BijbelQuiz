class BookReview {
  final String id;
  final String bookId;
  final String userId;
  final bool? isChristianContent;
  final bool? hasBadWords;
  final bool? hasViolentContent;
  final bool? hasMatureThemes;
  final bool? isSuitableForAllAges;
  final String? notes;
  final int? rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookReview({
    required this.id,
    required this.bookId,
    required this.userId,
    this.isChristianContent,
    this.hasBadWords,
    this.hasViolentContent,
    this.hasMatureThemes,
    this.isSuitableForAllAges,
    this.notes,
    this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookReview.fromJson(Map<String, dynamic> json) {
    return BookReview(
      id: json['id'] as String,
      bookId: json['book_id'] as String,
      userId: json['user_id'] as String,
      isChristianContent: json['is_christian_content'] as bool?,
      hasBadWords: json['has_bad_words'] as bool?,
      hasViolentContent: json['has_violent_content'] as bool?,
      hasMatureThemes: json['has_mature_themes'] as bool?,
      isSuitableForAllAges: json['is_suitable_for_all_ages'] as bool?,
      notes: json['notes'] as String?,
      rating: json['rating'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'user_id': userId,
      'is_christian_content': isChristianContent,
      'has_bad_words': hasBadWords,
      'has_violent_content': hasViolentContent,
      'has_mature_themes': hasMatureThemes,
      'is_suitable_for_all_ages': isSuitableForAllAges,
      'notes': notes,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  BookReview copyWith({
    String? id,
    String? bookId,
    String? userId,
    bool? isChristianContent,
    bool? hasBadWords,
    bool? hasViolentContent,
    bool? hasMatureThemes,
    bool? isSuitableForAllAges,
    String? notes,
    int? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookReview(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      userId: userId ?? this.userId,
      isChristianContent: isChristianContent ?? this.isChristianContent,
      hasBadWords: hasBadWords ?? this.hasBadWords,
      hasViolentContent: hasViolentContent ?? this.hasViolentContent,
      hasMatureThemes: hasMatureThemes ?? this.hasMatureThemes,
      isSuitableForAllAges: isSuitableForAllAges ?? this.isSuitableForAllAges,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
