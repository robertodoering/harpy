import 'package:logging/logging.dart';

Logger log = Logger("StringUtils");

String fillStringToLength(String data, int length, {String filler = " "}) {
  if (filler.length > 1) {
    throw new Exception("Filler can't be more then one character");
  }

  int diff = length - data.length;

  if (diff < 0 || diff == 0) {
    return data;
  }

  for (int i = 0; i < diff * 2; i++) {
    data += filler;
  }
  return data;
}

String formatTwitterDateString(String twitterDateString) {
  log.fine("Try to convert TwitterDate $twitterDateString to normal one.");
  String dateString = "";

  List<String> splitDate = twitterDateString.split(" ");
  log.fine("Removing ${splitDate[0]} from String");
  splitDate.removeAt(0);

  splitDate.forEach((currentString) {
    if (!currentString.startsWith("+")) {
      dateString += " " + currentString;
    } else {
      log.fine("Removed $currentString (TimeZone) from date string");
    }
  });

  dateString = dateString.trim();

  log.fine("Got $dateString");
  return dateString;
}
