import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:householder_app/core/core.dart'
    show applyWebRuntimeConfig, configureDependencies, getIt;
import 'package:housing_core/housing_core.dart';

import 'app.dart';
import 'role/role_cubit.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await applyWebRuntimeConfig(
    mapsKey: AppConfig.mapsWebApiKeyOrNull,
    googleClientId: AppConfig.googleWebClientIdOrNull,
  );

  await configureDependencies();

  getIt
    ..registerLazySingleton<RoleApi>(() => RoleApi(getIt<Dio>()))
    ..registerLazySingleton<RoleService>(
      () => RoleService(
        api: getIt<RoleApi>(),
        tokenStorage: getIt<TokenStorage>(),
      ),
    )
    ..registerLazySingleton<RoleCubit>(
      () => RoleCubit(currentUser: getIt<CurrentUserService>()),
    );

  runApp(const ShellApp());
}
