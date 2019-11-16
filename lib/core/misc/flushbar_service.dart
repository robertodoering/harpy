import 'dart:collection';

import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:logging/logging.dart';

/// The type of the message shown in the [Flushbar].
///
/// Determines the icon, color and duration of the [Flushbar].
enum FlushbarType {
  info,
  warning,
  error,
}

/// Uses the [Flushbar] package to display messages on the bottom of the
/// screen similar to a [SnackBar].
///
/// todo: when a flushbar is showing and navigator.pop() is called (i.e.
///   pressing the back button) it should pop the flushbar route first and
///   then call navigator.pop() again
class FlushbarService {
  static final Logger _log = Logger("Flushbar");

  /// The time the same [Flushbar] has to wait to be shown again.
  final Duration _reshowLimit = const Duration(seconds: 10);

  /// The queue of [Flushbar]s that will be shown until empty.
  ///
  /// When a [Flushbar] is currently showing, it gets added to the [_queue]
  /// and will be shown after the other completes.
  final Queue<Flushbar> _queue = Queue();

  /// The [FlushbarRoute] that is being pushed onto the navigator.
  ///
  /// The reference is used to determine if a [Flushbar] is currently showing
  /// by checking [Route.isActive].
  Route _route;

  /// The last message that has been shown / is showing.
  ///
  /// Used to prevent showing the same [Flushbar] twice.
  String _lastMessage;

  /// The last time a [Flushbar] has been shown.
  ///
  /// Used to prevent showing the same [Flushbar] twice.
  DateTime _lastShown = DateTime.fromMillisecondsSinceEpoch(0);

  void info(String message) => show(
        message: message,
        type: FlushbarType.info,
      );

  void warning(String message) => show(
        message: message,
        type: FlushbarType.warning,
      );

  void error(String message) => show(
        message: message,
        type: FlushbarType.error,
      );

  /// Shows the [message] in a [Flushbar].
  ///
  /// If [child] is not `null`, it is used to build the message in the
  /// [Flushbar] instead and the [message] will be ignored.
  ///
  /// The [type] determines the icon and color.
  void show({
    String message,
    Widget child,
    FlushbarType type = FlushbarType.info,
  }) {
    assert(message != null || child != null);

    if (_hideDuplicate(message)) {
      _log.info("not showing the same flushbar twice");
      return;
    }

    _lastMessage = message;
    _lastShown = DateTime.now();

    final navigator = HarpyNavigator.key.currentState;
    final context = navigator.context;
    final harpyTheme = HarpyTheme.of(context);

    final flushbar = _buildFlushbar(
      message: message,
      child: child,
      type: type,
      harpyTheme: harpyTheme,
    );

    final showing = _route?.isActive ?? false;

    if (showing) {
      _log.info("adding flushbar to queue");
      _queue.add(flushbar);
    } else {
      _log.info("showing flushbar");

      _pushFlushbar(context, flushbar);
    }
  }

  Flushbar _buildFlushbar({
    String message,
    Widget child,
    FlushbarType type,
    HarpyTheme harpyTheme,
  }) {
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

    return Flushbar(
      backgroundColor: harpyTheme.backgroundColors.first,
      icon: Icon(icon, color: color),
      messageText:
          child ?? Text(message, style: harpyTheme.theme.textTheme.subhead),
      duration: duration,
      leftBarIndicatorColor: color,
      animationDuration: const Duration(milliseconds: 600),
      forwardAnimationCurve: Curves.easeOutCirc,
    );
  }

  /// Pushes the [flushbar] onto the navigator.
  ///
  /// If any flushbar has been added into the queue while the [flushbar] is
  /// showing, it will be shown successively
  ///
  /// The future completes when the last [flushbar] completes and the queue
  /// is empty. However if another route has been pushed onto the navigator
  /// while a [Flushbar] was showing, the future never completes.
  Future<dynamic> _pushFlushbar(BuildContext context, Flushbar flushbar) {
    final navigator = HarpyNavigator.key.currentState;

    _log.info("showing flushbar message: ${flushbar.message}");

    _route = FlushbarRoute(
      flushbar: flushbar,
      theme: Theme.of(context),
      settings: RouteSettings(name: FLUSHBAR_ROUTE_NAME),
    );

    return navigator.push(_route).then((_) {
      if (_queue.isNotEmpty) {
        return _pushFlushbar(context, _queue.removeFirst());
      }

      return Future.value();
    });
  }

  /// Whether or not a new flushbar should not show because a flushbar with
  /// the same [message] has been shown recently.
  bool _hideDuplicate(String message) {
    if (DateTime.now().difference(_lastShown) < _reshowLimit) {
      return message == _lastMessage;
    } else {
      return false;
    }
  }
}
