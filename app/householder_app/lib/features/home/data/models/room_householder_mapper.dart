import '../../domain/entities/property_summary.dart';
import '../../domain/entities/room_status.dart';
import 'room_householder_dto.dart';

extension RoomHouseholderDtoMapper on RoomHouseholderDto {
  PropertySummary toPropertySummary() => PropertySummary(
        id: id,
        name: name,
        description: description,
        status: RoomStatus.fromBackend(roomStatus),
        pendingRequests: bookingRequests,
        price: price,
        imageUrl: imageRoomUrls.isEmpty ? null : imageRoomUrls.first,
      );
}
