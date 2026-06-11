import 'package:flutter/material.dart';
import 'package:householder_design_system/householder_design_system.dart';

import '../../domain/entities/room_status.dart';

({Color fg, Color bg}) roomStatusBadgeColors(RoomStatus status) {
  switch (status) {
    case RoomStatus.available:
      return (fg: AppColors.success, bg: AppColors.successSurface);
    case RoomStatus.booked:
      return (fg: AppColors.accent, bg: AppColors.accentSurface);
    case RoomStatus.unavailable:
    case RoomStatus.unknown:
      return (fg: AppColors.textSecondary, bg: AppColors.neutralSurface);
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
