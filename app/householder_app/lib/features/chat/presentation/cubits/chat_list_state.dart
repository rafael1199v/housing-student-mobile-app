part of 'chat_list_cubit.dart';

sealed class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object?> get props => [];
}

class ChatListLoading extends ChatListState {
  const ChatListLoading();
}

class ChatListLoaded extends ChatListState {
  const ChatListLoaded(this.chats);

  final List<ChatSummary> chats;

  @override
  List<Object?> get props => [chats];
}

class ChatListFailureState extends ChatListState {
  const ChatListFailureState(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}
