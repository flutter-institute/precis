import 'package:flutter_test/flutter_test.dart';
import 'package:precis/precis.dart';

import 'idempotency_helper.dart';

void main() {
  group('Opaque String Profile', () {
    test('Allowed strings', () {
      // ASCII space is allowed
      expect(opaqueString.enforce('correct horse battery staple'),
          equals('correct horse battery staple'));
      expect(opaqueString.enforce('Correct Horse Battery Staple'),
          equals('Correct Horse Battery Staple'));
      expect(opaqueString.enforce('πßå'), equals('πßå'));
      expect(
          opaqueString.enforce('Jack of \u2666s'), equals('Jack of \u2666s'));
      expect(opaqueString.enforce('foo\u1680bar'), equals('foo bar'));
    });

    test('Zero length', () {
      expect(
          () => opaqueString.enforce(''),
          throwsA((e) =>
              e is EnforcementException &&
              e.message.contains('must not be empty')));
    });

    test('Control characters', () {
      expect(
          () => opaqueString.enforce('my cat is a \u0009by'),
          throwsA((e) =>
              e is InvalidCodePointException &&
              e.message.contains('Invalid code point')));
    });

    test('Idempotency enforcement', () {
      testIdempotency(opaqueString.enforce);
    });
  });
}
