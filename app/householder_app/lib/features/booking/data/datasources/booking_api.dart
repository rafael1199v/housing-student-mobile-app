import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/booking_request_dto.dart';

part 'booking_api.g.dart';

@RestApi()
abstract class BookingApi {
  factory BookingApi(Dio dio, {String baseUrl}) = _BookingApi;

  @GET('/api/rooms/householder/{roomId}')
  Future<RoomBookingsDto> getRoomBookings(@Path('roomId') int roomId);

  @PUT('/api/bookings/approve/{bookingId}')
  Future<bool> approveBooking(@Path('bookingId') String bookingId);

  @PUT('/api/bookings/reject/{bookingId}')
  Future<bool> rejectBooking(@Path('bookingId') String bookingId);
}
