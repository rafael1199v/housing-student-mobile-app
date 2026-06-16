import '../../../domain/entities/chat_message.dart';
import '../../../domain/entities/chat_summary.dart';
import 'chat_local_data_source.dart';

class InMemoryChatLocalDataSource implements ChatLocalDataSource {
  List<ChatSummary> _chats = const [];
  final Map<int, List<ChatMessage>> _messages = {};
  final List<({int chatId, String message})> _outbox = [];

  @override
  Future<void> cacheChats(List<ChatSummary> chats) async {
    _chats = List.unmodifiable(chats);
  }

  @override
  Future<List<ChatSummary>> readChats() async => _chats;

  @override
  Future<void> cacheMessages(int chatId, List<ChatMessage> messages) async {
    _messages[chatId] = List.unmodifiable(messages);
  }

  @override
  Future<List<ChatMessage>> readMessages(int chatId) async =>
      _messages[chatId] ?? const [];

  @override
  Future<void> appendMessage(ChatMessage message) async {
    final existing = _messages[message.chatId] ?? const [];
    if (existing.any((m) => m.id == message.id)) return;
    _messages[message.chatId] = List.unmodifiable([message, ...existing]);
  }

  @override
  Future<void> enqueueOutgoing(int chatId, String message) async {
    _outbox.add((chatId: chatId, message: message));
  }

  @override
  Future<void> clear() async {
    _chats = const [];
    _messages.clear();
    _outbox.clear();
  }
}
