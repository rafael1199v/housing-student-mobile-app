import '../../../../core/core.dart';
import '../../domain/entities/credentials.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api.dart';
import '../models/credentials_mapper.dart';
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
  Future<void> logout() async {
    try {
      await _api.logout();
    } catch (_) {
    } finally {
      await _tokenStorage.clear();
    }
  }
}
