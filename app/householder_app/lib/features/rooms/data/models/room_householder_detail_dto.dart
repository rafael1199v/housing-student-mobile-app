import 'package:json_annotation/json_annotation.dart';

part 'room_householder_detail_dto.g.dart';

@JsonSerializable(createToJson: false)
class RoomHouseholderDetailDto {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String description;
  final double price;
  final String roomStatus;
  final List<String> imageRoomUrls;
  final List<RoomImageDto> images;
  final List<String> services;
  final List<RoomPolicyDto> policies;
  final List<RoomBookingDto> bookings;

  const RoomHouseholderDetailDto({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.roomStatus,
    this.description = '',
    this.price = 0,
    this.imageRoomUrls = const [],
    this.images = const [],
    this.services = const [],
    this.policies = const [],
    this.bookings = const [],
  });

  factory RoomHouseholderDetailDto.fromJson(Map<String, dynamic> json) =>
      _$RoomHouseholderDetailDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class RoomImageDto {
  final int id;
  final String url;

  const RoomImageDto({this.id = 0, this.url = ''});

  factory RoomImageDto.fromJson(Map<String, dynamic> json) =>
      _$RoomImageDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class RoomPolicyDto {
  final String code;
  final String description;

  const RoomPolicyDto({this.code = '', this.description = ''});

  factory RoomPolicyDto.fromJson(Map<String, dynamic> json) =>
      _$RoomPolicyDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class RoomBookingDto {
  final String bookingStatus;
  const RoomBookingDto({this.bookingStatus = ''});

  factory RoomBookingDto.fromJson(Map<String, dynamic> json) =>
      _$RoomBookingDtoFromJson(json);  
}
