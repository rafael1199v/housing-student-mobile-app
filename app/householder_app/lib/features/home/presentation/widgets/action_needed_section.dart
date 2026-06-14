import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../domain/entities/booking_request.dart';
import '../cubits/dashboard_cubit.dart';
import 'request_card.dart';
import 'section_header.dart';

class ActionNeededSection extends StatefulWidget {
  final List<BookingRequest> requests;

  const ActionNeededSection({super.key, required this.requests});

  @override
  State<ActionNeededSection> createState() => _ActionNeededSectionState();
}

class _ActionNeededSectionState extends State<ActionNeededSection> {
  final ScrollController _scrollController = ScrollController();

  String? _processingId;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _resolve(BookingRequest request, {required bool accept}) async {
    if (_processingId != null) return;
    setState(() => _processingId = request.id);

    final cubit = context.read<DashboardCubit>();
    final messenger = ScaffoldMessenger.of(context);

    final errorCode = accept
        ? await cubit.acceptRequest(request.id)
        : await cubit.rejectRequest(request.id);

    if (!mounted) return;
    setState(() => _processingId = null);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            switch ((accept, errorCode)) {
              (_, final code?) => _errorMessage(code),
              (true, null) => 'Accepted ${request.requesterName}\'s request.',
              (false, null) => 'Declined ${request.requesterName}\'s request.',
            },
          ),
        ),
      );
  }

  String _errorMessage(String code) => switch (code) {
        'network.error' => 'No connection. Check your network and try again.',
        'rate.limited' => 'Too many requests. Please wait a moment.',
        _ => 'Could not update the request. Please try again.',
      };

  @override
  Widget build(BuildContext context) {
    final requests = widget.requests;
    if (requests.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Action Needed', onViewAll: () {}),
        AppSpacing.gapLg,
        _buildCarousel(context, requests),
      ],
    );
  }

  Widget _buildCarousel(BuildContext context, List<BookingRequest> requests) {
    final showScrollbar = !Breakpoints.isCompact(context);
    final list = SizedBox(
      height: 250,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(bottom: showScrollbar ? AppSpacing.md : 0),
        itemCount: requests.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.lg),
        itemBuilder: (context, index) => _card(requests[index]),
      ),
    );

    if (!showScrollbar) return list;

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: list,
    );
  }

  Widget _card(BookingRequest request) {
    return RequestCard(
      request: request,
      enabled: _processingId == null,
      onAccept: () => _resolve(request, accept: true),
      onDecline: () => _resolve(request, accept: false),
    );
  }
}
