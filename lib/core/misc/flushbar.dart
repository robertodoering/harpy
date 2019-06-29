import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart' as route;
import 'package:flutter/material.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:logging/logging.dart';

import 'harpy_navigator.dart';

Logger _log = Logger("Flushbar");

enum FlushbarType {
  info,
  warning,
  error,
}

/// Shows the [message] in a [Flushbar].
///
/// The [type] determines the icon and color.
void showFlushbar(
  String message, {
  FlushbarType type = FlushbarType.info,
}) {
  _log.fine("showing error message: $message");

  final navigator = HarpyNavigator.key.currentState;

  Color color;
  IconData icon;

  switch (type) {
    case FlushbarType.info:
      color = Colors.blue;
      icon = Icons.info_outline;
      break;
    case FlushbarType.warning:
      color = Colors.yellow;
      icon = Icons.error_outline;
      break;
    case FlushbarType.error:
      color = Colors.red;
      icon = Icons.error_outline;
      break;
  }

  final harpyTheme = ThemeSettingsModel.of(navigator.context).harpyTheme;

  final flushbar = Flushbar(
    backgroundColor: harpyTheme.primaryColor,
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: harpyTheme.backgroundColors,
    ),
    icon: Icon(icon, color: color),
    messageText: Text(message, style: harpyTheme.theme.textTheme.subhead),
    duration: const Duration(seconds: 3),
    leftBarIndicatorColor: color,
  );

  navigator.push(route.showFlushbar(
    context: navigator.context,
    flushbar: flushbar,
  ));
}
