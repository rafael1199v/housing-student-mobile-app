import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../utils/register_validators.dart';
import 'phone_field.dart';

typedef RegisterSubmitCallback =
    void Function({
      required String firstName,
      required String lastName,
      required String gender,
      required String birthDate,
      required String nationality,
      required String phoneNumber,
      required String email,
      required String password,
    });

const List<AppDropdownItem<String>> _genders = [
  AppDropdownItem(value: 'Male', label: 'Male'),
  AppDropdownItem(value: 'Female', label: 'Female'),
  AppDropdownItem(value: 'Other', label: 'Other'),
];

const List<AppDropdownItem<String>> _nationalities = [
  AppDropdownItem(value: 'Bolivian', label: 'Bolivian'),
  AppDropdownItem(value: 'Argentinian', label: 'Argentinian'),
  AppDropdownItem(value: 'Chilean', label: 'Chilean'),
  AppDropdownItem(value: 'Colombian', label: 'Colombian'),
  AppDropdownItem(value: 'Mexican', label: 'Mexican'),
  AppDropdownItem(value: 'Peruvian', label: 'Peruvian'),
  AppDropdownItem(value: 'Spanish', label: 'Spanish'),
  AppDropdownItem(value: 'American', label: 'American'),
  AppDropdownItem(value: 'Other', label: 'Other'),
];

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
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    setState(() {
      _firstNameError = RegisterValidators.required(firstName, 'First name');
      _lastNameError = RegisterValidators.required(lastName, 'Last name');
      _genderError = _gender == null ? 'Please select a gender.' : null;
      _birthDateError = _birthDate == null
          ? 'Please select your date of birth.'
          : null;
      _nationalityError = _nationality == null
          ? 'Please select a nationality.'
          : null;
      _phoneError = RegisterValidators.phoneNumber(phone);
      _emailError = RegisterValidators.email(email);
      _passwordError = RegisterValidators.password(password);
      _confirmError = RegisterValidators.confirmPassword(password, confirm);
      _termsError = _acceptedTerms
          ? null
          : 'You must accept the terms to continue.';
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
    final enabled = !widget.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'First Name',
          hintText: 'e.g. Jane',
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
          label: 'Last Name',
          hintText: 'e.g. Doe',
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
          label: 'Gender',
          hintText: 'Select gender',
          items: _genders,
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
          label: 'Date of Birth',
          hintText: 'mm/dd/yyyy',
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
          label: 'Nationality',
          hintText: 'Select nationality',
          items: _nationalities,
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
          label: 'Email Address',
          hintText: 'name@example.com',
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
          label: 'Password',
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
          label: 'Confirm Password',
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
          label: 'Create Account',
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
      tooltip: obscured ? 'Show password' : 'Hide password',
      onPressed: widget.isLoading ? null : onPressed,
    );
  }

  Widget _termsCheckbox(ColorScheme cs) {
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
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(text: ' of Itersapiens.'),
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
