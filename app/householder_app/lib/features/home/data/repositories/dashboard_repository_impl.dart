import '../../../../core/core.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_api.dart';
import '../models/dashboard_summary_mapper.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl({required DashboardApi api}) : _api = api;

  final DashboardApi _api;

  @override
  Future<DashboardSummary> getSummary() async {
    try {
      final dto = await _api.getDashboardSummary();
      return dto.toDomain();
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<void> acceptRequest(String bookingId) =>
      _respond(() => _api.approveBooking(bookingId));

  @override
  Future<void> rejectRequest(String bookingId) =>
      _respond(() => _api.rejectBooking(bookingId));

  Future<void> _respond(Future<bool> Function() call) async {
    try {
      await call();
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
