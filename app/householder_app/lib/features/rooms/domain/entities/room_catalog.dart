import 'package:flutter/material.dart';

class RoomServiceOption {
  final int id;
  final String code;
  final String name;
  final IconData icon;

  const RoomServiceOption({
    required this.id,
    required this.code,
    required this.name,
    required this.icon,
  });
}

class RoomPolicyOption {
  final int id;
  final String code;
  final String name;
  final IconData icon;

  const RoomPolicyOption({
    required this.id,
    required this.code,
    required this.name,
    required this.icon,
  });
}

const List<RoomServiceOption> kRoomServices = [
  RoomServiceOption(
      id: 1, code: 'service.wifi', name: 'Wi-Fi', icon: Icons.wifi),
  RoomServiceOption(
      id: 2, code: 'service.kitchen', name: 'Kitchen', icon: Icons.kitchen),
  RoomServiceOption(id: 3, code: 'service.tv', name: 'TV', icon: Icons.tv),
  RoomServiceOption(
      id: 4,
      code: 'service.air-conditioner',
      name: 'Air Conditioning',
      icon: Icons.ac_unit),
  RoomServiceOption(
      id: 5,
      code: 'service.gym-equipment',
      name: 'Gym Equipment',
      icon: Icons.fitness_center),
];

const List<RoomPolicyOption> kRoomPolicies = [
  RoomPolicyOption(
      id: 1, code: 'policy.rules', name: 'Rules', icon: Icons.gavel),
  RoomPolicyOption(
      id: 2,
      code: 'policy.cleaning',
      name: 'Cleaning',
      icon: Icons.cleaning_services),
  RoomPolicyOption(id: 3, code: 'policy.pets', name: 'Pets', icon: Icons.pets),
  RoomPolicyOption(
      id: 4, code: 'policy.security', name: 'Security', icon: Icons.security),
  RoomPolicyOption(
      id: 5,
      code: 'policy.parking',
      name: 'Parking',
      icon: Icons.local_parking),
];
