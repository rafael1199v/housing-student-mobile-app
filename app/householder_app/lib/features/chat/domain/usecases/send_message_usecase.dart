import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  const SendMessageUseCase(this._repository);

  final ChatRepository _repository;

  Future<void> call(int chatId, String message) =>
      _repository.sendMessage(chatId, message);
}
