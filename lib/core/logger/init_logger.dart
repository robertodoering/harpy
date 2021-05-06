import 'package:http/http.dart';
import 'package:logging/logging.dart';

// ignore_for_file: avoid_print

void initLogger({String? prefix}) {
  Logger.root.level = Level.ALL;

  const String separator = ' | ';
  const String horizontalSeparator = '--------------------------------';

  Logger.root.onRecord.listen((LogRecord rec) {
    final List<String> content = <String>[
      if (prefix != null) ...<String>[
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
      print('ERROR');

      if (rec.error is Response) {
        print((rec.error as Response).body);
      } else {
        print(rec.error.toString());
      }

      print(horizontalSeparator);

      if (rec.stackTrace != null) {
        print('STACK TRACE');
        rec.stackTrace.toString().trim().split('\n').forEach(print);
        print(horizontalSeparator);
      }
    }
  });
}
