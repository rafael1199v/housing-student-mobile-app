import 'package:flutter/material.dart';
import 'package:householder_design_system/householder_design_system.dart';

import 'theme_mode_selector.dart';

class PreferencesCard extends StatelessWidget {
  final ValueChanged<String> onComingSoon;
  final VoidCallback onSignOut;

  const PreferencesCard({
    super.key,
    required this.onComingSoon,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel(text: 'Language'),
          const SizedBox(height: AppSpacing.xs),
          _LanguageField(onTap: () => onComingSoon('Changing the language')),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Available in English, Portuguese, and Spanish.',
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
          ),
          AppSpacing.gapL,
          const FieldLabel(text: 'Theme Mode'),
          const SizedBox(height: AppSpacing.xs),
          ThemeModeSelector(onSelect: (mode) => onComingSoon('$mode theme')),
          AppSpacing.gapL,
          const Divider(height: 1),
          AppSpacing.gapL,
          _SignOutButton(onPressed: onSignOut),
        ],
      ),
    );
  }
}

class _LanguageField extends StatelessWidget {
  const _LanguageField({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.translate,
              size: 20,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: Text(
                'English (US)',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 22,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.logout, size: 20),
        label: const Text('Sign Out'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          ),
        ),
      ),
    );
  }
}
