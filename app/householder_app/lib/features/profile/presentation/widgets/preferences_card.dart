import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';
import 'language_selector.dart';
import 'theme_mode_selector.dart';

class PreferencesCard extends StatelessWidget {
  final VoidCallback onSignOut;

  const PreferencesCard({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFieldLabel(text: l10n.prefLanguage),
          const SizedBox(height: AppSpacing.sm),
          BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) => LanguageSelector(
              value: locale,
              onChanged: (selected) =>
                  context.read<LocaleCubit>().setLocale(selected),
            ),
          ),
          AppSpacing.gapXl,
          AppFieldLabel(text: l10n.prefThemeMode),
          const SizedBox(height: AppSpacing.sm),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) => ThemeModeSelector(
              value: mode,
              onChanged: (selected) =>
                  context.read<ThemeCubit>().setMode(selected),
            ),
          ),
          AppSpacing.gapXl,
          const _ChangeRoleEntry(),
          const Divider(height: 1),
          AppSpacing.gapXl,
          _SignOutButton(label: l10n.signOut, onPressed: onSignOut),
        ],
      ),
    );
  }
}

class _ChangeRoleEntry extends StatelessWidget {
  const _ChangeRoleEntry();

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<RoleSwitchController>()) {
      return const SizedBox.shrink();
    }
    final controller = getIt<RoleSwitchController>();
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (!controller.canChangeRole) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () => controller.open(context),
                icon: const Icon(Icons.swap_horiz, size: 20),
                label: Text(l10n.changeRole),
                style: OutlinedButton.styleFrom(
                  foregroundColor: cs.primary,
                  side: BorderSide(color: cs.primary),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.mdValue),
                  ),
                ),
              ),
            ),
            AppSpacing.gapXl,
          ],
        );
      },
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.label, required this.onPressed});

  final String label;
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
        label: Text(label),
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
