import '../entities/chat_message.dart';
import '../entities/chat_summary.dart';

abstract interface class ChatRepository {
  Future<List<ChatSummary>> getChats();
  Future<int> startChat(String participantUserId);
  Future<List<ChatMessage>> getMessages(int chatId, {int? beforeMessageId});
  Future<void> sendMessage(int chatId, String message);
  Future<void> markRead(int chatId, int lastMessageId);
  Stream<ChatMessage> watchMessages();
  Future<void> connect();
  Future<void> joinChat(int chatId);
}
