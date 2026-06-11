import 'booking_request.dart';
import 'property_summary.dart';

class DashboardSummary {
final String greetingName;
  final int totalListings;
  final int activeBookings;
  final int pendingRequests;
  final List<BookingRequest> actionNeeded;
  final List<PropertySummary> properties;

  const DashboardSummary({
    required this.greetingName,
    required this.totalListings,
    required this.activeBookings,
    required this.pendingRequests,
    required this.actionNeeded,
    required this.properties,
  });
}
