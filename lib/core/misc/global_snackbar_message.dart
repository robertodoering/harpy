import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:logging/logging.dart';

Logger _log = Logger("Global snackbar message");

/// Shows [message] in a [SnackBar] from the [globalScaffold].
void showSnackbarMessage(String message) {
  _log.fine("showing error message in snackbar: $message");

  globalScaffold.currentState.showSnackBar(
    SnackBar(content: Text(message)),
  );
}
