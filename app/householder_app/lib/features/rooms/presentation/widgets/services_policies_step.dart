import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../domain/entities/room_catalog.dart';
import '../../domain/entities/selected_policy.dart';
import '../cubits/create_room_cubit.dart';
import 'policy_picker_sheet.dart';

/// Step 2: select included amenities and attach house policies.
class ServicesPoliciesStep extends StatelessWidget {
  const ServicesPoliciesStep({super.key});

  Future<void> _addPolicy(BuildContext context, CreateRoomState state) async {
    final cubit = context.read<CreateRoomCubit>();
    final policy = await PolicyPickerSheet.show(
      context,
      alreadyAddedIds: state.policies.map((p) => p.id).toSet(),
    );
    if (policy != null) cubit.addPolicy(policy);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateRoomCubit>();
    return BlocBuilder<CreateRoomCubit, CreateRoomState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text(
              'Services & Policies',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Define what makes this space special and set clear expectations '
              'for potential tenants.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            AppSpacing.gapXl,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Included Amenities',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Select all services provided in this room.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  AppSpacing.gapLg,
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisExtent: 112,
                    ),
                    itemCount: kRoomServices.length,
                    itemBuilder: (context, i) {
                      final service = kRoomServices[i];
                      return AppSelectableOption(
                        label: service.name,
                        icon: service.icon,
                        selected: state.serviceIds.contains(service.id),
                        onTap: () => cubit.toggleService(service.id),
                      );
                    },
                  ),
                ],
              ),
            ),
            AppSpacing.gapXl,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'House Policies',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Provide detailed descriptions for your rules to ensure a '
                    'good fit.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  AppSpacing.gapLg,
                  for (final policy in state.policies) ...[
                    _PolicyTile(
                      policy: policy,
                      onRemove: () => cubit.removePolicy(policy.id),
                    ),
                    AppSpacing.gapMd,
                  ],
                  OutlinedButton.icon(
                    onPressed: state.policies.length >= kRoomPolicies.length
                        ? null
                        : () => _addPolicy(context, state),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add House Policy'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.mdValue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PolicyTile extends StatelessWidget {
  const _PolicyTile({required this.policy, required this.onRemove});

  final SelectedPolicy policy;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final option = kRoomPolicies.firstWhere(
      (p) => p.id == policy.id,
      orElse: () => kRoomPolicies.first,
    );
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.mdValue),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(option.icon, size: 20, color: cs.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  policy.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (policy.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    policy.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 18, color: cs.outline),
          ),
        ],
      ),
    );
  }
}
