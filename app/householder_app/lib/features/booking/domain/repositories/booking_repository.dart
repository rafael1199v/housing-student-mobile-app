import '../entities/room_bookings.dart';

abstract interface class BookingRepository {
  Future<RoomBookings> getRoomBookings(int roomId);

  Future<void> approveBooking(String bookingId);

  Future<void> rejectBooking(String bookingId);
}
