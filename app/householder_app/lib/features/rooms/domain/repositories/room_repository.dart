import '../entities/create_room_params.dart';
import '../entities/room_detail.dart';


abstract interface class RoomRepository {
  Future<RoomDetail> getHouseholderRoomDetail(int roomId);

  Future<void> createRoom(CreateRoomParams params);
}
