import '../../../domain/entities/chat_message.dart';
import '../../../domain/entities/chat_summary.dart';

class OutgoingMessage {
  const OutgoingMessage({
    required this.id,
    required this.chatId,
    required this.message,
  });

  final int id;
  final int chatId;
  final String message;
}

/// Local cache for chats and messages.
abstract interface class ChatLocalDataSource {
  Future<void> cacheChats(List<ChatSummary> chats);
  Future<List<ChatSummary>> readChats();

  Future<void> cacheMessages(int chatId, List<ChatMessage> messages);
  Future<List<ChatMessage>> readMessages(int chatId);
  Future<void> appendMessage(ChatMessage message);

  Future<void> enqueueOutgoing(int chatId, String message);
  Future<List<OutgoingMessage>> readOutgoing();
  Future<void> removeOutgoing(int id);
  Future<void> clear();
}
