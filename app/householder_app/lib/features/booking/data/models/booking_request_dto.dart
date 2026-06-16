import 'package:json_annotation/json_annotation.dart';

part 'booking_request_dto.g.dart';

@JsonSerializable(createToJson: false)
class RoomBookingsDto {
  final String name;
  final List<BookingRequestDto> bookings;

  const RoomBookingsDto({this.name = '', this.bookings = const []});

  factory RoomBookingsDto.fromJson(Map<String, dynamic> json) =>
      _$RoomBookingsDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class BookingRequestDto {
  final int id;
  final String bookerName;
  final String bookerEmail;
  final String? bookerPhoneNumber;
  final String bookingStatus;
  final String bookerId;

  const BookingRequestDto({
    this.id = 0,
    this.bookerName = '',
    this.bookerEmail = '',
    this.bookerPhoneNumber,
    this.bookingStatus = '',
    this.bookerId = '',
  });

  factory BookingRequestDto.fromJson(Map<String, dynamic> json) =>
      _$BookingRequestDtoFromJson(json);
}
