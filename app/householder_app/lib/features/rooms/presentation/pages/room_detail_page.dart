import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';
import '../../../booking/booking.dart';
import '../../domain/entities/room_detail.dart';
import '../cubits/room_detail_cubit.dart';
import '../utils/room_status_ui.dart';
import '../utils/room_tag_resolver.dart';
import '../widgets/amenities_grid.dart';
import '../widgets/booking_requests_card.dart';
import '../widgets/room_image_carousel.dart';
import '../widgets/room_location_section.dart';
import 'create_room_page.dart';

class RoomDetailPage extends StatelessWidget {
  static const routeName = '/rooms/:roomId';
  static String pathTo(int roomId) => '/rooms/$roomId';

  final int roomId;
  const RoomDetailPage({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RoomDetailCubit>(
      create: (_) => GetIt.I<RoomDetailCubit>()..load(roomId),
      child: _RoomDetailView(roomId: roomId),
    );
  }
}

class _RoomDetailView extends StatelessWidget {
  const _RoomDetailView({required this.roomId});

  final int roomId;

  Future<void> _openEdit(BuildContext context) async {
    final cubit = context.read<RoomDetailCubit>();
    await context.push(CreateRoomPage.editPathTo(roomId));
    if (context.mounted) cubit.load(roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).roomDetails,
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontSize: 20),
        ),
      ),
      body: BlocBuilder<RoomDetailCubit, RoomDetailState>(
        builder: (context, state) {
          return switch (state) {
            RoomDetailLoaded(:final detail, :final address) => _Content(
              detail: detail,
              address: address,
              onEdit: () => _openEdit(context),
              onViewRequests: () =>
                  context.push(BookingRequestsPage.pathTo(roomId)),
            ),
            RoomDetailFailureState(:final code) => _RoomDetailError(
              code: code,
              onRetry: () => context.read<RoomDetailCubit>().load(roomId),
            ),
            _ => const Center(child: CircularProgressIndicator()),
          };
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.detail,
    required this.address,
    required this.onEdit,
    required this.onViewRequests,
  });

  final RoomDetail detail;
  final String? address;
  final VoidCallback onEdit;
  final VoidCallback onViewRequests;

  String get _addressLabel =>
      address ??
      '${detail.latitude.toStringAsFixed(5)}, '
          '${detail.longitude.toStringAsFixed(5)}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final colors = roomStatusBadgeColors(context, detail.status);
    final serviceTags =
        detail.services.map((s) => resolveServiceTag(l10n, s)).toList();
    final policyTags =
        detail.policies.map((p) => resolvePolicyTag(l10n, p)).toList();

    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoomImageCarousel(imageUrls: detail.imageUrls, onEdit: onEdit),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              detail.name,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontSize: 26,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: AppStatusBadge(
                              label: roomStatusLabel(context, detail.status),
                              foregroundColor: colors.fg,
                              backgroundColor: colors.bg,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.gapSm,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              _addressLabel,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.gapXl,
                      Text(
                        l10n.descriptionLabel,
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      AppSpacing.gapMd,
                      Text(
                        detail.description.trim().isEmpty
                            ? l10n.noDescriptionProvided
                            : detail.description.trim(),
                        style: theme.textTheme.bodyMedium,
                      ),
                      AppSpacing.gapXl,
                      AmenitiesGrid(
                        serviceTags: serviceTags,
                        policyTags: policyTags,
                      ),
                      AppSpacing.gapXl,
                      RoomLocationSection(
                        latitude: detail.latitude,
                        longitude: detail.longitude,
                      ),
                      AppSpacing.gapXl,
                      BookingRequestsCard(
                        pendingCount: detail.pendingBookingsCount,
                        onViewRequests: onViewRequests,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomDetailError extends StatelessWidget {
  const _RoomDetailError({required this.code, required this.onRetry});

  final String code;
  final VoidCallback onRetry;

  String _message(AppLocalizations l10n) => switch (code) {
    'network.error' => l10n.errNetwork,
    'server.error' => l10n.errServer,
    'unauthorized' => l10n.errUnauthorized,
    _ => l10n.errRoomLoad,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.outline,
            ),
            AppSpacing.gapLg,
            Text(
              _message(l10n),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            AppSpacing.gapXl,
            AppPrimaryButton(
              label: l10n.retry,
              expanded: true,
              trailingIcon: null,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
