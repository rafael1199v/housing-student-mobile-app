import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../domain/entities/room_catalog.dart';
import '../../domain/entities/room_detail.dart';

class RoomTag {
  final IconData icon;
  final String label;

  const RoomTag({required this.icon, required this.label});
}

const _fallbackIcon = Icons.check_circle_outline;

String serviceName(AppLocalizations l10n, String code) => switch (code) {
      'service.wifi' => l10n.serviceWifi,
      'service.kitchen' => l10n.serviceKitchen,
      'service.tv' => l10n.serviceTv,
      'service.air-conditioner' => l10n.serviceAirConditioning,
      'service.gym-equipment' => l10n.serviceGymEquipment,
      _ => code,
    };

String policyName(AppLocalizations l10n, String code) => switch (code) {
      'policy.rules' => l10n.policyRules,
      'policy.cleaning' => l10n.policyCleaning,
      'policy.pets' => l10n.policyPets,
      'policy.security' => l10n.policySecurity,
      'policy.parking' => l10n.policyParking,
      _ => code,
    };

RoomTag resolveServiceTag(AppLocalizations l10n, String service) {
  final key = service.trim().toLowerCase();
  for (final option in kRoomServices) {
    if (option.name.toLowerCase() == key || option.code.toLowerCase() == key) {
      return RoomTag(icon: option.icon, label: serviceName(l10n, option.code));
    }
  }
  return RoomTag(icon: _fallbackIcon, label: service.trim());
}

RoomTag resolvePolicyTag(AppLocalizations l10n, RoomPolicyTag policy) {
  final key = policy.code.trim().toLowerCase();
  for (final option in kRoomPolicies) {
    if (option.code.toLowerCase() == key) {
      final label = policy.description.trim().isNotEmpty
          ? policy.description.trim()
          : policyName(l10n, option.code);
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
