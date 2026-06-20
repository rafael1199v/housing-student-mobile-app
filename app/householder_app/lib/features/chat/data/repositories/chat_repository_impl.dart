import '../../../../core/core.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_summary.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_api.dart';
import '../datasources/chat_socket_data_source.dart';
import '../datasources/local/chat_local_data_source.dart';
import '../models/chat_dtos.dart';
import '../models/chat_mapper.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required ChatApi api,
    required ChatSocketDataSource socket,
    required ChatLocalDataSource local,
    required ConnectivityService connectivity,
  })  : _api = api,
        _socket = socket,
        _local = local,
        _connectivity = connectivity {
    _socket.messages.listen((dto) => _local.appendMessage(dto.toEntity()));
    _connectivity.onStatusChanged().listen((status) {
      if (status == ConnectionStatus.online) _flushOutbox();
    });
    _connectivity.currentStatus().then((status) {
      if (status == ConnectionStatus.online) _flushOutbox();
    });
  }

  final ChatApi _api;
  final ChatSocketDataSource _socket;
  final ChatLocalDataSource _local;
  final ConnectivityService _connectivity;
  bool _flushing = false;

  Future<void> _flushOutbox() async {
    if (_flushing) return;
    _flushing = true;
    try {
      final pending = await _local.readOutgoing();
      for (final outgoing in pending) {
        try {
          await _socket.sendMessage(outgoing.chatId, outgoing.message);
          await _local.removeOutgoing(outgoing.id);
        } catch (_) {
          break;
        }
      }
    } finally {
      _flushing = false;
    }
  }

  @override
  Future<List<ChatSummary>> getChats() async {
    try {
      final dtos = await _api.getChats();
      final chats = dtos.map((d) => d.toEntity()).toList();
      await _local.cacheChats(chats);
      return chats;
    } catch (error) {
      final failure = ErrorMapper.map(error);
      if (failure is NetworkFailure) {
        final cached = await _local.readChats();
        if (cached.isNotEmpty) return cached;
      }
      throw failure;
    }
  }

  @override
  Future<int> startChat(String participantUserId) async {
    try {
      final dto = await _api.startChat(
        StartChatRequest(participantUserId: participantUserId),
      );
      return dto.chatId;
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<List<ChatMessage>> getMessages(
    int chatId, {
    int? beforeMessageId,
  }) async {
    try {
      final dtos = await _api.getMessages(
        chatId,
        beforeMessageId: beforeMessageId,
      );
      final messages = dtos.map((d) => d.toEntity()).toList();
      if (beforeMessageId == null) {
        await _local.cacheMessages(chatId, messages);
      }
      return messages;
    } catch (error) {
      final failure = ErrorMapper.map(error);
      if (failure is NetworkFailure && beforeMessageId == null) {
        final cached = await _local.readMessages(chatId);
        if (cached.isNotEmpty) return cached;
      }
      throw failure;
    }
  }

  @override
  Future<void> sendMessage(int chatId, String message) async {
    try {
      await _socket.sendMessage(chatId, message);
    } catch (error) {
      // Offline first
      await _local.enqueueOutgoing(chatId, message);
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<void> markRead(int chatId, int lastMessageId) async {
    try {
      await _api.markRead(chatId, MarkReadRequest(lastMessageId: lastMessageId));
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Stream<ChatMessage> watchMessages() =>
      _socket.messages.map((dto) => dto.toEntity());

  @override
  Future<void> connect() async {
    try {
      await _socket.connect();
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<void> joinChat(int chatId) async {
    try {
      await _socket.joinChat(chatId);
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
