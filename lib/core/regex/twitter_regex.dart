/// Positive lookbehind group, matches:
/// * Any non-unicode letters ([^\p{L}])
/// * An underscore (_)
/// * The beginning of the string (^)
const _tagBeginGroup = r'(?<=[^\p{L}]+|_|^)';

final hashtagRegex = RegExp(
  _tagBeginGroup + r'(?=.{2,140})(#|＃){1}([0-9_\p{L}]*[_\p{L}][0-9_\p{L}]*)',
  caseSensitive: false,
  unicode: true,
);

final hashtagStartRegex = RegExp(
  '$_tagBeginGroup(#|＃){1}',
  caseSensitive: false,
  unicode: true,
);

final mentionRegex = RegExp(
  _tagBeginGroup + r'(@{1}\w+)',
  caseSensitive: false,
  unicode: true,
);

final mentionStartRegex = RegExp(
  '$_tagBeginGroup(@{1})',
  caseSensitive: false,
  unicode: true,
);

/// Matches everything that is not a valid character in a hashtag (no
/// numbers, unicode letters, underscores.
final nonHashtagCharactersRegex = RegExp(
  r'[^0-9_\p{L}]',
  unicode: true,
);
