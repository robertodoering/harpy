// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:harpy/rby/rby.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

/// A convenience mixin to expose a [Logger] instance for classes named after
/// their type.
mixin LoggerMixin {
  Logger get log => Logger('$runtimeType');
}

/// Adds a listener to the top-level root logger.
///
/// Clients can call the [Logger] singleton constructor to log messages or use
/// [Logger.detached] to create local short-living logger that can be
/// garbage-collected later.
void initializeLogger({String? prefix}) {
  if (kReleaseMode || isTest) return;

  Logger.root.level = Level.ALL;

  const separator = ' | ';
  const horizontalSeparator = '--------------------------------';

  Logger.root.onRecord.listen((rec) {
    final content = [
      DateFormat('HH:mm:s.S').format(DateTime.now()),
      separator,
      if (prefix != null) ...[
        prefix,
        separator,
      ],
      rec.level.name.padRight(7),
      separator,
      if (rec.loggerName.isNotEmpty) ...[
        rec.loggerName.padRight(22),
        separator,
      ],
      rec.message,
    ];

    final color = _colorForLevel(rec.level);

    print(color(content.join()));

    if (rec.error != null) {
      print(color(horizontalSeparator));
      print(color('ERROR'));

      if (rec.error is Response) {
        print(color((rec.error! as Response).body));
      } else {
        print(color(rec.error.toString()));
      }

      print(color(horizontalSeparator));

      if (rec.stackTrace != null) {
        print(color('STACK TRACE'));
        for (final line in rec.stackTrace.toString().trim().split('\n')) {
          print(color(line));
        }
        print(color(horizontalSeparator));
      }
    }
  });
}

final _levelColors = {
  Level.FINEST: AnsiColor.fg(AnsiColor.grey(0.5)),
  Level.FINER: AnsiColor.fg(AnsiColor.grey(0.5)),
  Level.FINE: AnsiColor.fg(AnsiColor.grey(0.5)),
  Level.CONFIG: AnsiColor.fg(12),
  Level.INFO: AnsiColor.fg(12),
  Level.WARNING: AnsiColor.fg(208),
  Level.SEVERE: AnsiColor.fg(196),
  Level.SHOUT: AnsiColor.fg(199),
};

AnsiColor _colorForLevel(Level level) {
  return _levelColors[level] ?? AnsiColor.none();
}
