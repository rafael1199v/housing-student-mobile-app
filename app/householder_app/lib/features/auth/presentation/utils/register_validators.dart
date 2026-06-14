import 'auth_validators.dart';

class RegisterValidators {
  const RegisterValidators._();

  static String? email(String value) => AuthValidators.email(value.trim());

  static String? password(String value) => AuthValidators.password(value);

  static String? required(String value, String label) =>
      AuthValidators.required(value, label);

  static String? confirmPassword(String password, String confirm) {
    if (confirm.isEmpty) return 'Please confirm your password.';
    if (password != confirm) return 'Passwords do not match.';
    return null;
  }

  static String? phoneNumber(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Phone number is required.';
    if (!RegExp(r'^\d{6,15}$').hasMatch(trimmed)) {
      return 'Enter a valid phone number.';
    }
    return null;
  }
}
