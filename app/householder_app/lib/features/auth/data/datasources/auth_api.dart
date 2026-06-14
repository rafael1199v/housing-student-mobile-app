import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/core.dart';
import '../models/credentials_dto.dart';
import '../models/login_dto.dart';
import '../models/register_dto.dart';
import '../models/register_response_dto.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/api/login')
  @Extra({AuthMeta.requiresAuthKey: false})
  Future<CredentialsDto> login(@Body() LoginDto body);

  @POST('/api/register')
  @Extra({AuthMeta.requiresAuthKey: false})
  Future<RegisterResponseDto> register(@Body() RegisterDto body);

  @DELETE('/api/auth/logout')
  @Extra({AuthMeta.requiresAuthKey: false})
  Future<void> logout();
}
