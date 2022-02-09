/// Matches any whitespace.
final whitespaceRegex = RegExp(r'\s');

/// Matches a ISO 8601 formatted date.
final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');

/// Matches text inside of a html tag.
///
/// Example:
/// `<a href='url'>Some text</a>` matches: `Some text`.
final htmlTagRegex = RegExp(r'(?<=>)([\w\s]+)(?=<\/)');

final urlRegex = RegExp(
  r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?',
);

/// Matches all known Unicode Emoji sequences as specified by
/// http://www.unicode.org/reports/tr51/.
final emojiRegex = RegExp(
  r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
);
