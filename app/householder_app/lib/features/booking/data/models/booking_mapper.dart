import '../../domain/entities/booking_request.dart';
import '../../domain/entities/booking_status.dart';
import '../../domain/entities/room_bookings.dart';
import 'booking_request_dto.dart';

extension RoomBookingsDtoMapper on RoomBookingsDto {
  RoomBookings toRoomBookings() => RoomBookings(
        roomName: name,
        requests: bookings.map((b) => b.toBookingRequest()).toList(),
      );
}

extension BookingRequestDtoMapper on BookingRequestDto {
  BookingRequest toBookingRequest() {
    final phone = bookerPhoneNumber?.trim();
    return BookingRequest(
      id: id.toString(),
      bookerName: bookerName,
      bookerEmail: bookerEmail,
      phoneNumber: (phone == null || phone.isEmpty) ? null : phone,
      status: BookingStatus.fromBackend(bookingStatus),
    );
  }
}
