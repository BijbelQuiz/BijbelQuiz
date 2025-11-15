/// Represents different Bible translations available in the app.
enum BibleTranslation {
  statenvertaling,
  nieuweVertaling,
  kingJames,
  englishStandard,
  newInternational
}

BibleTranslation _parseBibleTranslation(String? translation) {
  if (translation == null) return BibleTranslation.statenvertaling;

  switch (translation.toLowerCase()) {
    case 'statenvertaling':
    case 'staten':
      return BibleTranslation.statenvertaling;
    case 'nieuwevertaling':
    case 'nieuw':
    case 'nv':
      return BibleTranslation.nieuweVertaling;
    case 'kingjames':
    case 'kjv':
      return BibleTranslation.kingJames;
    case 'englishstandard':
    case 'esv':
      return BibleTranslation.englishStandard;
    case 'newinternational':
    case 'niv':
      return BibleTranslation.newInternational;
    default:
      return BibleTranslation.statenvertaling;
  }
}

String _bibleTranslationToString(BibleTranslation translation) {
  switch (translation) {
    case BibleTranslation.statenvertaling:
      return 'statenvertaling';
    case BibleTranslation.nieuweVertaling:
      return 'nieuweVertaling';
    case BibleTranslation.kingJames:
      return 'kingJames';
    case BibleTranslation.englishStandard:
      return 'englishStandard';
    case BibleTranslation.newInternational:
      return 'newInternational';
  }
}

/// Represents a structured Bible reference with book, chapter, and verse information.
class BibleReference {
  /// The name of the Bible book (e.g., "Genesis", "Mattheus").
  final String bookName;

  /// The chapter number in the book.
  final int chapter;

  /// The starting verse number.
  final int verse;

  /// The ending verse number (for verse ranges).
  final int? endVerse;

  /// The Bible translation this reference is from.
  final BibleTranslation translation;

  /// The full formatted reference string (e.g., "Genesis 1:1-3").
  final String fullReference;

  /// Additional context or notes about this reference.
  final String? context;

  /// The language of the book name (nl/en).
  final String language;

  /// Creates a new [BibleReference].
  ///
  /// The [fullReference] is automatically generated if not provided.
  /// For verse ranges, provide both [verse] and [endVerse].
  const BibleReference({
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.translation,
    required this.language,
    this.endVerse,
    String? fullReference,
    this.context,
  }) : fullReference = fullReference ??
            (endVerse != null
                ? '$bookName $chapter:$verse-$endVerse'
                : '$bookName $chapter:$verse');

  /// Creates a [BibleReference] from a JSON map.
  ///
  /// This factory is used to parse Bible reference data from storage or API responses.
  factory BibleReference.fromJson(Map<String, dynamic> json) {
    return BibleReference(
      bookName: json['bookName']?.toString() ?? '',
      chapter: (json['chapter'] is int)
          ? json['chapter'] as int
          : int.tryParse(json['chapter']?.toString() ?? '') ?? 1,
      verse: (json['verse'] is int)
          ? json['verse'] as int
          : int.tryParse(json['verse']?.toString() ?? '') ?? 1,
      endVerse: (json['endVerse'] is int)
          ? json['endVerse'] as int
          : (json['endVerse'] != null
              ? int.tryParse(json['endVerse'].toString())
              : null),
      translation: _parseBibleTranslation(json['translation']?.toString()),
      language: json['language']?.toString() ?? 'nl',
      fullReference: json['fullReference']?.toString(),
      context: json['context']?.toString(),
    );
  }

  /// Converts the [BibleReference] to a JSON map.
  ///
  /// This method is used for storing references or sending them via API.
  Map<String, dynamic> toJson() {
    return {
      'bookName': bookName,
      'chapter': chapter,
      'verse': verse,
      'endVerse': endVerse,
      'translation': _bibleTranslationToString(translation),
      'language': language,
      'fullReference': fullReference,
      'context': context,
    };
  }

  /// Creates a copy of this reference with the given fields replaced.
  BibleReference copyWith({
    String? bookName,
    int? chapter,
    int? verse,
    int? endVerse,
    BibleTranslation? translation,
    String? language,
    String? fullReference,
    String? context,
  }) {
    return BibleReference(
      bookName: bookName ?? this.bookName,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      endVerse: endVerse ?? this.endVerse,
      translation: translation ?? this.translation,
      language: language ?? this.language,
      fullReference: fullReference ?? this.fullReference,
      context: context ?? this.context,
    );
  }

  /// Creates a BibleReference from a formatted string (e.g., "Genesis 1:1-3").
  factory BibleReference.fromString(String referenceString,
      {BibleTranslation? translation, String? language}) {
    // Simple parsing logic for common Bible reference formats
    final regex = RegExp(r'(\w+)\s+(\d+):(\d+)(?:-(\d+))?');
    final match = regex.firstMatch(referenceString.trim());

    if (match != null) {
      final book = match.group(1) ?? '';
      final chapter = int.tryParse(match.group(2) ?? '') ?? 1;
      final verse = int.tryParse(match.group(3) ?? '') ?? 1;
      final endVerse =
          match.group(4) != null ? int.tryParse(match.group(4)!) : null;

      return BibleReference(
        bookName: book,
        chapter: chapter,
        verse: verse,
        endVerse: endVerse,
        translation: translation ?? BibleTranslation.statenvertaling,
        language: language ?? 'nl',
      );
    }

    // Fallback for unparseable strings
    return BibleReference(
      bookName: 'Unknown',
      chapter: 1,
      verse: 1,
      translation: translation ?? BibleTranslation.statenvertaling,
      language: language ?? 'nl',
      fullReference: referenceString,
    );
  }

  /// Checks if this reference represents a verse range.
  bool get isVerseRange => endVerse != null && endVerse! > verse;

  /// Gets the number of verses in this reference.
  int get verseCount => isVerseRange ? (endVerse! - verse) + 1 : 1;

  /// Gets a short display string for this reference.
  String get shortReference => isVerseRange
      ? '$bookName $chapter:$verse-$endVerse'
      : '$bookName $chapter:$verse';

  /// Gets a formatted string suitable for UI display.
  String get displayString {
    final translationName = _getTranslationDisplayName(translation, language);
    return '$fullReference ($translationName)';
  }

  String _getTranslationDisplayName(
      BibleTranslation translation, String language) {
    if (language.toLowerCase() == 'nl') {
      switch (translation) {
        case BibleTranslation.statenvertaling:
          return 'Statenvertaling';
        case BibleTranslation.nieuweVertaling:
          return 'Nieuwe Vertaling';
        case BibleTranslation.kingJames:
          return 'King James';
        case BibleTranslation.englishStandard:
          return 'English Standard';
        case BibleTranslation.newInternational:
          return 'New International';
      }
    } else {
      switch (translation) {
        case BibleTranslation.statenvertaling:
          return 'Statenvertaling';
        case BibleTranslation.nieuweVertaling:
          return 'Nieuwe Vertaling';
        case BibleTranslation.kingJames:
          return 'King James Version';
        case BibleTranslation.englishStandard:
          return 'English Standard Version';
        case BibleTranslation.newInternational:
          return 'New International Version';
      }
    }
  }

  @override
  String toString() => 'BibleReference($fullReference, $translation)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BibleReference &&
        other.bookName == bookName &&
        other.chapter == chapter &&
        other.verse == verse &&
        other.endVerse == endVerse &&
        other.translation == translation &&
        other.language == language;
  }

  @override
  int get hashCode => Object.hash(
        bookName,
        chapter,
        verse,
        endVerse,
        translation,
        language,
      );
}
