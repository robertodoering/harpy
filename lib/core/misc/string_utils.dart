import 'package:collection/collection.dart';

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
