import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';

class LocationMap extends StatefulWidget {

  final double? latitude;
  final double? longitude;
  final void Function(double lat, double lng) onTap;
  final Future<bool> Function() onUseCurrentLocation;

  const LocationMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onTap,
    required this.onUseCurrentLocation,
  });
 

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  static const _fallback = LatLng(-17.3935, -66.1570);

  GoogleMapController? _controller;
  bool _locating = false;

  LatLng? get _picked => widget.latitude != null && widget.longitude != null
      ? LatLng(widget.latitude!, widget.longitude!)
      : null;

  @override
  void didUpdateWidget(LocationMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final picked = _picked;
    if (picked != null &&
        (widget.latitude != oldWidget.latitude ||
            widget.longitude != oldWidget.longitude)) {
      _controller?.animateCamera(CameraUpdate.newLatLng(picked));
    }
  }

  Future<void> _useCurrent() async {
    setState(() => _locating = true);
    bool ok = false;
    try {
      ok = await widget.onUseCurrentLocation();
    } finally {
      if (mounted) setState(() => _locating = false);
    }
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).locationError)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final picked = _picked;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.mdValue),
          child: SizedBox(
            height: 200,
            child: GoogleMap(
              markerType: GoogleMapMarkerType.advancedMarker,
              mapId: AppConfig.mapsCloudMapIdOrNull,
              initialCameraPosition: CameraPosition(
                target: picked ?? _fallback,
                zoom: picked != null ? 15 : 12,
              ),
              onMapCreated: (c) => _controller = c,
              onTap: (pos) => widget.onTap(pos.latitude, pos.longitude),
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  EagerGestureRecognizer.new,
                ),
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              markers: {
                if (picked != null)
                  AdvancedMarker(markerId: const MarkerId('room'), position: picked),
              },
            ),
          ),
        ),
        AppSpacing.gapMd,
        SizedBox(
          height: 48,
          child: OutlinedButton.icon(
            onPressed: _locating ? null : _useCurrent,
            icon: _locating
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location, size: 18),
            label: Text(AppLocalizations.of(context).pinCurrentLocation),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.mdValue),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
