class AuthValidators {
  const AuthValidators._();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String value) {
    if (value.isEmpty) return 'Email is required.';
    if (!_emailRegex.hasMatch(value)) return 'Enter a valid email address.';
    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) return 'Password is required.';
    if (value.length < 6) return 'At least 6 characters.';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Add an uppercase letter.';
    if (!value.contains(RegExp(r'[a-z]'))) return 'Add a lowercase letter.';
    if (!value.contains(RegExp(r'\d'))) return 'Add a number.';
    if (!value.contains(RegExp(r'[^A-Za-z0-9]'))) {
      return 'Add a special character.';
    }
    return null;
  }

  static String? required(String value, String label) =>
      value.trim().isEmpty ? '$label is required.' : null;
}
