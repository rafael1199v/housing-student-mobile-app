import 'package:flutter/material.dart';
import 'package:householder_design_system/householder_design_system.dart';

import '../../domain/entities/booking_status.dart';

({Color fg, Color bg}) bookingStatusBadgeColors(BookingStatus status) {
  switch (status) {
    case BookingStatus.pending:
      return (fg: AppColors.accent, bg: AppColors.accentSurface);
    case BookingStatus.confirmed:
    case BookingStatus.completed:
      return (fg: AppColors.success, bg: AppColors.successSurface);
    case BookingStatus.cancelled:
    case BookingStatus.unknown:
      return (fg: AppColors.textSecondary, bg: AppColors.neutralSurface);
  }
}

String bookingStatusLabel(BookingStatus status) {
  switch (status) {
    case BookingStatus.pending:
      return 'PENDING';
    case BookingStatus.confirmed:
      return 'ACCEPTED';
    case BookingStatus.completed:
      return 'COMPLETED';
    case BookingStatus.cancelled:
      return 'REJECTED';
    case BookingStatus.unknown:
      return 'UNKNOWN';
  }
}
