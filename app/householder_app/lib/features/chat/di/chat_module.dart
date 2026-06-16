import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../core/core.dart';
import '../data/datasources/chat_api.dart';
import '../data/datasources/chat_socket_data_source.dart';
import '../data/datasources/local/chat_local_data_source.dart';
import '../data/datasources/local/chat_local_data_source_memory.dart';
import '../data/datasources/local/chat_local_data_source_sqflite.dart';
import '../data/repositories/chat_repository_impl.dart';
import '../domain/repositories/chat_repository.dart';
import '../domain/usecases/get_chats_usecase.dart';
import '../domain/usecases/get_messages_usecase.dart';
import '../domain/usecases/join_chat_usecase.dart';
import '../domain/usecases/mark_chat_read_usecase.dart';
import '../domain/usecases/send_message_usecase.dart';
import '../domain/usecases/start_chat_usecase.dart';
import '../domain/usecases/watch_messages_usecase.dart';
import '../presentation/cubits/chat_conversation_cubit.dart';
import '../presentation/cubits/chat_list_cubit.dart';

void registerChatDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<ChatApi>(() => ChatApi(getIt<Dio>()))
    ..registerLazySingleton<ChatSocketDataSource>(
      () => SignalRChatSocketDataSource(getIt<TokenStorage>()),
    )
    ..registerLazySingleton<ChatLocalDataSource>(
      () => kIsWeb
          ? InMemoryChatLocalDataSource()
          : SqfliteChatLocalDataSource(),
    )
    ..registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(
        api: getIt<ChatApi>(),
        socket: getIt<ChatSocketDataSource>(),
        local: getIt<ChatLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<GetChatsUseCase>(
      () => GetChatsUseCase(getIt<ChatRepository>()),
    )
    ..registerLazySingleton<StartChatUseCase>(
      () => StartChatUseCase(getIt<ChatRepository>()),
    )
    ..registerLazySingleton<GetMessagesUseCase>(
      () => GetMessagesUseCase(getIt<ChatRepository>()),
    )
    ..registerLazySingleton<SendMessageUseCase>(
      () => SendMessageUseCase(getIt<ChatRepository>()),
    )
    ..registerLazySingleton<MarkChatReadUseCase>(
      () => MarkChatReadUseCase(getIt<ChatRepository>()),
    )
    ..registerLazySingleton<JoinChatUseCase>(
      () => JoinChatUseCase(getIt<ChatRepository>()),
    )
    ..registerLazySingleton<WatchMessagesUseCase>(
      () => WatchMessagesUseCase(getIt<ChatRepository>()),
    )
    ..registerFactory<ChatListCubit>(
      () => ChatListCubit(
        getChatsUseCase: getIt<GetChatsUseCase>(),
        watchMessagesUseCase: getIt<WatchMessagesUseCase>(),
      ),
    )
    ..registerFactory<ChatConversationCubit>(
      () => ChatConversationCubit(
        getMessagesUseCase: getIt<GetMessagesUseCase>(),
        sendMessageUseCase: getIt<SendMessageUseCase>(),
        markChatReadUseCase: getIt<MarkChatReadUseCase>(),
        watchMessagesUseCase: getIt<WatchMessagesUseCase>(),
        joinChatUseCase: getIt<JoinChatUseCase>(),
        currentUser: getIt<CurrentUserService>(),
      ),
    );

  getIt<ChatRepository>().connect().ignore();

  final session = getIt<SessionNotifier>();
  session.addListener(() {
    if (!session.isAuthenticated) {
      getIt<ChatLocalDataSource>().clear().ignore();
    }
  });
}
