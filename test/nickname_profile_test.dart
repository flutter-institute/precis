import 'package:flutter_test/flutter_test.dart';
import 'package:precis/precis.dart';

import 'idempotency_helper.dart';

void main() {
  group('Nickname Profile', () {
    test('Should replace non ascii spaces', () {
      expect(
          nickname.enforce(
              'a\u00A0a\u1680a\u2000a\u2001a\u2002a\u2003a\u2004a\u2005a\u2006a\u2007a\u2008a\u2009a\u200Aa\u202Fa\u205Fa\u3000a'),
          equals('a a a a a a a a a a a a a a a a a'));
    });

    test('Should trim', () {
      expect(nickname.enforce('stpeter '), equals('stpeter'));
    });

    test('Should map to single space', () {
      expect(nickname.enforce('st    peter'), equals('st peter'));
    });

    test('Should normalize NFKC', () {
      expect(nickname.enforce('\u2163'), equals('IV'));
    });

    test('Should not be empty', () {
      expect(
          () => nickname.enforce(''),
          throwsA((e) =>
              e is EnforcementException &&
              e.message.contains('must not be empty')));
    });

    test('Comparisons', () {
      expect(nickname.compare('Foo', 'foo'), equals(0));
      expect(nickname.compare('foo', 'foo'), equals(0));
      expect(nickname.compare('Foo Bar', 'foo bar'), equals(0));
      expect(nickname.compare('foo bar', 'foo bar'), equals(0));
      expect(nickname.compare('\u03A3', '\u03C3'), equals(0));
      expect(nickname.compare('\u03C3', '\u03C3'), equals(0));
      expect(nickname.compare('\u03C2', '\u03C2'), equals(0));
      expect(nickname.compare('\u265A', '\u265A'), equals(0));
      expect(nickname.compare('\u03AB', '\u03CB'),
          equals(0)); // GREEK SMALL LETTER UPSILON WITH DIALYTIKA
      expect(nickname.compare('\u221E', '\u221E'), equals(0));
      expect(nickname.compare('Richard \u2163', 'richard iv'), equals(0));
    });

    test('To comparable string', () {
      expect(nickname.toComparableString('Foo Bar '),
          equals(nickname.toComparableString('foo bar')));
    });

    test('Idempotency enforcement', () {
      testIdempotency(nickname.enforce);
    });

    test('Idempotency comparison', () {
      testIdempotency(nickname.toComparableString);
    });
  });
}
