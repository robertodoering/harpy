import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/widgets/shared/dialogs.dart';
import 'package:harpy/core/misc/harpy_error_handler.dart';
import 'package:logging/logging.dart';
import 'package:package_info/package_info.dart';
import 'package:sentry/sentry.dart';
import 'package:yaml/yaml.dart';

import 'harpy_navigator.dart';

/// Handles reporting errors caught by the [HarpyErrorHandler] and reports
/// them to sentry.
///
/// See [HarpyErrorReporter] for more information.
class HarpyErrorReporter {
  HarpyErrorReporter() {
    if (kReleaseMode) {
      _initSentry();
    }
  }

  static final Logger _log = Logger("HarpyErrorReporter");

  /// The duration that reports are locked for after one error has been caught.
  final Duration _lockDuration = const Duration(minutes: 5);

  /// The [SentryClient} reports errors to the https://sentry.io error tracking
  /// service.
  ///
  /// See https://pub.dev/packages/sentry.
  SentryClient _sentry;

  /// The last time the error dialog has been shown.
  ///
  /// Used to prevent a lot of dialogs in a short timespan.
  DateTime _lastReportTime;

  /// Returns `true` if the report dialog should not be shown.
  bool get _reportLocked =>
      _lastReportTime != null &&
      DateTime.now().difference(_lastReportTime) < _lockDuration;

  /// Loads the DSN for sentry that is used to report the error in release mode.
  Future<void> _initSentry() async {
    try {
      final String appConfig = await rootBundle.loadString(
        "assets/config/app_config.yaml",
      );

      // parse app config
      final YamlMap yamlMap = loadYaml(appConfig);
      final String dsn = yamlMap["sentry"]["dsn"];

      if (dsn.isEmpty) {
        _log.warning("No dsn set for sentry. \n"
            "Errors that are thrown will not be reported to sentry.");
      } else {
        _sentry = SentryClient(dsn: dsn);
      }
    } catch (e) {
      // unable to load dsn for sentry; error reporting will be omitted.
    }
  }

  /// Shows the [_ErrorDialog] to ask the user whether or not the error
  /// should get reported to sentry.
  Future<void> reportError(Object error, StackTrace stackTrace) async {
    if (_reportLocked) {
      _log.warning("report still locked");
      return;
    }

    _lastReportTime = DateTime.now();

    // this await fixes an error when showing dialog in the same frame when
    // the error is thrown during a navigation
    await Future.delayed(Duration.zero);

    final result = await showDialog<bool>(
      context: HarpyNavigator.key.currentState.overlay.context,
      builder: (_) => const _ErrorDialog(),
    );

    if (result == true && _sentry != null) {
      // report error with sentry

      final packageInfo = await PackageInfo.fromPlatform();

      final tags = <String, String>{
        "appName": packageInfo.appName,
        "buildNumber": packageInfo.buildNumber,
        "packageName": packageInfo.packageName,
        ...await _loadDeviceInfo(),
      };

      final event = Event(
        exception: error,
        stackTrace: stackTrace,
        release: packageInfo.version,
        tags: tags,
      );

      // todo: test to report error without a connection
      final sentryResponse = await _sentry.capture(event: event);

      if (sentryResponse.isSuccessful) {
        _log.fine("error reported to sentry");
      } else {
        _log.severe("error while reporting to sentry", sentryResponse.error);
      }
    } else {
      _log.warning("not sending the report");
    }
  }

  /// Loads additional device info to send along with the report.
  Future<Map<String, String>> _loadDeviceInfo() async {
    if (Platform.isAndroid) {
      try {
        final androidInfo = await DeviceInfoPlugin().androidInfo;

        return <String, String>{
          "androidId": androidInfo.androidId,
          "board": androidInfo.board,
          "bootloader": androidInfo.bootloader,
          "brand": androidInfo.brand,
          "device": androidInfo.device,
          "display": androidInfo.display,
          "fingerprint": androidInfo.fingerprint,
          "hardware": androidInfo.hardware,
          "host": androidInfo.host,
          "id": androidInfo.id,
          "isPhysicalDevice": "${androidInfo.isPhysicalDevice}",
          "manufacturer": androidInfo.manufacturer,
          "model": androidInfo.model,
          "product": androidInfo.product,
          "tags": androidInfo.tags,
          "type": androidInfo.type,
          "version.baseOS": androidInfo.version.baseOS,
          "version.codename": androidInfo.version.codename,
          "version.incremental": androidInfo.version.incremental,
          "version.previewSdkInt": "${androidInfo.version.previewSdkInt}",
          "version.release": androidInfo.version.release,
          "version.sdkInt": "${androidInfo.version.sdkInt}",
          "version.securityPatch": androidInfo.version.securityPatch,
        };
      } catch (e) {
        return {};
      }
    } else {
      // no need to support non android devices at the moment
      return {};
    }
  }
}

/// Shows a [HarpyDialog] for a crash report.
///
/// The dialog contains a switch to ask the user for consent to send along
/// device diagnostic data with the error report.
class _ErrorDialog extends StatelessWidget {
  const _ErrorDialog();

  @override
  Widget build(BuildContext context) {
    return const HarpyDialog(
      title: "Crash report",
      text: "An unexpected error occurred.\n"
          "Send a crash report?",
      actions: <DialogAction>[
        DialogAction<bool>(
          result: false,
          text: "No, thanks",
        ),
        DialogAction<bool>(
          result: true,
          text: "Send report",
        ),
      ],
    );
  }
}
