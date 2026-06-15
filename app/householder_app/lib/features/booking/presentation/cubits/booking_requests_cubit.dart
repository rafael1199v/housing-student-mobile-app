import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/room_bookings.dart';
import '../../domain/usecases/approve_booking_usecase.dart';
import '../../domain/usecases/get_room_bookings_usecase.dart';
import '../../domain/usecases/reject_booking_usecase.dart';

part 'booking_requests_state.dart';

class BookingRequestsCubit extends Cubit<BookingRequestsState> {
  BookingRequestsCubit({
    required GetRoomBookingsUseCase getRoomBookingsUseCase,
    required ApproveBookingUseCase approveBookingUseCase,
    required RejectBookingUseCase rejectBookingUseCase,
  })  : _getRoomBookingsUseCase = getRoomBookingsUseCase,
        _approveBookingUseCase = approveBookingUseCase,
        _rejectBookingUseCase = rejectBookingUseCase,
        super(const BookingRequestsLoading());

  final GetRoomBookingsUseCase _getRoomBookingsUseCase;
  final ApproveBookingUseCase _approveBookingUseCase;
  final RejectBookingUseCase _rejectBookingUseCase;

  int? _roomId;

  Future<void> load(int roomId) async {
    _roomId = roomId;
    emit(const BookingRequestsLoading());
    await _fetch();
  }

  Future<String?> approve(String bookingId) =>
      _respond(bookingId, () => _approveBookingUseCase(bookingId));

  Future<String?> reject(String bookingId) =>
      _respond(bookingId, () => _rejectBookingUseCase(bookingId));

  Future<String?> _respond(
    String bookingId,
    Future<void> Function() action,
  ) async {
    final current = state;
    if (current is BookingRequestsLoaded) {
      emit(current.copyWith(actingBookingId: bookingId));
    }
    try {
      await action();
      await _fetch();
      return null;
    } on Failure catch (failure) {
      if (current is BookingRequestsLoaded) {
        emit(current.copyWith(clearActing: true));
      }
      return failure.code;
    } catch (_) {
      if (current is BookingRequestsLoaded) {
        emit(current.copyWith(clearActing: true));
      }
      return 'unknown.error';
    }
  }

  Future<void> _fetch() async {
    final roomId = _roomId;
    if (roomId == null) return;
    try {
      final data = await _getRoomBookingsUseCase(roomId);
      emit(BookingRequestsLoaded(data));
    } on Failure catch (failure) {
      emit(BookingRequestsFailureState(failure.code));
    } catch (_) {
      emit(const BookingRequestsFailureState('unknown.error'));
    }
  }
}
