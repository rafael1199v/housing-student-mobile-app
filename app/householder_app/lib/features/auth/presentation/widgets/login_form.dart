import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

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
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _emailError = AuthValidators.email(email);
      _passwordError = password.isEmpty ? 'Password is required.' : null;
    });

    if (_emailError == null && _passwordError == null) {
      widget.onSubmit(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Email address',
          hintText: 'name@example.com',
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
          label: 'Password',
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
            tooltip: _obscurePassword ? 'Show password' : 'Hide password',
            onPressed: widget.isLoading
                ? null
                : () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppPrimaryButton(
          label: 'Sign In',
          expanded: true,
          isLoading: widget.isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
