import 'package:harpy/core/utils/string_utils.dart';
import 'package:test_api/test_api.dart';

void main() {
  test("fillStringToLength with default filler", () {
    String result = fillStringToLength("123", 5);
    expect(result, matches("123  "));
  });

  test("fillStringToLength with custom filler", () {
    String result = fillStringToLength("123", 5, filler: "-");
    expect(result, matches("123--"));
  });

  test("fillStringToLength with invalid custom filler", () {
    expect(() => fillStringToLength("123", 5, filler: "--"), throwsException);
  });

  test("formatTwitterDateString", () {
    String testData = "Thu Apr 06 15:24:15 +0000 2017";

    String expectedResult = "Apr 06 15:24:15 2017";
    String actualResult = formatTwitterDateString(testData);
    expect(actualResult, expectedResult);
  });

  test("explodeListToSeparatedString multiple strings", () {
    List<String> testData = ["1", "3", "5"];

    String expectedResult = "1,3,5";
    String actualResult = explodeListToSeparatedString(testData);
    expect(actualResult, expectedResult);
  });

  test("explodeListToSeparatedString single strings", () {
    List<String> testData = ["1"];

    String expectedResult = "1";
    String actualResult = explodeListToSeparatedString(testData);
    expect(actualResult, expectedResult);
  });

  test("appendParamsToUrl", () {
    String url = "https://google.com";
    var params = <String, String>{
      "count": "69",
      "max_id": "1337",
    };

    String actual = appendParamsToUrl(url, params);
    String expected = "https://google.com?count=69&max_id=1337";

    expect(actual, expected);
  });

  test("formatNumber", () {
    expect(formatNumber(431), "431");

    expect(formatNumber(1234), "1.2K");

    expect(formatNumber(43219), "43.2K");

    expect(formatNumber(999999), "999.9K");

    expect(formatNumber(5500000), "5.5M");

    expect(formatNumber(77000001), "77.0M");
  });

  test("prettyPrintDurationDifference", () {
    int timestamp = 1557836948;

    DateTime now = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
    );

    DateTime rateLimitReset1 = DateTime.fromMillisecondsSinceEpoch(
      (timestamp + 330) * 1000,
    );

    DateTime rateLimitReset2 = DateTime.fromMillisecondsSinceEpoch(
      (timestamp + 25) * 1000,
    );

    DateTime rateLimitReset3 = DateTime.fromMillisecondsSinceEpoch(
      (timestamp + 304) * 1000,
    );

    Duration difference1 = rateLimitReset1.difference(now);
    Duration difference2 = rateLimitReset2.difference(now);
    Duration difference3 = rateLimitReset3.difference(now);

    expect(prettyPrintDurationDifference(difference1), "5:30 minutes");

    expect(prettyPrintDurationDifference(difference2), "25 seconds");

    expect(prettyPrintDurationDifference(difference3), "5:04 minutes");
  });
}
