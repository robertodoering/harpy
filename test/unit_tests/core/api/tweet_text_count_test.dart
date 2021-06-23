import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/api/api.dart';

void main() {
  group('tweet text count', () {
    test('counts each url as 23 characters', () {
      final count = tweetTextCount(
        'this tweet is rad! check out https://www.robertodoering.com and '
        'www.flutter.dev!',
      );

      const part1 = 'this tweet is rad! check out ';
      const part2 = ' and ';
      const part3 = '!';

      expect(
        count,
        equals(part1.length + part2.length + part3.length + 23 * 2),
      );
    });

    test(
        'counts emojis with and without combining modifiers as '
        '2 characters each', () {
      final count = tweetTextCount(
        // 👾 (U+1F47E)
        '👾'
        // Emoji with skin tone modifier
        // 🙋 (U+1F64B) + 🏽 (U+1F3FD)
        '🙋🏽'
        // Emoji sequence using combining glyph (zero-width joiner)
        // 👨 (U+1F468) + U+200D + 🎤 (U+1F3A4)
        '👨‍🎤'
        // Emoji sequence using multiple combining glyphs (zero-width joiners)
        // 👨 (U+1F468) + U+200D + 👩 (U+1F469) + U+200D + 👧 (U+1F467) +
        // U+200D + 👦 (U+1F466)
        '👨‍👩‍👧‍👦',
      );

      expect(count, equals(8));
    });

    test('counts special characters as 2', () {
      final count = tweetTextCount('幽閉　利口　逝く前に');

      expect(count, equals(20));
    });

    test('counts normal-weighted characters as 1', () {
      final count = tweetTextCount('never gonna give you up');

      expect(count, equals(23));
    });
  });
}
