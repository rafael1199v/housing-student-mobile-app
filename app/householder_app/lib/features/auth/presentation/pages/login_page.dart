import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:householder_design_system/householder_design_system.dart';

import '../../../../core/core.dart';
import '../bloc/auth_bloc.dart';
import '../utils/auth_error_messages.dart';
import '../widgets/google_auth_button.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/login';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => GetIt.I<AuthBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (prev, curr) =>
            curr is AuthAuthenticated || curr is AuthFailureState,
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            GetIt.I<SessionNotifier>().signedIn();
          } else if (state is AuthFailureState) {
            debugPrint('Auth failure code: ${state.code}');
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.error,
                  content: Text(authErrorMessage(state.code)),
                ),
              );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const BrandLogo(),
                AppSpacing.gapL,
                Text(
                  'Welcome back',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Sign in to your householder dashboard to continue.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                AppSpacing.gapXL,
                LoginForm(
                  isLoading: isLoading,
                  onForgotPassword: () => {},
                  onSubmit: (email, password) {
                    FocusScope.of(context).unfocus();
                    context.read<AuthBloc>().add(
                      LoginSubmitted(email: email, password: password),
                    );
                  },
                ),
                AppSpacing.gapL,
                const LabeledDivider(label: 'or'),
                AppSpacing.gapL,
                GoogleAuthButton(
                  service: GetIt.I<GoogleSignInService>(),
                  label: 'Sign in with Google',
                  enabled: !isLoading,
                  onIdToken: (idToken) => context.read<AuthBloc>().add(
                    GoogleAuthSubmitted(idToken),
                  ),
                  onError: (error) { 
                    debugPrint('Google sign-in error: $error');
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.error,
                          duration: const Duration(seconds: 6),
                          content: Text('Google sign-in failed: $error'),
                        ),
                      );
                  },
                ),
                AppSpacing.gapL,
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.go(LoginPage.routeName),
                        child: Text(
                          'Sign up as a Host',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.primary,
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
