import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

class InfoField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const InfoField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFieldLabel(text: label),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadii.mdValue),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: cs.onSurfaceVariant),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
