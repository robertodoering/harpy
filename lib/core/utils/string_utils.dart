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

  if (list == null) {
    return result;
  }

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

Map<String, String> htmlEntities = {
  "&amp;": "&",
  "&lt;": "<",
  "&gt;": ">",
};

/// Parses <, > and & when they appear as html entities.
String parseHtmlEntities(String source) {
  htmlEntities.forEach((entity, value) {
    source = source.replaceAll(entity, value);
  });

  return source;
}

String formatNumber(int number) {
  String formatted = number.toString();

  if (number >= 100000000) {
    formatted = "${formatted.substring(0, 3)}.${formatted[3]}M";
  } else if (number >= 10000000) {
    formatted = "${formatted.substring(0, 2)}.${formatted[2]}M";
  } else if (number >= 1000000) {
    formatted = "${formatted[0]}.${formatted[1]}M";
  } else if (number >= 100000) {
    formatted = "${formatted.substring(0, 3)}.${formatted[3]}K";
  } else if (number >= 10000) {
    formatted = "${formatted.substring(0, 2)}.${formatted[2]}K";
  } else if (number >= 1000) {
    formatted = "${formatted[0]}.${formatted[1]}K";
  }

  return formatted;
}
