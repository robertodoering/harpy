import 'package:harpy/core/utils/string_utils.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

Logger log = Logger("DateUtils");

DateTime convertFromTwitterDateString(String twitterDateString) {
  try {
    return DateTime.parse(twitterDateString);
  } catch (ex) {
    String dateString = formatTwitterDateString(twitterDateString);
    return DateFormat("MMM dd HH:mm:ss yyyy").parse(dateString);
  }
}
