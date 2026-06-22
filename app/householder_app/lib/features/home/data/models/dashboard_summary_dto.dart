import 'package:json_annotation/json_annotation.dart';

import 'room_householder_dto.dart';

part 'dashboard_summary_dto.g.dart';

@JsonSerializable(createToJson: false)
class DashboardSummaryDto {
  final String greetingName;
  final int totalListings;
  final int activeBookings;
  final int pendingRequests;
  final List<DashboardBookingRequestDto> actionNeeded;
  final List<RoomHouseholderDto> properties;

  const DashboardSummaryDto({
    required this.greetingName,
    required this.totalListings,
    required this.activeBookings,
    required this.pendingRequests,
    this.actionNeeded = const [],
    this.properties = const [],
  });

  factory DashboardSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class DashboardBookingRequestDto {
  final String id;
  final String requesterName;
  final String propertyName;
  final String? bookerImageUrl;

  const DashboardBookingRequestDto({
    required this.id,
    required this.requesterName,
    required this.propertyName,
    this.bookerImageUrl,
  });

  factory DashboardBookingRequestDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardBookingRequestDtoFromJson(json);
}
