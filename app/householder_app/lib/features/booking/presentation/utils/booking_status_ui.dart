import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';
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

String bookingStatusLabel(BuildContext context, BookingStatus status) {
  final l10n = AppLocalizations.of(context);
  switch (status) {
    case BookingStatus.pending:
      return l10n.bookingStatusPending;
    case BookingStatus.confirmed:
      return l10n.bookingStatusAccepted;
    case BookingStatus.completed:
      return l10n.bookingStatusCompleted;
    case BookingStatus.cancelled:
      return l10n.bookingStatusRejected;
    case BookingStatus.unknown:
      return l10n.bookingStatusUnknown;
  }
}
