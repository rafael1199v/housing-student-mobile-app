import '../../domain/entities/room_detail.dart';
import '../../domain/entities/room_status.dart';
import 'room_householder_detail_dto.dart';

extension RoomHouseholderDetailDtoMapper on RoomHouseholderDetailDto {
  RoomDetail toRoomDetail() => RoomDetail(
        id: id,
        name: name,
        description: description,
        price: price,
        latitude: latitude,
        longitude: longitude,
        status: RoomStatus.fromBackend(roomStatus),
        imageUrls: imageRoomUrls,
        services: services,
        policies: policies
            .map((p) => RoomPolicyTag(code: p.code, description: p.description))
            .toList(),
        pendingBookingsCount: bookings
            .where((b) => b.bookingStatus.trim().toLowerCase() == 'pending')
            .length,
      );
}
