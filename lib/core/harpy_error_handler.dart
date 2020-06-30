import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:harpy/core/error_reporter.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:logging/logging.dart';

/// Calls [runApp] to run the app and catches any errors thrown by the Flutter
/// framework or dart.
///
/// Caught error are logged and when building in release mode, errors are
/// reported to the https://sentry.io error tracking service.
/// For sentry to report the caught errors, a DSN issued by sentry has to be
/// added to the app config located in `assets/config/app_config.yaml`
///
/// See https://flutter.dev/docs/cookbook/maintenance/error-reporting for more
/// information about error reporting in Flutter.
class HarpyErrorHandler {
  HarpyErrorHandler({
    @required Widget child,
  }) {
    if (kReleaseMode) {
      // override the error widget in release mode (the red error screen)
      ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    }

    FlutterError.onError = _handleFlutterError;

    runZoned(() {
      runApp(child);
    }, onError: _handleError);
  }

  static final Logger _log = Logger('HarpyErrorHandler');

  /// Handles errors caught by the Flutter framework.
  ///
  /// Forwards the error to the [_handleError] handler when in release mode.
  /// Prints it to the console otherwise.
  Future<void> _handleFlutterError(FlutterErrorDetails details) async {
    if (kReleaseMode) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    } else {
      FlutterError.dumpErrorToConsole(details);
    }
  }

  /// Prints the [error] and shows a dialog asking to send the error report.
  ///
  /// Additional device diagnostic data will be sent along the error if the
  /// user consents for it.
  Future<void> _handleError(Object error, StackTrace stackTrace) async {
    if (error is SocketException) {
      // no internet connection, can be ignored
      _log.warning('ignoring error $error');
      return;
    }

    _log.severe('caught error', error, stackTrace);

    // report the error in release mode
    if (kReleaseMode) {
      app<ErrorReporter>().reportError(error, stackTrace);
    } else {
      _log.info('not reporting error in debug / profile mode');
    }
  }
}
