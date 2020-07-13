import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/misc/utils/string_utils.dart';

void main() {
  test('Pretty print a duration difference', () {
    const int timestamp = 1557836948;

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

    expect(prettyPrintDurationDifference(difference1), '5:30 minutes');

    expect(prettyPrintDurationDifference(difference2), '25 seconds');

    expect(prettyPrintDurationDifference(difference3), '5:04 minutes');
  });

  test('Parses html entities as they appear in twitter text respones', () {
    const String source = '&lt;body&gt;Hello world &amp;&lt;/body&gt;';

    expect(parseHtmlEntities(source), '<body>Hello world &</body>');
  });
}
