import 'package:flutter/widgets.dart';

abstract interface class GoogleSignInService {
  bool get usesRenderedButton;
  Future<String?> signIn();
  Widget buildButton({required ValueChanged<String> onIdToken});
}
