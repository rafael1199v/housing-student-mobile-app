import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';
import '../../domain/entities/user_profile.dart';
import '../cubits/edit_profile_cubit.dart';
import '../widgets/edit_profile_form.dart';

class EditProfilePage extends StatelessWidget {
  static const routeName = '/profile/edit';

  const EditProfilePage({super.key, required this.profile});

  final UserProfile profile;

  String _errorMessage(AppLocalizations l10n, String code) => switch (code) {
        'network.error' => l10n.errNetwork,
        'server.error' => l10n.errServer,
        'unauthorized' => l10n.errUnauthorized,
        'rate.limited' => l10n.errRateLimited,
        _ => l10n.errProfileUpdate,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return BlocProvider<EditProfileCubit>(
      create: (_) => GetIt.I<EditProfileCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cs.surface,
          elevation: 0,
          title: Text(l10n.editProfileTitle),
        ),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(l10n.profileUpdated)),
                );
              context.pop();
            } else if (state is EditProfileFailure &&
                state.fieldErrors.isEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(_errorMessage(l10n, state.code))),
                );
            }
          },
          builder: (context, state) {
            final submitting = state is EditProfileSubmitting;
            final fieldErrors =
                state is EditProfileFailure ? state.fieldErrors : const <String, String>{};

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xxl,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: EditProfileForm(
                    profile: profile,
                    isSubmitting: submitting,
                    fieldErrors: fieldErrors,
                    onSubmit: (params) =>
                        context.read<EditProfileCubit>().submit(params),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
