import 'dart:async';

import 'package:housing_core/housing_core.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../models/chat_dtos.dart';

abstract interface class ChatSocketDataSource {
  Stream<MessageDto> get messages;
  Future<void> connect();
  Future<void> joinChat(int chatId);
  Future<void> sendMessage(int chatId, String message);

  Future<void> disconnect();
}

class SignalRChatSocketDataSource implements ChatSocketDataSource {
  SignalRChatSocketDataSource(this._tokenStorage);

  final TokenStorage _tokenStorage;

  final _controller = StreamController<MessageDto>.broadcast();
  HubConnection? _connection;
  Future<void>? _connecting;

  @override
  Stream<MessageDto> get messages => _controller.stream;

  @override
  Future<void> connect() {
    final connection = _connection;
    if (connection != null &&
        connection.state == HubConnectionState.Connected) {
      return Future.value();
    }
    return _connecting ??= _start().whenComplete(() => _connecting = null);
  }

  Future<void> _start() async {
    await _connection?.stop();
    final connection = HubConnectionBuilder()
        .withUrl(
          '${AppConfig.baseUrl}/hubs/chat',
          options: HttpConnectionOptions(
            accessTokenFactory: () async =>
                await _tokenStorage.readAccessToken() ?? '',
          ),
        )
        .withAutomaticReconnect()
        .build();

    connection.on('ReceiveMessage', _onReceiveMessage);

    await connection.start();
    _connection = connection;
  }

  void _onReceiveMessage(List<Object?>? args) {
    if (args == null || args.isEmpty) return;
    final payload = args.first;
    if (payload is! Map) return;
    try {
      final dto = MessageDto.fromJson(Map<String, dynamic>.from(payload));
      _controller.add(dto);
    } catch (_) {
      // REST remains the source of truth.
    }
  }

  @override
  Future<void> joinChat(int chatId) async {
    await connect();
    await _connection?.invoke('JoinChat', args: [chatId]);
  }

  @override
  Future<void> sendMessage(int chatId, String message) async {
    await connect();
    await _connection?.invoke('SendMessage', args: [chatId, message]);
  }

  @override
  Future<void> disconnect() async {
    await _connection?.stop();
    _connection = null;
  }
}
