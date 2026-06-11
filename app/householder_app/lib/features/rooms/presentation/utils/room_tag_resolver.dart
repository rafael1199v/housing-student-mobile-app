import 'package:flutter/material.dart';

import '../../domain/entities/room_catalog.dart';
import '../../domain/entities/room_detail.dart';

class RoomTag {
  final IconData icon;
  final String label;

  const RoomTag({required this.icon, required this.label});

}

const _fallbackIcon = Icons.check_circle_outline;

RoomTag resolveServiceTag(String service) {
  final key = service.trim().toLowerCase();
  for (final option in kRoomServices) {
    if (option.name.toLowerCase() == key || option.code.toLowerCase() == key) {
      return RoomTag(icon: option.icon, label: option.name);
    }
  }
  return RoomTag(icon: _fallbackIcon, label: service.trim());
}

RoomTag resolvePolicyTag(RoomPolicyTag policy) {
  final key = policy.code.trim().toLowerCase();
  for (final option in kRoomPolicies) {
    if (option.code.toLowerCase() == key) {
      final label = policy.description.trim().isNotEmpty
          ? policy.description.trim()
          : option.name;
      return RoomTag(icon: option.icon, label: label);
    }
  }
  return RoomTag(
    icon: _fallbackIcon,
    label: policy.description.trim().isNotEmpty
        ? policy.description.trim()
        : policy.code.trim(),
  );
}
