import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:householder_design_system/householder_design_system.dart';

import '../../../rooms/rooms.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/property_summary.dart';
import '../cubits/dashboard_cubit.dart';
import '../widgets/action_needed_section.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/my_properties_section.dart';
import '../widgets/stats_section.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardCubit>(
      create: (_) => GetIt.I<DashboardCubit>()..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  Future<void> _openCreateRoom(BuildContext context) async {
    final cubit = context.read<DashboardCubit>();
    await context.push('/rooms/new');
    await cubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const BrandLogo()
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        onPressed: () => _openCreateRoom(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return switch (state) {
            DashboardLoaded(:final summary) =>
              _DashboardContent(summary: summary),
            DashboardFailureState(:final code) => _DashboardError(code: code),
            _ => const Center(child: CircularProgressIndicator()),
          };
        },
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<DashboardCubit>().refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.l,
          AppSpacing.l,
          AppSpacing.l,
          AppSpacing.xxl + AppSpacing.xl,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DashboardHeader(name: summary.greetingName),
                AppSpacing.gapL,
                StatsSection(summary: summary),
                AppSpacing.gapXL,
                ActionNeededSection(requests: summary.actionNeeded),
                if (summary.actionNeeded.isNotEmpty) AppSpacing.gapXL,
                MyPropertiesSection(
                  properties: summary.properties,
                  onManage: (property) => _onManage(context, property),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onManage(BuildContext context, PropertySummary property) async {
    final cubit = context.read<DashboardCubit>();
    await context.push(RoomDetailPage.pathTo(property.id));
    await cubit.refresh();
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.code});

  final String code;

  String get _message => switch (code) {
        'network.error' => 'No connection. Check your network and try again.',
        'server.error' => 'Something went wrong on our side. Please try again.',
        _ => 'We could not load your dashboard. Please try again.',
      };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined,
                size: 56, color: AppColors.textHint),
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
              onPressed: () => context.read<DashboardCubit>().load(),
            ),
          ],
        ),
      ),
    );
  }
}
