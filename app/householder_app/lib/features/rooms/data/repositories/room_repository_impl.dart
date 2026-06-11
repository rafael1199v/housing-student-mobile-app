import '../../../../core/error/error_mapper.dart';
import '../../domain/entities/room_detail.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/room_api.dart';
import '../models/room_detail_mapper.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomApi _api;
  const RoomRepositoryImpl({required RoomApi api}) : _api = api;

  @override
  Future<RoomDetail> getHouseholderRoomDetail(int roomId) async {
    try {
      final dto = await _api.getHouseholderRoomDetail(roomId);
      return dto.toRoomDetail();
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
