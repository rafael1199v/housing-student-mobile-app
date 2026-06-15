import '../entities/room_detail.dart';
import '../repositories/room_repository.dart';

class GetRoomDetailUseCase {
  const GetRoomDetailUseCase(this._repository);

  final RoomRepository _repository;

  Future<RoomDetail> call(int roomId) =>
      _repository.getHouseholderRoomDetail(roomId);
}
