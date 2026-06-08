import 'google_sign_in_service.dart';
import 'google_sign_in_service_stub.dart';

GoogleSignInService createGoogleSignInService({
  String? webClientId,
  String? serverClientId,
}) =>
    createGoogleSignInServiceImpl(
      webClientId: webClientId,
      serverClientId: serverClientId,
    );
