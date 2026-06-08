import '../entities/credentials.dart';

abstract interface class AuthRepository {
  Future<Credentials> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}