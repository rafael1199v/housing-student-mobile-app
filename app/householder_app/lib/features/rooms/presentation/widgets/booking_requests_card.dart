import 'package:flutter/material.dart';
import 'package:householder_design_system/householder_design_system.dart';

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
                StatusBadge(
                  label: '$pendingCount Pending',
                  foregroundColor: AppColors.accent,
                  backgroundColor: AppColors.accentSurface,
                ),
            ],
          ),
          AppSpacing.gapXS,
          Text(
            hasPending
                ? 'You have $pendingCount request${pendingCount == 1 ? '' : 's'} awaiting your response.'
                : 'No pending requests right now.',
            style: theme.textTheme.bodyMedium,
          ),
          AppSpacing.gapM,
          PrimaryButton(
            label: 'View Requests',
            trailingIcon: Icons.arrow_forward,
            onPressed: onViewRequests,
          ),
        ],
      ),
    );
  }
}
