import 'package:logging/logging.dart';
import 'package:logs/logs.dart';

void initLogger({String prefix}) {
  Logger.root.level = Level.ALL;

  // show network traffic logs in the dev tools logging view
  Log('http').enabled = true;

  Logger.root.onRecord.listen((rec) {
    final color = _AnsiColor.fromLogLevel(rec.level);

    final separator = _colored("  ::  ", color);

    final logString =
        "${prefix != null ? '${_colored(prefix, _AnsiColor.cyan)}$separator' : ''}"
        "${_colored(rec.level.name, color)}$separator"
        "${rec.loggerName}$separator"
        "${_colored(rec.message, color)}";

    print(logString);

    if (rec.error != null) {
      print(_colored("----------------", color));
      print(_colored("error", color));
      print(rec.error);
      print(_colored("----------------", color));
      if (rec.stackTrace != null) {
        print(_colored("stack trace", color));
        print(rec.stackTrace.toString());
        print(_colored("----------------", color));
      }
    }
  });
}

String _colored(String message, _AnsiColor color) {
  return "$color$message${_AnsiColor.reset}";
}

class _AnsiColor {
  const _AnsiColor._(this.value);

  const _AnsiColor.foreground(int colorCode) : value = "38;5;${colorCode}m";

  const _AnsiColor.background(int colorCode) : value = "48;5;${colorCode}m";

  factory _AnsiColor.fromLogLevel(Level level) {
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

  static const _AnsiColor reset = _AnsiColor._("0m");

  static const _AnsiColor red = _AnsiColor.foreground(31);
  static const _AnsiColor green = _AnsiColor.foreground(32);
  static const _AnsiColor yellow = _AnsiColor.foreground(33);
  static const _AnsiColor blue = _AnsiColor.foreground(34);
  static const _AnsiColor magenta = _AnsiColor.foreground(35);
  static const _AnsiColor cyan = _AnsiColor.foreground(36);
  static const _AnsiColor white = _AnsiColor.foreground(37);

  static const _AnsiColor brightBlack = _AnsiColor.foreground(90);
  static const _AnsiColor brightRed = _AnsiColor.foreground(91);
  static const _AnsiColor brightGreen = _AnsiColor.foreground(92);
  static const _AnsiColor brightYellow = _AnsiColor.foreground(93);
  static const _AnsiColor brightBlue = _AnsiColor.foreground(94);
  static const _AnsiColor brightMagenta = _AnsiColor.foreground(95);
  static const _AnsiColor brightCyan = _AnsiColor.foreground(96);
  static const _AnsiColor brightWhite = _AnsiColor.foreground(97);

  static const _AnsiColor redBg = _AnsiColor.foreground(31 + 10);
  static const _AnsiColor greenBg = _AnsiColor.foreground(32 + 10);
  static const _AnsiColor yellowBg = _AnsiColor.foreground(33 + 10);
  static const _AnsiColor blueBg = _AnsiColor.foreground(34 + 10);
  static const _AnsiColor magentaBg = _AnsiColor.foreground(35 + 10);
  static const _AnsiColor cyanBg = _AnsiColor.foreground(36 + 10);
  static const _AnsiColor whiteBg = _AnsiColor.foreground(37 + 10);

  static const _AnsiColor brightBlackBg = _AnsiColor.foreground(90 + 10);
  static const _AnsiColor brightRedBg = _AnsiColor.foreground(91 + 10);
  static const _AnsiColor brightGreenBg = _AnsiColor.foreground(92 + 10);
  static const _AnsiColor brightYellowBg = _AnsiColor.foreground(93 + 10);
  static const _AnsiColor brightBlueBg = _AnsiColor.foreground(94 + 10);
  static const _AnsiColor brightMagentaBg = _AnsiColor.foreground(95 + 10);
  static const _AnsiColor brightCyanBg = _AnsiColor.foreground(96 + 10);
  static const _AnsiColor brightWhiteBg = _AnsiColor.foreground(97 + 10);

  final String value;

  @override
  String toString() {
    return "$ansiEsc$value";
  }
}
