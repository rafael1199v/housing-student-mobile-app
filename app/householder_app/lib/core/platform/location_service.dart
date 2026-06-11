class LatLngPoint {
  const LatLngPoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

abstract interface class LocationService {
  Future<bool> ensurePermission();
  Future<LatLngPoint> getCurrentPosition();
  Future<String?> reverseGeocode(LatLngPoint point);
}
