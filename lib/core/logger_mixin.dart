import 'package:logging/logging.dart' as logging;

mixin Logger {
  logging.Logger get log => logging.Logger('$runtimeType');
}
