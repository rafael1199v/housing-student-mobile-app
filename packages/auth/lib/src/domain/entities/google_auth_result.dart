import 'credentials.dart';

class GoogleAuthResult {
  const GoogleAuthResult({required this.isNewUser, this.credentials});

  final bool isNewUser;
  final Credentials? credentials;
}
