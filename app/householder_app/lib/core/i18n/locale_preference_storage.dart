import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class LocalePreferenceStorage {
  static const _key = 'locale';

  Future<Locale?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  Future<void> write(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }
}
