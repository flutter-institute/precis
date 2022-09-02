import 'package:precis/precis.dart';
import 'package:precis/src/character.dart';
import 'package:test/test.dart';

void testIdempotency(String Function(String) rules) {
  for (var cp = Character.MinCodePoint; cp < Character.MaxCodePoint; cp++) {
    final input = String.fromCharCode(cp);
    try {
      final first = rules(input);
      final second = rules(first);
      expect(first, equals(second));
    } on PrecisException {
      // Ignore
    }
  }
}
