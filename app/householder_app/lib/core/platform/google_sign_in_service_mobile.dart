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
      : _google = GoogleSignIn(
          serverClientId: serverClientId,
          scopes: const ['email', 'profile'],
        );

  final GoogleSignIn _google;

  @override
  bool get usesRenderedButton => false;

  @override
  Future<String?> signIn() async {
    await _google.signOut();
    final account = await _google.signIn();

    if (account == null) return null;
    final auth = await account.authentication;

    final idToken = auth.idToken;
    
    if (idToken == null) {
      throw StateError(
        'Google returned no ID token. Pass '
        '--dart-define=GOOGLE_WEB_CLIENT_ID=<your web client id> so Android can '
        'mint a token (used as serverClientId) for the backend.',
      );
    }
    return idToken;
  }

  @override
  Widget buildButton({required ValueChanged<String> onIdToken}) =>
      throw UnsupportedError('Mobile uses imperative signIn(), not a button.');
}
