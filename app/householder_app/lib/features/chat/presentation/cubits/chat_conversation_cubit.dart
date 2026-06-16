import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/join_chat_usecase.dart';
import '../../domain/usecases/mark_chat_read_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/watch_messages_usecase.dart';

part 'chat_conversation_state.dart';

class ChatConversationCubit extends Cubit<ChatConversationState> {
  ChatConversationCubit({
    required GetMessagesUseCase getMessagesUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required MarkChatReadUseCase markChatReadUseCase,
    required WatchMessagesUseCase watchMessagesUseCase,
    required JoinChatUseCase joinChatUseCase,
    required CurrentUserService currentUser,
  })  : _getMessagesUseCase = getMessagesUseCase,
        _sendMessageUseCase = sendMessageUseCase,
        _markChatReadUseCase = markChatReadUseCase,
        _watchMessagesUseCase = watchMessagesUseCase,
        _joinChatUseCase = joinChatUseCase,
        _currentUser = currentUser,
        super(const ChatConversationLoading());

  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final MarkChatReadUseCase _markChatReadUseCase;
  final WatchMessagesUseCase _watchMessagesUseCase;
  final JoinChatUseCase _joinChatUseCase;
  final CurrentUserService _currentUser;

  late int _chatId;
  String? _myId;
  int _tempIdSeq = 0;
  StreamSubscription<ChatMessage>? _incomingSub;

  /// Messages are kept newest-first to feed a `reverse: true` ListView.
  Future<void> load(int chatId) async {
    _chatId = chatId;
    emit(const ChatConversationLoading());
    _myId = await _currentUser.currentUserId();
    _joinChatUseCase(chatId).ignore();
    try {
      final messages = await _getMessagesUseCase(chatId);
      emit(ChatConversationLoaded(messages: messages, currentUserId: _myId));
      await _markReadUpToLatest(messages);
      _incomingSub ??= _watchMessagesUseCase().listen(_onIncoming);
    } on Failure catch (failure) {
      emit(ChatConversationFailureState(failure.code));
    } catch (_) {
      emit(const ChatConversationFailureState('unknown.error'));
    }
  }

  Future<void> send(String text) async {
    final current = state;
    if (current is! ChatConversationLoaded) return;

    final temp = ChatMessage(
      id: --_tempIdSeq,
      chatId: _chatId,
      senderId: _myId ?? '',
      senderName: '',
      message: text,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.sending,
    );
    emit(current.copyWith(messages: [temp, ...current.messages]));

    try {
      await _sendMessageUseCase(_chatId, text);
    } catch (_) {
      _replaceMessage(
        temp.id,
        temp.copyWith(status: ChatMessageStatus.failed),
      );
    }
  }

  void _onIncoming(ChatMessage message) {
    if (message.chatId != _chatId) return;
    final current = state;
    if (current is! ChatConversationLoaded) return;

    final messages = [...current.messages];

    if (message.senderId == _myId) {
      final idx = messages.indexWhere(
        (m) => m.id < 0 && m.message == message.message,
      );
      if (idx != -1) {
        messages[idx] = message;
        emit(current.copyWith(messages: messages));
        return;
      }
    }

    if (messages.any((m) => m.id == message.id)) return; // dedupe
    emit(current.copyWith(messages: [message, ...messages]));

    if (message.senderId != _myId) {
      _markChatReadUseCase(_chatId, message.id).ignore();
    }
  }

  Future<void> _markReadUpToLatest(List<ChatMessage> messages) async {
    final latest = messages
        .where((m) => m.id > 0)
        .fold<int?>(null, (max, m) => max == null || m.id > max ? m.id : max);
    if (latest == null) return;
    try {
      await _markChatReadUseCase(_chatId, latest);
    } catch (_) {}
  }

  void _replaceMessage(int id, ChatMessage replacement) {
    final current = state;
    if (current is! ChatConversationLoaded) return;
    final messages = current.messages
        .map((m) => m.id == id ? replacement : m)
        .toList();
    emit(current.copyWith(messages: messages));
  }

  @override
  Future<void> close() {
    _incomingSub?.cancel();
    return super.close();
  }
}
