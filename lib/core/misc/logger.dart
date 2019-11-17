import 'package:logging/logging.dart';
import 'package:logs/logs.dart';

void initLogger({String prefix}) {
  Logger.root.level = Level.ALL;

  // show network traffic logs in the dev tools logging view
  Log('http').enabled = true;

  const separator = " | ";
  const horizontalSeparator = "--------------------------------";

  Logger.root.onRecord.listen((rec) {
    final content = <String>[
      if (prefix != null) ...[
        prefix,
        separator,
      ],
      rec.level.name.padRight(7),
      separator,
      rec.loggerName.padRight(22),
      separator,
      rec.message,
    ];

    print(content.join());

    if (rec.error != null) {
      print(horizontalSeparator);
      print("ERROR");
      print(rec.error.toString());
      print(horizontalSeparator);

      if (rec.stackTrace != null) {
        print("STACK TRACE");
        rec.stackTrace.toString().trim().split("\n").forEach(print);
        print(horizontalSeparator);
      }
    }
  });
}
