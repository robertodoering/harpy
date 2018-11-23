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
}
