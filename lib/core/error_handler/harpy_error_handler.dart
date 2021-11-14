import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/helper/network_error_handler.dart';
import 'package:harpy/core/core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Calls [runApp] to run the app and catches any errors thrown by the Flutter
/// framework or dart.
///
/// * In debug mode, any caught errors will be printed to the console.
/// * In release mode, errors are reported to the https://sentry.io error
///   tracking service (when the user has given their consent).
///
/// See https://flutter.dev/docs/cookbook/maintenance/error-reporting for more
/// information about error reporting in Flutter.
class HarpyErrorHandler with HarpyLogger {
  HarpyErrorHandler({
    required Widget child,
  }) {
    if (kReleaseMode) {
      // override the error widget in release mode (the red error screen)
      ErrorWidget.builder = (details) => const SizedBox();
    }

    FlutterError.onError = _handleFlutterError;

    runZonedGuarded(
      () async {
        if (kReleaseMode && app<EnvConfig>().hasSentryDsn) {
          await SentryFlutter.init(
            (options) => options.dsn = app<EnvConfig>().sentryDsn,
          ).handleError(silentErrorHandler);
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

    if (!app<GeneralPreferences>().crashReports) {
      log.info('not reporting error due to missing consent from the user');
    } else if (kReleaseMode && app<EnvConfig>().hasSentryDsn) {
      log.info('reporting error to sentry');

      try {
        await Sentry.captureException(error, stackTrace: stackTrace)
            .handleError(silentErrorHandler);
        log.fine('error reported');
      } catch (e, st) {
        log.warning('error while reporting error', e, st);
      }
    } else {
      log.info('not reporting error in debug / profile mode');
    }
  }
}
