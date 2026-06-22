import 'package:flutter/widgets.dart';

ImageProvider? avatarImageFromUrl(String? url) {
  final trimmed = url?.trim() ?? '';
  return trimmed.isEmpty ? null : NetworkImage(trimmed);
}
