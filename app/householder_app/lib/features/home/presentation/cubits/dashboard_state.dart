part of 'dashboard_cubit.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded(this.summary);

  final DashboardSummary summary;

  @override
  List<Object?> get props => [summary];
}

class DashboardFailureState extends DashboardState {
  const DashboardFailureState(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}
