import 'room_status.dart';

class PropertySummary {
  final int id;
  final String name;
  final String description;
  final RoomStatus status;
  final int pendingRequests;
  final double price;
  final String? imageUrl;

  const PropertySummary({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.pendingRequests,
    required this.price,
    this.imageUrl,
  });
}
