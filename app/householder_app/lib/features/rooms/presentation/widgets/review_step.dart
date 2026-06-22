import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';
import '../../domain/entities/room_catalog.dart';
import '../cubits/create_room_cubit.dart';
import '../utils/room_tag_resolver.dart';

class ReviewStep extends StatelessWidget {
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRoomCubit, CreateRoomState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final l10n = AppLocalizations.of(context);
        final services = kRoomServices
            .where((s) => state.serviceIds.contains(s.id))
            .toList();
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text(
              l10n.reviewListing,
              style: theme.textTheme.displaySmall?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.reviewSubtitle,
              style: theme.textTheme.bodyMedium,
            ),
            AppSpacing.gapXl,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(context, Icons.info_outline, l10n.basicInfo),
                  AppSpacing.gapLg,
                  _field(context, l10n.fieldTitle,
                      state.name.isEmpty ? '—' : state.name),
                  _field(context, l10n.monthlyRent,
                      '\$${state.priceValue?.toStringAsFixed(2) ?? '0.00'}'),
                  _field(context, l10n.initialStatus,
                      state.statusId == 1
                          ? l10n.roomStatusAvailable
                          : l10n.statusNotAvailable),
                  if (state.description.isNotEmpty)
                    _field(context, l10n.descriptionLabel, state.description),
                ],
              ),
            ),
            if (!state.isEditMode) ...[
              AppSpacing.gapXl,
              _ReadyBanner(),
            ],
            AppSpacing.gapXl,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(
                      context, Icons.location_on_outlined, l10n.location),
                  AppSpacing.gapLg,
                  if (state.address != null)
                    _field(context, l10n.detectedAddress, state.address!),
                  _field(
                    context,
                    l10n.coordinates,
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
                  _sectionTitle(context, Icons.chair_outlined, l10n.amenities),
                  AppSpacing.gapLg,
                  if (services.isEmpty)
                    Text(l10n.noneSelected, style: theme.textTheme.bodyMedium)
                  else
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final s in services)
                          AppStatusBadge(
                            label: serviceName(l10n, s.code),
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
                  _sectionTitle(context, Icons.gavel, l10n.policiesRules),
                  AppSpacing.gapLg,
                  if (state.policies.isEmpty)
                    Text(l10n.noneAdded, style: theme.textTheme.bodyMedium)
                  else
                    for (var i = 0; i < state.policies.length; i++) ...[
                      if (i > 0) AppSpacing.gapLg,
                      Text(
                        policyName(l10n, state.policies[i].code),
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
              l10n.photosAttached(state.totalPhotoCount),
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
    final l10n = AppLocalizations.of(context);
    return AppCard(
      color: sem.successContainer,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.readyToPublish,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.allFieldsCompleted,
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
