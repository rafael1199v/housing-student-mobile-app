import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetMessagesUseCase {
  const GetMessagesUseCase(this._repository);

  final ChatRepository _repository;

  Future<List<ChatMessage>> call(int chatId, {int? beforeMessageId}) =>
      _repository.getMessages(chatId, beforeMessageId: beforeMessageId);
}
