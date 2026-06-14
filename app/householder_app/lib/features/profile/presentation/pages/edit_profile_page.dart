import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../domain/entities/user_profile.dart';
import '../cubits/edit_profile_cubit.dart';
import '../widgets/edit_profile_form.dart';

class EditProfilePage extends StatelessWidget {
  static const routeName = '/profile/edit';

  const EditProfilePage({super.key, required this.profile});

  final UserProfile profile;

  String _errorMessage(String code) => switch (code) {
        'network.error' => 'No connection. Check your network and try again.',
        'server.error' => 'Something went wrong on our side. Please try again.',
        'unauthorized' => 'Your session expired. Please sign in again.',
        'rate.limited' => 'Too many requests. Please wait a moment.',
        _ => 'We could not update your profile. Please try again.',
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BlocProvider<EditProfileCubit>(
      create: (_) => GetIt.I<EditProfileCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cs.surface,
          elevation: 0,
          title: const Text('Edit Profile'),
        ),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Profile updated.')),
                );
              context.pop();
            } else if (state is EditProfileFailure &&
                state.fieldErrors.isEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(_errorMessage(state.code))),
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
