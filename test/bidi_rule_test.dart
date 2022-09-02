import 'package:precis/precis.dart';
import 'package:precis/src/profile.dart';
import 'package:test/test.dart';

void main() {
  void testException(String test, String expectedException) {
    expect(
        () => PrecisProfile.checkBidiRule(test),
        throwsA((e) =>
            e is PrecisException && e.message.contains(expectedException)));
  }

  group('Bidi Test', () {
    test('Rule 1: invalid first character', () {
      testException('\u07AA', 'Bidi Rule 1');
    });

    test('Rule 2: RTL label should not contain L characters', () {
      testException('\u0786test', 'Bidi Rule 2');
    });

    test('Rule 3: RTL label should not end with L character', () {
      testException('\u0786\u0793a\u07A6', 'Bidi Rule 3');
    });

    test('Rule 4: RTL label should not contain both EN and AN characters', () {
      testException('\u0786123\u0660', 'Bidi Rule 4'); // 0660 = Arabic Zero
    });

    test('Rule 5: LTR label should not contain R characters', () {
      testException('abc\u0786a', 'Bidi Rule 5');
    });

    test('Rule 6: LTR label should end with L or EN', () {
      testException('a\u0793', 'Bidi Rule 6');
    });
  });
}
