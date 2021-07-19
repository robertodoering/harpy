import 'package:flutter/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Pretty prints a duration difference as long as the difference is smaller
/// than an hour.
String prettyPrintDurationDifference(Duration difference) {
  final minutes = difference.inMinutes;
  final seconds = difference.inSeconds;

  if (minutes > 0) {
    final remainingSeconds = seconds - minutes * 60;
    final secondsString =
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
String prettyPrintDuration(Duration? duration) {
  if (duration == null) {
    return '';
  }

  final seconds = (duration.inSeconds % 60).toString();

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
String? parseHtmlEntities(String? source) {
  _twitterHtmlEntities.forEach((entity, value) {
    source = source!.replaceAll(entity, value);
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
String? trimOne(
  String? source, {
  bool start = true,
  bool end = true,
}) {
  if (source != null && source.isNotEmpty == true) {
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

/// Returns a formatted String displaying the difference of the tweet creation
/// time.
String tweetTimeDifference(BuildContext context, DateTime createdAt) {
  return timeago.format(
    createdAt.toLocal(),
    locale: Localizations.localeOf(context).toString(),
  );
}

/// Returns the file name from a string url.
///
/// Example:
/// Url: https://video.twimg.com/ext_tw_video/1322182514157346818/pu/vid/1280x720/VoCc7t0UyB_R-KvW.mp4?tag=10
/// returns 'VoCc7t0UyB_R-KvW.mp4'.
String? fileNameFromUrl(String? url) {
  if (url != null) {
    try {
      final startIndex = url.lastIndexOf('/') + 1;

      var endIndex = url.lastIndexOf('?');
      if (endIndex == -1) {
        endIndex = url.length;
      }

      return url.substring(startIndex, endIndex);
    } catch (e) {
      // unexpected url string
      return null;
    }
  } else {
    return null;
  }
}

/// Prepends the [prependSymbol] to the [value] if the value does not start
/// with any of the [symbols].
///
/// If the value only consists of one of the symbols, `null` is returned
/// instead.
String? prependIfMissing(
  String? value,
  String prependSymbol,
  List<String> symbols,
) {
  if (value == null || value.isEmpty) {
    return value;
  } else {
    for (final symbol in symbols) {
      if (value.startsWith(symbol)) {
        if (value.length == symbol.length) {
          return null;
        } else {
          return value;
        }
      }
    }

    return '$prependSymbol$value';
  }
}

/// Returns the [value] without its prepended symbol if it starts with any
/// symbol in [symbols].
String? removePrependedSymbol(String? value, List<String> symbols) {
  if (value == null) {
    return null;
  }

  for (final symbol in symbols) {
    if (value.startsWith(symbol)) {
      return value.substring(symbol.length);
    }
  }

  return value;
}

/// Returns a display string for the color value.
///
/// When [displayOpacity] is `true`, the returned string will include the
/// opacity as a percentage.
///
/// If [displayOpacity] is `true` and the opacity is 0%, the text 'trasparent'
/// is returned instead.
String colorValueToHex(int color, {bool displayOpacity = true}) {
  final a = (color >> 24) & 0xff;

  final rgb = [
    (color >> 16) & 0xff,
    (color >> 8) & 0xff,
    color & 0xff,
  ];

  final rgbString = rgb
      .map((value) => value.toRadixString(16))
      .map((value) => value.length == 1 ? '0$value' : value)
      .join();

  if (displayOpacity) {
    if (a == 0) {
      return 'transparent';
    }

    final opacity = ((a / 255) * 100).toInt();

    return '#$rgbString \u00b7 $opacity%';
  } else {
    return '#$rgbString';
  }
}
