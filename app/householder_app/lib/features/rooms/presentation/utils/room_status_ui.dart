import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../domain/entities/room_status.dart';

({Color fg, Color bg}) roomStatusBadgeColors(
  BuildContext context,
  RoomStatus status,
) {
  final cs = Theme.of(context).colorScheme;
  final sem = Theme.of(context).extension<AppSemanticColors>()!;
  switch (status) {
    case RoomStatus.available:
      return (fg: sem.success, bg: sem.successContainer);
    case RoomStatus.booked:
      return (fg: sem.accent, bg: sem.accentContainer);
    case RoomStatus.unavailable:
    case RoomStatus.unknown:
      return (fg: cs.onSurfaceVariant, bg: cs.surfaceContainer);
  }
}

String roomStatusLabel(BuildContext context, RoomStatus status) {
  switch (status) {
    case RoomStatus.available:
      return 'Available';
    case RoomStatus.unavailable:
      return 'Unavailable';
    case RoomStatus.booked:
      return 'Booked';
    case RoomStatus.unknown:
      return 'Unknown';
  }
}
