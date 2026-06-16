import '../repositories/chat_repository.dart';

class MarkChatReadUseCase {
  const MarkChatReadUseCase(this._repository);

  final ChatRepository _repository;

  Future<void> call(int chatId, int lastMessageId) =>
      _repository.markRead(chatId, lastMessageId);
}
