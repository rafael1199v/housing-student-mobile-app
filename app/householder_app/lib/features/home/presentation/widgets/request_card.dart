import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

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
    final cs = theme.colorScheme;
    return SizedBox(
      width: 300,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: cs.surfaceContainerLow,
                  child: Icon(Icons.person_outline, color: cs.outline),
                ),
                const SizedBox(width: AppSpacing.md),
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
            AppSpacing.gapLg,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppRadii.mdValue),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Requested Property',
                    style: theme.textTheme.labelSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    request.propertyName,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: enabled ? onDecline : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.onSurface,
                      side: BorderSide(color: cs.outlineVariant),
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadii.mdValue),
                      ),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: enabled ? onAccept : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      elevation: 0,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadii.mdValue),
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
