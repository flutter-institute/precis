import 'package:flutter_test/flutter_test.dart';
import 'package:precis/precis.dart';

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
