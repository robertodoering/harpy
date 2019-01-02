import 'package:harpy/core/utils/string_utils.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

// todo: refactor
class HarpyLogger {
//  static Logger twitterClient = Logger("TwitterClient");

  static void init() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print(
          '${fillStringToLength(rec.level.name, 6)} :: ${DateFormat("d.M.y H:m:s").format(rec.time).toString()} :: ${rec.loggerName} :: ${rec.message}');
    });
  }
}
