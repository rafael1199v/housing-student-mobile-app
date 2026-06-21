import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:householder_app/core/core.dart'
    show applyWebRuntimeConfig, configureDependencies, getIt;
import 'package:housing_core/housing_core.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'role/role_cubit.dart';
import 'role/role_switch_controller_impl.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shellRoot');

Future<void> bootstrap() async {
  runZonedGuarded(
    () async {
      final binding = WidgetsFlutterBinding.ensureInitialized();
      usePathUrlStrategy();

      if (!kIsWeb) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        binding.platformDispatcher.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

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
        )
        ..registerLazySingleton<RoleSwitchController>(
          () => RoleSwitchControllerImpl(
            roleCubit: getIt<RoleCubit>(),
            rootNavigatorContext: () => rootNavigatorKey.currentContext,
          ),
        );

      runApp(const ShellApp());
    },
    (error, stack) {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
    },
  );
}
