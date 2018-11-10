import 'package:harpy/core/utils/string_utils.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

class HarpyLogger {
  init() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print(
          '${_getLevelString(rec.level.name)} :: ${_getLogDate(rec.time)} :: ${rec.loggerName} :: ${rec.message}');
    });
  }

  String _getLevelString(String levelName) {
    return fillStringToLength(levelName, 6);
  }

  String _getLogDate(DateTime time) {
    return DateFormat("d.M.y H:m:s").format(time).toString();
  }
}
