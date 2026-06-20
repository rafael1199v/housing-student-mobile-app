enum ConnectionStatus { online, offline }

abstract interface class ConnectivityService {
  Future<ConnectionStatus> currentStatus();
  Stream<ConnectionStatus> onStatusChanged();

  void dispose();
}
