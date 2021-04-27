import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
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

  /// Pushes a [UserProfileScreen] for the user with the [screenName].
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

  void pushTweetSearchScreen({
    String initialSearchQuery,
  }) {
    pushNamed(TweetSearchScreen.route, arguments: <String, dynamic>{
      'initialSearchQuery': initialSearchQuery,
    });
  }

  void pushComposeScreen({
    TweetData inReplyToStatus,
    TweetData quotedTweet,
  }) {
    pushNamed(ComposeScreen.route, arguments: <String, dynamic>{
      'inReplyToStatus': inReplyToStatus,
      'quotedTweet': quotedTweet,
    });
  }

  void pushShowListsScreen({
    String userId,
    ValueChanged<TwitterListData> onListSelected,
  }) {
    pushNamed(ShowListsScreen.route, arguments: <String, dynamic>{
      'userId': userId,
      'onListSelected': onListSelected,
    });
  }

  void pushListTimelineScreen({
    TwitterListData list,
  }) {
    pushNamed(ListTimelineScreen.route, arguments: <String, dynamic>{
      'list': list,
    });
  }

  void pushHomeTabCustomizationScreen({
    @required HomeTabModel model,
  }) {
    pushNamed(HomeTabCustomizationScreen.route, arguments: <String, dynamic>{
      'model': model,
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
    case ComposeScreen.route:
      screen = ComposeScreen(
        inReplyToStatus: arguments['inReplyToStatus'],
        quotedTweet: arguments['quotedTweet'],
      );
      break;
    case ShowListsScreen.route:
      screen = ShowListsScreen(
        userId: arguments['userId'],
        onListSelected: arguments['onListSelected'],
      );
      break;
    case ListTimelineScreen.route:
      screen = ListTimelineScreen(
        list: arguments['list'],
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
    case GeneralSettingsScreen.route:
      screen = const GeneralSettingsScreen();
      break;
    case LanguageSettingsScreen.route:
      screen = const LanguageSettingsScreen();
      break;
    case AboutScreen.route:
      screen = const AboutScreen();
      break;
    case BetaInfoScreen.route:
      screen = const BetaInfoScreen();
      break;
    case ChangelogScreen.route:
      screen = const ChangelogScreen();
      break;
    case UserSearchScreen.route:
      screen = const UserSearchScreen();
      break;
    case TweetSearchScreen.route:
      screen = TweetSearchScreen(
        initialSearchQuery: arguments['initialSearchQuery'],
      );
      break;
    case HomeTabCustomizationScreen.route:
      screen = HomeTabCustomizationScreen(
        model: arguments['model'],
      );
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
