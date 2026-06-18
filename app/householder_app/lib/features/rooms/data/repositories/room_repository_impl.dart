import 'package:dio/dio.dart';

import '../../../../core/core.dart';
import '../../domain/entities/create_room_params.dart';
import '../../domain/entities/room_detail.dart';
import '../../domain/entities/room_image.dart';
import '../../domain/entities/selected_policy.dart';
import '../../domain/entities/update_room_params.dart';
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
      final form = _buildRoomFormData(
        name: params.name,
        description: params.description,
        latitude: params.latitude,
        longitude: params.longitude,
        price: params.price,
        statusId: params.statusId,
        serviceIds: params.serviceIds,
        policies: params.policies,
        images: params.images,
      );

      await _api.createRoom(form);
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<void> updateRoom(int roomId, UpdateRoomParams params) async {
    try {
      final form = _buildRoomFormData(
        name: params.name,
        description: params.description,
        latitude: params.latitude,
        longitude: params.longitude,
        price: params.price,
        statusId: params.statusId,
        serviceIds: params.serviceIds,
        policies: params.policies,
        images: params.images,
      );

      for (var i = 0; i < params.keptImageIds.length; i++) {
        form.fields
            .add(MapEntry('KeptImageIds[$i]', '${params.keptImageIds[i]}'));
      }

      await _api.updateRoom(roomId, form);
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  FormData _buildRoomFormData({
    required String name,
    required String description,
    required double latitude,
    required double longitude,
    required double price,
    required int statusId,
    required List<int> serviceIds,
    required List<SelectedPolicy> policies,
    required List<RoomImage> images,
  }) {
    final form = FormData();
    form.fields.addAll([
      MapEntry('Name', name),
      MapEntry('Description', description),
      MapEntry('Latitude', latitude.toString()),
      MapEntry('Longitude', longitude.toString()),
      MapEntry('Price', price.toString()),
      MapEntry('RoomStatusId', statusId.toString()),
    ]);

    for (var i = 0; i < serviceIds.length; i++) {
      form.fields.add(MapEntry('Services[$i].Id', '${serviceIds[i]}'));
    }

    for (var i = 0; i < policies.length; i++) {
      final policy = policies[i];
      form.fields
        ..add(MapEntry('Policies[$i].Id', '${policy.id}'))
        ..add(MapEntry('Policies[$i].Description', policy.description));
    }

    for (final image in images) {
      form.files.add(
        MapEntry(
          'Images',
          MultipartFile.fromBytes(image.bytes, filename: image.filename),
        ),
      );
    }

    return form;
  }
}
