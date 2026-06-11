import 'package:flutter/material.dart';
import 'package:householder_design_system/householder_design_system.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, required this.name});

  final String name;

  String _greetingPrefix() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_greetingPrefix()}, $name',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 26),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          'Here is an overview of your properties today.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
