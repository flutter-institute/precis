import 'package:flutter_test/flutter_test.dart';
import 'package:precis/precis.dart';

import 'idempotency_helper.dart';

void testEnforceException(String test, String expectedException) {
  expect(
      () => usernameCaseMapped.enforce(test),
      throwsA((e) =>
          e is PrecisException && e.message.contains(expectedException)));
}

void testPrepareException(String test, String expectedException) {
  expect(
      () => usernameCaseMapped.prepare(test),
      throwsA((e) =>
          e is PrecisException && e.message.contains(expectedException)));
}

void main() {
  group('Username Case Mapped Profile', () {
    test('Allowed strings', () {
      expect(usernameCaseMapped.enforce('juliet@example.com'),
          equals('juliet@example.com'));
      expect(usernameCaseMapped.enforce('fussball'), equals('fussball'));

      expect(
          usernameCaseMapped.enforce('fu\u00DFball'), equals('fu\u00DFball'));
      expect(usernameCaseMapped.enforce('\u03C0'), equals('\u03C0'));
      expect(usernameCaseMapped.enforce('\u03A3'), equals('\u03C3'));
      expect(usernameCaseMapped.enforce('\u03C3'), equals('\u03C3'));
      expect(usernameCaseMapped.enforce('\u03C2'), equals('\u03C2'));
      expect(usernameCaseMapped.enforce('\u0049'), equals('\u0069'));

      expect(usernameCaseMapped.enforce('\u03B0'), equals('\u03B0'));
    });

    test('Error strings', () {
      testEnforceException('', 'must not be empty');
      testEnforceException('foo bar', 'Invalid code point'); // space character
      testEnforceException('henry\u2163', 'Invalid code point'); // Roman Four
      testEnforceException('\u221E', 'Invalid code point'); // Infinity
      testEnforceException('\u265A', 'Invalid code point'); // Black Chess King

      // Spaces
      testPrepareException(' ', 'Invalid code point');
      testPrepareException('\t', 'Invalid code point');
      testPrepareException('\n', 'Invalid code point');
      // Symbols
      testPrepareException('\u2600', 'Invalid code point');
      testPrepareException('\u26D6', 'Invalid code point');
      testPrepareException('\u26FF', 'Invalid code point');
      // Compat
      testPrepareException('\uFB00', 'Invalid code point');
      // Other Letter Digits
      testPrepareException('\u01C5', 'Invalid code point');
      testPrepareException('\u16EE', 'Invalid code point');
      testPrepareException('\u00B2', 'Invalid code point');
      testPrepareException('\u0488', 'Invalid code point');
    });

    test('Letter digits', () {
      expect(usernameCaseMapped.enforce('\u007E'), equals('\u007E'));
      expect(usernameCaseMapped.enforce('a'), equals('a'));
    });

    test('Printable characters', () {
      expect(usernameCaseMapped.enforce('\u0021'), equals('\u0021'));
    });

    test('Composite characters and combining sequence', () {
      final ang = usernameCaseMapped.enforce('\u212B'); // angstrom sign
      final a = usernameCaseMapped.enforce('\u0041\u030A'); // A + ring
      final b = usernameCaseMapped.enforce('\u00C5'); // A with ring
      expect(a, equals(b));
      expect(a, equals(ang));

      final c = usernameCaseMapped.enforce('\u0063\u0327'); // c + cedille
      final d = usernameCaseMapped.enforce('\u00E7'); // c cedille
      expect(c, equals(d));

      final e = usernameCaseMapped.enforce('\u0052\u030C');
      final f = usernameCaseMapped.enforce('\u0158');
      expect(e, equals(f));
    });

    test('Confusable characters', () {
      final a = usernameCaseMapped.enforce('\u0041'); // LATIN CAPITAL LETTER A
      final b =
          usernameCaseMapped.enforce('\u0410'); // CYRILLIC CAPITAL LETTER A
      expect(a, isNot(equals(b)));
    });

    test('Width mapping', () {
      final a = usernameCaseMapped.enforce('\uFF21\uFF22');
      final b = usernameCaseMapped.enforce('ab');
      expect(a, equals(b));
    });

    test('Idempotency enforcement', () {
      testIdempotency(usernameCaseMapped.enforce);
    });
  });
}
