import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart' show CryptoUtils;
import 'package:pointycastle/export.dart';

import '../../domain/services/password_cipher.dart';

class RsaPasswordCipher implements PasswordCipher {
  RsaPasswordCipher(this._publicKeyRaw);

  final String? _publicKeyRaw;

  RSAPublicKey? _cachedKey;

  @override
  String encrypt(String plain) {
    final encryptor = OAEPEncoding.withSHA256(RSAEngine())
      ..init(
        true, // true = encrypt
        ParametersWithRandom(
          PublicKeyParameter<RSAPublicKey>(_publicKey()),
          _secureRandom(),
        ),
      );

    final cipher = encryptor.process(Uint8List.fromList(utf8.encode(plain)));
    return base64Encode(cipher);
  }

  RSAPublicKey _publicKey() {
    final cached = _cachedKey;
    if (cached != null) return cached;

    final raw = _publicKeyRaw;
    if (raw == null || raw.trim().isEmpty) {
      throw StateError(
        'PASSWORD_PUBLIC_KEY is not configured. Provide it via '
        '--dart-define=PASSWORD_PUBLIC_KEY=<spki-base64> so the password can be '
        'encrypted before login/register.',
      );
    }

    final key = CryptoUtils.rsaPublicKeyFromPem(_toPem(raw));
    return _cachedKey = key;
  }

  String _toPem(String raw) {
    final trimmed = raw.trim();
    if (trimmed.contains('BEGIN')) return trimmed;
    return '-----BEGIN PUBLIC KEY-----\n$trimmed\n-----END PUBLIC KEY-----';
  }

  SecureRandom _secureRandom() {
    final seedSource = Random.secure();
    final seed = Uint8List.fromList(
      List<int>.generate(32, (_) => seedSource.nextInt(256)),
    );
    return FortunaRandom()..seed(KeyParameter(seed));
  }
}
