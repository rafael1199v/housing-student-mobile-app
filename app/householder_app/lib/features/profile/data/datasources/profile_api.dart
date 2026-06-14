import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/avatar_url_dto.dart';
import '../models/update_user_dto.dart';
import '../models/user_profile_dto.dart';

part 'profile_api.g.dart';

@RestApi()
abstract class ProfileApi {
  factory ProfileApi(Dio dio, {String baseUrl}) = _ProfileApi;

  @GET('/api/user')
  Future<UserProfileDto> getUser();

  @PUT('/api/user')
  Future<void> updateUser(@Body() UpdateUserDto body);

  @PUT('/api/user/avatar')
  Future<AvatarUrlDto> uploadAvatar(@Body() FormData body);
}
