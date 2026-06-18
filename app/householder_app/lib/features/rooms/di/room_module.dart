import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../core/core.dart';
import '../data/datasources/room_api.dart';
import '../data/repositories/room_repository_impl.dart';
import '../domain/repositories/room_repository.dart';
import '../domain/usecases/create_room_usecase.dart';
import '../domain/usecases/get_room_detail_usecase.dart';
import '../domain/usecases/update_room_usecase.dart';
import '../presentation/cubits/create_room_cubit.dart';
import '../presentation/cubits/room_detail_cubit.dart';


void registerRoomDependencies(GetIt getIt) {
   getIt
    ..registerLazySingleton<RoomApi>(() => RoomApi(getIt<Dio>()))
    ..registerLazySingleton<RoomRepository>(
      () => RoomRepositoryImpl(api: getIt<RoomApi>()),
    )
    ..registerLazySingleton<CreateRoomUseCase>(
      () => CreateRoomUseCase(getIt<RoomRepository>()),
    )
    ..registerLazySingleton<GetRoomDetailUseCase>(
      () => GetRoomDetailUseCase(getIt<RoomRepository>()),
    )
    ..registerLazySingleton<UpdateRoomUseCase>(
      () => UpdateRoomUseCase(getIt<RoomRepository>()),
    )
    ..registerLazySingleton<LocationService>(LocationServiceImpl.new)
    ..registerFactory<CreateRoomCubit>(
      () => CreateRoomCubit(
        createRoomUseCase: getIt<CreateRoomUseCase>(),
        updateRoomUseCase: getIt<UpdateRoomUseCase>(),
        getRoomDetailUseCase: getIt<GetRoomDetailUseCase>(),
        locationService: getIt<LocationService>(),
      ),
    )
    ..registerFactory<RoomDetailCubit>(
      () => RoomDetailCubit(
        getRoomDetailUseCase: getIt<GetRoomDetailUseCase>(),
        locationService: getIt<LocationService>(),
      ),
    );
}
