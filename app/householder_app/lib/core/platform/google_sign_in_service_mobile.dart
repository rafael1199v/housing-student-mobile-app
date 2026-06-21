import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'google_sign_in_service.dart';

GoogleSignInService createGoogleSignInServiceImpl({
  String? webClientId,
  String? serverClientId,
}) =>
    GoogleSignInServiceMobile(serverClientId: serverClientId);

class GoogleSignInServiceMobile implements GoogleSignInService {
  GoogleSignInServiceMobile({String? serverClientId})
      : _serverClientId = serverClientId;

  final String? _serverClientId;

  Future<void>? _initialization;

  Future<void> _ensureInitialized() => _initialization ??=
      GoogleSignIn.instance.initialize(serverClientId: _serverClientId);

  @override
  bool get usesRenderedButton => false;

  @override
  Future<String?> signIn() async {
    await _ensureInitialized();
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw StateError(
          'Google returned no ID token. Pass '
          '--dart-define=GOOGLE_WEB_CLIENT_ID=<your web client id> so Android can '
          'mint a token (used as serverClientId) for the backend.',
        );
      }
      return idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  @override
  Widget buildButton({required ValueChanged<String> onIdToken}) =>
      throw UnsupportedError('Mobile uses imperative signIn(), not a button.');
}
