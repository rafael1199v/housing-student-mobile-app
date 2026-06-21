import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

import 'google_sign_in_service.dart';

GoogleSignInService createGoogleSignInServiceImpl({
  String? webClientId,
  String? serverClientId,
}) =>
    GoogleSignInServiceWeb(clientId: webClientId);

class GoogleSignInServiceWeb implements GoogleSignInService {
  GoogleSignInServiceWeb({String? clientId}) : _clientId = clientId;

  final String? _clientId;

  Future<void>? _initialization;

  Future<void> ensureInitialized() => _initialization ??=
      GoogleSignIn.instance.initialize(clientId: _clientId);

  @override
  bool get usesRenderedButton => true;

  @override
  Future<String?> signIn() async {
    await ensureInitialized();
    final account =
        await GoogleSignIn.instance.attemptLightweightAuthentication();
    return account?.authentication.idToken;
  }

  @override
  Widget buildButton({required ValueChanged<String> onIdToken}) =>
      _WebGoogleButton(onIdToken: onIdToken, ensureInitialized: ensureInitialized);
}

class _WebGoogleButton extends StatefulWidget {
  const _WebGoogleButton({
    required this.onIdToken,
    required this.ensureInitialized,
  });

  final ValueChanged<String> onIdToken;
  final Future<void> Function() ensureInitialized;

  @override
  State<_WebGoogleButton> createState() => _WebGoogleButtonState();
}

class _WebGoogleButtonState extends State<_WebGoogleButton> {
  StreamSubscription<GoogleSignInAuthenticationEventSignIn>? _sub;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await widget.ensureInitialized();
    _sub = GoogleSignIn.instance.authenticationEvents
        .where((e) => e is GoogleSignInAuthenticationEventSignIn)
        .cast<GoogleSignInAuthenticationEventSignIn>()
        .listen((event) {
      final token = event.user.authentication.idToken;
      if (token != null && mounted) widget.onIdToken(token);
    });
    if (mounted) setState(() => _ready = true);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const SizedBox(height: 44);
    return Align(child: web.renderButton());
  }
}
