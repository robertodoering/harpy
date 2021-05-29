/// Positive lookbehind group, matches:
/// * Any non-word characters (\W+)
/// * An underscore (_)
/// * The beginning of the string (^)
const String _tagBeginGroup = r'(?<=\W+|_|^)';

final RegExp hashtagRegex = RegExp(
  _tagBeginGroup + r'(?=.{2,140})(#|＃){1}([0-9_\p{L}]*[_\p{L}][0-9_\p{L}]*)',
  caseSensitive: false,
  unicode: true,
);

final RegExp hashtagStartRegex = RegExp(
  '$_tagBeginGroup(#|＃){1}',
  caseSensitive: false,
  unicode: true,
);

final RegExp mentionRegex = RegExp(
  _tagBeginGroup + r'(@{1}\w+)',
  caseSensitive: false,
);

final RegExp mentionStartRegex = RegExp(
  '$_tagBeginGroup(@{1})',
  caseSensitive: false,
);

/// Matches everything that is not a valid character in a hashtag (no
/// numbers, unicode letters, underscores.
final RegExp nonHashtagCharactersRegex = RegExp(r'[^0-9_\p{L}]', unicode: true);
