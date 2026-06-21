import '../entities/credentials.dart';
import '../entities/google_auth_result.dart';

abstract interface class AuthRepository {
  Future<Credentials> login({
    required String email,
    required String password,
  });

  Future<String> register({
    required String email,
    required String password,
    required String role,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String nationality,
    required String gender,
    required String birthDate,
  });

  Future<void> confirmEmail({
    required String userId,
    required String token,
  });

  Future<GoogleAuthResult> loginWithGoogle(String idToken);

  Future<Credentials> registerWithGoogle({
    required String idToken,
    required String role,
  });
  
  Future<void> logout();
}