import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/dashboard_summary_dto.dart';

part 'dashboard_api.g.dart';

@RestApi()
abstract class DashboardApi {
  factory DashboardApi(Dio dio, {String baseUrl}) = _DashboardApi;

  @GET('/api/dashboard/summary')
  Future<DashboardSummaryDto> getDashboardSummary();

  @PUT('/api/bookings/approve/{bookingId}')
  Future<bool> approveBooking(@Path('bookingId') String bookingId);

  @PUT('/api/bookings/reject/{bookingId}')
  Future<bool> rejectBooking(@Path('bookingId') String bookingId);
}
