import 'package:flutter/services.dart';

import 'connectivity_service.dart';

ConnectivityService createConnectivityServiceImpl() =>
    ChannelConnectivityService();

class ChannelConnectivityService implements ConnectivityService {
  ChannelConnectivityService();

  static const _method = MethodChannel('app.householder/connectivity');
  static const _events = EventChannel('app.householder/connectivity/events');

  Stream<ConnectionStatus>? _stream;

  @override
  Future<ConnectionStatus> currentStatus() async {
    final raw = await _method.invokeMethod<String>('status');
    return _parse(raw);
  }

  @override
  Stream<ConnectionStatus> onStatusChanged() => _stream ??= _events
      .receiveBroadcastStream()
      .map((event) => _parse(event as String?))
      .asBroadcastStream();

  @override
  void dispose() {}

  static ConnectionStatus _parse(String? raw) =>
      raw == 'offline' ? ConnectionStatus.offline : ConnectionStatus.online;
}
