import '../../l10n/gen/auth_localizations.dart';

class AuthValidators {
  const AuthValidators._();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(AuthLocalizations l10n, String value) {
    if (value.isEmpty) return l10n.validationEmailRequired;
    if (!_emailRegex.hasMatch(value)) return l10n.validationEmailInvalid;
    return null;
  }

  static String? password(AuthLocalizations l10n, String value) {
    if (value.isEmpty) return l10n.validationPasswordRequired;
    if (value.length < 6) return l10n.validationPasswordMinLength;
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return l10n.validationPasswordUppercase;
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return l10n.validationPasswordLowercase;
    }
    if (!value.contains(RegExp(r'\d'))) return l10n.validationPasswordDigit;
    if (!value.contains(RegExp(r'[^A-Za-z0-9]'))) {
      return l10n.validationPasswordSpecial;
    }
    return null;
  }

  static String? required(AuthLocalizations l10n, String value, String label) =>
      value.trim().isEmpty ? l10n.validationRequired(label) : null;
}
