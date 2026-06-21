import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:housing_auth/src/data/services/rsa_password_cipher.dart';

void main() {
  const testPublicKeyPem = '''
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyCvAdTE5jQ6FeRUpjSe4
dGmYoy9y6p06F73UQRq0Xl7Fg0gdUje/GxXX3jBFP0IBQTYgWhcq75xolLdI0YNl
s756H2mNYgZD48KYahQTCpJRQvExV3c940+ssDswvs5Z7uPTh4yclrsq9m/xscUI
PAtGzeaPryanA8qgh0fBo039Ave7eE0GGSGji2CvHrvwXP+6XRJUM/rfT4OhMF0D
gUB0KlTCYBA9NiU+/JBqflmNOa3UTly/EdT0vH8j6H9uUE8mM4EEu6d1PCfFrv8O
Zc2uJImj99KNniwEf/gNEJhpIC+9O6DasuMtL2YTfRNPHPSWDEnD19n2Pa3pNmPu
9QIDAQAB
-----END PUBLIC KEY-----''';

  group('RsaPasswordCipher', () {
    test('encrypts to base64 of 256 bytes (RSA-2048 block size)', () {
      final cipher = RsaPasswordCipher(testPublicKeyPem);

      final encrypted = cipher.encrypt('SomePass123!');

      final bytes = base64Decode(encrypted);
      expect(bytes.length, 256);
    });

    test('is non-deterministic (OAEP randomization)', () {
      final cipher = RsaPasswordCipher(testPublicKeyPem);

      final first = cipher.encrypt('SomePass123!');
      final second = cipher.encrypt('SomePass123!');

      expect(first, isNot(equals(second)));
    });

    test('accepts a bare single-line SPKI body (no PEM header)', () {
      final bareBody = testPublicKeyPem
          .replaceAll('-----BEGIN PUBLIC KEY-----', '')
          .replaceAll('-----END PUBLIC KEY-----', '')
          .replaceAll('\n', '')
          .trim();
      final cipher = RsaPasswordCipher(bareBody);

      expect(base64Decode(cipher.encrypt('SomePass123!')).length, 256);
    });

    test('throws when the public key is null (fail fast, no plaintext)', () {
      final cipher = RsaPasswordCipher(null);

      expect(() => cipher.encrypt('SomePass123!'), throwsStateError);
    });

    test('throws when the public key is empty', () {
      final cipher = RsaPasswordCipher('   ');

      expect(() => cipher.encrypt('SomePass123!'), throwsStateError);
    });
  });
}
