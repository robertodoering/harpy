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

// `/harpy_app`
final userProfilePathRegex = RegExp(r'^\/(\w+)$');

// `/harpy_app/followers`
final userFollowersPathRegex = RegExp(r'^\/(\w+)\/followers$');

// `/harpy_app/following`
final userFollowingPathRegex = RegExp(r'^\/(\w+)\/following$');

// `/harpy_app/lists`
final userListsPathRegex = RegExp(r'^\/(\w+)\/lists$');

// `/harpy_app/status/1463545080837509120`
final statusPathRegex = RegExp(r'^\/(\w+)\/status\/(\d+)$');

// `/harpy_app/status/1463545080837509120/retweets`
final statusRetweetsPathRegex = RegExp(r'^\/(\w+)\/status\/(\d+)\/retweets$');
