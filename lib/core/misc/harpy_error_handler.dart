import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/widgets/shared/dialogs.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:logging/logging.dart';
import 'package:package_info/package_info.dart';
import 'package:sentry/sentry.dart';
import 'package:yaml/yaml.dart';

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
    _initSentry();

    FlutterError.onError = _handleFlutterError;

    runZoned(() {
      runApp(child);
    }, onError: _handleError);
  }

  static final Logger _log = Logger("HarpyErrorHandler");

  /// The duration that reports are locked for after one error has been caught.
  final Duration _lockDuration = const Duration(minutes: 5);

  /// The [SentryClient} reports errors to the https://sentry.io error tracking
  /// service.
  ///
  /// See https://pub.dev/packages/sentry.
  SentryClient _sentry;

  /// Whether or not to send additional device diagnostic data along with the
  /// error report.
  bool _sendDeviceDiagnostics = true;

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
    if (kReleaseMode) {
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
  }

  /// Handles errors caught by the Flutter framework.
  ///
  /// Forwards the error to the [_handleError] handler when in release mode and
  /// prints it to the console otherwise.
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
    _log.severe("cought error", error, stackTrace);

    if (_reportLocked) {
      _log.warning("report still locked");
      return;
    }

    if (kReleaseMode) {
      // this await fixes an error when showing dialog in the same frame when
      // the error is thrown during a navigation
      await Future.delayed(Duration.zero);

      final result = await showDialog<bool>(
        context: HarpyNavigator.key.currentState.overlay.context,
        builder: (_) => _ErrorDialog(
          onValueChanged: (value) => _sendDeviceDiagnostics = value,
        ),
      );

      if (result == true && _sentry != null) {
        // report error with sentry

        final packageInfo = await PackageInfo.fromPlatform();

        final tags = <String, String>{
          "appName": packageInfo.appName,
          "buildNumber": packageInfo.buildNumber,
          "packageName": packageInfo.packageName,
          if (_sendDeviceDiagnostics) ...await _loadDeviceInfo()
        };

        final event = Event(
          exception: error,
          stackTrace: stackTrace,
          release: packageInfo.version,
          tags: tags,
        );

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
  }

  Future<Map<String, String>> _loadDeviceInfo() async {
    if (Platform.isAndroid) {
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
class _ErrorDialog extends StatefulWidget {
  const _ErrorDialog({
    @required this.onValueChanged,
  });

  final ValueChanged<bool> onValueChanged;

  @override
  __ErrorDialogState createState() => __ErrorDialogState();
}

class __ErrorDialogState extends State<_ErrorDialog> {
  bool _sendDeviceDiagnostics = true;

  @override
  void initState() {
    super.initState();

    widget.onValueChanged(_sendDeviceDiagnostics);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return HarpyDialog(
      title: "Crash report",
      text: "An unexpected error occurred.\n"
          "Send a crash report?",
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Send device diagnostic data", style: textTheme.subtitle),
          Switch(
            value: _sendDeviceDiagnostics,
            onChanged: (value) {
              widget.onValueChanged(value);

              setState(() {
                _sendDeviceDiagnostics = value;
              });
            },
          )
        ],
      ),
      actions: <DialogAction>[
        const DialogAction<bool>(
          result: false,
          text: "No, thanks",
        ),
        const DialogAction<bool>(
          result: true,
          text: "Send report",
        ),
      ],
    );
  }
}
