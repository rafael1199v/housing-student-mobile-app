import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';


class StatusBadge extends StatelessWidget {
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.foregroundColor = AppColors.textSecondary,
    this.backgroundColor = AppColors.neutralSurface,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: foregroundColor),
            const SizedBox(width: AppSpacing.xxs),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
          ),
        ],
      ),
    );
  }
}
