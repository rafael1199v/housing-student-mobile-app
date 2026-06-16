import '../../../domain/entities/chat_message.dart';
import '../../../domain/entities/chat_summary.dart';

/// Local cache for chats and messages.
abstract interface class ChatLocalDataSource {
  Future<void> cacheChats(List<ChatSummary> chats);
  Future<List<ChatSummary>> readChats();

  Future<void> cacheMessages(int chatId, List<ChatMessage> messages);
  Future<List<ChatMessage>> readMessages(int chatId);
  Future<void> appendMessage(ChatMessage message);

  Future<void> enqueueOutgoing(int chatId, String message);
  Future<void> clear();
}
