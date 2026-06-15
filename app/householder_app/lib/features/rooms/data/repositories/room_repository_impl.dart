import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../domain/entities/create_room_params.dart';
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

  @override
  Future<void> createRoom(CreateRoomParams params) async {
    try {
      final form = FormData();
      form.fields.addAll([
        MapEntry('Name', params.name),
        MapEntry('Description', params.description),
        MapEntry('Latitude', params.latitude.toString()),
        MapEntry('Longitude', params.longitude.toString()),
        MapEntry('Price', params.price.toString()),
        MapEntry('RoomStatusId', params.statusId.toString()),
      ]);

      for (var i = 0; i < params.serviceIds.length; i++) {
        form.fields.add(MapEntry('Services[$i].Id', '${params.serviceIds[i]}'));
      }

      for (var i = 0; i < params.policies.length; i++) {
        final policy = params.policies[i];
        form.fields
          ..add(MapEntry('Policies[$i].Id', '${policy.id}'))
          ..add(MapEntry('Policies[$i].Description', policy.description));
      }

      for (final image in params.images) {
        form.files.add(
          MapEntry(
            'Images',
            MultipartFile.fromBytes(image.bytes, filename: image.filename),
          ),
        );
      }

      await _api.createRoom(form);
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
