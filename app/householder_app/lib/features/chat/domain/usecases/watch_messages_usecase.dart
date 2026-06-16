import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class WatchMessagesUseCase {
  const WatchMessagesUseCase(this._repository);

  final ChatRepository _repository;

  Stream<ChatMessage> call() => _repository.watchMessages();
}
