import '../repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<String> call({
    required String email,
    required String password,
    required String role,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String nationality,
    required String gender,
    required String birthDate,
  }) {
    return _repository.register(
      email: email,
      password: password,
      role: role,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      nationality: nationality,
      gender: gender,
      birthDate: birthDate,
    );
  }
}
