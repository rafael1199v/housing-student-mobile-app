import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../session/session_notifier.dart';
import '../storage/secure_token_storage.dart';
import '../storage/token_storage.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<TokenStorage>(SecureTokenStorage.new);

  final hasSession = await getIt<TokenStorage>().hasTokens();
  getIt.registerLazySingleton<SessionNotifier>(
    () => SessionNotifier(isAuthenticated: hasSession),
  );

  final refreshClient = DioClient.createRefreshClient();
  getIt.registerLazySingleton<Dio>(
    () => DioClient.create(
      tokenStorage: getIt<TokenStorage>(),
      refreshClient: refreshClient,
      onSessionExpired: () => getIt<SessionNotifier>().signedOut(),
    ),
  );
}
