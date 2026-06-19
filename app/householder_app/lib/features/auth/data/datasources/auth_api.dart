import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/core.dart';
import '../models/confirm_email_dto.dart';
import '../models/credentials_dto.dart';
import '../models/google_auth_response_dto.dart';
import '../models/google_login_dto.dart';
import '../models/google_register_dto.dart';
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

  @PATCH('/api/auth/confirm-email')
  @Extra({AuthMeta.requiresAuthKey: false})
  Future<void> confirmEmail(@Body() ConfirmEmailDto body);

  @DELETE('/api/auth/logout')
  @Extra({AuthMeta.requiresAuthKey: false})
  Future<void> logout();

  @POST('/api/login/google')
  @Extra({AuthMeta.requiresAuthKey: false})
  Future<GoogleAuthResponseDto> loginWithGoogle(@Body() GoogleLoginDto body);

  @POST('/api/register/google')
  @Extra({AuthMeta.requiresAuthKey: false})
  Future<CredentialsDto> registerWithGoogle(@Body() GoogleRegisterDto body);
}
