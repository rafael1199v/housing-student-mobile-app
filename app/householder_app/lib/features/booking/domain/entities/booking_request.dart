import 'booking_status.dart';

class BookingRequest {
  final String id;
  final String bookerName;
  final String bookerEmail;
  final String? phoneNumber;
  final BookingStatus status;

  const BookingRequest({
    required this.id,
    required this.bookerName,
    required this.bookerEmail,
    required this.status,
    this.phoneNumber,
  });
}
