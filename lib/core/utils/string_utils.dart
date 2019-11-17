import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

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
String prettyPrintNumber(int number) => NumberFormat.compact().format(number);

/// Gets the time difference of the [createdAt] time to [DateTime.now].
///
/// The createdAt time is in UTC, so we need to make sure we take the
/// timezone into account.
String tweetTimeDifference(DateTime createdAt) {
  final utcTime = TZDateTime.now(UTC);

  // convert the current utc time into a DateTime
  final utcConverted = DateTime(
    utcTime.year,
    utcTime.month,
    utcTime.day,
    utcTime.hour,
    utcTime.minute,
    utcTime.second,
    utcTime.millisecond,
    utcTime.microsecond,
  );

  final Duration timeDifference = utcConverted.difference(createdAt);

  if (timeDifference.inMinutes <= 59) {
    return "${timeDifference.inMinutes}m";
  } else if (timeDifference.inHours <= 24) {
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
