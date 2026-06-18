import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';
import '../../../home/home.dart';

import '../cubits/create_room_cubit.dart';
import '../widgets/basic_details_step.dart';
import '../widgets/review_step.dart';
import '../widgets/services_policies_step.dart';
import '../widgets/step_indicator.dart';

class CreateRoomPage extends StatelessWidget {
  static const String routeName = '/rooms/new';
  static const String editRouteName = '/rooms/:roomId/edit';
  static String editPathTo(int roomId) => '/rooms/$roomId/edit';

  const CreateRoomPage({super.key, this.roomId});

  final int? roomId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateRoomCubit>(
      create: (_) {
        final cubit = GetIt.I<CreateRoomCubit>();
        if (roomId != null) cubit.loadForEdit(roomId!);
        return cubit;
      },
      child: const _CreateRoomView(),
    );
  }
}

class _CreateRoomView extends StatelessWidget {
  const _CreateRoomView();

  void _exit(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(HomePage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateRoomCubit, CreateRoomState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        final l10n = AppLocalizations.of(context);
        if (state.status == CreateRoomStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.isEditMode
                    ? l10n.roomUpdatedSuccess
                    : l10n.roomPublishedSuccess),
              ),
            );
          _exit(context);
        } else if (state.status == CreateRoomStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).colorScheme.error,
                content: Text(_errorMessage(l10n, state.errorCode)),
              ),
            );
        }
      },
      builder: (context, state) {
        final cubit = context.read<CreateRoomCubit>();
        final isLast = state.currentStep == CreateRoomState.lastStep;
        final submitting = state.status == CreateRoomStatus.submitting;

        if (state.initializing) {
          return const Scaffold(
            body: SafeArea(
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _Header(
                  step: state.currentStep,
                  isEditMode: state.isEditMode,
                  onBack: () =>
                      state.currentStep == 0 ? _exit(context) : cubit.back(),
                  onClose: () => _exit(context),
                ),
                const Divider(height: 1),
                Expanded(
                  child: switch (state.currentStep) {
                    0 => const BasicDetailsStep(),
                    1 => const ServicesPoliciesStep(),
                    _ => const ReviewStep(),
                  },
                ),
                _BottomBar(
                  isLast: isLast,
                  isEditMode: state.isEditMode,
                  submitting: submitting,
                  onBack: () =>
                      state.currentStep == 0 ? _exit(context) : cubit.back(),
                  onNext: isLast ? cubit.submit : cubit.next,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _errorMessage(AppLocalizations l10n, String? code) => switch (code) {
    'network.error' => l10n.errNetwork,
    'server.error' => l10n.errServer,
    'validation.failed' => l10n.errRoomPublishValidation,
    _ => l10n.errRoomPublish,
  };
}

class _Header extends StatelessWidget {
  const _Header({
    required this.step,
    required this.isEditMode,
    required this.onBack,
    required this.onClose,
  });

  final int step;
  final bool isEditMode;
  final VoidCallback onBack;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      isEditMode
                          ? AppLocalizations.of(context).editRoom
                          : AppLocalizations.of(context).addNewRoom,
                      style: Theme.of(
                        context,
                      ).textTheme.displaySmall?.copyWith(fontSize: 18),
                    ),
                    Text(
                      AppLocalizations.of(context).stepOfThree(step + 1),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.close), onPressed: onClose),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: StepIndicator(currentStep: step),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.isLast,
    required this.isEditMode,
    required this.submitting,
    required this.onBack,
    required this.onNext,
  });

  final bool isLast;
  final bool isEditMode;
  final bool submitting;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: submitting ? null : onBack,
              style: OutlinedButton.styleFrom(
                foregroundColor: cs.onSurface,
                side: BorderSide(color: cs.outlineVariant),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.pillValue),
                ),
              ),
              child: Text(AppLocalizations.of(context).back),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: AppPrimaryButton(
              label: isLast
                  ? (isEditMode
                      ? AppLocalizations.of(context).save
                      : AppLocalizations.of(context).publish)
                  : AppLocalizations.of(context).nextStep,
              expanded: true,
              isLoading: submitting,
              trailingIcon: isLast ? Icons.check : Icons.arrow_forward,
              onPressed: onNext,
            ),
          ),
        ],
      ),
    );
  }
}
