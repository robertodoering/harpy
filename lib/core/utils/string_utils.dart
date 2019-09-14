import 'package:intl/intl.dart';

/// Removes the timezone to allow [DateTime] to parse the string.
String formatTwitterDateString(String twitterDateString) {
  final List sanitized = twitterDateString.split(" ")
    ..removeAt(0)
    ..removeWhere((part) => part.startsWith("+"));

  return sanitized.join(" ");
}

// todo: use Uri class instead
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

/// Pretty prints a large number to make it easier to read.
String prettyPrintNumber(int number) {
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

/// Gets the time difference of the [createdAt] time to [DateTime.now].
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

/// Pretty prints a duration difference as long as the difference is smaller
/// than an hour.
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

/// Reduces the [text] by replacing newlines with spaces and if the length of
/// the text exceeds the [limit], the text will be cut at the closest space
/// after [limit] with an ellipsis.
String reduceText(String text, {int limit = 100}) {
  text = text.replaceAll("\n", " ").trim();

  if (text.length > limit) {
    final int index = text.substring(limit).indexOf(" ");

    if (index != -1) {
      // cut off the text before the nearest space
      text = "${text.substring(0, limit + index)}...";
    }
  }

  return text;
}
