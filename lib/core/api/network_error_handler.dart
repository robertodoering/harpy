import 'dart:async';
import 'dart:io';

import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/utils/string_utils.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger('NetworkErrorHandler');

/// Does nothing with the error except logging it.
///
/// Used when an error can just be ignored.
void silentErrorHandler(dynamic error) {
  _log.info('silently ignoring error', error);
}

/// Handles the [error] from a request.
///
/// An error message is shown in a [HarpyMessage].
///
/// If [fallbackMessage] is not `null`, it is used in place of a generic error
/// message if the error wasn't handled.
void twitterApiErrorHandler(
  dynamic error, {
  String fallbackMessage,
}) {
  _log.info('handling twitter error', error);

  final MessageService messageService = app<MessageService>();

  String message = fallbackMessage;

  if (error is Response) {
    // response error (status code != 2xx)

    switch (error.statusCode) {
      case 429:
        // rate limit reached
        final Duration limitReset = _limitResetDuration(error);

        message = 'Rate limit reached.\n';
        message += limitReset != null
            ? 'Please try again in ${prettyPrintDurationDifference(limitReset)}'
            : 'Please try again later.';

        break;
      default:
        _log.warning('unhandled response exception\n'
            'statuscode: ${error.statusCode}\n'
            'body: ${error.body}');
        break;
    }

    message ??= 'An unexpected error occurred (${error.statusCode})\n'
        'Please try again later';
  } else if (error is TimeoutException) {
    message = 'Request timed out\n'
        'Please try again later';
  } else if (error is SocketException) {
    // no internet connection
    message = 'Unable to connect to the Twitter servers\n'
        'Please try again later';
  } else if (error is Error) {
    _log.warning('twitter api error not handled', error, error.stackTrace);
  } else if (error is Exception) {
    _log.warning('twitter api exception not handled', error);
  }

  message ??= 'An unexpected error occurred';

  messageService.show(message);
}

/// Gets the duration of how long the request is blocked due to being rate
/// limited from the twitter api.
Duration _limitResetDuration(Response response) {
  try {
    final int limitReset = int.parse(response.headers['x-rate-limit-reset']);

    return DateTime.fromMillisecondsSinceEpoch(
      limitReset * 1000,
    ).difference(DateTime.now());
  } catch (e) {
    return null;
  }
}
