import 'package:harpy/core/utils/date_utils.dart';
import 'package:test_api/test_api.dart';

void main() {
  test("convert twitter date string to date time", () {
    const testDate = "Thu Apr 06 15:24:15 +0000 2017";
    final DateTime result = convertFromTwitterDateString(testDate);
    final DateTime expected = DateTime(2017, 4, 6, 15, 24, 15);

    expect(result.difference(expected), Duration());
  });
}
