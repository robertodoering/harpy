import 'package:harpy/core/utils/string_utils.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

void initLogger({String prefix}) {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    String logString =
        '${fillStringToLength(rec.level.name, 6)} :: ${DateFormat('d.M.y H:m:s').format(rec.time).toString()} :: ${rec.loggerName} :: ${rec.message}';

    if (prefix != null) {
      logString = '$prefix :: $logString';
    }

    print(logString);
  });
}
