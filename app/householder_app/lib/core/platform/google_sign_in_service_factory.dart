import 'google_sign_in_service.dart';
import 'google_sign_in_service_stub.dart'
    if (dart.library.js_interop) 'google_sign_in_service_web.dart'
    if (dart.library.io) 'google_sign_in_service_mobile.dart';

GoogleSignInService createGoogleSignInService({
  String? webClientId,
  String? serverClientId,
}) =>
    createGoogleSignInServiceImpl(
      webClientId: webClientId,
      serverClientId: serverClientId,
    );
