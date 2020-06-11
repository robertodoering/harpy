import 'package:logging/logging.dart';

void initLogger({String prefix}) {
  Logger.root.level = Level.ALL;

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
