class Book {
  final String id;
  final String title;
  final String author;
  final String? description;
  final String? coverImageUrl;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? reviewCount;
  final double? avgRating;
  final double? christianContentPercentage;
  final double? noBadWordsPercentage;
  final double? noViolentContentPercentage;
  final double? noMatureThemesPercentage;
  final double? suitableForAllAgesPercentage;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    this.coverImageUrl,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.reviewCount,
    this.avgRating,
    this.christianContentPercentage,
    this.noBadWordsPercentage,
    this.noViolentContentPercentage,
    this.noMatureThemesPercentage,
    this.suitableForAllAgesPercentage,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      reviewCount: json['review_count'] as int?,
      avgRating: (json['avg_rating'] as num?)?.toDouble(),
      christianContentPercentage: (json['christian_content_percentage'] as num?)
          ?.toDouble(),
      noBadWordsPercentage: (json['no_bad_words_percentage'] as num?)
          ?.toDouble(),
      noViolentContentPercentage:
          (json['no_violent_content_percentage'] as num?)?.toDouble(),
      noMatureThemesPercentage: (json['no_mature_themes_percentage'] as num?)
          ?.toDouble(),
      suitableForAllAgesPercentage:
          (json['suitable_for_all_ages_percentage'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'cover_image_url': coverImageUrl,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverImageUrl,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reviewCount: reviewCount,
      avgRating: avgRating,
      christianContentPercentage: christianContentPercentage,
      noBadWordsPercentage: noBadWordsPercentage,
      noViolentContentPercentage: noViolentContentPercentage,
      noMatureThemesPercentage: noMatureThemesPercentage,
      suitableForAllAgesPercentage: suitableForAllAgesPercentage,
    );
  }
}
