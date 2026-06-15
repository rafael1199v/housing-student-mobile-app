import 'package:intl/intl.dart';

const profileEmptyValue = '—';

/// Formats an ISO date string (e.g. `1998-04-23`) using localized month names.
/// [localeName] is the active locale tag, e.g. `en`, `es`, `pt`.
String formatBirthDate(String? raw, String localeName) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return profileEmptyValue;
  final date = DateTime.tryParse(value);
  if (date == null) return value;
  return DateFormat.yMMMMd(localeName).format(date);
}

String profileValueOrDash(String? value) {
  final v = value?.trim() ?? '';
  return v.isEmpty ? profileEmptyValue : v;
}
