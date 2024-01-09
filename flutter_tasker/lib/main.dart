import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'screens/task_screen.dart';
import 'blocs/localization_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocalizationBloc(), // Bloc для управления локализацией
      child: BlocBuilder<LocalizationBloc, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            title: 'Управление задачами',
            theme: ThemeData(primarySwatch: Colors.blue),
            locale: locale, // Текущая локаль
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: TaskScreen(),
          );
        },
      ),
    );
  }
}
