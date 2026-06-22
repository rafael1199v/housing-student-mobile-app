import 'package:housing_core/housing_core.dart';

import '../../domain/entities/room_bookings.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_api.dart';
import '../models/booking_mapper.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingApi _api;
  const BookingRepositoryImpl({required BookingApi api}) : _api = api;

  @override
  Future<RoomBookings> getRoomBookings(int roomId) async {
    try {
      final dto = await _api.getRoomBookings(roomId);
      return dto.toRoomBookings();
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<void> approveBooking(String bookingId) =>
      _respond(() => _api.approveBooking(bookingId));

  @override
  Future<void> rejectBooking(String bookingId) =>
      _respond(() => _api.rejectBooking(bookingId));

  Future<void> _respond(Future<bool> Function() call) async {
    try {
      await call();
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
