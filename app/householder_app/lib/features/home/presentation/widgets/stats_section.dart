import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../domain/entities/dashboard_summary.dart';
import 'stat_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key, required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final sem = Theme.of(context).extension<AppSemanticColors>()!;
    final cards = <Widget>[
      StatCard(
        label: 'Total Listings',
        value: '${summary.totalListings}',
        icon: Icons.home_work_outlined,
      ),
      StatCard(
        label: 'Active Bookings',
        value: '${summary.activeBookings}',
        icon: Icons.event_available_outlined,
        valueColor: sem.success,
      ),
      StatCard(
        label: 'Pending Requests',
        value: '${summary.pendingRequests}',
        icon: Icons.mark_email_unread_outlined,
        valueColor: sem.accent,
        backgroundColor: sem.accentContainer,
        bordered: false,
        iconColor: sem.accent,
      ),
    ];

    final isCompact = Breakpoints.isCompact(context);
    if (isCompact) {
      return Column(
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) AppSpacing.gapLg,
            cards[i],
          ],
        ],
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.lg),
            Expanded(child: cards[i]),
          ],
        ],
      ),
    );
  }
}
