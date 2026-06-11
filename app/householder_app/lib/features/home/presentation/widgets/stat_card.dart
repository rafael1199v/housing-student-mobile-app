import 'package:flutter/material.dart';
import 'package:householder_design_system/householder_design_system.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color valueColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor = AppColors.primary,
    this.backgroundColor = AppColors.surface,
    this.borderColor = AppColors.border,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
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
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  value,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 30,
                        color: valueColor,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
        ],
      ),
    );
  }
}
