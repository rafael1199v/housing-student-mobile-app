import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

class BookingRequestsCard extends StatelessWidget {
  final int pendingCount;
  final VoidCallback onViewRequests;

  const BookingRequestsCard({
    super.key,
    required this.pendingCount,
    required this.onViewRequests,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sem = theme.extension<AppSemanticColors>()!;
    final hasPending = pendingCount > 0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Booking Requests',
                  style: theme.textTheme.displaySmall?.copyWith(fontSize: 18),
                ),
              ),
              if (hasPending)
                AppStatusBadge(
                  label: '$pendingCount Pending',
                  foregroundColor: sem.accent,
                  backgroundColor: sem.accentContainer,
                ),
            ],
          ),
          AppSpacing.gapSm,
          Text(
            hasPending
                ? 'You have $pendingCount request${pendingCount == 1 ? '' : 's'} awaiting your response.'
                : 'No pending requests right now.',
            style: theme.textTheme.bodyMedium,
          ),
          AppSpacing.gapLg,
          AppPrimaryButton(
            label: 'View Requests',
            expanded: true,
            trailingIcon: Icons.arrow_forward,
            onPressed: onViewRequests,
          ),
        ],
      ),
    );
  }
}
