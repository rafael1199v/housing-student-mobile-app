import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../core/core.dart';
import '../data/datasources/auth_api.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../presentation/bloc/auth_bloc.dart';

void registerAuthDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<AuthApi>(() => AuthApi(getIt<Dio>()))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        api: getIt<AuthApi>(),
        tokenStorage: getIt<TokenStorage>(),
      ),
    )
    ..registerLazySingleton<GoogleSignInService>(
      () => createGoogleSignInService(
        webClientId: AppConfig.googleWebClientIdOrNull,
        serverClientId: kIsWeb
            ? null
            : AppConfig.googleServerClientIdOrNull ??
                  AppConfig.googleWebClientIdOrNull,
      ),
    )

    ..registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()),
    )
    ..registerFactory<AuthBloc>(
      () => AuthBloc(loginUseCase: getIt<LoginUseCase>()),
    );
}
