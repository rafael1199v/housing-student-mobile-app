import '../repositories/chat_repository.dart';

class StartChatUseCase {
  const StartChatUseCase(this._repository);

  final ChatRepository _repository;

  Future<int> call(String participantUserId) =>
      _repository.startChat(participantUserId);
}
