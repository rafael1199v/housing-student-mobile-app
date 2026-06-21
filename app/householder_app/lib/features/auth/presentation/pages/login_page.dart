import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';
import '../blocs/auth_bloc.dart';
import '../utils/auth_error_messages.dart';
import '../widgets/google_auth_button.dart';
import '../widgets/google_role_picker.dart';
import '../widgets/login_form.dart';
import 'register_page.dart';

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
            curr is AuthAuthenticated ||
            curr is AuthFailureState ||
            curr is AuthNeedsGoogleRole,
        listener: (context, state) async {
          if (state is AuthAuthenticated) {
            GetIt.I<SessionNotifier>().signedIn();
          } else if (state is AuthNeedsGoogleRole) {
            final bloc = context.read<AuthBloc>();
            final role = await showGoogleRolePicker(context);
            if (role == null) return;
            bloc.add(
              GoogleRoleSelected(idToken: state.idToken, role: role),
            );
          } else if (state is AuthFailureState) {
            debugPrint('Auth failure code: ${state.code}');
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  content: Text(
                    authErrorMessage(AppLocalizations.of(context), state.code),
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final l10n = AppLocalizations.of(context);

          return AppAuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppBrandLogo(brandName: 'Itersapiens'),
                AppSpacing.gapXl,
                Text(
                  l10n.authWelcomeBack,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.authLoginSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xxl),
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
                AppSpacing.gapXl,
                AppLabeledDivider(label: l10n.orDivider),
                AppSpacing.gapXl,
                GoogleAuthButton(
                  service: GetIt.I<GoogleSignInService>(),
                  label: l10n.authSignInWithGoogle,
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
                          backgroundColor: Theme.of(context).colorScheme.error,
                          duration: const Duration(seconds: 6),
                          content: Text(l10n.authGoogleSignInFailed('$error')),
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
                        l10n.authNoAccount,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.go(RegisterPage.routeName),
                        child: Text(
                          l10n.authSignUpAsHost,
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
