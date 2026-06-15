import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.trailingIcon = Icons.arrow_forward,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(AppColors.onPrimary),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: Theme.of(context).textTheme.labelLarge),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Icon(trailingIcon, size: 20),
                  ],
                ],
              ),
      ),
    );
  }
}
