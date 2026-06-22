import 'package:flutter/material.dart';

import '../../responsive/breakpoints.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.child, this.maxWidth = 440});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final isCompact = Breakpoints.isCompact(context);

    final content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.xl,
        ),
        child: child,
      ),
    );

    if (isCompact) {
      return SafeArea(
        child: Center(
          child: SingleChildScrollView(child: content),
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusL),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: content,
        ),
      ),
    );
  }
}
