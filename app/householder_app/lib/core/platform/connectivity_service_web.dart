import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'connectivity_service.dart';

ConnectivityService createConnectivityServiceImpl() => WebConnectivityService();

class WebConnectivityService implements ConnectivityService {
  WebConnectivityService() {
    _onOnline = ((web.Event _) => _emit(ConnectionStatus.online)).toJS;
    _onOffline = ((web.Event _) => _emit(ConnectionStatus.offline)).toJS;
    web.window.addEventListener('online', _onOnline);
    web.window.addEventListener('offline', _onOffline);
  }

  final _controller = StreamController<ConnectionStatus>.broadcast();
  late final JSFunction _onOnline;
  late final JSFunction _onOffline;

  @override
  Future<ConnectionStatus> currentStatus() async => _read();

  @override
  Stream<ConnectionStatus> onStatusChanged() => _controller.stream;

  void _emit(ConnectionStatus status) {
    if (!_controller.isClosed) _controller.add(status);
  }

  ConnectionStatus _read() => web.window.navigator.onLine
      ? ConnectionStatus.online
      : ConnectionStatus.offline;

  @override
  void dispose() {
    web.window.removeEventListener('online', _onOnline);
    web.window.removeEventListener('offline', _onOffline);
    _controller.close();
  }
}
