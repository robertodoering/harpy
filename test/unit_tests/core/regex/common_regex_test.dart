import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/core/core.dart';

void main() {
  test('dateRegex matches dates', () {
    expect(dateRegex.hasMatch('2021-07-29'), isTrue);
    expect(dateRegex.hasMatch('1900-01-01'), isTrue);
    expect(dateRegex.hasMatch('no u'), isFalse);
    expect(dateRegex.hasMatch('abcd-ef-gh'), isFalse);
    expect(dateRegex.hasMatch('1-2-3'), isFalse);
  });

  test('htmlTagRegex matches html tag value', () {
    final match = htmlTagRegex.firstMatch('<html>value</html>');

    expect(match?.group(0), equals('value'));
    expect(htmlTagRegex.hasMatch('<html>value<a>><>'), isFalse);
  });

  test('urlRegex matches urls', () {
    final match1 = urlRegex.firstMatch(
      'text https://robertodoering.com more text',
    );

    final match2 = urlRegex.firstMatch(
      'text https://robertodoering.com.',
    );

    final match3 = urlRegex.firstMatch(
      'text https://robertodoering.com/this/path/doesnt/exist.html!',
    );

    expect(match1?.group(0), equals('https://robertodoering.com'));
    expect(match2?.group(0), equals('https://robertodoering.com'));
    expect(
      match3?.group(0),
      equals('https://robertodoering.com/this/path/doesnt/exist.html'),
    );
    expect(urlRegex.hasMatch('http://robertodoering.com'), isTrue);
    expect(urlRegex.hasMatch('www.robertodoering.com'), isTrue);
    expect(urlRegex.hasMatch('https://robertodoering'), isFalse);
    expect(urlRegex.hasMatch('www.robertodoering'), isFalse);
    expect(urlRegex.hasMatch('robertodoering.com'), isFalse);
  });

  test('emojiRegex matches emojis', () {
    expect(emojiRegex.hasMatch('👾'), isTrue);
    expect(emojiRegex.hasMatch('🙋🏽'), isTrue);
    expect(emojiRegex.hasMatch('👨‍🎤'), isTrue);
    expect(emojiRegex.hasMatch('👨‍👩‍👧‍👦'), isTrue);
    expect(emojiRegex.hasMatch(':)'), isFalse);
    expect(emojiRegex.hasMatch('a b c d e f g 1 2 3'), isFalse);
  });
}
