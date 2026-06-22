import 'room_image.dart';
import 'selected_policy.dart';

class UpdateRoomParams {
  final int roomId;
  final String name;
  final String description;
  final double price;
  final int statusId;
  final double latitude;
  final double longitude;
  final List<int> serviceIds;
  final List<SelectedPolicy> policies;
  final List<RoomImage> images;
  final List<int> keptImageIds;

  const UpdateRoomParams({
    required this.roomId,
    required this.name,
    required this.description,
    required this.price,
    required this.statusId,
    required this.latitude,
    required this.longitude,
    required this.serviceIds,
    required this.policies,
    required this.images,
    required this.keptImageIds,
  });
}
