import 'connectivity_service.dart';

ConnectivityService createConnectivityServiceImpl() =>
    const _AlwaysOnlineConnectivityService();

class _AlwaysOnlineConnectivityService implements ConnectivityService {
  const _AlwaysOnlineConnectivityService();

  @override
  Future<ConnectionStatus> currentStatus() async => ConnectionStatus.online;

  @override
  Stream<ConnectionStatus> onStatusChanged() => const Stream.empty();

  @override
  void dispose() {}
}
