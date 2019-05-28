import 'package:catcher/catcher_plugin.dart';
import 'package:flutter/material.dart';

/// Wraps the [Catcher] with custom debug and release options.
///
/// [Catcher] calls [runApp] with [child] as the root app.
class HarpyCatcher {
  HarpyCatcher(Widget child) {
    Catcher(
      child,
      debugConfig: debugOptions,
      releaseConfig: releaseOptions,
      enableLogger: false,
    );
  }

  CatcherOptions get debugOptions => CatcherOptions(DialogReportMode(), [
        ConsoleHandler(),
      ], localizationOptions: [
        localizationOptions,
      ]);

  CatcherOptions get releaseOptions => CatcherOptions(DialogReportMode(), [
//        EmailAutoHandler(), // todo: setup report email
      ], localizationOptions: [
        localizationOptions,
      ]);

  LocalizationOptions get localizationOptions {
    return LocalizationOptions(
      "en",
      dialogReportModeTitle: "Crash report",
      dialogReportModeDescription: "An unexpected error occurred.\nSend a "
          "crash report?",
      dialogReportModeAccept: "Send report",
      dialogReportModeCancel: "No, thanks",
    );
  }
}
