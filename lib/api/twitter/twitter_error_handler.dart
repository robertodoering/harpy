import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:harpy/core/misc/flushbar_service.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:harpy/harpy.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger("Error handler");

final _flushbarService = app<FlushbarService>();

/// Handles the [error] from a request.
///
/// An error message is shown in a [Flushbar] when the [error] has been handled.
void twitterClientErrorHandler(
  dynamic error, {
  String message,
}) {
  _log.warning("handling error: $error");

  // response
  if (error is Response) {
    if (_handleRateLimitReached(error)) {
      return;
    } else {
      _log.severe("unhandled response exception\n"
          "statuscode: ${error.statusCode}\n"
          "body: ${error.body}");

      message ??= "An unexpected error occurred (${error.statusCode})/n"
          "Please try again later";
    }
  } else if (error is TimeoutException) {
    message = "Request timed out/n"
        "Please try again later";
  }

  // show the error message
  if (message != null) {
    _flushbarService.error(message);
    return;
  }

  if (error is Error) {
    _log.warning("error not handled", error, error.stackTrace);
  } else if (error is Exception) {
    _log.warning("exception not handled", error);
  }
  // todo: allow to report the error

  _flushbarService.error("An unexpected error occurred");
}

/// Does nothing with the error except logging it.
///
/// Used when an error can just be ignored.
void silentErrorHandler(dynamic error) {
  _log.warning("silently ignoring error: $error");
}

bool _handleRateLimitReached(Response response) {
  if (response.statusCode == 429) {
    // rate limit has been reached
    final limitReset = _limitResetDuration(response);

    _log.fine("rate limit reached, reset in $limitReset");

    _flushbarService.show(
      child: _RateLimitReachedText(limitReset),
      type: FlushbarType.error,
    );

    return true;
  } else {
    return false;
  }
}

/// The message in the [Flushbar] when the api rate limit has been reached.
///
/// The remaining time will automatically count down in the message.
class _RateLimitReachedText extends StatefulWidget {
  const _RateLimitReachedText(this.resetDuration);

  final Duration resetDuration;

  @override
  __RateLimitReachedTextState createState() => __RateLimitReachedTextState();
}

class __RateLimitReachedTextState extends State<_RateLimitReachedText> {
  Duration _resetDuration;
  Timer _timer;

  String get _durationString => _resetDuration != null
      ? prettyPrintDurationDifference(_resetDuration)
      : null;

  @override
  void initState() {
    super.initState();

    _resetDuration = widget.resetDuration;

    if (_resetDuration != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), _update);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _timer.cancel();
  }

  void _update(Timer timer) {
    if (mounted && _resetDuration.inSeconds > 0) {
      setState(() {
        _resetDuration = _resetDuration - const Duration(seconds: 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final message = _durationString != null
        ? "Rate limit reached.\nPlease try again in $_durationString."
        : "Rate limit reached.\nPlease try again later.";

    return Text(message);
  }
}

/// Gets the duration of how long the request is blocked due to being rate
/// limited from the twitter api.
Duration _limitResetDuration(Response response) {
  try {
    final limitReset = int.parse(response.headers["x-rate-limit-reset"]);

    return DateTime.fromMillisecondsSinceEpoch(
      limitReset * 1000,
    ).difference(DateTime.now());
  } catch (e) {
    return null;
  }
}
