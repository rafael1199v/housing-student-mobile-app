import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';


class CrashKeys {
  const CrashKeys._();

  static bool get _enabled => !kIsWeb;

  static FirebaseCrashlytics get _crashlytics => FirebaseCrashlytics.instance;

  static Future<void> setActiveRole(String roleName, {required bool isStudent}) async {
    if (!_enabled) return;
    await _crashlytics.setCustomKey('active_role', roleName);
    await _crashlytics.setCustomKey('microapp', isStudent ? 'student' : 'householder');
  }

  static Future<void> setUser(String? userId) async {
    if (!_enabled) return;
    await _crashlytics.setUserIdentifier(userId ?? '');
  }

  static Future<void> log(String message) async {
    if (!_enabled) return;
    await _crashlytics.log(message);
  }
}
