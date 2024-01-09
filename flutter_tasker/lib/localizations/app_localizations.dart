import 'package:flutter/material.dart';

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Тексты для локализации
  String get tasksScreenTitle {
    return 'Task List'; // Заголовок экрана списка задач
  }

  String get addTaskButtonTooltip {
    return 'Add Task'; // Подсказка для кнопки добавления задачи
  }
}