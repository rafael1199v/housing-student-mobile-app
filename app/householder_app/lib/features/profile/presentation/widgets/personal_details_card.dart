import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';
import '../../domain/entities/user_profile.dart';
import '../utils/profile_format.dart';
import 'info_field.dart';


class PersonalDetailsCard extends StatelessWidget {
  const PersonalDetailsCard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).languageCode;
    return AppCard(
      child: Column(
        children: [
          InfoField(
            label: l10n.fieldGender,
            value: profileValueOrDash(profile.gender),
            icon: Icons.wc_outlined,
          ),
          AppSpacing.gapLg,
          InfoField(
            label: l10n.fieldPhone,
            value: profileValueOrDash(profile.phoneNumber),
            icon: Icons.phone_outlined,
          ),
          AppSpacing.gapLg,
          InfoField(
            label: l10n.fieldNationality,
            value: profileValueOrDash(profile.nationality),
            icon: Icons.public_outlined,
          ),
          AppSpacing.gapLg,
          InfoField(
            label: l10n.fieldDateOfBirth,
            value: formatBirthDate(profile.birthDate, localeName),
            icon: Icons.calendar_today_outlined,
          ),
        ],
      ),
    );
  }
}
