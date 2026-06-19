import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../core/core.dart';
import '../data/datasources/auth_api.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/confirm_email_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/login_with_google_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../domain/usecases/register_with_google_usecase.dart';
import '../presentation/blocs/auth_bloc.dart';
import '../presentation/blocs/confirm_email_bloc.dart';
import '../presentation/blocs/register_bloc.dart';

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
    ..registerLazySingleton<LoginWithGoogleUseCase>(
      () => LoginWithGoogleUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<RegisterWithGoogleUseCase>(
      () => RegisterWithGoogleUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<ConfirmEmailUseCase>(
      () => ConfirmEmailUseCase(getIt<AuthRepository>()),
    )
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        loginUseCase: getIt<LoginUseCase>(),
        loginWithGoogleUseCase: getIt<LoginWithGoogleUseCase>(),
        registerWithGoogleUseCase: getIt<RegisterWithGoogleUseCase>(),
      ),
    )
    ..registerFactory<RegisterBloc>(
      () => RegisterBloc(registerUseCase: getIt<RegisterUseCase>()),
    )
    ..registerFactory<ConfirmEmailBloc>(
      () => ConfirmEmailBloc(confirmEmailUseCase: getIt<ConfirmEmailUseCase>()),
    );
}
