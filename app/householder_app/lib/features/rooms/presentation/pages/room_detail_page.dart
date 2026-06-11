import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:householder_design_system/householder_design_system.dart';

import '../../domain/entities/room_detail.dart';
import '../cubits/room_detail_cubit.dart';
import '../utils/room_status_ui.dart';
import '../utils/room_tag_resolver.dart';
import '../widgets/amenities_grid.dart';
import '../widgets/booking_requests_card.dart';
import '../widgets/room_image_carousel.dart';
import '../widgets/room_location_section.dart';

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

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature is coming soon.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Room Details',
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
              onEdit: () => _comingSoon(context, 'Editing a room'),
              onViewRequests: () => context.push('/rooms/$roomId/bookings'),
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
    final colors = roomStatusBadgeColors(detail.status);
    final serviceTags = detail.services.map(resolveServiceTag).toList();
    final policyTags = detail.policies.map(resolvePolicyTag).toList();

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
                  padding: const EdgeInsets.all(AppSpacing.l),
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
                          const SizedBox(width: AppSpacing.s),
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xxs),
                            child: StatusBadge(
                              label: roomStatusLabel(context, detail.status),
                              foregroundColor: colors.fg,
                              backgroundColor: colors.bg,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.gapXS,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Expanded(
                            child: Text(
                              _addressLabel,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.gapL,
                      Text(
                        'Description',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      AppSpacing.gapS,
                      Text(
                        detail.description.trim().isEmpty
                            ? 'No description provided.'
                            : detail.description.trim(),
                        style: theme.textTheme.bodyMedium,
                      ),
                      AppSpacing.gapL,
                      Text(
                        'Amenities & Policies',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      AppSpacing.gapM,
                      AmenitiesGrid(
                        serviceTags: serviceTags,
                        policyTags: policyTags,
                      ),
                      AppSpacing.gapL,
                      RoomLocationSection(
                        latitude: detail.latitude,
                        longitude: detail.longitude,
                      ),
                      AppSpacing.gapL,
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

  String get _message => switch (code) {
    'network.error' => 'No connection. Check your network and try again.',
    'server.error' => 'Something went wrong on our side. Please try again.',
    'unauthorized' => 'Your session expired. Please sign in again.',
    _ => 'We could not load this room. Please try again.',
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: AppColors.textHint,
            ),
            AppSpacing.gapM,
            Text(
              _message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            AppSpacing.gapL,
            PrimaryButton(
              label: 'Retry',
              trailingIcon: null,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
