import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/core/utils/string_utils.dart';

void main() {
  test("Format twitter date string removes the timezone", () {
    const testData = "Thu Apr 06 15:24:15 +0000 2017";

    const expectedResult = "Apr 06 15:24:15 2017";
    final String actualResult = formatTwitterDateString(testData);
    expect(actualResult, expectedResult);
  });

  test("Append query params to url", () {
    const url = "https://google.com";
    final params = <String, String>{
      "count": "69",
      "max_id": "1337",
    };

    final String actual = appendParamsToUrl(url, params);
    const expected = "https://google.com?count=69&max_id=1337";

    expect(actual, expected);
  });

  test("Pretty print a duration difference", () {
    const timestamp = 1557836948;

    final DateTime now = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
    );

    final DateTime rateLimitReset1 = DateTime.fromMillisecondsSinceEpoch(
      (timestamp + 330) * 1000,
    );

    final DateTime rateLimitReset2 = DateTime.fromMillisecondsSinceEpoch(
      (timestamp + 25) * 1000,
    );

    final DateTime rateLimitReset3 = DateTime.fromMillisecondsSinceEpoch(
      (timestamp + 304) * 1000,
    );

    final Duration difference1 = rateLimitReset1.difference(now);
    final Duration difference2 = rateLimitReset2.difference(now);
    final Duration difference3 = rateLimitReset3.difference(now);

    expect(prettyPrintDurationDifference(difference1), "5:30 minutes");

    expect(prettyPrintDurationDifference(difference2), "25 seconds");

    expect(prettyPrintDurationDifference(difference3), "5:04 minutes");
  });
}
