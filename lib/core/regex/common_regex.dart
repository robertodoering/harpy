/// Matches any whitespace.
final RegExp whitespaceRegex = RegExp(r'\s');

/// Matches a ISO 8601 formatted date.
final RegExp dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');

/// Matches text inside of a html tag.
///
/// Example:
/// `<a href="url">Some text</a>` matches: `Some text`.
final RegExp htmlTagRegex = RegExp(r'(?<=>)([\w\s]+)(?=<\/)');
