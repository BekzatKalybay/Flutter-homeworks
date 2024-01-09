class LocalizationBloc extends Bloc<String, Locale> {
  LocalizationBloc() : super(Locale('en')); // Устанавливаем язык по умолчанию

  @override
  Stream<Locale> mapEventToState(String event) async* {
    if (event == 'change_to_russian') {
      yield Locale('ru'); // Устанавливаем русский язык
    } else if (event == 'change_to_english') {
      yield Locale('en'); // Устанавливаем английский язык
    }
    // Можно добавить другие условия для изменения на другие языки
  }
}