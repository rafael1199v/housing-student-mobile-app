import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_summary.dart';
import '../../domain/usecases/get_chats_usecase.dart';
import '../../domain/usecases/watch_messages_usecase.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit({
    required GetChatsUseCase getChatsUseCase,
    required WatchMessagesUseCase watchMessagesUseCase,
  })  : _getChatsUseCase = getChatsUseCase,
        _watchMessagesUseCase = watchMessagesUseCase,
        super(const ChatListLoading());

  final GetChatsUseCase _getChatsUseCase;
  final WatchMessagesUseCase _watchMessagesUseCase;

  StreamSubscription<ChatMessage>? _incomingSub;

  Future<void> load() async {
    emit(const ChatListLoading());
    _incomingSub ??= _watchMessagesUseCase().listen((_) => _refresh());
    await _refresh();
  }

  Future<void> _refresh() async {
    try {
      final chats = await _getChatsUseCase();
      emit(ChatListLoaded(chats));
    } on Failure catch (failure) {
      emit(ChatListFailureState(failure.code));
    } catch (_) {
      emit(const ChatListFailureState('unknown.error'));
    }
  }

  @override
  Future<void> close() {
    _incomingSub?.cancel();
    return super.close();
  }
}
