import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger('NetworkErrorHandler');

/// Does nothing with the error except logging it.
///
/// Used when an error can just be ignored.
void silentErrorHandler(dynamic error, [StackTrace? stackTrace]) {
  _log.info('silently ignoring error', error, stackTrace);
}

/// Handles the [error] from a request.
///
/// An error message is shown in a [HarpyMessage].
void twitterApiErrorHandler(dynamic error, [StackTrace? stackTrace]) {
  _log.info('handling twitter error', error);

  String? message;

  if (error is Response) {
    // response error (status code != 2xx)

    switch (error.statusCode) {
      case 429:
        // rate limit reached
        final limitReset = _limitResetDuration(error);

        message = 'rate limit reached\n';
        message += limitReset != null
            ? 'please try again in ${prettyPrintDurationDifference(limitReset)}'
            : 'please try again later';

        break;
      default:
        _log.warning(
          'unhandled response exception\n'
          'request: ${error.request}\n'
          'statuscode: ${error.statusCode}\n'
          'body: ${error.body}',
        );
        break;
    }

    message ??= 'an unexpected error occurred (${error.statusCode})\n'
        'please try again later';
  } else if (error is TimeoutException) {
    message = 'request timed out\n'
        'please try again later';
  } else if (error is SocketException) {
    // no internet connection
    message = 'unable to connect to the twitter servers\n'
        'please try again later';
  } else if (error is Error) {
    _log.warning('twitter api error not handled', error, stackTrace);
  } else if (error is Exception) {
    _log.warning('twitter api exception not handled', error, stackTrace);
  }

  message ??= 'An unexpected error occurred';

  app<MessageService>().show(message);
}

/// Gets the duration of how long the request is blocked due to being rate
/// limited from the twitter api.
Duration? _limitResetDuration(Response response) {
  try {
    final limitReset = int.parse(response.headers['x-rate-limit-reset']!);

    return DateTime.fromMillisecondsSinceEpoch(
      limitReset * 1000,
    ).difference(DateTime.now());
  } catch (e) {
    return null;
  }
}

/// Returns the error message of an error response or `null` if the error was
/// unable to be parsed.
///
/// Example response:
/// {"errors":[{"code":324,"message":"Duration too long, maximum:30000,
/// actual:30528 (MediaId: snf:1338982061273714688)"}]}
String? responseErrorMessage(String body) {
  try {
    // ignore: avoid_dynamic_calls
    return jsonDecode(body)['errors'][0]['message'];
  } catch (e, st) {
    _log.warning(
      'unable to parse error message from response body: $body',
      e,
      st,
    );
    return null;
  }
}
