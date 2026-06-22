import 'booking_status.dart';

class BookingRequest {
  final String id;
  final String bookerName;
  final String bookerEmail;
  final String? phoneNumber;
  final BookingStatus status;
  final String studentUserId;
  final String? bookerImageUrl;

  const BookingRequest({
    required this.id,
    required this.bookerName,
    required this.bookerEmail,
    required this.status,
    this.phoneNumber,
    this.studentUserId = '',
    this.bookerImageUrl,
  });
}
