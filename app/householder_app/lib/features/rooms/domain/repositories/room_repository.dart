import '../entities/create_room_params.dart';
import '../entities/room_detail.dart';
import '../entities/update_room_params.dart';


abstract interface class RoomRepository {
  Future<RoomDetail> getHouseholderRoomDetail(int roomId);

  Future<void> createRoom(CreateRoomParams params);

  Future<void> updateRoom(int roomId, UpdateRoomParams params);
}
