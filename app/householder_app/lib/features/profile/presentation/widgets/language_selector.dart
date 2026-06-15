import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Locale value;
  final ValueChanged<Locale> onChanged;

  static const _options = <AppDropdownItem<String>>[
    AppDropdownItem(value: 'en', label: 'English'),
    AppDropdownItem(value: 'es', label: 'Español'),
    AppDropdownItem(value: 'pt', label: 'Português'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppDropdownField<String>(
      items: _options,
      value: value.languageCode,
      prefixIcon: Icons.translate,
      onChanged: (code) {
        if (code != null) onChanged(Locale(code));
      },
    );
  }
}
