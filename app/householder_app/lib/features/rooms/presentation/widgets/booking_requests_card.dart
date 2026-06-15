import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';

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
    final l10n = AppLocalizations.of(context);
    final hasPending = pendingCount > 0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.bookingRequestsTitle,
                  style: theme.textTheme.displaySmall?.copyWith(fontSize: 18),
                ),
              ),
              if (hasPending)
                AppStatusBadge(
                  label: l10n.pendingBadge(pendingCount),
                  foregroundColor: sem.accent,
                  backgroundColor: sem.accentContainer,
                ),
            ],
          ),
          AppSpacing.gapSm,
          Text(
            hasPending
                ? l10n.pendingRequestsAwaiting(pendingCount)
                : l10n.noPendingRequests,
            style: theme.textTheme.bodyMedium,
          ),
          AppSpacing.gapLg,
          AppPrimaryButton(
            label: l10n.viewRequests,
            expanded: true,
            trailingIcon: Icons.arrow_forward,
            onPressed: onViewRequests,
          ),
        ],
      ),
    );
  }
}
