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
  String dateString = "";

  List<String> splitDate = twitterDateString.split(" ");
  splitDate.removeAt(0);

  splitDate.forEach((currentString) {
    if (!currentString.startsWith("+")) {
      dateString += " " + currentString;
    }
  });

  dateString = dateString.trim();

  return dateString;
}

String explodeListToSeparatedString(List<String> list,
    {String separator = ","}) {
  String result = "";

  list.forEach((currentString) {
    result += "$currentString$separator";
  });

  result = result.replaceRange(result.length - 1, result.length, "");

  return result;
}

String appendParamsToUrl(String url, Map<String, String> params) {
  if (params == null || params.isEmpty) {
    return url;
  }

  String paramsString = "?";

  for (int i = 0; i < params.length; i++) {
    if (i != 0) {
      paramsString += "&";
    }
    paramsString += "${params.keys.elementAt(i)}=${params.values.elementAt(i)}";
  }

  return url + paramsString;
}
