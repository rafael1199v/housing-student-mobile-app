import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';
import '../../../profile/presentation/utils/profile_form_options.dart';
import '../utils/register_validators.dart';
import '../utils/role_options.dart';
import 'phone_field.dart';

typedef RegisterSubmitCallback =
    void Function({
      required String role,
      required String firstName,
      required String lastName,
      required String gender,
      required String birthDate,
      required String nationality,
      required String phoneNumber,
      required String email,
      required String password,
    });

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  final bool isLoading;
  final RegisterSubmitCallback onSubmit;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String _dialCode = '+591';
  String _role = kDefaultRoleValue;
  String? _gender;
  String? _nationality;
  DateTime? _birthDate;
  bool _acceptedTerms = false;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  String? _firstNameError;
  String? _lastNameError;
  String? _genderError;
  String? _birthDateError;
  String? _nationalityError;
  String? _phoneError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _termsError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String _formatBirthDate(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd';
  }

  void _submit() {
    final l10n = AppLocalizations.of(context);
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    setState(() {
      _firstNameError =
          RegisterValidators.required(l10n, firstName, l10n.fieldFirstName);
      _lastNameError =
          RegisterValidators.required(l10n, lastName, l10n.fieldLastName);
      _genderError = _gender == null ? l10n.validationSelectGender : null;
      _birthDateError =
          _birthDate == null ? l10n.validationSelectBirthDate : null;
      _nationalityError =
          _nationality == null ? l10n.validationSelectNationality : null;
      _phoneError = RegisterValidators.phoneNumber(l10n, phone);
      _emailError = RegisterValidators.email(l10n, email);
      _passwordError = RegisterValidators.password(l10n, password);
      _confirmError =
          RegisterValidators.confirmPassword(l10n, password, confirm);
      _termsError = _acceptedTerms ? null : l10n.validationAcceptTerms;
    });

    final hasError = [
      _firstNameError,
      _lastNameError,
      _genderError,
      _birthDateError,
      _nationalityError,
      _phoneError,
      _emailError,
      _passwordError,
      _confirmError,
      _termsError,
    ].any((e) => e != null);

    if (hasError) return;

    widget.onSubmit(
      role: _role,
      firstName: firstName,
      lastName: lastName,
      gender: _gender!,
      birthDate: _formatBirthDate(_birthDate!),
      nationality: _nationality!,
      phoneNumber: '$_dialCode$phone',
      email: email,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final enabled = !widget.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDropdownField<String>(
          label: l10n.fieldRole,
          hintText: l10n.hintSelectRole,
          items: roleOptions(l10n),
          value: _role,
          enabled: enabled,
          onChanged: (value) => setState(() => _role = value ?? _role),
        ),
        AppSpacing.gapLg,
        AppTextField(
          label: l10n.fieldFirstName,
          hintText: l10n.hintFirstName,
          controller: _firstNameController,
          enabled: enabled,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          errorText: _firstNameError,
          onChanged: (_) {
            if (_firstNameError != null) {
              setState(() => _firstNameError = null);
            }
          },
        ),
        AppSpacing.gapLg,
        AppTextField(
          label: l10n.fieldLastName,
          hintText: l10n.hintLastName,
          controller: _lastNameController,
          enabled: enabled,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          errorText: _lastNameError,
          onChanged: (_) {
            if (_lastNameError != null) setState(() => _lastNameError = null);
          },
        ),
        AppSpacing.gapLg,
        AppDropdownField<String>(
          label: l10n.fieldGender,
          hintText: l10n.hintSelectGender,
          items: genderOptions(l10n),
          value: _gender,
          enabled: enabled,
          errorText: _genderError,
          onChanged: (value) => setState(() {
            _gender = value;
            _genderError = null;
          }),
        ),
        AppSpacing.gapLg,
        AppDateField(
          label: l10n.fieldDateOfBirth,
          hintText: l10n.hintDateOfBirth,
          value: _birthDate,
          enabled: enabled,
          errorText: _birthDateError,
          onChanged: (value) => setState(() {
            _birthDate = value;
            _birthDateError = null;
          }),
        ),
        AppSpacing.gapLg,
        AppDropdownField<String>(
          label: l10n.fieldNationality,
          hintText: l10n.hintSelectNationality,
          items: nationalityOptions(l10n),
          value: _nationality,
          enabled: enabled,
          errorText: _nationalityError,
          onChanged: (value) => setState(() {
            _nationality = value;
            _nationalityError = null;
          }),
        ),
        AppSpacing.gapLg,
        PhoneField(
          controller: _phoneController,
          dialCode: _dialCode,
          enabled: enabled,
          errorText: _phoneError,
          onDialCodeChanged: (value) =>
              setState(() => _dialCode = value ?? _dialCode),
          onChanged: (_) {
            if (_phoneError != null) setState(() => _phoneError = null);
          },
        ),
        AppSpacing.gapLg,
        AppTextField(
          label: l10n.fieldEmailAddress,
          hintText: l10n.hintEmail,
          prefixIcon: Icons.mail_outline,
          controller: _emailController,
          enabled: enabled,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
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
          controller: _passwordController,
          enabled: enabled,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          errorText: _passwordError,
          onChanged: (_) {
            if (_passwordError != null) setState(() => _passwordError = null);
          },
          suffixIcon: _visibilityToggle(
            obscured: _obscurePassword,
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        AppSpacing.gapLg,
        AppTextField(
          label: l10n.fieldConfirmPassword,
          hintText: '••••••••',
          prefixIcon: Icons.lock_outline,
          controller: _confirmController,
          enabled: enabled,
          obscureText: _obscureConfirm,
          textInputAction: TextInputAction.done,
          errorText: _confirmError,
          onChanged: (_) {
            if (_confirmError != null) setState(() => _confirmError = null);
          },
          onFieldSubmitted: (_) => _submit(),
          suffixIcon: _visibilityToggle(
            obscured: _obscureConfirm,
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ),
        AppSpacing.gapLg,
        _termsCheckbox(cs),
        const SizedBox(height: AppSpacing.xxl),
        AppPrimaryButton(
          label: l10n.createAccount,
          expanded: true,
          isLoading: widget.isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }

  Widget _visibilityToggle({
    required bool obscured,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(
        obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 20,
        color: Theme.of(context).colorScheme.outline,
      ),
      tooltip: obscured
          ? AppLocalizations.of(context).showPassword
          : AppLocalizations.of(context).hidePassword,
      onPressed: widget.isLoading ? null : onPressed,
    );
  }

  Widget _termsCheckbox(ColorScheme cs) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _acceptedTerms,
                onChanged: widget.isLoading
                    ? null
                    : (value) => setState(() {
                        _acceptedTerms = value ?? false;
                        _termsError = null;
                      }),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(text: l10n.termsAgreePrefix),
                      TextSpan(
                        text: l10n.termsAndConditions,
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      TextSpan(text: l10n.termsConnector),
                      TextSpan(
                        text: l10n.privacyPolicy,
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      TextSpan(text: l10n.termsSuffix),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_termsError != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs, left: 4),
            child: Text(
              _termsError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.error,
                  ),
            ),
          ),
      ],
    );
  }
}
