import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'locale_preference_storage.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit({
    required LocalePreferenceStorage storage,
    required Locale initial,
  })  : _storage = storage,
        super(initial);

  final LocalePreferenceStorage _storage;

  static const supported = [Locale('en'), Locale('es'), Locale('pt')];

  static bool isSupported(Locale locale) =>
      supported.any((l) => l.languageCode == locale.languageCode);

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode == state.languageCode) return;
    await _storage.write(locale);
    emit(locale);
  }
}
