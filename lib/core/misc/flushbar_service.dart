import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart' as route;
import 'package:flutter/material.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:logging/logging.dart';

import 'harpy_navigator.dart';

enum FlushbarType {
  info,
  warning,
  error,
}

class FlushbarService {
  final Logger _log = Logger("Flushbar");

  void info(String message) => show(message, type: FlushbarType.info);

  void warning(String message) => show(message, type: FlushbarType.warning);

  void error(String message) => show(message, type: FlushbarType.error);

  /// Shows the [message] in a [Flushbar].
  ///
  /// The [type] determines the icon and color.
  void show(
    String message, {
    FlushbarType type = FlushbarType.info,
  }) {
    _log.fine("showing error message: $message");

    final navigator = HarpyNavigator.key.currentState;

    Color color;
    IconData icon;
    Duration duration;

    switch (type) {
      case FlushbarType.info:
        color = Colors.blue;
        icon = Icons.info_outline;
        duration = const Duration(seconds: 3);
        break;
      case FlushbarType.warning:
        color = Colors.yellow;
        icon = Icons.error_outline;
        duration = const Duration(seconds: 6);
        break;
      case FlushbarType.error:
        color = Colors.red;
        icon = Icons.error_outline;
        duration = const Duration(seconds: 6);
        break;
    }

    final harpyTheme = HarpyTheme.of(navigator.context);

    final flushbar = Flushbar(
      backgroundColor: harpyTheme.primaryColor,
      backgroundGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: harpyTheme.backgroundColors,
      ),
      icon: Icon(icon, color: color),
      messageText: Text(message, style: harpyTheme.theme.textTheme.subhead),
      duration: duration,
      leftBarIndicatorColor: color,
    );

    navigator.push(route.showFlushbar(
      context: navigator.context,
      flushbar: flushbar,
    ));
  }
}
