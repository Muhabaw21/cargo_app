import 'dart:ui';

class Language {
  final String languageCode;
  final String languageName;
  final Locale locale;

  Language({
    required this.languageCode,
    required this.languageName,
    required this.locale,
  });
}