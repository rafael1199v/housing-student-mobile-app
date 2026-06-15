import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_preference_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit({
    required ThemePreferenceStorage storage,
    required ThemeMode initial,
  })  : _storage = storage,
        super(initial);

  final ThemePreferenceStorage _storage;

  Future<void> setMode(ThemeMode mode) async {
    if (mode == state) return;
    await _storage.write(mode);
    emit(mode);
  }
}
