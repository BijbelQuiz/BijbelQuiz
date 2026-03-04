class BibleBookMapper {
  // Mapping of English book names to Dutch book names
  static const Map<String, String> _englishToDutch = {
    'Genesis': 'Genesis',
    'Exodus': 'Exodus',
    'Leviticus': 'Leviticus',
    'Numbers': 'Numeri',
    'Deuteronomy': 'Deuteronomium',
    'Joshua': 'Jozua',
    'Judges': 'Richteren',
    'Ruth': 'Ruth',
    '1 Samuel': '1 Samuel',
    '2 Samuel': '2 Samuel',
    '1 Kings': '1 Koningen',
    '2 Kings': '2 Koningen',
    '1 Chronicles': '1 Kronieken',
    '2 Chronicles': '2 Kronieken',
    'Ezra': 'Ezra',
    'Nehemiah': 'Nehemia',
    'Esther': 'Esther',
    'Job': 'Job',
    'Psalms': 'Psalmen',
    'Proverbs': 'Spreuken',
    'Ecclesiastes': 'Prediker',
    'Song of Solomon': 'Hooglied',
    'Isaiah': 'Jesaja',
    'Jeremiah': 'Jeremia',
    'Lamentations': 'Klaagliederen',
    'Ezekiel': 'Ezechiel',
    'Daniel': 'Daniel',
    'Hosea': 'Hosea',
    'Joel': 'Joel',
    'Amos': 'Amos',
    'Obadiah': 'Obadja',
    'Jonah': 'Jona',
    'Micah': 'Micha',
    'Nahum': 'Nahum',
    'Habakkuk': 'Habakuk',
    'Haggai': 'Haggai',
    'Zechariah': 'Zacharia',
    'Malachi': 'Maleachi',
    'Matthew': 'Mattheus',
    'Mark': 'Markus',
    'Luke': 'Lukas',
    'John': 'Johannes',
    'Acts': 'Handelingen',
    'Romans': 'Romeinen',
    '1 Corinthians': '1 Korintiers',
    '2 Corinthians': '2 Korintiers',
    'Galatians': 'Galaten',
    'Ephesians': 'Efeziers',
    'Philippians': 'Filippenzen',
    'Colossians': 'Kolossenzen',
    '1 Thessalonians': '1 Tessalonicenzen',
    '2 Thessalonians': '2 Tessalonicenzen',
    '1 Timothy': '1 Timoteus',
    '2 Timothy': '2 Timoteus',
    'Titus': 'Titus',
    'Philemon': 'Filemon',
    'Hebrews': 'Hebreeen',
    'James': 'Jakobus',
    '1 Peter': '1 Petrus',
    '2 Peter': '2 Petrus',
    '1 John': '1 Johannes',
    '2 John': '2 Johannes',
    '3 John': '3 Johannes',
    'Jude': 'Judas',
    'Revelation': 'Openbaring',
  };

  // Mapping of Dutch book names to their corresponding numbers for online-bijbel.nl API
  // Using normalized names (without special characters) as keys for API compatibility
  static const Map<String, int> _bookNameToNumber = {
    // Old Testament
    'Genesis': 1,
    'Exodus': 2,
    'Leviticus': 3,
    'Numeri': 4,
    'Deuteronomium': 5,
    'Jozua': 6,
    'Richteren': 7,
    'Ruth': 8,
    '1 Samuel': 9,
    '2 Samuel': 10,
    '1 Koningen': 11,
    '2 Koningen': 12,
    '1 Kronieken': 13,
    '2 Kronieken': 14,
    'Ezra': 15,
    'Nehemia': 16,
    'Esther': 17,
    'Job': 18,
    'Psalmen': 19,
    'Spreuken': 20,
    'Prediker': 21,
    'Hooglied': 22,
    'Jesaja': 23,
    'Jeremia': 24,
    'Klaagliederen': 25,
    'Ezechiel': 26,
    'Daniel': 27,
    'Hosea': 28,
    'Joel': 29,
    'Amos': 30,
    'Obadja': 31,
    'Jona': 32,
    'Micha': 33,
    'Nahum': 34,
    'Habakuk': 35,
    'Sefanja': 36,
    'Haggai': 37,
    'Zacharia': 38,
    'Maleachi': 39,

    // New Testament
    'Nieuwe testament': 40,
    'Mattheus': 41,
    'Markus': 42,
    'Lukas': 43,
    'Johannes': 44,
    'Handelingen': 45,
    'Romeinen': 46,
    '1 Korintiers': 47,
    '2 Korintiers': 48,
    'Galaten': 49,
    'Efeziers': 50,
    'Filippenzen': 51,
    'Kolossenzen': 52,
    '1 Tessalonicenzen': 53,
    '2 Tessalonicenzen': 54,
    '1 Timoteus': 55,
    '2 Timoteus': 56,
    'Titus': 57,
    'Filemon': 58,
    'Hebreeen': 59,
    'Jakobus': 60,
    '1 Petrus': 61,
    '2 Petrus': 62,
    '1 Johannes': 63,
    '2 Johannes': 64,
    '3 Johannes': 65,
    'Judas': 66,
    'Openbaring': 67,
  };

  /// Convert Dutch book name to book number for online-bijbel.nl API
  static int? getBookNumber(String bookName) {
    // First try to convert English book name to Dutch
    String normalizedName = _normalizeBookName(bookName.trim());

    // Check if it's an English name and convert to Dutch
    if (_englishToDutch.containsKey(normalizedName)) {
      normalizedName = _englishToDutch[normalizedName]!;
    }

    return _bookNameToNumber[normalizedName];
  }

  /// Check if a book name is valid
  static bool isValidBookName(String bookName) {
    String normalizedName = _normalizeBookName(bookName.trim());

    // Check if it's an English name and convert to Dutch
    if (_englishToDutch.containsKey(normalizedName)) {
      normalizedName = _englishToDutch[normalizedName]!;
    }

    return _bookNameToNumber.containsKey(normalizedName);
  }

  /// Normalize Dutch book names by removing special characters for API compatibility
  static String _normalizeBookName(String bookName) {
    return bookName
        // Convert special characters to ASCII equivalents
        .replaceAll('ë', 'e')
        .replaceAll('ï', 'i')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('â', 'a')
        .replaceAll('ô', 'o')
        .replaceAll('û', 'u')
        .replaceAll('î', 'i')
        .replaceAll('ä', 'a')
        .replaceAll('ö', 'o')
        .replaceAll('ü', 'u')
        .replaceAll('ÿ', 'y')
        .replaceAll('ç', 'c')
        // Remove any remaining special characters
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim();
  }

  /// Get all valid book names (normalized for API)
  static List<String> getAllBookNames() {
    return _bookNameToNumber.keys.toList();
  }

  /// Get book name from number (if needed)
  static String? getBookName(int bookNumber) {
    return _bookNameToNumber.entries
        .where((entry) => entry.value == bookNumber)
        .map((entry) => entry.key)
        .firstOrNull;
  }

  /// Get the original book name (with special characters) from a normalized name
  static String? getOriginalBookName(String normalizedName) {
    // Create reverse mapping for common special character conversions
    const reverseMapping = {
      'Ezechiel': 'Ezechiël',
      'Daniel': 'Daniël',
      'Joel': 'Joël',
      '1 Korintiers': '1 Korintiërs',
      '2 Korintiers': '2 Korintiërs',
      'Efeziers': 'Efeziërs',
      'Hebreeen': 'Hebreeën',
      'Mattheus': 'Mattheüs',
      '1 Timoteus': '1 Timotheüs',
      '2 Timoteus': '2 Timotheüs',
      '1 Samuel': '1 Samuël',
      '2 Samuel': '2 Samuël',
    };

    return reverseMapping[normalizedName] ?? normalizedName;
  }
}
