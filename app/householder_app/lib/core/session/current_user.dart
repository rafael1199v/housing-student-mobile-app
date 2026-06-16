import 'dart:convert';

import '../storage/token_storage.dart';

class CurrentUserService {
  CurrentUserService(this._tokenStorage);

  final TokenStorage _tokenStorage;

  String? _cachedToken;
  String? _cachedUserId;

  Future<String?> currentUserId() async {
    final token = await _tokenStorage.readAccessToken();
    if (token == null || token.isEmpty) {
      _cachedToken = null;
      _cachedUserId = null;
      return null;
    }
    if (token == _cachedToken) return _cachedUserId;

    _cachedToken = token;
    _cachedUserId = _extractSub(token);
    return _cachedUserId;
  }

  static String? _extractSub(String jwt) {
    final parts = jwt.split('.');
    if (parts.length != 3) return null;
    try {
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final map = jsonDecode(payload);
      if (map is! Map<String, dynamic>) return null;
      final sub = map['sub'] ?? map['nameid'] ?? map['userId'];
      return sub?.toString();
    } catch (_) {
      return null;
    }
  }
}
