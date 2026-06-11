import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:householder_design_system/householder_design_system.dart';

import '../../domain/entities/booking_request.dart';
import '../cubits/booking_requests_cubit.dart';
import '../widgets/booking_request_tile.dart';

class BookingRequestsPage extends StatelessWidget {
  static const routeName = '/rooms/:roomId/bookings';
  static String pathTo(int roomId) => '/rooms/$roomId/bookings';

  final int roomId;
  const BookingRequestsPage({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingRequestsCubit>(
      create: (_) => GetIt.I<BookingRequestsCubit>()..load(roomId),
      child: _BookingRequestsView(roomId: roomId),
    );
  }
}

class _BookingRequestsView extends StatelessWidget {
  const _BookingRequestsView({required this.roomId});

  final int roomId;

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature is coming soon.')));
  }

  void _showActionError(BuildContext context, String code) {
    final message = switch (code) {
      'network.error' => 'No connection. Check your network and try again.',
      'unauthorized' => 'Your session expired. Please sign in again.',
      _ => 'We could not update this request. Please try again.',
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Booking Requests',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontSize: 20),
        ),
      ),
      body: BlocBuilder<BookingRequestsCubit, BookingRequestsState>(
        builder: (context, state) {
          return switch (state) {
            BookingRequestsLoaded(:final data, :final actingBookingId) =>
              _Content(
                roomName: data.roomName,
                requests: data.requests,
                actingBookingId: actingBookingId,
                onAccept: (id) => _onAction(context, () {
                  return context.read<BookingRequestsCubit>().approve(id);
                }),
                onDecline: (id) => _onAction(context, () {
                  return context.read<BookingRequestsCubit>().reject(id);
                }),
                onChat: () => _comingSoon(context, 'Chatting with a student'),
              ),
            BookingRequestsFailureState(:final code) => _BookingRequestsError(
              code: code,
              onRetry: () =>
                  context.read<BookingRequestsCubit>().load(roomId),
            ),
            _ => const Center(child: CircularProgressIndicator()),
          };
        },
      ),
    );
  }

  Future<void> _onAction(
    BuildContext context,
    Future<String?> Function() action,
  ) async {
    final code = await action();
    if (code != null && context.mounted) {
      _showActionError(context, code);
    }
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.roomName,
    required this.requests,
    required this.actingBookingId,
    required this.onAccept,
    required this.onDecline,
    required this.onChat,
  });

  final String roomName;
  final List<BookingRequest> requests;
  final String? actingBookingId;
  final void Function(String bookingId) onAccept;
  final void Function(String bookingId) onDecline;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.l),
            children: [
              Text(
                roomName.trim().isEmpty
                    ? 'Requests'
                    : 'Requests for $roomName',
                style: theme.textTheme.displaySmall?.copyWith(fontSize: 22),
              ),
              AppSpacing.gapXS,
              Text(
                'Review student profiles and manage upcoming stays.',
                style: theme.textTheme.bodyMedium,
              ),
              AppSpacing.gapL,
              if (requests.isEmpty)
                const _EmptyRequests()
              else
                for (final request in requests) ...[
                  BookingRequestTile(
                    request: request,
                    isBusy: actingBookingId == request.id,
                    onAccept: () => onAccept(request.id),
                    onDecline: () => onDecline(request.id),
                    onChat: onChat,
                  ),
                  AppSpacing.gapM,
                ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyRequests extends StatelessWidget {
  const _EmptyRequests();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 40,
            color: AppColors.textHint,
          ),
          AppSpacing.gapS,
          Text(
            'No booking requests yet.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _BookingRequestsError extends StatelessWidget {
  const _BookingRequestsError({required this.code, required this.onRetry});

  final String code;
  final VoidCallback onRetry;

  String get _message => switch (code) {
    'network.error' => 'No connection. Check your network and try again.',
    'server.error' => 'Something went wrong on our side. Please try again.',
    'unauthorized' => 'Your session expired. Please sign in again.',
    _ => 'We could not load these requests. Please try again.',
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
