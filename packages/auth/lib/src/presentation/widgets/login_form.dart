import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../l10n/gen/auth_localizations.dart';
import '../utils/auth_validators.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    required this.onForgotPassword,
  });

  final bool isLoading;
  final void Function(String email, String password) onSubmit;
  final VoidCallback onForgotPassword;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AuthLocalizations.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _emailError = AuthValidators.email(l10n, email);
      _passwordError =
          password.isEmpty ? l10n.validationPasswordRequired : null;
    });

    if (_emailError == null && _passwordError == null) {
      widget.onSubmit(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AuthLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: l10n.authEmailLabel,
          hintText: l10n.hintEmail,
          prefixIcon: Icons.mail_outline,
          uppercaseLabel: true,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          enabled: !widget.isLoading,
          errorText: _emailError,
          onChanged: (_) {
            if (_emailError != null) setState(() => _emailError = null);
          },
        ),
        AppSpacing.gapLg,
        AppTextField(
          label: l10n.fieldPassword,
          hintText: '••••••••',
          prefixIcon: Icons.lock_outline,
          uppercaseLabel: true,
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          enabled: !widget.isLoading,
          errorText: _passwordError,
          onChanged: (_) {
            if (_passwordError != null) setState(() => _passwordError = null);
          },
          onFieldSubmitted: (_) => _submit(),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
              color: cs.outline,
            ),
            tooltip: _obscurePassword ? l10n.showPassword : l10n.hidePassword,
            onPressed: widget.isLoading
                ? null
                : () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppPrimaryButton(
          label: l10n.signIn,
          expanded: true,
          isLoading: widget.isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
