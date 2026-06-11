import 'package:json_annotation/json_annotation.dart';

part 'created_room_dto.g.dart';

@JsonSerializable(createToJson: false)
class CreatedRoomDto {
  const CreatedRoomDto({
    required this.name,
    this.description = '',
    this.roomStatus = '',
    this.price = 0,
  });

  factory CreatedRoomDto.fromJson(Map<String, dynamic> json) =>
      _$CreatedRoomDtoFromJson(json);

  final String name;
  final String description;
  final String roomStatus;
  final double price;
}
