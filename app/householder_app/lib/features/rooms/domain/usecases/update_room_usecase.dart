import '../entities/update_room_params.dart';
import '../repositories/room_repository.dart';

class UpdateRoomUseCase {
  const UpdateRoomUseCase(this._repository);

  final RoomRepository _repository;

  Future<void> call(int roomId, UpdateRoomParams params) =>
      _repository.updateRoom(roomId, params);
}
