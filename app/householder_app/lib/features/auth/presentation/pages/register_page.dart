import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../blocs/register_bloc.dart';
import '../utils/auth_error_messages.dart';
import '../widgets/register_form.dart';
import 'login_page.dart';
import 'registration_email_sent_page.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = '/register';
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (_) => GetIt.I<RegisterBloc>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listenWhen: (prev, curr) =>
            curr is RegisterSuccess || curr is RegisterFailureState,
        listener: (context, state) {
          if (state is RegisterSuccess) {
            context.go(
              RegistrationEmailSentPage.routeName,
              extra: state.email,
            );
          } else if (state is RegisterFailureState) {
            debugPrint('Register failure code: ${state.code}');
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  content: Text(authErrorMessage(state.code)),
                ),
              );
          }
        },
        builder: (context, state) {
          final isLoading = state is RegisterLoading;

          return AppAuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(child: AppBrandLogo(brandName: 'Itersapiens')),
                AppSpacing.gapLg,
                Center(
                  child: Text(
                    'Householder Registration',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: Text(
                    'Create your secure profile to begin managing your space.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                RegisterForm(
                  isLoading: isLoading,
                  onSubmit: ({
                    required String firstName,
                    required String lastName,
                    required String gender,
                    required String birthDate,
                    required String nationality,
                    required String phoneNumber,
                    required String email,
                    required String password,
                  }) {
                    FocusScope.of(context).unfocus();
                    context.read<RegisterBloc>().add(
                      RegisterSubmitted(
                        email: email,
                        password: password,
                        firstName: firstName,
                        lastName: lastName,
                        phoneNumber: phoneNumber,
                        nationality: nationality,
                        gender: gender,
                        birthDate: birthDate,
                      ),
                    );
                  },
                ),
                AppSpacing.gapXl,
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.go(LoginPage.routeName),
                        child: Text(
                          'Log in',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
