import '../../../../core/core.dart';
import 'auth_validators.dart';

class RegisterValidators {
  const RegisterValidators._();

  static String? email(AppLocalizations l10n, String value) =>
      AuthValidators.email(l10n, value.trim());

  static String? password(AppLocalizations l10n, String value) =>
      AuthValidators.password(l10n, value);

  static String? required(AppLocalizations l10n, String value, String label) =>
      AuthValidators.required(l10n, value, label);

  static String? confirmPassword(
    AppLocalizations l10n,
    String password,
    String confirm,
  ) {
    if (confirm.isEmpty) return l10n.validationConfirmPasswordRequired;
    if (password != confirm) return l10n.validationPasswordsNoMatch;
    return null;
  }

  static String? phoneNumber(AppLocalizations l10n, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return l10n.validationPhoneRequired;
    if (!RegExp(r'^\d{6,15}$').hasMatch(trimmed)) {
      return l10n.validationPhoneInvalid;
    }
    return null;
  }
}
