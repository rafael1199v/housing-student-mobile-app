part of 'booking_requests_cubit.dart';

sealed class BookingRequestsState extends Equatable {
  const BookingRequestsState();

  @override
  List<Object?> get props => [];
}

class BookingRequestsLoading extends BookingRequestsState {
  const BookingRequestsLoading();
}

class BookingRequestsLoaded extends BookingRequestsState {
  const BookingRequestsLoaded(this.data, {this.actingBookingId});

  final RoomBookings data;

  final String? actingBookingId;

  BookingRequestsLoaded copyWith({
    String? actingBookingId,
    bool clearActing = false,
  }) {
    return BookingRequestsLoaded(
      data,
      actingBookingId: clearActing ? null : (actingBookingId ?? this.actingBookingId),
    );
  }

  @override
  List<Object?> get props => [data, actingBookingId];
}

class BookingRequestsFailureState extends BookingRequestsState {
  const BookingRequestsFailureState(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}
