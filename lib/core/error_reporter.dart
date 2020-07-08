import 'dart:io';

import 'package:flutter/material.dart';
import 'package:harpy/components/common/dialogs/error_dialog.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/app_config.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:logging/logging.dart';
import 'package:sentry/sentry.dart';

/// Handles reporting errors caught by the [HarpyErrorHandler] and reports
/// them to sentry.
///
/// See [HarpyErrorHandler] for more information.
class ErrorReporter {
  static final Logger _log = Logger('ErrorReporter');

  /// The duration that reports are locked for after one error has been caught.
  final Duration _lockDuration = const Duration(minutes: 5);

  /// The [SentryClient] reports errors to the https://sentry.io error tracking
  /// service.
  ///
  /// See https://pub.dev/packages/sentry.
  SentryClient _sentry;

  /// The last time the error dialog has been shown.
  ///
  /// Used to prevent a lot of dialogs to show in a short timespan.
  DateTime _lastReportTime;

  /// Returns `true` if the report dialog should not be shown.
  bool get _reportLocked =>
      _lastReportTime != null &&
      DateTime.now().difference(_lastReportTime) < _lockDuration;

  /// Initializes the [SentryClient] with the DSN of the [AppConfig] to report
  /// errors in release mode.
  Future<void> initialize() async {
    final String dsn = app<AppConfig>().data?.sentryDsn;

    if (dsn?.isNotEmpty == true) {
      _sentry = SentryClient(dsn: dsn);
    } else {
      _log.warning('No dsn set for sentry. \n'
          'Errors that are thrown will not be reported to sentry.');
    }
  }

  /// Shows the [_ErrorDialog] to ask the user whether or not the error
  /// should get reported to sentry.
  Future<void> reportError(Object error, StackTrace stackTrace) async {
    if (_reportLocked) {
      _log.warning('report still locked');
      return;
    }

    _lastReportTime = DateTime.now();

    // this await fixes an error when showing dialog in the same frame when
    // the error is thrown during a navigation
    await Future<void>.delayed(Duration.zero);

    final bool result = await showDialog<bool>(
      context: app<HarpyNavigator>().key.currentState.overlay.context,
      builder: (_) => const ErrorDialog(),
    );

    if (result == true && _sentry != null) {
      // report error with sentry

      final HarpyInfo harpyInfo = app<HarpyInfo>();

      final Map<String, String> tags = <String, String>{
        'appName': harpyInfo.packageInfo?.appName,
        'buildNumber': harpyInfo.packageInfo?.buildNumber,
        'packageName': harpyInfo.packageInfo?.packageName,
        ..._appendDeviceInfo(harpyInfo),
      };

      final Event event = Event(
        exception: error,
        stackTrace: stackTrace,
        release: harpyInfo.packageInfo?.version,
        tags: tags,
      );

      final SentryResponse sentryResponse =
          await _sentry.capture(event: event).catchError(silentErrorHandler);

      if (sentryResponse?.isSuccessful == true) {
        _log.fine('error reported to sentry');
      } else {
        _log.severe('error while reporting to sentry', sentryResponse.error);
      }
    } else {
      _log.warning('not sending the report');
    }
  }

  /// Returns additional device info to send along with the report.
  Map<String, String> _appendDeviceInfo(HarpyInfo harpyInfo) {
    if (Platform.isAndroid && harpyInfo.deviceInfo != null) {
      return <String, String>{
        'androidId': harpyInfo.deviceInfo.androidId,
        'board': harpyInfo.deviceInfo.board,
        'bootloader': harpyInfo.deviceInfo.bootloader,
        'brand': harpyInfo.deviceInfo.brand,
        'device': harpyInfo.deviceInfo.device,
        'display': harpyInfo.deviceInfo.display,
        'fingerprint': harpyInfo.deviceInfo.fingerprint,
        'hardware': harpyInfo.deviceInfo.hardware,
        'host': harpyInfo.deviceInfo.host,
        'id': harpyInfo.deviceInfo.id,
        'isPhysicalDevice': '${harpyInfo.deviceInfo.isPhysicalDevice}',
        'manufacturer': harpyInfo.deviceInfo.manufacturer,
        'model': harpyInfo.deviceInfo.model,
        'product': harpyInfo.deviceInfo.product,
        'tags': harpyInfo.deviceInfo.tags,
        'type': harpyInfo.deviceInfo.type,
        'version.baseOS': harpyInfo.deviceInfo.version.baseOS,
        'version.codename': harpyInfo.deviceInfo.version.codename,
        'version.incremental': harpyInfo.deviceInfo.version.incremental,
        'version.previewSdkInt':
            '${harpyInfo.deviceInfo.version.previewSdkInt}',
        'version.release': harpyInfo.deviceInfo.version.release,
        'version.sdkInt': '${harpyInfo.deviceInfo.version.sdkInt}',
        'version.securityPatch': harpyInfo.deviceInfo.version.securityPatch,
      };
    } else {
      // non android devices are currently not supported
      return <String, String>{};
    }
  }
}
