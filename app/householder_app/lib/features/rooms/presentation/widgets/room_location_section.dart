import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:householder_design_system/householder_design_system.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/core.dart';

class RoomLocationSection extends StatelessWidget {
  final double latitude;
  final double longitude;

  const RoomLocationSection({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  Future<void> _openInMaps(BuildContext context) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    final launched =
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Could not open Maps.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final position = LatLng(latitude, longitude);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Location',
              style: theme.textTheme.displaySmall?.copyWith(fontSize: 18),
            ),
            GestureDetector(
              onTap: () => _openInMaps(context),
              child: Text(
                'Open in Maps',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.gapM,
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          child: SizedBox(
            height: 200,
            child: GoogleMap(
              markerType: GoogleMapMarkerType.advancedMarker,
              mapId: AppConfig.mapsCloudMapIdOrNull,
              initialCameraPosition: CameraPosition(target: position, zoom: 15),
              markers: {
                AdvancedMarker(markerId: const MarkerId('room'), position: position),
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  EagerGestureRecognizer.new,
                ),
              },
            ),
          ),
        ),
        if (kIsWeb) ...[
          AppSpacing.gapXS,
          Text(
            'Tap "Open in Maps" for directions.',
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
          ),
        ],
      ],
    );
  }
}
