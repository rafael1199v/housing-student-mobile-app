import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/created_room_dto.dart';
import '../models/room_householder_detail_dto.dart';

part 'room_api.g.dart';

@RestApi()
abstract class RoomApi {
  factory RoomApi(Dio dio, {String baseUrl}) = _RoomApi;

  @GET('/api/rooms/householder/{roomId}')
  Future<RoomHouseholderDetailDto> getHouseholderRoomDetail(
    @Path('roomId') int roomId,
  );

  @POST('/api/rooms')
  Future<CreatedRoomDto> createRoom(@Body() FormData body);
}
