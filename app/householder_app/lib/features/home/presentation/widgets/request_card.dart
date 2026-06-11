import 'package:flutter/material.dart';
import 'package:householder_design_system/householder_design_system.dart';

import '../../domain/entities/booking_request.dart';

class RequestCard extends StatelessWidget {
  final BookingRequest request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  final bool enabled;

  const RequestCard({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onDecline,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 300,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.fieldFill,
                  child: Icon(Icons.person_outline, color: AppColors.textHint),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Text(
                    request.requesterName,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapM,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.s),
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Requested Property',
                    style: theme.textTheme.labelSmall,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    request.propertyName,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapM,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: enabled ? onDecline : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border),
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.s),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusM),
                      ),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: ElevatedButton(
                    onPressed: enabled ? onAccept : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      elevation: 0,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.s),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusM),
                      ),
                    ),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
