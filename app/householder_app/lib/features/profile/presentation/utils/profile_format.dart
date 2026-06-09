const _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const profileEmptyValue = '—';

String formatBirthDate(String? raw) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return profileEmptyValue;
  final date = DateTime.tryParse(value);
  if (date == null) return value;
  return '${_months[date.month - 1]} ${date.day}, ${date.year}';
}

String profileValueOrDash(String? value) {
  final v = value?.trim() ?? '';
  return v.isEmpty ? profileEmptyValue : v;
}
