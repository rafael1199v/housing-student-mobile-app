import 'package:housing_design_system/housing_design_system.dart';

const List<AppDropdownItem<String>> kGenderOptions = [
  AppDropdownItem(value: 'Male', label: 'Male'),
  AppDropdownItem(value: 'Female', label: 'Female'),
  AppDropdownItem(value: 'Other', label: 'Other'),
];

const List<AppDropdownItem<String>> kNationalityOptions = [
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

String? matchDropdownValue(
  String? value,
  List<AppDropdownItem<String>> items,
) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  for (final item in items) {
    if (item.value == trimmed) return trimmed;
  }
  return null;
}
