import '../entities/chat_summary.dart';
import '../repositories/chat_repository.dart';

class GetChatsUseCase {
  const GetChatsUseCase(this._repository);

  final ChatRepository _repository;

  Future<List<ChatSummary>> call() => _repository.getChats();
}
