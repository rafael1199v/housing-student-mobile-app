import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../booking/booking.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required GetDashboardSummaryUseCase getSummaryUseCase,
    required ApproveBookingUseCase acceptBookingUseCase,
    required RejectBookingUseCase rejectBookingUseCase,
  })  : _getSummaryUseCase = getSummaryUseCase,
        _acceptBookingUseCase = acceptBookingUseCase,
        _rejectBookingUseCase = rejectBookingUseCase,
        super(const DashboardInitial());

  final GetDashboardSummaryUseCase _getSummaryUseCase;
  final ApproveBookingUseCase _acceptBookingUseCase;
  final RejectBookingUseCase _rejectBookingUseCase;

  Future<void> load() async {
    emit(const DashboardLoading());
    await _fetch();
  }

  Future<void> refresh() => _fetch();

  Future<String?> acceptRequest(String bookingId) =>
      _respond(() => _acceptBookingUseCase(bookingId));

  Future<String?> rejectRequest(String bookingId) =>
      _respond(() => _rejectBookingUseCase(bookingId));

  Future<String?> _respond(Future<void> Function() action) async {
    try {
      await action();
      await refresh();
      return null;
    } on Failure catch (failure) {
      return failure.code;
    } catch (_) {
      return 'unknown.error';
    }
  }

  Future<void> _fetch() async {
    try {
      final summary = await _getSummaryUseCase();
      emit(DashboardLoaded(summary));
    } on Failure catch (failure) {
      emit(DashboardFailureState(failure.code));
    } catch (_) {
      emit(const DashboardFailureState('unknown.error'));
    }
  }
}
