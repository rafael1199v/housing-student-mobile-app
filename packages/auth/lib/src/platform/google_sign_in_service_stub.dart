import 'package:flutter/widgets.dart';

import 'google_sign_in_service.dart';


GoogleSignInService createGoogleSignInServiceImpl({
  String? webClientId,
  String? serverClientId,
}) =>
    const _UnsupportedGoogleSignInService();

class _UnsupportedGoogleSignInService implements GoogleSignInService {
  const _UnsupportedGoogleSignInService();

  @override
  bool get usesRenderedButton => false;

  @override
  Future<String?> signIn() =>
      throw UnsupportedError('Google Sign-In is not supported on this platform.');

  @override
  Widget buildButton({required ValueChanged<String> onIdToken}) =>
      const SizedBox.shrink();
}