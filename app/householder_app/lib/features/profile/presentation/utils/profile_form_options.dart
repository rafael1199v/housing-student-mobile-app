import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';

const List<String> kGenderValues = ['Male', 'Female', 'Other'];

const List<String> kNationalityValues = [
  'Bolivian',
  'Argentinian',
  'Chilean',
  'Colombian',
  'Mexican',
  'Peruvian',
  'Spanish',
  'American',
  'Other',
];

String genderLabel(AppLocalizations l10n, String value) => switch (value) {
      'Male' => l10n.genderMale,
      'Female' => l10n.genderFemale,
      _ => l10n.genderOther,
    };

String nationalityLabel(AppLocalizations l10n, String value) => switch (value) {
      'Bolivian' => l10n.nationalityBolivian,
      'Argentinian' => l10n.nationalityArgentinian,
      'Chilean' => l10n.nationalityChilean,
      'Colombian' => l10n.nationalityColombian,
      'Mexican' => l10n.nationalityMexican,
      'Peruvian' => l10n.nationalityPeruvian,
      'Spanish' => l10n.nationalitySpanish,
      'American' => l10n.nationalityAmerican,
      _ => l10n.nationalityOther,
    };

List<AppDropdownItem<String>> genderOptions(AppLocalizations l10n) => [
      for (final value in kGenderValues)
        AppDropdownItem(value: value, label: genderLabel(l10n, value)),
    ];

List<AppDropdownItem<String>> nationalityOptions(AppLocalizations l10n) => [
      for (final value in kNationalityValues)
        AppDropdownItem(value: value, label: nationalityLabel(l10n, value)),
    ];

String? matchDropdownValue(String? value, List<String> allowed) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return allowed.contains(trimmed) ? trimmed : null;
}
