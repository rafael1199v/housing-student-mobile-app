import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../core/core.dart';
import '../data/datasources/profile_api.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/usecases/get_profile_usecase.dart';
import '../presentation/cubit/profile_cubit.dart';

void registerProfileDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<ProfileApi>(() => ProfileApi(getIt<Dio>()))
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(api: getIt<ProfileApi>()),
    )
    ..registerLazySingleton<GetProfileUseCase>(
      () => GetProfileUseCase(getIt<ProfileRepository>()),
    )
    ..registerFactory<ProfileCubit>(
      () => ProfileCubit(
        getProfileUseCase: getIt<GetProfileUseCase>(),
        tokenStorage: getIt<TokenStorage>(),
        sessionNotifier: getIt<SessionNotifier>(),
      ),
    );
}
