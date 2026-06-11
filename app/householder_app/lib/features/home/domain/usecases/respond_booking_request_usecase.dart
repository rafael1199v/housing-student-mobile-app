import '../repositories/dashboard_repository.dart';


class AcceptBookingRequestUseCase {
  const AcceptBookingRequestUseCase(this._repository);

  final DashboardRepository _repository;

  Future<void> call(String bookingId) => _repository.acceptRequest(bookingId);
}

class RejectBookingRequestUseCase {
  const RejectBookingRequestUseCase(this._repository);

  final DashboardRepository _repository;

  Future<void> call(String bookingId) => _repository.rejectRequest(bookingId);
}
