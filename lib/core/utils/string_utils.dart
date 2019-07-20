import 'package:intl/intl.dart';

String fillStringToLength(String data, int length, {String filler = " "}) {
  if (filler.length > 1) {
    throw Exception("Filler can't be more then one character");
  }

  final int diff = length - data.length;

  if (diff < 0 || diff == 0) {
    return data;
  }

  for (int i = 0; i < diff * 2; i++) {
    data += filler;
  }
  return data;
}

String formatTwitterDateString(String twitterDateString) {
  final List sanitized = twitterDateString.split(" ")
    ..removeAt(0)
    ..removeWhere((part) => part.startsWith("+"));

  return sanitized.join(" ");
}

String explodeListToSeparatedString(List<String> list,
    {String separator = ","}) {
  String result = "";

  list.forEach((currentString) {
    result += "$currentString$separator";
  });

  return result.replaceRange(result.length - 1, result.length, "");
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

String tweetTimeDifference(DateTime createdAt) {
  final Duration timeDifference = DateTime.now().difference(createdAt);
  if (timeDifference.inHours <= 24) {
    return "${timeDifference.inHours}h";
  } else if (timeDifference.inDays > 365) {
    return DateFormat("MMM d yyyy").format(createdAt);
  } else {
    return DateFormat("MMMd").format(createdAt);
  }
}

String prettyPrintDurationDifference(Duration difference) {
  final int minutes = difference.inMinutes;
  final int seconds = difference.inSeconds;

  if (minutes > 0) {
    final int remainingSeconds = seconds - minutes * 60;
    final String secondsString =
        remainingSeconds > 9 ? "$remainingSeconds" : "0$remainingSeconds";

    return "$minutes:$secondsString minutes";
  } else {
    return "$seconds seconds";
  }
}

String getFileExtension(String path) {
  final index = path.lastIndexOf(".");

  if (index != -1) {
    return path.substring(index + 1);
  } else {
    return null;
  }
}
