import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';

const List<AppDropdownItem<String>> kDialCodes = [
  AppDropdownItem(value: '+591', label: '🇧🇴 +591', selectedLabel: '+591'),
  AppDropdownItem(value: '+1', label: '🇺🇸 +1', selectedLabel: '+1'),
  AppDropdownItem(value: '+52', label: '🇲🇽 +52', selectedLabel: '+52'),
  AppDropdownItem(value: '+54', label: '🇦🇷 +54', selectedLabel: '+54'),
  AppDropdownItem(value: '+57', label: '🇨🇴 +57', selectedLabel: '+57'),
  AppDropdownItem(value: '+34', label: '🇪🇸 +34', selectedLabel: '+34'),
  AppDropdownItem(value: '+51', label: '🇵🇪 +51', selectedLabel: '+51'),
  AppDropdownItem(value: '+56', label: '🇨🇱 +56', selectedLabel: '+56'),
];

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    required this.dialCode,
    required this.onDialCodeChanged,
    this.label,
    this.errorText,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String dialCode;
  final ValueChanged<String?> onDialCodeChanged;
  final String? label;
  final String? errorText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFieldLabel(text: label ?? l10n.fieldPhoneNumber),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 116,
              child: AppDropdownField<String>(
                items: kDialCodes,
                value: dialCode,
                enabled: enabled,
                onChanged: onDialCodeChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppTextField(
                hintText: l10n.hintPhoneLocal,
                controller: controller,
                enabled: enabled,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                errorText: errorText,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: onChanged,
                onFieldSubmitted: onSubmitted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
