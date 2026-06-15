import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';
import '../../domain/entities/room_catalog.dart';
import '../../domain/entities/selected_policy.dart';
import '../utils/room_tag_resolver.dart';

class PolicyPickerSheet extends StatefulWidget {
  const PolicyPickerSheet({super.key, required this.alreadyAddedIds});

  final Set<int> alreadyAddedIds;

  static Future<SelectedPolicy?> show(
    BuildContext context, {
    required Set<int> alreadyAddedIds,
  }) {
    return showModalBottomSheet<SelectedPolicy>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lgValue)),
      ),
      builder: (_) => PolicyPickerSheet(alreadyAddedIds: alreadyAddedIds),
    );
  }

  @override
  State<PolicyPickerSheet> createState() => _PolicyPickerSheetState();
}

class _PolicyPickerSheetState extends State<PolicyPickerSheet> {
  final _description = TextEditingController();
  RoomPolicyOption? _selected;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  void _add() {
    final option = _selected;
    if (option == null) return;
    Navigator.of(context).pop(
      SelectedPolicy(
        id: option.id,
        code: option.code,
        name: option.name,
        description: _description.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final available =
        kRoomPolicies.where((p) => !widget.alreadyAddedIds.contains(p.id)).toList();

    final media = MediaQuery.of(context);
    final bottomInset = media.viewInsets.bottom + media.padding.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.addHousePolicy,
                style:
                    Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 20),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          AppSpacing.gapLg,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              mainAxisExtent: 112,
            ),
            itemCount: available.length,
            itemBuilder: (context, i) {
              final option = available[i];
              return AppSelectableOption(
                label: policyName(l10n, option.code),
                icon: option.icon,
                selected: _selected?.id == option.id,
                onTap: () => setState(() => _selected = option),
              );
            },
          ),
          if (_selected != null) ...[
            AppSpacing.gapXl,
            AppTextField(
              label: l10n.policyDescriptionLabel(
                policyName(l10n, _selected!.code),
              ),
              hintText: l10n.hintPolicyDescription,
              uppercaseLabel: false,
              controller: _description,
              maxLines: 3,
            ),
          ],
          AppSpacing.gapXl,
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: cs.outlineVariant),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.mdValue),
                      ),
                    ),
                    child: Text(l10n.cancel),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _selected == null ? null : _add,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.mdValue),
                      ),
                    ),
                    child: Text(l10n.addPolicy),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
