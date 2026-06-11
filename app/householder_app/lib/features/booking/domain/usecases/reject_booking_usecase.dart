import '../repositories/booking_repository.dart';

class RejectBookingUseCase {
  const RejectBookingUseCase(this._repository);

  final BookingRepository _repository;

  Future<void> call(String bookingId) => _repository.rejectBooking(bookingId);
}
