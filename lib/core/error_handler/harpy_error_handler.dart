import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:harpy/core/core.dart';
import 'package:sentry/sentry.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Calls [runApp] to run the app and catches any errors thrown by the Flutter
/// framework or dart.
///
/// In debug mode, any caught errors will be printed to the console.
/// In release mode, errors are reported to the https://sentry.io error
/// tracking service.
///
/// See https://flutter.dev/docs/cookbook/maintenance/error-reporting for more
/// information about error reporting in Flutter.
class HarpyErrorHandler with HarpyLogger {
  HarpyErrorHandler({
    required Widget child,
  }) {
    if (kReleaseMode) {
      // override the error widget in release mode (the red error screen)
      ErrorWidget.builder = (FlutterErrorDetails details) => const SizedBox();
    }

    FlutterError.onError = _handleFlutterError;

    runZonedGuarded(
      () async {
        if (kReleaseMode && hasSentryDsn) {
          await SentryFlutter.init(
            (SentryOptions options) => options.dsn = sentryDsn,
          );
        }

        runApp(child);
      },
      _handleError,
    );
  }

  /// Handles errors caught by the Flutter framework.
  ///
  /// Forwards the error to the [_handleError] handler when in release mode.
  /// Prints it to the console otherwise.
  Future<void> _handleFlutterError(FlutterErrorDetails details) async {
    log.severe('caught flutter error');

    if (kReleaseMode) {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    } else {
      FlutterError.dumpErrorToConsole(details);
    }
  }

  /// Prints the error and reports it to sentry in release mode.
  Future<void> _handleError(Object error, StackTrace stackTrace) async {
    if (error is SocketException) {
      // no internet connection, can be ignored
      log.warning('ignoring internet connection error $error');
      return;
    }

    log.severe('caught error', error, stackTrace);

    // report the error in release mode
    if (kReleaseMode && hasSentryDsn) {
      log.info('reporting error to sentry');
      try {
        await Sentry.captureException(error, stackTrace: stackTrace);
        log.fine('error reported');
      } catch (e) {
        log.warning('error while reporting error');
      }
    } else {
      log.info('not reporting error in debug / profile mode');
    }
  }
}
