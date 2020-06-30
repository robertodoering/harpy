import 'package:logging/logging.dart';

final Logger _log = Logger('NetworkErrorHandler');

/// Does nothing with the error except logging it.
///
/// Used when an error can just be ignored.
void silentErrorHandler(dynamic error) {
  _log.warning('silently ignoring error', error);
}
