import '../entities/google_auth_result.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogleUseCase {
  const LoginWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  Future<GoogleAuthResult> call(String idToken) =>
      _repository.loginWithGoogle(idToken);
}
