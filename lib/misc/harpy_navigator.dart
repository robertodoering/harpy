import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger('HarpyNavigator');

/// Determines what [PageRoute] is used for the new route.
///
/// This determines the transition animation for the new route.
enum RouteType {
  defaultRoute,
  fade,
}

/// A [Navigator] observer that is used to notify [RouteAware]s of changes to
/// the state of their [Route].
final harpyRouteObserver = RouteObserver<ModalRoute<dynamic>>();

/// The [HarpyNavigator] contains the [Navigator] key used by the root
/// [MaterialApp].
///
/// This allows for navigation without access to the [BuildContext].
// TODO: refactor and make use of flutter's navigator 2.0
class HarpyNavigator {
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  NavigatorState get state => key.currentState!;

  void pop<T extends Object>([T? result]) => state.pop<T>(result);

  Future<bool> maybePop<T extends Object>([T? result]) =>
      state.maybePop(result);

  Future<T?> push<T>(Route<T> route) => state.push<T>(route);

  void pushReplacementNamed(
    String route, {
    RouteType type = RouteType.defaultRoute,
    Map<String, dynamic>? arguments,
  }) {
    state.pushReplacementNamed<void, void>(
      route,
      arguments: <String, dynamic>{
        'routeType': type,
        ...?arguments,
      },
    );
  }

  void pushNamed(
    String route, {
    RouteType type = RouteType.defaultRoute,
    Map<String, dynamic>? arguments,
  }) {
    state.pushNamed<void>(
      route,
      arguments: <String, dynamic>{
        'routeType': type,
        ...?arguments,
      },
    );
  }

  void pushUserProfile({
    UserData? initialUser,
    String? handle,
    RouteSettings? currentRoute,
  }) {
    assert(
      initialUser != null || handle != null,
      'no initial user or handle specified',
    );

    handle ??= initialUser!.handle;

    // prevent navigation to the same user back to back
    if (currentRoute?.name == UserProfileScreen.route) {
      final arguments = currentRoute!.arguments as Map<String, dynamic>? ??
          <String, dynamic>{};

      if (arguments['handle'] == handle) {
        _log.fine('preventing navigation to current user');
        return;
      }
    }

    pushNamed(
      UserProfileScreen.route,
      arguments: <String, dynamic>{
        'initialUser': initialUser,
        'handle': handle,
      },
    );
  }

  void pushCustomTheme({
    required HarpyThemeData themeData,
    required int themeId,
  }) {
    pushNamed(
      CustomThemeScreen.route,
      arguments: <String, dynamic>{
        'themeData': themeData,
        'themeId': themeId,
      },
    );
  }

  void pushFollowingScreen({
    required String userId,
  }) {
    pushNamed(
      FollowingScreen.route,
      arguments: <String, dynamic>{
        'userId': userId,
      },
    );
  }

  void pushFollowersScreen({
    required String userId,
  }) {
    pushNamed(
      FollowersScreen.route,
      arguments: <String, dynamic>{
        'userId': userId,
      },
    );
  }

  void pushRetweetersScreen({
    required String tweetId,
  }) {
    pushNamed(
      RetweetersScreen.route,
      arguments: <String, dynamic>{
        'tweetId': tweetId,
      },
    );
  }

  void pushTweetDetailScreen({
    required TweetData tweet,
  }) {
    pushNamed(
      TweetDetailScreen.route,
      arguments: <String, dynamic>{
        'tweet': tweet,
      },
    );
  }

  void pushTweetSearchScreen({
    String? initialSearchQuery,
  }) {
    pushNamed(
      TweetSearchScreen.route,
      arguments: <String, dynamic>{
        'initialSearchQuery': initialSearchQuery,
      },
    );
  }

  void pushSearchScreen({
    required TrendsCubit trendsCubit,
    required TrendsLocationsCubit trendsLocationsCubit,
  }) {
    pushNamed(
      SearchScreen.route,
      arguments: <String, dynamic>{
        'trendsCubit': trendsCubit,
        'trendsLocationsCubit': trendsLocationsCubit,
      },
    );
  }

  void pushComposeScreen({
    TweetData? inReplyToStatus,
    TweetData? quotedTweet,
  }) {
    pushNamed(
      ComposeScreen.route,
      arguments: <String, dynamic>{
        'inReplyToStatus': inReplyToStatus,
        'quotedTweet': quotedTweet,
      },
    );
  }

  /// Pushes a [ShowListsScreen].
  ///
  /// [userId] can be used to show the lists of a specified user. If `null`
  /// the lists of the authenticated user will be shown.
  ///
  /// [onListSelected] is an optional callback that will be invoked on the
  /// list tap. When `null` the list timeline screen will be navigated to.
  void pushShowListsScreen({
    String? userId,
    ValueChanged<TwitterListData>? onListSelected,
  }) {
    pushNamed(
      ShowListsScreen.route,
      arguments: <String, dynamic>{
        'userId': userId,
        'onListSelected': onListSelected,
      },
    );
  }

  void pushListTimelineScreen({
    required String listId,
    required String listName,
  }) {
    pushNamed(
      ListTimelineScreen.route,
      arguments: <String, dynamic>{
        'listId': listId,
        'listName': listName,
      },
    );
  }

  void pushListMembersScreen({
    required String listId,
    required String listName,
  }) {
    pushNamed(
      ListMembersScreen.route,
      arguments: <String, dynamic>{
        'listId': listId,
        'listName': listName,
      },
    );
  }

  void pushHomeTabCustomizationScreen({
    required HomeTabModel model,
  }) {
    pushNamed(
      HomeTabCustomizationScreen.route,
      arguments: <String, dynamic>{
        'model': model,
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
  final routeName = settings.name;

  _log.fine('navigating to $routeName');

  final arguments =
      settings.arguments as Map<String, dynamic>? ?? <String, dynamic>{};

  final routeType =
      arguments['routeType'] as RouteType? ?? RouteType.defaultRoute;

  Widget screen;

  switch (routeName) {
    case TweetDetailScreen.route:
      screen = TweetDetailScreen(
        tweet: arguments['tweet'],
      );
      break;
    case UserProfileScreen.route:
      screen = UserProfileScreen(
        initialUser: arguments['initialUser'],
        handle: arguments['handle'],
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
        listId: arguments['listId'],
        listName: arguments['listName'],
      );
      break;
    case ListMembersScreen.route:
      screen = ListMembersScreen(
        listId: arguments['listId'],
        name: arguments['listName'],
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
    case RetweetersScreen.route:
      screen = RetweetersScreen(
        tweetId: arguments['tweetId'],
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
    case DisplaySettingsScreen.route:
      screen = const DisplaySettingsScreen();
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
    case ChangelogScreen.route:
      screen = const ChangelogScreen();
      break;
    case UserSearchScreen.route:
      screen = const UserSearchScreen();
      break;
    case SearchScreen.route:
      screen = SearchScreen(
        trendsCubit: arguments['trendsCubit'],
        trendsLocationsCubit: arguments['trendsLocationsCubit'],
      );
      break;
    case TweetSearchScreen.route:
      screen = TweetSearchScreen(
        initialQuery: arguments['initialSearchQuery'],
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
      return HarpyPageRoute<void>(
        builder: (_) => screen,
        settings: RouteSettings(name: routeName, arguments: arguments),
      );
  }
}
