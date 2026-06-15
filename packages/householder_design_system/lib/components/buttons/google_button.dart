import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'google_logo.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GoogleLogo(size: 20),
            const SizedBox(width: AppSpacing.s),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
