import 'package:hive/hive.dart';

class LocalizationRepository {
  static const _boxName = 'app_settings';
  static const _localeKey = 'selected_locale';

  Future<void> saveSelectedLocale(String localeCode) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_localeKey, localeCode);
    await box.close();
  }

  Future<String?> getSelectedLocale() async {
    final box = await Hive.openBox(_boxName);
    final selectedLocale = box.get(_localeKey);
    await box.close();
    return selectedLocale as String?;
  }
}