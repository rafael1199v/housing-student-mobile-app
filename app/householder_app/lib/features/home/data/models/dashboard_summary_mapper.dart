import '../../domain/entities/booking_request.dart';
import '../../domain/entities/dashboard_summary.dart';
import 'dashboard_summary_dto.dart';
import 'room_householder_mapper.dart';

extension DashboardSummaryDtoMapper on DashboardSummaryDto {
  DashboardSummary toDomain() => DashboardSummary(
        greetingName: greetingName,
        totalListings: totalListings,
        activeBookings: activeBookings,
        pendingRequests: pendingRequests,
        actionNeeded:
            actionNeeded.map((request) => request.toBookingRequest()).toList(),
        properties:
            properties.map((room) => room.toPropertySummary()).toList(),
      );
}

extension DashboardBookingRequestDtoMapper on DashboardBookingRequestDto {
  BookingRequest toBookingRequest() => BookingRequest(
        id: id,
        requesterName: requesterName,
        propertyName: propertyName,
      );
}
