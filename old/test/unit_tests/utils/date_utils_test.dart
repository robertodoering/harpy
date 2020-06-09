import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/core/utils/date_utils.dart';

void main() {
  test("Convert twitter date string to date time", () {
    const testDate = "Thu Apr 06 15:24:15 +0000 2017";
    final DateTime result = convertFromTwitterDateString(testDate);
    final DateTime expected = DateTime(2017, 4, 6, 15, 24, 15);

    expect(result.difference(expected), const Duration());
  });
}
