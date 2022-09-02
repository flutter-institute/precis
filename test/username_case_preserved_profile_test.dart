import 'package:precis/precis.dart';
import 'package:test/test.dart';

import 'idempotency_helper.dart';

void main() {
  group('Username Case Preserved Profile', () {
    test('Confusable characters', () {
      expect(usernameCasePreserved.enforce('ABC'), equals('ABC'));
    });

    test('Idempotency enforcement', () {
      testIdempotency(usernameCasePreserved.enforce);
    });
  });
}
