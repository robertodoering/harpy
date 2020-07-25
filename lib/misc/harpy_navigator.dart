import 'package:flutter/material.dart';
import 'package:harpy/components/authentication/widgets/login_screen.dart';
import 'package:harpy/components/common/routes/fade_route.dart';
import 'package:harpy/components/timeline/home_timeline/widgets/home_screen.dart';
import 'package:logging/logging.dart';

/// The [RouteType] determines what [PageRoute] is used for the new route.
///
/// This determines the transition animation for the new route.
enum RouteType {
  defaultRoute,
  fade,
}

final Logger _log = Logger('HarpyNavigator');

/// The [HarpyNavigator] contains the [Navigator] key used by the root
/// [MaterialApp]. This allows for navigation without access to the
/// [BuildContext].
class HarpyNavigator {
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  NavigatorState get state => key.currentState;

  /// A convenience method to push a new [MaterialPageRoute] to the [Navigator].
  void push(Widget widget, {String name}) {
    key.currentState.push<void>(MaterialPageRoute<void>(
      builder: (BuildContext context) => widget,
      settings: RouteSettings(name: name),
    ));
  }

  /// A convenience method to push a new [route] to the [Navigator].
  void pushRoute(Route<void> route) {
    key.currentState.push<void>(route);
  }

  /// A convenience method to push a named replacement route.
  void pushReplacementNamed(
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

  _log.fine('navigating to $routeName');

  final Map<String, dynamic> arguments =
      settings.arguments as Map<String, dynamic> ?? <String, dynamic>{};

  final RouteType routeType =
      arguments['routeType'] as RouteType ?? RouteType.defaultRoute;

  Widget screen;

  switch (routeName) {
    case HomeScreen.route:
      screen = HomeScreen();
      break;
    case LoginScreen.route:
      screen = LoginScreen();
      break;
    default:
      _log.warning('route does not exist; navigating to login screen instead');
      screen = LoginScreen();
  }

  switch (routeType) {
    case RouteType.fade:
      return FadeRoute<void>(
        builder: (_) => screen,
        settings: RouteSettings(name: routeName),
      );
    case RouteType.defaultRoute:
    default:
      return MaterialPageRoute<void>(
        builder: (_) => screen,
        settings: RouteSettings(name: routeName),
      );
  }
}
