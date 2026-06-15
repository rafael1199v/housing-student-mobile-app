import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferenceStorage {
  static const _key = 'theme_mode';

  Future<ThemeMode> read() async {
    final prefs = await SharedPreferences.getInstance();
    return _decode(prefs.getString(_key));
  }

  Future<void> write(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _encode(mode));
  }

  String _encode(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };

  ThemeMode _decode(String? value) => switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}
