import 'booking_request.dart';

class RoomBookings {
  final String roomName;
  final List<BookingRequest> requests;

  const RoomBookings({required this.roomName, this.requests = const []});
}
