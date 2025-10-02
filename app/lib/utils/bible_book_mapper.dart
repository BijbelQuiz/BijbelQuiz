class BibleBookMapper {
  // Mapping of Dutch book names to their corresponding numbers for online-bijbel.nl API
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
    'Ester': 17,
    'Job': 18,
    'Psalmen': 19,
    'Spreuken': 20,
    'Prediker': 21,
    'Hooglied': 22,
    'Jesaja': 23,
    'Jeremia': 24,
    'Klaagliederen': 25,
    'Ezechiël': 26,
    'Daniël': 27,
    'Hosea': 28,
    'Joël': 29,
    'Amos': 30,
    'Obadja': 31,
    'Jona': 32,
    'Micha': 33,
    'Nahum': 34,
    'Habakuk': 35,
    'Zefanja': 36,
    'Haggai': 37,
    'Zacharia': 38,
    'Maleachi': 39,

    // New Testament
    'Matteüs': 40,
    'Marcus': 41,
    'Lukas': 42,
    'Johannes': 43,
    'Handelingen': 44,
    'Romeinen': 45,
    '1 Korintiërs': 46,
    '2 Korintiërs': 47,
    'Galaten': 48,
    'Efeziërs': 49,
    'Filippenzen': 50,
    'Kolossenzen': 51,
    '1 Tessalonicenzen': 52,
    '2 Tessalonicenzen': 53,
    '1 Timoteüs': 54,
    '2 Timoteüs': 55,
    'Titus': 56,
    'Filemon': 57,
    'Hebreeën': 58,
    'Jakobus': 59,
    '1 Petrus': 60,
    '2 Petrus': 61,
    '1 Johannes': 62,
    '2 Johannes': 63,
    '3 Johannes': 64,
    'Judas': 65,
    'Openbaring': 66,
  };

  /// Convert Dutch book name to book number for online-bijbel.nl API
  static int? getBookNumber(String bookName) {
    return _bookNameToNumber[bookName.trim()];
  }

  /// Check if a book name is valid
  static bool isValidBookName(String bookName) {
    return _bookNameToNumber.containsKey(bookName.trim());
  }

  /// Get all valid book names
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
}