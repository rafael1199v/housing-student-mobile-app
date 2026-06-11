import 'package:flutter/material.dart';
import 'package:householder_design_system/householder_design_system.dart';

import '../../domain/entities/room_catalog.dart';
import '../../domain/entities/selected_policy.dart';

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
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusL)),
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
    final available =
        kRoomPolicies.where((p) => !widget.alreadyAddedIds.contains(p.id)).toList();
  
    final media = MediaQuery.of(context);
    final bottomInset = media.viewInsets.bottom + media.padding.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.l + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add House Policy',
                style:
                    Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 20),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          AppSpacing.gapM,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.s,
              crossAxisSpacing: AppSpacing.s,
              mainAxisExtent: 112,
            ),
            itemCount: available.length,
            itemBuilder: (context, i) {
              final option = available[i];
              return SelectableOptionCard(
                label: option.name,
                icon: option.icon,
                selected: _selected?.id == option.id,
                onTap: () => setState(() => _selected = option),
              );
            },
          ),
          if (_selected != null) ...[
            AppSpacing.gapL,
            AppTextField(
              label: '${_selected!.name} Description',
              hintText: 'Be specific about your rule…',
              uppercaseLabel: false,
              controller: _description,
              maxLines: 3,
            ),
          ],
          AppSpacing.gapL,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selected == null ? null : _add,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                    ),
                  ),
                  child: const Text('Add Policy'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
