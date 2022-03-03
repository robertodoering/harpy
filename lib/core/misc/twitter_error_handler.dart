import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/core/core.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

/// Handles an error from a Twitter api request.
void twitterErrorHandler(Reader read, dynamic error, [StackTrace? stackTrace]) {
  Logger('error handler').info(
    'handling twitter error',
    error,
    stackTrace,
  );

  String message;

  if (error is Response) {
    switch (error.statusCode) {
      case 429:
        // rate limit reached
        final limitReset = _limitResetDuration(error);
        message = 'rate limit reached\n';
        message += limitReset != null && limitReset.inSeconds > 0
            ? 'please try again in ${prettyPrintDurationDifference(limitReset)}'
            : 'please try again later';
        break;
      default:
        message = 'an unexpected error occurred (${error.statusCode})\n'
            'please try again later';
        break;
    }
  } else if (error is TimeoutException) {
    message = 'request timed out\n'
        'please try again later';
  } else if (error is SocketException) {
    // no internet connection
    message = 'unable to connect to the twitter servers\n'
        'please try again later';
  } else {
    message = 'an unexpected error occurred';
  }

  read(messageServiceProvider).showText(message);
}

/// Returns the duration of how long the request is blocked due to being rate
/// limited from the twitter api.
Duration? _limitResetDuration(Response response) {
  try {
    final limitReset = int.parse(response.headers['x-rate-limit-reset']!);

    return DateTime.fromMillisecondsSinceEpoch(limitReset * 1000)
        .difference(DateTime.now());
  } catch (e) {
    return null;
  }
}
