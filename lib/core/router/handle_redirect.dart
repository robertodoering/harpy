import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/*
example deeplinks

adb shell am start -a android.intent.action.VIEW \
 -c android.intent.category.BROWSABLE \
 -d "https://twitter.com/harpy_app"

adb shell am start -a android.intent.action.VIEW \
 -c android.intent.category.BROWSABLE \
 -d "https://twitter.com/search?q=cute+cat"

adb shell am start -a android.intent.action.VIEW \
 -c android.intent.category.BROWSABLE \
 -d "https://twitter.com/search?q=harpy+app&f=user"

adb shell am start -a android.intent.action.VIEW \
 -c android.intent.category.BROWSABLE \
 -d "https://twitter.com/harpy_app/status/1463545080837509120"

adb shell am start -a android.intent.action.VIEW \
 -c android.intent.category.BROWSABLE \
 -d "https://twitter.com/harpy_app/status/1463545080837509120/retweets"

adb shell am start -a android.intent.action.VIEW \
 -c android.intent.category.BROWSABLE \
 -d "https://twitter.com/harpy_app/followers"
*/

/// Paths that an unauthenticated user can access.
///
/// If the requested path is a sublocation of an unprotected path, it can still
/// be accessed.
const _unprotectedRoutes = [
  SplashPage.path,
  LoginPage.path,
  AboutPage.path,
  CustomApiPage.path,
];

// - when navigating to the splash page don't redirect
// - when not initialized, redirect to the splash page and then go to the
//   expected location after initialization
// - when not authenticated, redirect to the login page
// - when the location doesn't exist, redirect to the home page
// - otherwise don't redirect
String? handleRedirect(Ref ref, GoRouterState state) {
  if (state.subloc == SplashPage.path) return null;

  // handle redirect when uninitialized
  final coldDeeplink = _handleColdDeeplink(ref, state);
  if (coldDeeplink != null) return coldDeeplink;

  // handle redirect when unauthenticated
  final unauthenticated = _handleUnauthenticated(ref, state);
  if (unauthenticated != null) return unauthenticated;

  if (!locationHasRouteMatch(
    location: state.location,
    routes: ref.read(routesProvider),
  )) {
    // handle the location if it's a twitter path that can be mapped to a harpy
    // path
    final mappedLocation = _mapTwitterPath(state);
    if (mappedLocation != null) return mappedLocation;

    // if the location doesn't exist, launch it and navigate to home instead
    final launcher = ref.watch(launcherProvider);
    launcher('https://twitter.com${state.location}');
    return '/';
  }

  return null;
}

/// Returns the [SplashPage.path] with the target location as a redirect if the
/// app is not initialized.
String? _handleColdDeeplink(Ref ref, GoRouterState state) {
  final isInitialized =
      ref.read(applicationStateProvider) == ApplicationState.initialized;

  return !isInitialized
      ? '${SplashPage.path}'
          '?transition=fade'
          '&redirect=${state.location}'
      : null;
}

/// Returns the [LoginPage.path] if the user is not authenticated and tried to
/// navigate to a protected route.
String? _handleUnauthenticated(Ref ref, GoRouterState state) {
  final isAuthenticated = ref.read(authenticationStateProvider).isAuthenticated;

  return !isAuthenticated &&
          !_unprotectedRoutes.any((path) => state.subloc.startsWith(path))
      ? LoginPage.path
      : null;
}

/// Maps a twitter url path to the harpy equivalent path or returns `null` if
/// there is no matching location.
///
/// Same as harpy (no need to map):
/// - /i/lists/$id: list timeline
/// - /i/lists/$id/members: list members
/// - /compose/tweet: tweet compose
///
/// Mapped:
/// - /home:          home
/// - /i/trends:      home with trends tab
/// - /explore:       home with trends tab
/// - /notifications: home with mentions tab
///
/// - /search?q=test:         search with query
/// - /search?q=harpy&f=user: search user with query
///
/// - /$handle:           user profile
/// - /$handle/followers: followers page
/// - /$handle/following: following page
/// - /$handle/lists:     lists show page
///
/// - /$handle/status/$id:          tweet detail page
/// - /$handle/status/$id/retweets: tweet retweeters
String? _mapTwitterPath(GoRouterState state) {
  final uri = Uri.tryParse(state.location);

  if (uri == null) return null;

  switch (uri.path) {
    case '/home':
      return '/';
    case '/notifications':
      // TODO: go to mentions tab in home page if it exists
      return '/';
    case '/explore':
    case '/i/trends':
      // TODO: go to search tab in home page if it exists
      return '/';
    case '/search':
      // TODO: user search if `f=user`
      return Uri(
        path: '/harpy_search/tweets',
        queryParameters: {
          if (uri.queryParameters['q'] != null)
            'query': uri.queryParameters['q'],
        },
      ).toString();
  }

  final userProfileMatch = userProfilePathRegex.firstMatch(uri.path);
  if (userProfileMatch?.group(1) != null) {
    return '/user/${userProfileMatch!.group(1)}';
  }

  final userFollowersMatch = userFollowersPathRegex.firstMatch(uri.path);
  if (userFollowersMatch?.group(1) != null) {
    return '/user/${userFollowersMatch!.group(1)}/followers';
  }

  final userFollowingMatch = userFollowingPathRegex.firstMatch(uri.path);
  if (userFollowingMatch?.group(1) != null) {
    return '/user/${userFollowingMatch!.group(1)}/following';
  }

  final userListsMatch = userListsPathRegex.firstMatch(uri.path);
  if (userListsMatch?.group(1) != null) {
    return '/user/${userListsMatch!.group(1)}/lists';
  }

  final statusMatch = statusPathRegex.firstMatch(uri.path);
  if (statusMatch?.group(1) != null && statusMatch?.group(2) != null) {
    return '/user/${statusMatch!.group(1)}'
        '/status/${statusMatch.group(2)}';
  }

  final statusRetweetsMatch = statusRetweetsPathRegex.firstMatch(uri.path);
  if (statusRetweetsMatch?.group(1) != null &&
      statusRetweetsMatch?.group(2) != null) {
    return '/user/${statusRetweetsMatch!.group(1)}'
        '/status/${statusRetweetsMatch.group(2)}'
        '/retweets';
  }

  return null;
}
