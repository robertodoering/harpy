import 'package:catcher/catcher_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/widgets/shared/dialogs.dart';
import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

/// Wraps the [Catcher] with custom debug and release options.
///
/// [Catcher] calls [runApp] with [child] as the root app.
class HarpyCatcher {
  HarpyCatcher(Widget child) {
    _setup(child);
  }

  Future<void> _setup(Widget child) async {
    Catcher(
      child,
      debugConfig: debugOptions,
      releaseConfig: await releaseOptions,
      enableLogger: false,
    );
  }

  CatcherOptions get debugOptions {
    return CatcherOptions(HarpyDialogReportMode(), [
      ConsoleHandler(),
    ], localizationOptions: [
      localizationOptions,
    ]);
  }

  Future<CatcherOptions> get releaseOptions async {
    return CatcherOptions(
      HarpyDialogReportMode(),
      await releaseHandlers,
      localizationOptions: [
        localizationOptions,
      ],
    );
  }

  Future<List<ReportHandler>> get releaseHandlers async {
    String sender;
    String pass;

    // load credentials from app config
    try {
      final String appConfig = await rootBundle.loadString(
        "assets/config/app_config.yaml",
      );

      final YamlMap yamlMap = loadYaml(appConfig);
      sender = yamlMap["email"]["sender"];
      pass = yamlMap["email"]["pass"];
    } catch (e) {
      // app config not found, email auto handler will be omitted
    }

    return <ReportHandler>[
      if (sender?.isNotEmpty == true && pass?.isNotEmpty == true)
        EmailAutoHandler(
          "smtp.gmail.com",
          587,
          sender,
          "Harpy",
          pass,
          ["rbydoering+harpy@gmail.com"],
          enableCustomParameters: false,
        )
    ];
  }

  LocalizationOptions get localizationOptions {
    return LocalizationOptions(
      "en",
      dialogReportModeTitle: "Crash report",
      dialogReportModeDescription: "An unexpected error occurred.\n"
          "Send a crash report?",
      dialogReportModeAccept: "Send report",
      dialogReportModeCancel: "No, thanks",
    );
  }
}

/// Shows a [HarpyDialog] when an error occurs.
///
/// Only one dialog can be shown every 5 minutes to prevent a lot of dialogs in
/// a short timespan.
class HarpyDialogReportMode extends DialogReportMode {
  /// The last time a report dialog has been shown.
  static DateTime _lastReportTime;

  /// The duration that reports are locked after one error has been caught.
  static const Duration _lockDuration = Duration(minutes: 5);

  /// The list of [Report]s that either have not been sent by the user's action
  /// or have been ignored because the reports were locked.
  static final List<Report> _ignoredReports = [];

  static final Logger _log = Logger("HarpyDialogReportMode");

  /// Returns `true` if the report should not be shown.
  bool get _reportLocked {
    return _lastReportTime != null &&
        DateTime.now().difference(_lastReportTime) < _lockDuration;
  }

  @override
  void requestAction(Report report, BuildContext context) {
    if (_reportLocked) {
      _log.warning("Error catched but report still locked");
      _ignoredReports.add(report);
    } else {
      _lastReportTime = DateTime.now();
      _showDialog(report, context);
    }
  }

  Future<void> _showDialog(Report report, BuildContext context) async {
    await Future.delayed(Duration.zero);

    final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return HarpyDialog(
            title: localizationOptions.dialogReportModeTitle,
            text: localizationOptions.dialogReportModeDescription,
            actions: [
              DialogAction<bool>(
                result: false,
                text: localizationOptions.dialogReportModeCancel,
              ),
              DialogAction<bool>(
                result: true,
                text: localizationOptions.dialogReportModeAccept,
              ),
            ],
          );
        });

    if (result == true) {
      onActionConfirmed(report);
    } else {
      onActionRejected(report);
    }
  }

  @override
  void onActionRejected(Report report) {
    // add the report to the ignored reports
    _ignoredReports.add(report);
    super.onActionRejected(report);
  }

  @override
  void onActionConfirmed(Report report) {
    // call onActionConfirmed for each previously ignored reports and the
    // current one
    _ignoredReports
      ..forEach(super.onActionConfirmed)
      ..clear();
    super.onActionConfirmed(report);
  }
}
