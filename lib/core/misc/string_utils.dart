import 'package:collection/collection.dart';

/// Unicode code units of whitespaces defined by the Unicode White_Space
/// property (as defined in version 6.2 or later) and the BOM character, 0xFEFF.
const _unicodeWhitespaces = [
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

/// Returns the [value] without the first leading or trailing whitespace.
///
/// Similar to [String.trim()] except it only removes one of the starting and
/// one of the trailing whitespace if any are present.
///
/// Whitespace is defined by the Unicode White_Space property (as defined in
/// version 6.2 or later) and the BOM character, 0xFEFF.
///
/// [_unicodeWhitespaces] includes a list of trimmed characters.
String trimOne(
  String value, {
  bool begin = true,
  bool end = true,
}) {
  if (value.isNotEmpty) {
    if (begin && _unicodeWhitespaces.contains(value.codeUnitAt(0)))
      value = value.substring(1, value.length);

    if (end && _unicodeWhitespaces.contains(value.codeUnitAt(value.length - 1)))
      value = value.substring(0, value.length - 1);
  }

  return value;
}

/// Parses `<`, `>` and `&` when they appear as html entities in the [source].
String parseHtmlEntities(String source) {
  return source
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>');
}

/// Returns a display string for a 32 bit [color] value in ARGB format.
///
/// When [displayOpacity] is `true`, the returned string will include the
/// opacity as a percentage.
///
/// If [displayOpacity] is `true` and the opacity is 0%, the text 'transparent'
/// is returned instead.
String colorValueToDisplayHex(int color, {bool displayOpacity = true}) {
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

/// Returns the [value] without its prepended symbol if it starts with any
/// symbol in [symbols].
String? removePrependedSymbol(String? value, Iterable<String> symbols) {
  if (value == null) {
    return null;
  }

  final symbol = symbols.firstWhereOrNull(value.startsWith);

  return symbol != null ? value.substring(symbol.length) : null;
}
