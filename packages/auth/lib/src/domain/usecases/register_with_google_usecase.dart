import '../entities/credentials.dart';
import '../repositories/auth_repository.dart';

class RegisterWithGoogleUseCase {
  const RegisterWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  Future<Credentials> call({
    required String idToken,
    required String role,
  }) =>
      _repository.registerWithGoogle(idToken: idToken, role: role);
}
