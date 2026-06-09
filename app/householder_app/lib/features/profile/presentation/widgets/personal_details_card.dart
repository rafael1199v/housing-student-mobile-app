import 'package:flutter/material.dart';
import 'package:householder_design_system/householder_design_system.dart';

import '../../domain/entities/user_profile.dart';
import '../utils/profile_format.dart';
import 'info_field.dart';


class PersonalDetailsCard extends StatelessWidget {
  const PersonalDetailsCard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          InfoField(
            label: 'Gender',
            value: profileValueOrDash(profile.gender),
            icon: Icons.wc_outlined,
          ),
          AppSpacing.gapM,
          InfoField(
            label: 'Telephone Number',
            value: profileValueOrDash(profile.phoneNumber),
            icon: Icons.phone_outlined,
          ),
          AppSpacing.gapM,
          InfoField(
            label: 'Nationality',
            value: profileValueOrDash(profile.nationality),
            icon: Icons.public_outlined,
          ),
          AppSpacing.gapM,
          InfoField(
            label: 'Date of Birth',
            value: formatBirthDate(profile.birthDate),
            icon: Icons.calendar_today_outlined,
          ),
        ],
      ),
    );
  }
}
