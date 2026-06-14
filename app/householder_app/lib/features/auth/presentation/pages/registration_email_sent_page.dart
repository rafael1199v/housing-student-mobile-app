import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:housing_design_system/housing_design_system.dart';

import 'login_page.dart';

class RegistrationEmailSentPage extends StatelessWidget {
  static const routeName = '/register/email-sent';

  const RegistrationEmailSentPage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
              'Check your inbox',
              textAlign: TextAlign.center,
              style: textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'We sent a confirmation email to:',
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
              'Open the link in that email to confirm your account, then sign '
              'in to continue.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppPrimaryButton(
              label: 'Go to sign in',
              expanded: true,
              onPressed: () => context.go(LoginPage.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
