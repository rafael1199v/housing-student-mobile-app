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
        images:
            images.map((i) => RoomImageRef(id: i.id, url: i.url)).toList(),
        services: services,
        policies: policies
            .map((p) => RoomPolicyTag(code: p.code, description: p.description))
            .toList(),
        pendingBookingsCount: bookings
            .where((b) => b.bookingStatus.trim().toLowerCase() == 'pending')
            .length,
      );
}
