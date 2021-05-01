import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/core/core.dart';

void main() {
  test('dateRegex matches dates', () {
    expect(dateRegex.hasMatch('2021-07-29'), isTrue);
    expect(dateRegex.hasMatch('1900-01-01'), isTrue);
    expect(dateRegex.hasMatch('no u'), isFalse);
    expect(dateRegex.hasMatch('abcd-ef-gh'), isFalse);
    expect(dateRegex.hasMatch('1-2-3'), isFalse);
  });
}
