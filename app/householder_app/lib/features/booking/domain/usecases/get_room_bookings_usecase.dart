import '../entities/room_bookings.dart';
import '../repositories/booking_repository.dart';

class GetRoomBookingsUseCase {
  const GetRoomBookingsUseCase(this._repository);

  final BookingRepository _repository;

  Future<RoomBookings> call(int roomId) => _repository.getRoomBookings(roomId);
}
