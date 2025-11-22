class ScripturaBookNameMapper {
  // Mapping of Dutch book names (as used in the app) to English names expected by Scriptura API.
  static const Map<String, String> _dutchToEnglish = {
    // Old Testament
    'Genesis': 'Genesis',
    'Exodus': 'Exodus',
    'Leviticus': 'Leviticus',
    'Numeri': 'Numbers',
    'Deuteronomium': 'Deuteronomy',
    'Jozua': 'Joshua',
    'Richteren': 'Judges',
    'Ruth': 'Ruth',
    '1 Samuël': '1 Samuel',
    '2 Samuël': '2 Samuel',
    '1 Koningen': '1 Kings',
    '2 Koningen': '2 Kings',
    '1 Kronieken': '1 Chronicles',
    '2 Kronieken': '2 Chronicles',
    'Ezra': 'Ezra',
    'Nehemia': 'Nehemiah',
    'Esther': 'Esther',
    'Job': 'Job',
    'Psalmen': 'Psalm',
    'Spreuken': 'Proverbs',
    'Prediker': 'Ecclesiastes',
    'Hooglied': 'Song of Songs',
    'Jesaja': 'Isaiah',
    'Jeremia': 'Jeremiah',
    'Klaagliederen': 'Lamentations',
    'Ezechiël': 'Ezekiel',
    'Daniël': 'Daniel',
    'Hosea': 'Hosea',
    'Joël': 'Joel',
    'Amos': 'Amos',
    'Obadja': 'Obadiah',
    'Jona': 'Jonah',
    'Micha': 'Micah',
    'Nahum': 'Nahum',
    'Habakuk': 'Habakkuk',
    'Zefanja': 'Zephaniah',
    'Haggaï': 'Haggai',
    'Zacharia': 'Zechariah',
    'Maleachi': 'Malachi',
    // New Testament
    'Mattheüs': 'Matthew',
    'Markus': 'Mark',
    'Lukas': 'Luke',
    'Johannes': 'John',
    'Handelingen': 'Acts',
    'Romeinen': 'Romans',
    '1 Corinthiërs': '1 Corinthians',
    '2 Corinthiër': '2 Corinthians',
    'Galaten': 'Galatians',
    'Efeziërs': 'Ephesians',
    'Filippenzen': 'Philippians',
    'Colossenzen': 'Colossians',
    '1 Thessalonicenzen': '1 Thessalonians',
    '2 Thessalonicenzen': '2 Thessalonians',
    '1 Timotheüs': '1 Timothy',
    '2 Timotheüs': '2 Timothy',
    'Titus': 'Titus',
    'Filémon': 'Philemon',
    'Hebreeën': 'Hebrews',
    'Jakobus': 'James',
    '1 Petrus': '1 Peter',
    '2 Petrus': '2 Peter',
    '1 Johannes': '1 John',
    '2 Johannes': '2 John',
    '3 Johannes': '3 John',
    'Judas': 'Jude',
    'Openbaring': 'Revelation',
  };

  /// Normalizes a Dutch book name (removes diacritics, trims) using the same logic as BibleBookMapper.
  static String _normalize(String name) {
    return name
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
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim();
  }

  /// Returns the English book name for a given Dutch (or English) reference.
  /// If the name is already English and present in the Scriptura list, it is returned unchanged.
  static String? toEnglish(String bookName) {
    final normalized = _normalize(bookName);
    // Direct match (English) – check values of the map.
    if (_dutchToEnglish.containsValue(normalized)) {
      return normalized;
    }
    // Lookup Dutch -> English.
    return _dutchToEnglish[normalized];
  }
}
