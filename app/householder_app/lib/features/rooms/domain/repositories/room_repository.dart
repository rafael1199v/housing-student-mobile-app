import '../entities/room_detail.dart';


abstract interface class RoomRepository {
  Future<RoomDetail> getHouseholderRoomDetail(int roomId);
}
