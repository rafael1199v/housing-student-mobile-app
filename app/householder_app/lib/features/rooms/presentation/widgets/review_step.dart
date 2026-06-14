import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../domain/entities/room_catalog.dart';
import '../cubits/create_room_cubit.dart';

class ReviewStep extends StatelessWidget {
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRoomCubit, CreateRoomState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final services = kRoomServices
            .where((s) => state.serviceIds.contains(s.id))
            .toList();
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text(
              'Review Listing',
              style: theme.textTheme.displaySmall?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Almost done! Review the details below before publishing.',
              style: theme.textTheme.bodyMedium,
            ),
            AppSpacing.gapXl,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(context, Icons.info_outline, 'Basic Info'),
                  AppSpacing.gapLg,
                  _field(context, 'Title',
                      state.name.isEmpty ? '—' : state.name),
                  _field(context, 'Monthly Rent',
                      '\$${state.priceValue?.toStringAsFixed(2) ?? '0.00'}'),
                  _field(context, 'Initial Status',
                      state.statusId == 1 ? 'Available' : 'Not Available'),
                  if (state.description.isNotEmpty)
                    _field(context, 'Description', state.description),
                ],
              ),
            ),
            AppSpacing.gapXl,
            _ReadyBanner(),
            AppSpacing.gapXl,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(
                      context, Icons.location_on_outlined, 'Location'),
                  AppSpacing.gapLg,
                  if (state.address != null)
                    _field(context, 'Detected Address', state.address!),
                  _field(
                    context,
                    'Coordinates',
                    state.hasLocation
                        ? '${state.latitude!.toStringAsFixed(5)}, ${state.longitude!.toStringAsFixed(5)}'
                        : '—',
                  ),
                ],
              ),
            ),
            AppSpacing.gapXl,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(context, Icons.chair_outlined, 'Amenities'),
                  AppSpacing.gapLg,
                  if (services.isEmpty)
                    Text('None selected.', style: theme.textTheme.bodyMedium)
                  else
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final s in services)
                          AppStatusBadge(
                            label: s.name,
                            icon: s.icon,
                            backgroundColor: theme.colorScheme.surfaceContainer,
                          ),
                      ],
                    ),
                ],
              ),
            ),
            AppSpacing.gapXl,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(context, Icons.gavel, 'Policies & Rules'),
                  AppSpacing.gapLg,
                  if (state.policies.isEmpty)
                    Text('None added.', style: theme.textTheme.bodyMedium)
                  else
                    for (var i = 0; i < state.policies.length; i++) ...[
                      if (i > 0) AppSpacing.gapLg,
                      Text(
                        state.policies[i].name,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      if (state.policies[i].description.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(state.policies[i].description,
                            style: theme.textTheme.bodyMedium),
                      ],
                    ],
                ],
              ),
            ),
            AppSpacing.gapXl,
            Text(
              '${state.images.length} photo${state.images.length == 1 ? '' : 's'} attached.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }

  Widget _sectionTitle(BuildContext context, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style:
              Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 16),
        ),
      ],
    );
  }

  Widget _field(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _ReadyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sem = Theme.of(context).extension<AppSemanticColors>()!;
    return AppCard(
      color: sem.successContainer,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready to Publish',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'All required fields have been completed.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: sem.success),
        ],
      ),
    );
  }
}
