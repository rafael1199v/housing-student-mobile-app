import '../repositories/auth_repository.dart';

class ConfirmEmailUseCase {
  const ConfirmEmailUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String userId, required String token}) {
    return _repository.confirmEmail(userId: userId, token: token);
  }
}
