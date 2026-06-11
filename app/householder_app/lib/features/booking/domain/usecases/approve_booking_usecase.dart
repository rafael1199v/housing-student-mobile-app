import '../repositories/booking_repository.dart';

class ApproveBookingUseCase {
  const ApproveBookingUseCase(this._repository);

  final BookingRepository _repository;

  Future<void> call(String bookingId) => _repository.approveBooking(bookingId);
}
