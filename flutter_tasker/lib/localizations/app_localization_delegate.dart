class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  // Поддерживаемые языки
  static const supportedLanguages = ['en', 'ru'];

  @override
  bool isSupported(Locale locale) {
    // Проверяем, что languageCode поддерживается
    return supportedLanguages.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations();
    await localizations.load(); // Загрузка текстов для локализации
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
