import 'package:flutter/material.dart';
import 'package:harpy/harpy.dart';

/// The [RouteType] determines what [PageRoute] is used for the new route.
///
/// This determines the transition animation for the new route.
enum RouteType {
  defaultRoute,
  fade,
}

/// A convenience class to wrap [Navigator] functionality.
///
/// Since a [GlobalKey] is used for the [Navigator], the [BuildContext] is not
/// necessary when changing the current route.
class HarpyNavigator {
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  /// A convenience method to push a new [MaterialPageRoute] to the [Navigator].
  static void push(Widget widget, {String name}) {
    key.currentState.push<void>(MaterialPageRoute(
      builder: (BuildContext context) => widget,
      settings: RouteSettings(name: name),
    ));
  }

  /// A convenience method to push a new [route] to the [Navigator].
  static void pushRoute(Route<void> route) {
    key.currentState.push<void>(route);
  }

  /// A convenience method to push a named replacement route.
  static void pushReplacementNamed(
    String route, {
    RouteType type = RouteType.defaultRoute,
  }) {
    key.currentState.pushReplacementNamed<void, void>(
      route,
      arguments: <String, dynamic>{
        'routeType': type,
      },
    );
  }
}

/// [onGenerateRoute] is called whenever a new named route is being pushed to
/// the app.
///
/// The [RouteSettings.arguments] that can be passed along the named route
/// needs to be a `Map<String, dynamic>` and can be used to pass along
/// arguments for the screen.
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final String routeName = settings.name;

  final Map<String, dynamic> arguments =
      settings.arguments as Map<String, dynamic> ?? <String, dynamic>{};

  final RouteType routeType =
      arguments['routeType'] as RouteType ?? RouteType.defaultRoute;

  Widget screen;

  switch (routeName) {
    case LoginScreen.route:
    default:
      screen = LoginScreen();
  }

  switch (routeType) {
    case RouteType.fade:
    // todo: add fade route
    // return FadeRoute(
    //   builder: (_) => screen,
    //   settings: RouteSettings(name: routeName),
    // );
    case RouteType.defaultRoute:
    default:
      return MaterialPageRoute<void>(
        builder: (_) => screen,
        settings: RouteSettings(name: routeName),
      );
  }
}
