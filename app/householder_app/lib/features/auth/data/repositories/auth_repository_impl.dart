import '../../../../core/core.dart';
import '../../domain/entities/credentials.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api.dart';
import '../models/credentials_mapper.dart';
import '../models/login_dto.dart';

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
  Future<void> logout() async {
    try {
      await _api.logout();
    } catch (_) {
    } finally {
      await _tokenStorage.clear();
    }
  }
}
