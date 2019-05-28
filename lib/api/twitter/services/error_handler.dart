import 'package:flutter/material.dart';
import 'package:harpy/core/misc/global_snackbar_message.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

Logger _log = Logger("Error handler");

/// Handles the [error] from a request.
///
/// An error message is shown in a [SnackBar] when the [error] has been handled.
///
/// If the error hasn't been handled and [backupErrorMessage] is set, the
/// [backupErrorMessage] is shown in a [SnackBar].
void twitterClientErrorHandler(dynamic error, [String backupErrorMessage]) {
  _log.fine("handling error");

  if (error is String) {
    showSnackbarMessage(error);
    return;
  }

  if (error is Response) {
    if (_reachedRateLimit(error)) {
      String limitReset = _limitResetString(error);

      _log.fine("rate limit reached, reset in $limitReset");

      if (limitReset != null) {
        showSnackbarMessage("Rate limit reached.\nTry again in $limitReset.");
        return;
      } else {
        showSnackbarMessage("Rate limit reached.\nPlease try again later.");
        return;
      }
    }
  }

  if (backupErrorMessage != null) {
    showSnackbarMessage(backupErrorMessage);
  }
}

bool _reachedRateLimit(Response response) => response.statusCode == 429;

String _limitResetString(Response response) {
  try {
    int limitReset = int.parse(response.headers["x-rate-limit-reset"]);

    return prettyPrintDurationDifference(
        DateTime.fromMillisecondsSinceEpoch(limitReset * 1000)
            .difference(DateTime.now()));
  } catch (e) {
    return null;
  }
}
