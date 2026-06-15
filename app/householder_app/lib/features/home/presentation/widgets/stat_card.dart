import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
  final Color? backgroundColor;
  final bool bordered;
  final Color? iconColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
    this.backgroundColor,
    this.bordered = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final resolvedValueColor = valueColor ?? cs.primary;
    final resolvedIconColor = iconColor ?? cs.primary;

    return AppCard(
      color: backgroundColor ?? cs.surfaceContainerLowest,
      bordered: bordered,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  value,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 30,
                        color: resolvedValueColor,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: resolvedIconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadii.mdValue),
            ),
            child: Icon(icon, size: 20, color: resolvedIconColor),
          ),
        ],
      ),
    );
  }
}
