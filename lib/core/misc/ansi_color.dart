import 'package:harpy/core/misc/logger.dart';
import 'package:logging/logging.dart';

/// [AnsiColor] codes are used to color text in the terminal and is used to
/// create colorful logs.
///
/// See [initLogger].
class AnsiColor {
  const AnsiColor._(this.value);

  const AnsiColor.foreground(int colorCode) : value = "38;5;${colorCode}m";

  const AnsiColor.background(int colorCode) : value = "48;5;${colorCode}m";

  factory AnsiColor.fromLogLevel(Level level) {
    if (level <= Level.FINE) {
      return green;
    } else if (level <= Level.INFO) {
      return blue;
    } else if (level <= Level.WARNING) {
      return yellow;
    } else if (level <= Level.SHOUT) {
      return red;
    } else {
      return reset;
    }
  }

  static const ansiEsc = '\x1B[';

  static const AnsiColor reset = AnsiColor._("0m");

  static const AnsiColor red = AnsiColor.foreground(31);
  static const AnsiColor green = AnsiColor.foreground(32);
  static const AnsiColor yellow = AnsiColor.foreground(33);
  static const AnsiColor blue = AnsiColor.foreground(34);
  static const AnsiColor magenta = AnsiColor.foreground(35);
  static const AnsiColor cyan = AnsiColor.foreground(36);
  static const AnsiColor white = AnsiColor.foreground(37);

  static const AnsiColor brightBlack = AnsiColor.foreground(90);
  static const AnsiColor brightRed = AnsiColor.foreground(91);
  static const AnsiColor brightGreen = AnsiColor.foreground(92);
  static const AnsiColor brightYellow = AnsiColor.foreground(93);
  static const AnsiColor brightBlue = AnsiColor.foreground(94);
  static const AnsiColor brightMagenta = AnsiColor.foreground(95);
  static const AnsiColor brightCyan = AnsiColor.foreground(96);
  static const AnsiColor brightWhite = AnsiColor.foreground(97);

  static const AnsiColor redBg = AnsiColor.foreground(31 + 10);
  static const AnsiColor greenBg = AnsiColor.foreground(32 + 10);
  static const AnsiColor yellowBg = AnsiColor.foreground(33 + 10);
  static const AnsiColor blueBg = AnsiColor.foreground(34 + 10);
  static const AnsiColor magentaBg = AnsiColor.foreground(35 + 10);
  static const AnsiColor cyanBg = AnsiColor.foreground(36 + 10);
  static const AnsiColor whiteBg = AnsiColor.foreground(37 + 10);

  static const AnsiColor brightBlackBg = AnsiColor.foreground(90 + 10);
  static const AnsiColor brightRedBg = AnsiColor.foreground(91 + 10);
  static const AnsiColor brightGreenBg = AnsiColor.foreground(92 + 10);
  static const AnsiColor brightYellowBg = AnsiColor.foreground(93 + 10);
  static const AnsiColor brightBlueBg = AnsiColor.foreground(94 + 10);
  static const AnsiColor brightMagentaBg = AnsiColor.foreground(95 + 10);
  static const AnsiColor brightCyanBg = AnsiColor.foreground(96 + 10);
  static const AnsiColor brightWhiteBg = AnsiColor.foreground(97 + 10);

  final String value;

  @override
  String toString() {
    return "$ansiEsc$value";
  }
}
