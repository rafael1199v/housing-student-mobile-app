import 'package:flutter/widgets.dart';

import '../../../../core/core.dart';
import '../../domain/entities/room_status.dart';

String roomStatusLabel(BuildContext context, RoomStatus status) {
  final l10n = AppLocalizations.of(context);
  switch (status) {
    case RoomStatus.available:
      return l10n.roomStatusAvailable;
    case RoomStatus.unavailable:
      return l10n.roomStatusUnavailable;
    case RoomStatus.booked:
      return l10n.roomStatusBooked;
    case RoomStatus.unknown:
      return l10n.roomStatusUnknown;
  }
}
