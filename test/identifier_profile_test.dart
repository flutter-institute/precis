import 'package:precis/precis.dart';
import 'package:precis/src/profile.dart';
import 'package:test/test.dart';

void testException(String test, String expectedException) {
  expect(
      () => usernameCaseMapped.prepare(test),
      throwsA((e) =>
          e is PrecisException && e.message.contains(expectedException)));
}

void main() {
  group('Identifier Test', () {
    test('Should not allow non-character', () {
      testException('\uFDD0', 'Invalid code point');
    });

    test('Should not allow old hangul jamo characters', () {
      testException('\uA960', 'Invalid code point');
    });

    test('Should not allow ignorable characters', () {
      testException('\u034F', 'Invalid code point');
    });

    test('Should not allow control characters', () {
      testException('\u061C', 'Invalid code point');
    });

    test('Should not allow symbols', () {
      // Black chess king
      testException('\u265A', 'Invalid code point');
    });

    test('Has compat', () {
      // Roman numeral 4
      expect(PrecisProfile.hasCompatibilityEquivalent(0x2163), isTrue);
    });

    test('Should be exceptionally valid', () {
      const s = '\u03C2\u00DF';
      expect(usernameCaseMapped.prepare(s), equals(s));
    });

    test('Should be exceptionally disallowed', () {
      testException('\u3032', 'Invalid code point');
    });

    test('Unassigned', () {
      // Unassigned code points
      expect(PrecisProfile.isUnassigned(0x2065), isTrue);
      expect(PrecisProfile.isUnassigned(0x05FF), isTrue);

      // Non-characters
      expect(PrecisProfile.isUnassigned(0xFFFF), isFalse);
      expect(PrecisProfile.isUnassigned(0xFDD0), isFalse);
    });
  });
}
