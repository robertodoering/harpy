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
}
