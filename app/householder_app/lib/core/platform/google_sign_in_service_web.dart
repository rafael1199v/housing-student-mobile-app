import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';

import 'google_sign_in_service.dart';

GoogleSignInService createGoogleSignInServiceImpl({
  String? webClientId,
  String? serverClientId,
}) =>
    GoogleSignInServiceWeb(clientId: webClientId);

class GoogleSignInServiceWeb implements GoogleSignInService {
  GoogleSignInServiceWeb({String? clientId})
      : _google = GoogleSignIn(
          clientId: clientId,
          scopes: const ['email', 'profile'],
        );

  final GoogleSignIn _google;

  @override
  bool get usesRenderedButton => true;

  @override
  Future<String?> signIn() async {
    final account = await _google.signInSilently();
    if (account == null) return null;
    final auth = await account.authentication;
    return auth.idToken;
  }

  @override
  Widget buildButton({required ValueChanged<String> onIdToken}) =>
      _WebGoogleButton(google: _google, onIdToken: onIdToken);
}

class _WebGoogleButton extends StatefulWidget {
  const _WebGoogleButton({required this.google, required this.onIdToken});

  final GoogleSignIn google;
  final ValueChanged<String> onIdToken;

  @override
  State<_WebGoogleButton> createState() => _WebGoogleButtonState();
}

class _WebGoogleButtonState extends State<_WebGoogleButton> {
  StreamSubscription<GoogleSignInAccount?>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = widget.google.onCurrentUserChanged.listen(_handleAccount);
    widget.google.signInSilently();
  }

  Future<void> _handleAccount(GoogleSignInAccount? account) async {
    if (account == null) return;
    final auth = await account.authentication;
    final token = auth.idToken;
    if (token != null && mounted) widget.onIdToken(token);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plugin = GoogleSignInPlatform.instance as GoogleSignInPlugin;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth.clamp(200.0, 400.0)
            : 360.0;
        return Align(
          child: plugin.renderButton(
            configuration: GSIButtonConfiguration(
              minimumWidth: width,
              theme: GSIButtonTheme.outline,
              size: GSIButtonSize.large,
              text: GSIButtonText.signinWith,
              shape: GSIButtonShape.rectangular,
              logoAlignment: GSIButtonLogoAlignment.left,
            ),
          ),
        );
      },
    );
  }
}
