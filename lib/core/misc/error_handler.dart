import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Calls [runApp] to run the app and catches any errors thrown by the Flutter
/// framework or dart.
///
/// * In debug mode, any caught errors will be printed to the console.
/// * In release mode, errors are reported to the https://sentry.io error
///   tracking service (when the user has given their consent).
///
/// The [SharedPreferences] are used to determine whether the user has given
/// their consent by checking the `crashReports` preference value.
///
/// See https://flutter.dev/docs/cookbook/maintenance/error-reporting for more
/// information about error reporting in Flutter.
class ErrorHandler with LoggerMixin {
  ErrorHandler({
    required Widget child,
    required SharedPreferences sharedPreferences,
  }) {
    if (kReleaseMode) {
      // override the error widget in release mode (the red error screen)
      ErrorWidget.builder = (details) => const SizedBox();
    }

    FlutterError.onError = _handleFlutterError;

    runZonedGuarded(
      () async {
        if (kReleaseMode && sentryDns.isNotEmpty) {
          await SentryFlutter.init(
            (options) => options.dsn = sentryDns,
          ).handleError(logErrorHandler);
        }

        runApp(child);
      },
      (e, st) => _handleError(e, st, sharedPreferences: sharedPreferences),
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
  Future<void> _handleError(
    Object error,
    StackTrace stackTrace, {
    required SharedPreferences sharedPreferences,
  }) async {
    if (error is SocketException) {
      // no internet connection, can be ignored
      log.warning(
        'ignoring internet connection error $error',
        error,
        stackTrace,
      );
      return;
    }

    log.warning('caught error', error, stackTrace);

    final consent = sharedPreferences.getBool('crashReports') ?? true;

    if (!consent) {
      log.info('not reporting error due to missing consent from the user');
    } else if (kReleaseMode && sentryDns.isNotEmpty) {
      log.info('reporting error to sentry');

      try {
        await Sentry.captureException(
          error,
          stackTrace: stackTrace,
        ).handleError(logErrorHandler);

        log.fine('error reported');
      } catch (e, st) {
        log.warning('error while reporting error', e, st);
      }
    } else {
      log.info('not reporting error in debug / profile mode');
    }
  }
}
