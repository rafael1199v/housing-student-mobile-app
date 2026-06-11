import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/datasources/dashboard_api.dart';
import '../data/repositories/dashboard_repository_impl.dart';
import '../domain/repositories/dashboard_repository.dart';
import '../domain/usecases/get_dashboard_summary_usecase.dart';
import '../domain/usecases/respond_booking_request_usecase.dart';
import '../presentation/cubits/dashboard_cubit.dart';

void registerHomeDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<DashboardApi>(() => DashboardApi(getIt<Dio>()))
    ..registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(api: getIt<DashboardApi>()),
    )
    ..registerLazySingleton<GetDashboardSummaryUseCase>(
      () => GetDashboardSummaryUseCase(getIt<DashboardRepository>()),
    )
    ..registerLazySingleton<AcceptBookingRequestUseCase>(
      () => AcceptBookingRequestUseCase(getIt<DashboardRepository>()),
    )
    ..registerLazySingleton<RejectBookingRequestUseCase>(
      () => RejectBookingRequestUseCase(getIt<DashboardRepository>()),
    )
    ..registerFactory<DashboardCubit>(
      () => DashboardCubit(
        getSummaryUseCase: getIt<GetDashboardSummaryUseCase>(),
        acceptBookingUseCase: getIt<AcceptBookingRequestUseCase>(),
        rejectBookingUseCase: getIt<RejectBookingRequestUseCase>(),
      ),
    );
}
