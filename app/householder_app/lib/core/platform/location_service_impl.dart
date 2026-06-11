import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';

import 'location_service.dart';

class LocationServiceImpl implements LocationService {
  const LocationServiceImpl();

  @override
  Future<bool> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<LatLngPoint> getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    return LatLngPoint(position.latitude, position.longitude);
  }

  @override
  Future<String?> reverseGeocode(LatLngPoint point) async {
    if (kIsWeb) return null;
    try {
      final placemarks =
          await geo.placemarkFromCoordinates(point.latitude, point.longitude);
      if (placemarks.isEmpty) return null;
      final p = placemarks.first;
      final parts = [
        if ((p.street ?? '').isNotEmpty) p.street,
        if ((p.locality ?? '').isNotEmpty) p.locality,
        if ((p.administrativeArea ?? '').isNotEmpty) p.administrativeArea,
        if ((p.postalCode ?? '').isNotEmpty) p.postalCode,
      ];
      return parts.isEmpty ? null : parts.join(', ');
    } catch (_) {
      return null;
    }
  }
}
