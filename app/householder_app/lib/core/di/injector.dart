import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:housing_auth/housing_auth.dart';
import 'package:housing_core/housing_core.dart';

import '../../features/booking/booking.dart';
import '../../features/chat/chat.dart';
import '../../features/home/home.dart';
import '../../features/profile/profile.dart';
import '../../features/rooms/rooms.dart';
import '../i18n/locale_cubit.dart';
import '../i18n/locale_preference_storage.dart';
import '../platform/connectivity_service.dart';
import '../platform/connectivity_service_factory.dart';
import '../theme/theme_cubit.dart';
import '../theme/theme_preference_storage.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<TokenStorage>(SecureTokenStorage.new);
  getIt.registerLazySingleton<CurrentUserService>(
    () => CurrentUserService(getIt<TokenStorage>()),
  );

  final hasSession = await getIt<TokenStorage>().hasTokens();
  getIt.registerLazySingleton<SessionNotifier>(
    () => SessionNotifier(isAuthenticated: hasSession),
  );

  final themeStorage = ThemePreferenceStorage();
  final savedThemeMode = await themeStorage.read();
  getIt.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(storage: themeStorage, initial: savedThemeMode),
  );

  final localeStorage = LocalePreferenceStorage();
  final savedLocale = await localeStorage.read();
  final deviceLocale = PlatformDispatcher.instance.locale;
  final initialLocale = savedLocale ??
      (LocaleCubit.isSupported(deviceLocale)
          ? Locale(deviceLocale.languageCode)
          : const Locale('en'));
  getIt.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(storage: localeStorage, initial: initialLocale),
  );

  final refreshClient = DioClient.createRefreshClient();
  getIt.registerLazySingleton<Dio>(
    () => DioClient.create(
      tokenStorage: getIt<TokenStorage>(),
      refreshClient: refreshClient,
      onSessionExpired: () => getIt<SessionNotifier>().signedOut(),
    ),
  );

  getIt.registerLazySingleton<ConnectivityService>(createConnectivityService);

  registerAuthDependencies(getIt);
  registerHouseholderDependencies(getIt);
}

void registerHouseholderDependencies(GetIt getIt) {
  registerProfileDependencies(getIt);
  registerBookingDependencies(getIt);
  registerHomeDependencies(getIt);
  registerRoomDependencies(getIt);
  registerChatDependencies(getIt);
}
