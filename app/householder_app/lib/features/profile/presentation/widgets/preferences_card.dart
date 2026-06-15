import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';
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
          const AppFieldLabel(text: 'Language'),
          const SizedBox(height: AppSpacing.sm),
          _LanguageField(onTap: () => onComingSoon('Changing the language')),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Available in English, Portuguese, and Spanish.',
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
          ),
          AppSpacing.gapXl,
          const AppFieldLabel(text: 'Theme Mode'),
          const SizedBox(height: AppSpacing.sm),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) => ThemeModeSelector(
              value: mode,
              onChanged: (selected) =>
                  context.read<ThemeCubit>().setMode(selected),
            ),
          ),
          AppSpacing.gapXl,
          const Divider(height: 1),
          AppSpacing.gapXl,
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
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.mdValue),
      onTap: onTap,
      child: Container(
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
            Icon(
              Icons.translate,
              size: 20,
              color: cs.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'English (US)',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 22,
              color: cs.onSurfaceVariant,
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
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.logout, size: 20),
        label: const Text('Sign Out'),
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.error,
          side: BorderSide(color: cs.error),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.mdValue),
          ),
        ),
      ),
    );
  }
}
