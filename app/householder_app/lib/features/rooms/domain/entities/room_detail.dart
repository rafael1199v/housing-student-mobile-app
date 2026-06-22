import 'room_status.dart';

class RoomPolicyTag {
  final String code;
  final String description;

  const RoomPolicyTag({required this.code, required this.description});
}

class RoomImageRef {
  final int id;
  final String url;

  const RoomImageRef({required this.id, required this.url});
}

class RoomDetail {
  final int id;
  final String name;
  final String description;
  final double price;
  final double latitude;
  final double longitude;
  final RoomStatus status;
  final List<String> imageUrls;
  final List<RoomImageRef> images;
  final List<String> services;
  final List<RoomPolicyTag> policies;
  final int pendingBookingsCount;

  const RoomDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.imageUrls,
    required this.images,
    required this.services,
    required this.policies,
    required this.pendingBookingsCount,
  });
}
