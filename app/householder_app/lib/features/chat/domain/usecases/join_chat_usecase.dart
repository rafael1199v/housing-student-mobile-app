import '../repositories/chat_repository.dart';

class JoinChatUseCase {
  const JoinChatUseCase(this._repository);

  final ChatRepository _repository;

  Future<void> call(int chatId) => _repository.joinChat(chatId);
}
