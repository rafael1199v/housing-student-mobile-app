import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../domain/entities/booking_status.dart';

({Color fg, Color bg}) bookingStatusBadgeColors(
  BuildContext context,
  BookingStatus status,
) {
  final cs = Theme.of(context).colorScheme;
  final sem = Theme.of(context).extension<AppSemanticColors>()!;
  switch (status) {
    case BookingStatus.pending:
      return (fg: sem.accent, bg: sem.accentContainer);
    case BookingStatus.confirmed:
    case BookingStatus.completed:
      return (fg: sem.success, bg: sem.successContainer);
    case BookingStatus.cancelled:
    case BookingStatus.unknown:
      return (fg: cs.onSurfaceVariant, bg: cs.surfaceContainer);
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
