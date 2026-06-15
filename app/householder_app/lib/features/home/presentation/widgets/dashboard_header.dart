import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, required this.name});

  final String name;

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.homeGreetingMorning(name);
    if (hour < 18) return l10n.homeGreetingAfternoon(name);
    return l10n.homeGreetingEvening(name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greeting(l10n),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 26),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.homeOverviewSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
