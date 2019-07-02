import 'package:harpy/core/utils/string_utils.dart';
import 'package:intl/intl.dart';

DateTime convertFromTwitterDateString(String twitterDateString) {
  try {
    return DateTime.parse(twitterDateString);
  } catch (ex) {
    final String dateString = formatTwitterDateString(twitterDateString);
    return DateFormat("MMM dd HH:mm:ss yyyy").parse(dateString);
  }
}

String formatCreatedAt(DateTime createdAt) {
  return DateFormat("MMMM yyyy").format(createdAt);
}
