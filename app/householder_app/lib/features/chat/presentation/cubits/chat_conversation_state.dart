part of 'chat_conversation_cubit.dart';

sealed class ChatConversationState extends Equatable {
  const ChatConversationState();

  @override
  List<Object?> get props => [];
}

class ChatConversationLoading extends ChatConversationState {
  const ChatConversationLoading();
}

class ChatConversationLoaded extends ChatConversationState {
  const ChatConversationLoaded({
    required this.messages,
    required this.currentUserId,
  });

  /// Newest-first (for a `reverse: true` ListView).
  final List<ChatMessage> messages;
  final String? currentUserId;

  ChatConversationLoaded copyWith({List<ChatMessage>? messages}) =>
      ChatConversationLoaded(
        messages: messages ?? this.messages,
        currentUserId: currentUserId,
      );

  @override
  List<Object?> get props => [messages, currentUserId];
}

class ChatConversationFailureState extends ChatConversationState {
  const ChatConversationFailureState(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}
