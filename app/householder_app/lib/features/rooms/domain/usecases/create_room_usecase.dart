import '../entities/create_room_params.dart';
import '../repositories/room_repository.dart';

class CreateRoomUseCase {
  const CreateRoomUseCase(this._repository);

  final RoomRepository _repository;

  Future<void> call(CreateRoomParams params) => _repository.createRoom(params);
}
