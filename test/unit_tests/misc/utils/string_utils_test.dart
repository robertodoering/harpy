import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/misc/utils/string_utils.dart';

void main() {
  test('prettyPrintDurationDifference pretty prints a duration difference', () {
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

  test('prettyPrintDuration pretty prints a duration', () {
    const Duration duration1 = Duration(minutes: 1, seconds: 9);

    const Duration duration2 = Duration(minutes: 4, seconds: 20);

    const Duration duration3 = Duration(hours: 1, minutes: 6, seconds: 9);

    expect(prettyPrintDuration(duration1), '1:09');
    expect(prettyPrintDuration(duration2), '4:20');
    expect(prettyPrintDuration(duration3), '66:09');
  });

  group('parseHtmlEntities', () {
    test('parses entities as they appear in twitter text respones', () {
      const String source = '&lt;body&gt;Hello world &amp;&lt;/body&gt;';

      expect(parseHtmlEntities(source), '<body>Hello world &</body>');
    });

    test('does nothing when the source does not contain any entites', () {
      const String source = 'This is just a regular string';

      expect(parseHtmlEntities(source), 'This is just a regular string');
    });
  });

  group('trimOne', () {
    test('trims the first and last whitespace of a string', () {
      const String source = '  Hello World   \n';

      expect(trimOne(source), ' Hello World   ');
    });

    test('trims the first whitespace of a string', () {
      const String source = '  Hello World   \n';

      expect(trimOne(source, end: false), ' Hello World   \n');
    });

    test('trims the last whitespace of a string', () {
      const String source = '  Hello World   \n';

      expect(trimOne(source, start: false), '  Hello World   ');
    });

    test('returns the string if it has no starting or ending whitespace', () {
      const String source = 'Hello World';

      expect(trimOne(source), 'Hello World');
    });

    test('returns null if the source is null', () {
      String source;

      expect(trimOne(source), null);
    });
  });
}
