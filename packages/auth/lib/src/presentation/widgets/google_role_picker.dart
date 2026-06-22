import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../l10n/gen/auth_localizations.dart';
import '../utils/role_options.dart';

Future<String?> showGoogleRolePicker(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => const _GoogleRolePicker(),
  );
}

class _GoogleRolePicker extends StatelessWidget {
  const _GoogleRolePicker();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AuthLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.googleRolePickerTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.googleRolePickerSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            for (final role in kSelectableRoles)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: FilledButton.tonal(
                  onPressed: () => Navigator.of(context).pop(role.wire),
                  child: Text(roleOptionLabel(l10n, role.wire)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
