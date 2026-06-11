import 'room_image.dart';
import 'selected_policy.dart';

class CreateRoomParams {
  final String name;
  final String description;
  final double price;
  final int statusId;
  final double latitude;
  final double longitude;
  final List<int> serviceIds;
  final List<SelectedPolicy> policies;
  final List<RoomImage> images;
  
  const CreateRoomParams({
    required this.name,
    required this.description,
    required this.price,
    required this.statusId,
    required this.latitude,
    required this.longitude,
    required this.serviceIds,
    required this.policies,
    required this.images,
  });
}
