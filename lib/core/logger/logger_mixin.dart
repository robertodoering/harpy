import 'package:logging/logging.dart';

mixin HarpyLogger {
  Logger get log => Logger('$runtimeType');
}
