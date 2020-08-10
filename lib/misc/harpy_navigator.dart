import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/authentication/widgets/login_screen.dart';
import 'package:harpy/components/common/routes/fade_route.dart';
import 'package:harpy/components/settings/widgets/media/media_settings_screen.dart';
import 'package:harpy/components/settings/widgets/settings_screen.dart';
import 'package:harpy/components/timeline/home_timeline/widgets/home_screen.dart';
import 'package:harpy/components/user_profile/widgets/user_profile_screen.dart';
import 'package:harpy/core/api/twitter/user_data.dart';
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

  /// A convenience method to push a new [route] to the [Navigator].
  void pushRoute(Route<void> route) {
    key.currentState.push<void>(route);
  }

  /// A convenience method to push a named replacement route.
  void pushReplacementNamed(
    String route, {
    RouteType type = RouteType.defaultRoute,
    Map<String, dynamic> arguments,
  }) {
    key.currentState.pushReplacementNamed<void, void>(
      route,
      arguments: <String, dynamic>{
        'routeType': type,
        ...?arguments,
      },
    );
  }

  /// A convenience method to push a named route.
  void pushNamed(
    String route, {
    RouteType type = RouteType.defaultRoute,
    Map<String, dynamic> arguments,
  }) {
    key.currentState.pushNamed<void>(
      route,
      arguments: <String, dynamic>{
        'routeType': type,
        ...?arguments,
      },
    );
  }

  /// Pushes a [UserProfileScreen] for the [user] or [screenName].
  ///
  /// Either [user] or [screenName] must not be `null`.
  void pushUserProfile({
    UserData user,
    String screenName,
  }) {
    assert(user != null || screenName != null);

    pushNamed(
      UserProfileScreen.route,
      arguments: <String, dynamic>{
        'user': user,
        'screenName': screenName,
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
    case UserProfileScreen.route:
      screen = UserProfileScreen(
        user: arguments['user'],
        screenName: arguments['screenName'],
      );
      break;
    case SettingsScreen.route:
      screen = const SettingsScreen();
      break;
    case MediaSettingsScreen.route:
      screen = const MediaSettingsScreen();
      break;
    case HomeScreen.route:
      screen = const HomeScreen();
      break;
    case LoginScreen.route:
      screen = const LoginScreen();
      break;
    default:
      _log.warning('route does not exist; navigating to login screen instead');
      screen = const LoginScreen();
  }

  switch (routeType) {
    case RouteType.fade:
      return FadeRoute<void>(
        builder: (_) => screen,
        settings: RouteSettings(name: routeName),
      );
    case RouteType.defaultRoute:
    default:
      return CupertinoPageRoute<void>(
        builder: (_) => screen,
        settings: RouteSettings(name: routeName),
      );
  }
}
