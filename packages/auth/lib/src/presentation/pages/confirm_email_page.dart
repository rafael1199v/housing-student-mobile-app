import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../l10n/gen/auth_localizations.dart';
import '../blocs/confirm_email_bloc.dart';
import '../utils/auth_error_messages.dart';
import 'login_page.dart';

class ConfirmEmailPage extends StatelessWidget {
  static const routeName = '/confirm-email';

  const ConfirmEmailPage({super.key, required this.userId, required this.token});

  final String userId;
  final String token;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConfirmEmailBloc>(
      create: (_) => GetIt.I<ConfirmEmailBloc>()
        ..add(ConfirmEmailRequested(userId: userId, token: token)),
      child: const _ConfirmEmailView(),
    );
  }
}

class _ConfirmEmailView extends StatelessWidget {
  const _ConfirmEmailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppAuthCard(
        child: BlocBuilder<ConfirmEmailBloc, ConfirmEmailState>(
          builder: (context, state) {
            return switch (state) {
              ConfirmEmailSuccess() => const _ConfirmEmailSuccessView(),
              ConfirmEmailFailureState(:final code) => _ConfirmEmailErrorView(
                code: code,
              ),
              _ => const _ConfirmEmailLoadingView(),
            };
          },
        ),
      ),
    );
  }
}

class _ConfirmEmailLoadingView extends StatelessWidget {
  const _ConfirmEmailLoadingView();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(),
        ),
        AppSpacing.gapXl,
        Text(
          AuthLocalizations.of(context).confirmEmailLoading,
          textAlign: TextAlign.center,
          style: textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _ConfirmEmailSuccessView extends StatelessWidget {
  const _ConfirmEmailSuccessView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semantics = Theme.of(context).extension<AppSemanticColors>();
    final successColor = semantics?.success ?? cs.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: successColor.withValues(alpha: 0.12),
          ),
          child: Icon(
            Icons.mark_email_read_outlined,
            size: 40,
            color: successColor,
          ),
        ),
        AppSpacing.gapXl,
        Text(
          AuthLocalizations.of(context).confirmEmailSuccessTitle,
          textAlign: TextAlign.center,
          style: textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          AuthLocalizations.of(context).confirmEmailSuccessBody,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppPrimaryButton(
          label: AuthLocalizations.of(context).goToLogin,
          expanded: true,
          onPressed: () => context.go(LoginPage.routeName),
        ),
      ],
    );
  }
}

class _ConfirmEmailErrorView extends StatelessWidget {
  const _ConfirmEmailErrorView({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cs.errorContainer,
          ),
          child: Icon(
            Icons.error_outline,
            size: 40,
            color: cs.onErrorContainer,
          ),
        ),
        AppSpacing.gapXl,
        Text(
          AuthLocalizations.of(context).confirmEmailErrorTitle,
          textAlign: TextAlign.center,
          style: textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          authErrorMessage(AuthLocalizations.of(context), code),
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppPrimaryButton(
          label: AuthLocalizations.of(context).goToLogin,
          expanded: true,
          onPressed: () => context.go(LoginPage.routeName),
        ),
      ],
    );
  }
}
