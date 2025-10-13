import 'package:flutter/material.dart';
import 'strings_nl.dart' as strings_nl;
import 'strings_en.dart' as strings_en;

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('nl', ''),
  ];

  // Get the appropriate strings class based on locale
  dynamic get strings {
    switch (locale.languageCode) {
      case 'en':
        return strings_en.AppStrings();
      case 'nl':
      default:
        return strings_nl.AppStrings();
    }
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any((supportedLocale) => 
        supportedLocale.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}