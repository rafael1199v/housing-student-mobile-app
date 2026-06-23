class PendingDeepLink {
  String? _target;

  void set(String location) => _target = location;
  String? peek() => _target;
  void clear() => _target = null;
  
  String? consume() {
    final target = _target;
    _target = null;
    return target;
  }
}
