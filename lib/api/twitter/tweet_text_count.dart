import 'package:flutter/widgets.dart';
import 'package:harpy/core/core.dart';

/// The count of weighted characters for a tweet.
///
/// - Each url counts as 23 characters
/// - Each emoji counts as 2 characters
/// - Glyphs defined in [_normalWeightedCharactersRegex] count as 1 character
///   (including Latin characters)
/// - Other glyphs including Chinese / Japanese / Korean glyphs count as 2
///   characters
int tweetTextCount(String text) {
  final urls = urlRegex.allMatches(text).length;
  text = text.replaceAll(urlRegex, '');

  final emojis = _uniqueEmojis(text);
  text = text.replaceAll(emojiRegex, '');

  final normalWeighted = _normalWeightedCharactersRegex.allMatches(text);
  text = text.replaceAll(_normalWeightedCharactersRegex, '');

  final urlsLength = urls * 23;
  final emojisLength = emojis * 2;
  final normalWeigthedCharacters = normalWeighted.length;
  final otherCharacters = text.codeUnits.length * 2;

  return urlsLength + emojisLength + normalWeigthedCharacters + otherCharacters;
}

/// Regex to match the code unit ranges for unicode glyphs that are weighted as
/// a single character.
///
/// The default weight for a character is 2 (e.g. Chinese / Japanese / Korean
/// characters).
///
/// From the twitter-text library config v3
/// https://github.com/twitter/twitter-text/blob/master/config/v3.json.
///
/// For information about unicode glyph ranges, see
/// https://www.unicodepedia.com/groups/.
final _normalWeightedCharactersRegex = RegExp(
  r'[\u0000-\u10FF]|[\u2000-\u200D]|[\u2010-\u201F]|[\u2032-\u2037]',
);

/// Returns the amount of unique emojis in the [text].
///
/// Emojis that consist of emoji sequences with combining glyphs count as a
/// single emoji.
///
/// For example:
///
/// Emoji with skin tone modifier:
/// 🙋🏽 = 1 // 🙋 (U+1F64B) + 🏽 (U+1F3FD)
///
/// Emoji sequence using combining glyph (zero-width joiner)
/// 👨‍🎤 = 1 // 👨 (U+1F468) + U+200D + 🎤 (U+1F3A4)
int _uniqueEmojis(String text) {
  var uniqueEmojis = 0;

  final emojiMatches = emojiRegex.allMatches(text);

  if (emojiMatches.isNotEmpty) {
    try {
      final emojiGroups = <String>[];

      var prevEnd = -1;
      var group = -1;

      for (final match in emojiMatches) {
        final start = match.start;
        final end = match.end;

        if (start == prevEnd) {
          emojiGroups[group] += text.substring(start, end);
        } else {
          emojiGroups.add(text.substring(start, end));
          group++;
        }

        prevEnd = end;
      }

      for (final emojiGroup in emojiGroups) {
        uniqueEmojis += Characters(emojiGroup).length;
      }
    } catch (e) {
      // ignore potential parsing errors
    }
  }

  return uniqueEmojis;
}
