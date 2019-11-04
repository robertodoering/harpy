import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/screens/custom_theme_screen.dart';
import 'package:harpy/components/screens/following_followers_screen.dart';
import 'package:harpy/components/screens/home_screen.dart';
import 'package:harpy/components/screens/login_screen.dart';
import 'package:harpy/components/screens/setup_screen.dart';
import 'package:harpy/components/screens/tweet_replies_screen.dart';
import 'package:harpy/components/screens/user_profile_screen.dart';
import 'package:harpy/components/widgets/shared/routes.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';

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
    key.currentState.push(MaterialPageRoute(
      builder: (context) => widget,
      settings: RouteSettings(name: name),
    ));
  }

  /// A convenience method to push a new [route] to the [Navigator].
  static void pushRoute(Route route) {
    key.currentState.push(route);
  }

  /// A convenience method to push a named replacement route.
  static void pushReplacementNamed(
    String route, {
    RouteType type = RouteType.defaultRoute,
  }) {
    key.currentState.pushReplacementNamed(
      route,
      arguments: <String, dynamic>{
        "routeType": type,
      },
    );
  }

  /// Pushes the [UserProfileScreen] and makes sure the previous screen is
  /// the [HomeScreen], a [TweetRepliesScreen], or a [FollowingFollowerScreen].
  static void pushUserProfileScreen({
    String userId,
    User user,
  }) {
    assert(userId != null || user != null);

    key.currentState.pushNamedAndRemoveUntil(
      UserProfileScreen.route,
      namePredicate([
        HomeScreen.route,
        TweetRepliesScreen.route,
        FollowingFollowerScreen.route,
      ]),
      arguments: <String, dynamic>{
        "userId": userId,
        "user": user,
      },
    );
  }

  /// Pushes the [TweetRepliesScreen] and makes sure the previous screen is
  /// the [HomeScreen] or a [UserProfileScreen].
  static void pushTweetRepliesScreen(Tweet tweet) {
    key.currentState.pushNamedAndRemoveUntil(
      TweetRepliesScreen.route,
      namePredicate([HomeScreen.route, UserProfileScreen.route]),
      arguments: <String, dynamic>{
        "tweet": tweet,
      },
    );
  }

  static void pushCustomThemeScreen({
    HarpyThemeData editingThemeData,
    int editingThemeId,
  }) {
    key.currentState.pushNamed(
      CustomThemeScreen.route,
      arguments: <String, dynamic>{
        "editingThemeData": editingThemeData,
        "editingThemeId": editingThemeId,
      },
    );
  }

  /// Returns a [RoutePredicate] similar to [ModalRoute.withName] except it
  /// compares a list of route names.
  ///
  /// Can be used in combination with [Navigator.pushNamedAndRemoveUntil] to
  /// pop until a route has one of the name in [names].
  static RoutePredicate namePredicate(List<String> names) {
    return (route) =>
        !route.willHandlePopInternally &&
        route is ModalRoute &&
        (names.contains(route.settings.name));
  }
}

/// [onGenerateRoute] is called whenever a new named route is being pushed to
/// the app.
///
/// The [RouteSettings.arguments] that can be passed along the named route
/// needs to be a `Map<String, dynamic>` and can be used to pass along
/// arguments for the screen.
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final routeName = settings.name;
  final arguments = settings.arguments as Map<String, dynamic> ?? {};
  final routeType =
      arguments["routeType"] as RouteType ?? RouteType.defaultRoute;

  Widget screen;

  switch (routeName) {
    case SetupScreen.route:
      screen = SetupScreen();
      break;
    case HomeScreen.route:
      screen = HomeScreen();
      break;
    case UserProfileScreen.route:
      screen = UserProfileScreen(
        userId: arguments["userId"],
        user: arguments["user"],
      );
      break;
    case TweetRepliesScreen.route:
      screen = TweetRepliesScreen(
        tweet: arguments["tweet"],
      );
      break;
    case CustomThemeScreen.route:
      screen = CustomThemeScreen(
        editingThemeData: arguments["editingThemeData"],
        editingThemeId: arguments["editingThemeId"],
      );
      break;
    case LoginScreen.route:
    default:
      screen = LoginScreen();
  }

  switch (routeType) {
    case RouteType.fade:
      return FadeRoute(
        builder: (_) => screen,
        settings: RouteSettings(name: routeName),
      );
    case RouteType.defaultRoute:
    default:
      return MaterialPageRoute(
        builder: (_) => screen,
        settings: RouteSettings(name: routeName),
      );
  }
}
