import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/core/core.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:rby/rby.dart';

/// Handles an error from a Twitter api request to potentially show a message to
/// the user.
void twitterErrorHandler(Ref ref, Object error, [StackTrace? stackTrace]) {
  Logger('error handler').info(
    'handling twitter error',
    error,
    stackTrace,
  );

  SnackBar? snackBar;
  String? message;

  if (error is Response) {
    switch (error.statusCode) {
      case 429:
        // rate limit reached
        final limitReset = _limitResetDuration(error);
        message = 'rate limit reached\n';
        message += limitReset != null && limitReset.inSeconds > 0
            ? 'please try again in ${prettyPrintDurationDifference(limitReset)}'
            : 'please try again later';

        if (limitReset == null) {
          // only show snackbar when we don't have a rate limit reset time (e.g.
          // when liking a tweet)
          snackBar = SnackBar(
            content: Text(message),
            action: SnackBarAction(
              label: 'info',
              onPressed: () => ref.read(dialogServiceProvider).show(
                    child: const _RateLimitReachedDialog(),
                  ),
            ),
          );
        }

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

  if (snackBar != null) {
    ref.read(messageServiceProvider).showSnackbar(snackBar);
  } else {
    ref.read(messageServiceProvider).showText(message);
  }
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

class _RateLimitReachedDialog extends StatelessWidget {
  const _RateLimitReachedDialog();

  @override
  Widget build(BuildContext context) {
    return RbyDialog(
      title: const Text('rate limit reached'),
      content: const Text(
        '''
Due to limitations from Twitter, harpy runs into rate limits (e.g. when liking a Tweet).

Unfortunately you'll have to wait a bit and try again later.''',
      ),
      actions: [
        RbyButton.text(
          label: const Text('ok'),
          onTap: Navigator.of(context).pop,
        ),
      ],
    );
  }
}
