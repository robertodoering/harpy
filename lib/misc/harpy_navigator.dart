import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/about/widgets/about_screen.dart';
import 'package:harpy/components/authentication/widgets/login_screen.dart';
import 'package:harpy/components/authentication/widgets/setup_screen.dart';
import 'package:harpy/components/common/routes/fade_route.dart';
import 'package:harpy/components/following_followers/followers/widgets/followers_screen.dart';
import 'package:harpy/components/following_followers/following/widgets/following_screen.dart';
import 'package:harpy/components/replies/widgets/replies_screen.dart';
import 'package:harpy/components/settings/common/widgets/settings_screen.dart';
import 'package:harpy/components/settings/custom_theme/widgets/custom_theme_screen.dart';
import 'package:harpy/components/settings/layout/widgets/layout_settings_screen.dart';
import 'package:harpy/components/settings/media/widgets/media_settings_screen.dart';
import 'package:harpy/components/settings/theme_selection/widgets/theme_selection_screen.dart';
import 'package:harpy/components/timeline/home_timeline/widgets/home_screen.dart';
import 'package:harpy/components/user_profile/widgets/user_profile_screen.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/theme/harpy_theme_data.dart';
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

  /// A [Navigator] observer that is used to notify [RouteAware]s of changes to
  /// the state of their [Route].
  final RouteObserver<PageRoute<dynamic>> routeObserver =
      RouteObserver<PageRoute<dynamic>>();

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
    @required String screenName,
    RouteSettings currentRoute,
  }) {
    if (currentRoute?.name == UserProfileScreen.route) {
      final Map<String, dynamic> arguments =
          currentRoute.arguments as Map<String, dynamic> ?? <String, dynamic>{};

      if (arguments['screenName'] == screenName) {
        _log.fine('preventing navigation to current user');
        return;
      }
    }

    pushNamed(
      UserProfileScreen.route,
      arguments: <String, dynamic>{
        'screenName': screenName,
      },
    );
  }

  /// Pushes a [CustomThemeScreen] with the [themeData] for [themeId].
  void pushCustomTheme({
    @required HarpyThemeData themeData,
    @required int themeId,
  }) {
    pushNamed(
      CustomThemeScreen.route,
      arguments: <String, dynamic>{
        'themeData': themeData,
        'themeId': themeId,
      },
    );
  }

  /// Pushes a [FollowingScreen] with the following users for the user with the
  /// [userId].
  void pushFollowingScreen({
    @required String userId,
  }) {
    pushNamed(FollowingScreen.route, arguments: <String, dynamic>{
      'userId': userId,
    });
  }

  /// Pushes a [FollowersScreen] with the followers for the user with the
  /// [userId].
  void pushFollowersScreen({
    @required String userId,
  }) {
    pushNamed(FollowersScreen.route, arguments: <String, dynamic>{
      'userId': userId,
    });
  }

  /// Pushes a [RepliesScreen] with the replies to the [tweet].
  void pushRepliesScreen({
    @required TweetData tweet,
  }) {
    pushNamed(RepliesScreen.route, arguments: <String, dynamic>{
      'tweet': tweet,
    });
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
    case RepliesScreen.route:
      screen = RepliesScreen(
        tweet: arguments['tweet'],
      );
      break;
    case UserProfileScreen.route:
      screen = UserProfileScreen(
        screenName: arguments['screenName'],
      );
      break;
    case FollowingScreen.route:
      screen = FollowingScreen(
        userId: arguments['userId'],
      );
      break;
    case FollowersScreen.route:
      screen = FollowersScreen(
        userId: arguments['userId'],
      );
      break;
    case SettingsScreen.route:
      screen = const SettingsScreen();
      break;
    case ThemeSelectionScreen.route:
      screen = const ThemeSelectionScreen();
      break;
    case CustomThemeScreen.route:
      screen = CustomThemeScreen(
        themeData: arguments['themeData'],
        themeId: arguments['themeId'],
      );
      break;
    case LayoutSettingsScreen.route:
      screen = const LayoutSettingsScreen();
      break;
    case MediaSettingsScreen.route:
      screen = const MediaSettingsScreen();
      break;
    case AboutScreen.route:
      screen = const AboutScreen();
      break;
    case HomeScreen.route:
      screen = const HomeScreen();
      break;
    case SetupScreen.route:
      screen = const SetupScreen();
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
        settings: RouteSettings(name: routeName, arguments: arguments),
      );
    case RouteType.defaultRoute:
    default:
      return CupertinoPageRoute<void>(
        builder: (_) => screen,
        settings: RouteSettings(name: routeName, arguments: arguments),
      );
  }
}
