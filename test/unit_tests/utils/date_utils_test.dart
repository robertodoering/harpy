import 'package:harpy/core/utils/date_utils.dart';
import 'package:test/test.dart';

void main() {
  test("convert twitter date string to date time", () {
    String testDate = "Thu Apr 06 15:24:15 +0000 2017";
    DateTime result = convertFromTwitterDateString(testDate);
    DateTime expected = DateTime(2017, 4, 6, 15, 24, 15);
    expect(result.difference(expected), Duration());
  });
}
