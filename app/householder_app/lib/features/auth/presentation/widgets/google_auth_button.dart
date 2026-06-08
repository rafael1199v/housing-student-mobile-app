import 'package:flutter/material.dart';
import 'package:householder_design_system/householder_design_system.dart';

import '../../../../../core/core.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({
    super.key,
    required this.service,
    required this.onIdToken,
    required this.label,
    this.enabled = true,
    this.onError,
  });

  final GoogleSignInService service;
  final ValueChanged<String> onIdToken;
  final String label;
  final bool enabled;
  final ValueChanged<Object>? onError;

  Future<void> _signInImperative() async {
    try {
      final idToken = await service.signIn();
      if (idToken != null) onIdToken(idToken);
    } catch (error) {
      onError?.call(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (service.usesRenderedButton) {
      return service.buildButton(onIdToken: onIdToken);
    }
    return GoogleButton(
      label: label,
      onPressed: enabled ? _signInImperative : null,
    );
  }
}
