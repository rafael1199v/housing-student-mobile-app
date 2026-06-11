import '../entities/dashboard_summary.dart';

abstract interface class DashboardRepository {
  Future<DashboardSummary> getSummary();

  Future<void> acceptRequest(String bookingId);

  Future<void> rejectRequest(String bookingId);
}
