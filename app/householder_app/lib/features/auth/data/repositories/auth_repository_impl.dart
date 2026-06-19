import '../../../../core/core.dart';
import '../../domain/entities/credentials.dart';
import '../../domain/entities/google_auth_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api.dart';
import '../models/confirm_email_dto.dart';
import '../models/credentials_mapper.dart';
import '../models/google_auth_response_mapper.dart';
import '../models/google_login_dto.dart';
import '../models/google_register_dto.dart';
import '../models/login_dto.dart';
import '../models/register_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthApi api,
    required TokenStorage tokenStorage,
  }) : _api = api,
       _tokenStorage = tokenStorage;

  final AuthApi _api;
  final TokenStorage _tokenStorage;

  @override
  Future<Credentials> login({
    required String email,
    required String password,
  }) async {
    try {
      final dto = await _api.login(LoginDto(email: email, password: password));
      final credentials = dto.toEntity();
      await _tokenStorage.saveTokens(
        accessToken: credentials.accessToken,
        refreshToken: credentials.refreshToken,
      );
      return credentials;
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<String> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String nationality,
    required String gender,
    required String birthDate,
  }) async {
    try {
      final dto = await _api.register(
        RegisterDto(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          nationality: nationality,
          gender: gender,
          birthDate: birthDate,
        ),
      );
      return dto.userId;
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<void> confirmEmail({
    required String userId,
    required String token,
  }) async {
    try {
      await _api.confirmEmail(ConfirmEmailDto(userId: userId, token: token));
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<GoogleAuthResult> loginWithGoogle(String idToken) async {
    try {
      final dto = await _api.loginWithGoogle(GoogleLoginDto(idToken: idToken));
      final result = dto.toEntity();
      final credentials = result.credentials;
      if (credentials != null) {
        await _tokenStorage.saveTokens(
          accessToken: credentials.accessToken,
          refreshToken: credentials.refreshToken,
        );
      }
      return result;
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<Credentials> registerWithGoogle({
    required String idToken,
    required String role,
  }) async {
    try {
      final dto = await _api.registerWithGoogle(
        GoogleRegisterDto(idToken: idToken, role: role),
      );
      final credentials = dto.toEntity();
      await _tokenStorage.saveTokens(
        accessToken: credentials.accessToken,
        refreshToken: credentials.refreshToken,
      );
      return credentials;
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _api.logout();
    } catch (_) {
    } finally {
      await _tokenStorage.clear();
    }
  }
}
