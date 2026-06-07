import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.brandName = 'Itersapiens'});

  final String brandName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.shield, color: AppColors.primary, size: 26),
        const SizedBox(width: AppSpacing.xs),
        Text(
          brandName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
        ),
      ],
    );
  }
}
