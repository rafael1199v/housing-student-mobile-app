import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';
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

  AppLocalizations get _l10n => AppLocalizations.of(context);

  String _formatBirthDate(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd';
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return _l10n.validationRequired(label);
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return _l10n.validationPhoneRequired;
    if (!RegExp(r'^\+?\d{6,15}$').hasMatch(trimmed)) {
      return _l10n.validationPhoneInvalid;
    }
    return null;
  }

  void _submit() {
    if (widget.isSubmitting) return;
    final isValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      _genderError = _gender == null ? _l10n.validationSelectGender : null;
      _nationalityError =
          _nationality == null ? _l10n.validationSelectNationality : null;
      _birthDateError =
          _birthDate == null ? _l10n.validationSelectBirthDate : null;
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
    final l10n = AppLocalizations.of(context);

    return Form(
      key: _formKey,
      child: AppFormSection(
        actions: AppPrimaryButton(
          label: l10n.save,
          expanded: true,
          isLoading: widget.isSubmitting,
          onPressed: _submit,
        ),
        children: [
          AppTextField(
            label: l10n.fieldFirstName,
            hintText: l10n.hintFirstName,
            controller: _firstNameController,
            enabled: enabled,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (v) => _required(v, l10n.fieldFirstName),
            errorText: errors['firstName'],
          ),
          AppTextField(
            label: l10n.fieldLastName,
            hintText: l10n.hintLastName,
            controller: _lastNameController,
            enabled: enabled,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (v) => _required(v, l10n.fieldLastName),
            errorText: errors['lastName'],
          ),
          AppDropdownField<String>(
            label: l10n.fieldGender,
            hintText: l10n.hintSelectGender,
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
            label: l10n.fieldNationality,
            hintText: l10n.hintSelectNationality,
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
            label: l10n.fieldDateOfBirth,
            hintText: l10n.hintDateOfBirth,
            value: _birthDate,
            enabled: enabled,
            errorText: _birthDateError ?? errors['birthdate'],
            onChanged: (value) => setState(() {
              _birthDate = value;
              _birthDateError = null;
            }),
          ),
          AppTextField(
            label: l10n.fieldPhoneNumber,
            hintText: l10n.hintPhoneNumber,
            controller: _phoneController,
            enabled: enabled,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            validator: _phoneValidator,
            errorText: errors['phoneNumber'],
            onFieldSubmitted: (_) => _submit(),
          ),
          AppTextField(
            label: l10n.fieldEmailAddress,
            controller: _emailController,
            enabled: false,
            prefixIcon: Icons.mail_outline,
          ),
        ],
      ),
    );
  }
}
