import 'package:flutter/widgets.dart';

import '../../domain/entities/room_status.dart';

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
