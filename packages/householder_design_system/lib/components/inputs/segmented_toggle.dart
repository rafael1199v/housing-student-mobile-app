import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class SegmentedToggle extends StatelessWidget {
  const SegmentedToggle({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(child: _segment(context, i)),
        ],
      ),
    );
  }

  Widget _segment(BuildContext context, int index) {
    final selected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onChanged(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusS),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          labels[index],
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: selected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
