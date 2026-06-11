import 'package:json_annotation/json_annotation.dart';

part 'room_householder_dto.g.dart';

@JsonSerializable(createToJson: false)
class RoomHouseholderDto {

  final int id;
  final String name;
  final String description;
  final String roomStatus;
  final int bookingRequests;
  final double price;
  final List<String> imageRoomUrls;

  const RoomHouseholderDto({
    required this.id,
    required this.name,
    required this.roomStatus,
    required this.bookingRequests,
    required this.price,
    this.description = '',
    this.imageRoomUrls = const [],
  });

  factory RoomHouseholderDto.fromJson(Map<String, dynamic> json) =>
      _$RoomHouseholderDtoFromJson(json);
}
