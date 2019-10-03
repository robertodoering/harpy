import 'package:flutter/material.dart';

/// A convenience class to wrap [Navigator] functionality.
///
/// Since a [GlobalKey] is used for the [Navigator], the [BuildContext] is not
/// necessary when changing the current route.
class HarpyNavigator {
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  /// A convenience method to push a new [MaterialPageRoute] to the [Navigator].
  static void push(Widget widget) {
    key.currentState.push(MaterialPageRoute(builder: (context) => widget));
  }

  /// A convenience method to push a new [route] to the [Navigator].
  static void pushRoute(Route route) {
    key.currentState.push(route);
  }

  /// A convenience method to push a new replacement [MaterialPageRoute] to the
  /// [Navigator].
  static void pushReplacement(Widget widget) {
    key.currentState.pushReplacement(
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  /// A convenience method to push a new replacement [route] to the [Navigator].
  static void pushReplacementRoute(Route route) {
    key.currentState.pushReplacement(route);
  }
}
