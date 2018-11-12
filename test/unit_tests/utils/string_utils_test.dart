import 'package:test/test.dart';
import 'package:harpy/core/utils/string_utils.dart';

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
    expect(actualResult, matches(expectedResult));
  });
}
