import '../entities/credentials.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Credentials> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
