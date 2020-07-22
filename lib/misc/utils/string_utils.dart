/// Pretty prints a duration difference as long as the difference is smaller
/// than an hour.
String prettyPrintDurationDifference(Duration difference) {
  final int minutes = difference.inMinutes;
  final int seconds = difference.inSeconds;

  if (minutes > 0) {
    final int remainingSeconds = seconds - minutes * 60;
    final String secondsString =
        remainingSeconds > 9 ? '$remainingSeconds' : '0$remainingSeconds';

    return '$minutes:$secondsString minutes';
  } else {
    return '$seconds seconds';
  }
}

/// Pretty prints the [duration].
///
/// Returns an empty string if duration is `null`.
///
/// Example:
/// ```dart
/// prettyPrintDuration(Duration(minutes: 13, seconds: 37)) == '13:37';
///
/// prettyPrintDuration(Duration(minutes: 72, seconds: 7)) == '72:07';
/// ```
String prettyPrintDuration(Duration duration) {
  if (duration == null) {
    return '';
  }

  final String seconds = (duration.inSeconds % 60).toString();

  return '${duration.inMinutes}:${seconds.length < 2 ? "0$seconds" : seconds}';
}

/// Contains html entities that are returned in twitter text responses with
/// their corresponding character.
const Map<String, String> _twitterHtmlEntities = <String, String>{
  '&amp;': '&',
  '&lt;': '<',
  '&gt;': '>',
};

/// Parses `<`, `>` and `&` when they appear as html entities in the [source].
String parseHtmlEntities(String source) {
  _twitterHtmlEntities.forEach((String entity, String value) {
    source = source.replaceAll(entity, value);
  });

  return source;
}

/// Unicode code units of whitespaces defined by the Unicode White_Space
/// property (as defined in version 6.2 or later) and the BOM character, 0xFEFF.
const List<int> _unicodeWhitespaces = <int>[
  // <control-0009>..<control-000D>
  0x0009, 0x000A, 0x000B, 0x000B, 0x000C, 0x000D,
  0x0020, // SPACE
  0x0085, // <control-0085>
  0x00A0, // NO-BREAK SPACE
  0x1680, // OGHAM SPACE MARK
  // EN QUAD..HAIR SPACE
  0x2000, 0x2001, 0x2002, 0x2003, 0x2004, 0x2005, 0x2006, 0x2007, 0x2008,
  0x2009, 0x200A,
  0x2028, // LINE SEPARATOR
  0x2029, // PARAGRAPH SEPARATOR
  0x202F, // NARROW NO-BREAK SPACE
  0x205F, // MEDIUM MATHEMATICAL SPACE
  0x3000, // IDEOGRAPHIC SPACE
  0xFEFF, // ZERO WIDTH NO_BREAK SPACE
];

/// Returns the [source] without the first leading or trailing whitespace.
///
/// Similar to [String.trim()] except it only removes one of the starting and
/// one of the trailing whitespace if any are present.
///
/// Whitespace is defined by the Unicode White_Space property (as defined in
/// version 6.2 or later) and the BOM character, 0xFEFF.
///
/// [_unicodeWhitespaces] includes a list of trimmed characters.
String trimOne(
  String source, {
  bool start = true,
  bool end = true,
}) {
  if (source?.isNotEmpty == true) {
    if (start && _unicodeWhitespaces.contains(source.codeUnitAt(0))) {
      source = source.substring(1, source.length);
    }

    if (end &&
        source.isNotEmpty &&
        _unicodeWhitespaces.contains(source.codeUnitAt(source.length - 1))) {
      source = source.substring(0, source.length - 1);
    }
  }

  return source;
}
