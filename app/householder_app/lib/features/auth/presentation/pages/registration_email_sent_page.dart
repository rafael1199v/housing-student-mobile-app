import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';
import 'login_page.dart';

class RegistrationEmailSentPage extends StatelessWidget {
  static const routeName = '/register/email-sent';

  const RegistrationEmailSentPage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: AppAuthCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primaryContainer,
              ),
              child: Icon(
                Icons.mark_email_unread_outlined,
                size: 40,
                color: cs.onPrimaryContainer,
              ),
            ),
            AppSpacing.gapXl,
            Text(
              l10n.emailSentTitle,
              textAlign: TextAlign.center,
              style: textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.emailSentBody1,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              email,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.emailSentBody2,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppPrimaryButton(
              label: l10n.goToSignIn,
              expanded: true,
              onPressed: () => context.go(LoginPage.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
