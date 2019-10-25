import 'package:logging/logging.dart';
import 'package:logs/logs.dart';

import 'ansi_color.dart';

/// Controls whether or not the log messages sent to the terminal are colored.
///
/// Set this to `false` if your terminal doesn't support [AnsiColor]s.
const _enableColoredLogs = true;

void initLogger({String prefix}) {
  Logger.root.level = Level.ALL;

  // show network traffic logs in the dev tools logging view
  Log('http').enabled = true;

  Logger.root.onRecord.listen((rec) {
    final color = AnsiColor.fromLogLevel(rec.level);

    final separator = _colored("  ::  ", color);

    final logString =
        "${prefix != null ? '${_colored(prefix, AnsiColor.cyan)}$separator' : ''}"
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

String _colored(String message, AnsiColor color) {
  return _enableColoredLogs ? "$color$message${AnsiColor.reset}" : message;
}
