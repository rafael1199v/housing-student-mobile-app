import '../entities/credentials.dart';

abstract interface class AuthRepository {
  Future<Credentials> login({
    required String email,
    required String password,
  });

  Future<String> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String nationality,
    required String gender,
    required String birthDate,
  });

  Future<void> logout();
}