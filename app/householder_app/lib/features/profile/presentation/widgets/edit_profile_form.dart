import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../domain/entities/update_profile_params.dart';
import '../../domain/entities/user_profile.dart';
import '../utils/profile_form_options.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({
    super.key,
    required this.profile,
    required this.isSubmitting,
    required this.onSubmit,
    this.fieldErrors = const {},
  });

  final UserProfile profile;
  final bool isSubmitting;
  final ValueChanged<UpdateProfileParams> onSubmit;
  final Map<String, String> fieldErrors;

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  String? _gender;
  String? _nationality;
  DateTime? _birthDate;

  String? _genderError;
  String? _nationalityError;
  String? _birthDateError;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _firstNameController = TextEditingController(text: p.firstName);
    _lastNameController = TextEditingController(text: p.lastName ?? '');
    _phoneController = TextEditingController(text: p.phoneNumber ?? '');
    _emailController = TextEditingController(text: p.email);
    _gender = matchDropdownValue(p.gender, kGenderOptions);
    _nationality = matchDropdownValue(p.nationality, kNationalityOptions);
    _birthDate = DateTime.tryParse(p.birthDate?.trim() ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String _formatBirthDate(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd';
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label is required.';
    return null;
  }

  String? _phoneValidator(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Phone number is required.';
    if (!RegExp(r'^\+?\d{6,15}$').hasMatch(trimmed)) {
      return 'Enter a valid phone number.';
    }
    return null;
  }

  void _submit() {
    if (widget.isSubmitting) return;
    final isValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      _genderError = _gender == null ? 'Please select a gender.' : null;
      _nationalityError =
          _nationality == null ? 'Please select a nationality.' : null;
      _birthDateError =
          _birthDate == null ? 'Please select your date of birth.' : null;
    });

    final hasSelectorError =
        _genderError != null || _nationalityError != null || _birthDateError != null;
    if (!isValid || hasSelectorError) return;

    widget.onSubmit(
      UpdateProfileParams(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        gender: _gender,
        nationality: _nationality,
        birthdate: _formatBirthDate(_birthDate!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final enabled = !widget.isSubmitting;
    final errors = widget.fieldErrors;

    return Form(
      key: _formKey,
      child: AppFormSection(
        actions: AppPrimaryButton(
          label: 'Save',
          expanded: true,
          isLoading: widget.isSubmitting,
          onPressed: _submit,
        ),
        children: [
          AppTextField(
            label: 'First Name',
            hintText: 'e.g. Jane',
            controller: _firstNameController,
            enabled: enabled,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (v) => _required(v, 'First name'),
            errorText: errors['firstName'],
          ),
          AppTextField(
            label: 'Last Name',
            hintText: 'e.g. Doe',
            controller: _lastNameController,
            enabled: enabled,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (v) => _required(v, 'Last name'),
            errorText: errors['lastName'],
          ),
          AppDropdownField<String>(
            label: 'Gender',
            hintText: 'Select gender',
            items: kGenderOptions,
            value: _gender,
            enabled: enabled,
            errorText: _genderError ?? errors['gender'],
            onChanged: (value) => setState(() {
              _gender = value;
              _genderError = null;
            }),
          ),
          AppDropdownField<String>(
            label: 'Nationality',
            hintText: 'Select nationality',
            items: kNationalityOptions,
            value: _nationality,
            enabled: enabled,
            errorText: _nationalityError ?? errors['nationality'],
            onChanged: (value) => setState(() {
              _nationality = value;
              _nationalityError = null;
            }),
          ),
          AppDateField(
            label: 'Date of Birth',
            hintText: 'mm/dd/yyyy',
            value: _birthDate,
            enabled: enabled,
            errorText: _birthDateError ?? errors['birthdate'],
            onChanged: (value) => setState(() {
              _birthDate = value;
              _birthDateError = null;
            }),
          ),
          AppTextField(
            label: 'Phone Number',
            hintText: '+591 000 000 000',
            controller: _phoneController,
            enabled: enabled,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            validator: _phoneValidator,
            errorText: errors['phoneNumber'],
            onFieldSubmitted: (_) => _submit(),
          ),
          AppTextField(
            label: 'Email Address',
            controller: _emailController,
            enabled: false,
            prefixIcon: Icons.mail_outline,
          ),
        ],
      ),
    );
  }
}
