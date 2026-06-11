import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/datasources/booking_api.dart';
import '../data/repositories/booking_repository_impl.dart';
import '../domain/repositories/booking_repository.dart';
import '../domain/usecases/approve_booking_usecase.dart';
import '../domain/usecases/get_room_bookings_usecase.dart';
import '../domain/usecases/reject_booking_usecase.dart';
import '../presentation/cubits/booking_requests_cubit.dart';

void registerBookingDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<BookingApi>(() => BookingApi(getIt<Dio>()))
    ..registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(api: getIt<BookingApi>()),
    )
    ..registerLazySingleton<GetRoomBookingsUseCase>(
      () => GetRoomBookingsUseCase(getIt<BookingRepository>()),
    )
    ..registerLazySingleton<ApproveBookingUseCase>(
      () => ApproveBookingUseCase(getIt<BookingRepository>()),
    )
    ..registerLazySingleton<RejectBookingUseCase>(
      () => RejectBookingUseCase(getIt<BookingRepository>()),
    )
    ..registerFactory<BookingRequestsCubit>(
      () => BookingRequestsCubit(
        getRoomBookingsUseCase: getIt<GetRoomBookingsUseCase>(),
        approveBookingUseCase: getIt<ApproveBookingUseCase>(),
        rejectBookingUseCase: getIt<RejectBookingUseCase>(),
      ),
    );
}
