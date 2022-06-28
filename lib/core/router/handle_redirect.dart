import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

// - when navigating to the splash page don't redirect
// - when not initialized, redirect to the splash page and then go to the
//   expected location after initialization
//   (app has been opened with a deep link)
// - when not authenticated, redirect to the login page
// - when the location doesn't exist, redirect to the home page
// - otherwise don't redirect
// NOTE: state.name is always `null`
String? handleRedirect(Reader read, GoRouterState state) {
  final isInitialized =
      read(applicationStateProvider) == ApplicationState.initialized;

  if (!isInitialized && state.subloc != SplashPage.path) {
    return '${SplashPage.path}?redirect=${state.location}';
  }
  // TODO: properly redirect without an initial route

  return null;

  final isAuthenticated = read(authenticationStateProvider).isAuthenticated;

  if (state.subloc == SplashPage.path) return null;
  if (state.subloc == LoginPage.path) return null;

  final coldDeeplink = _handleColdDeeplink(read, state);
  if (coldDeeplink != null) return coldDeeplink;

  final unauthenticated = _handleUnauthenticated(isAuthenticated, state);
  if (unauthenticated != null) return unauthenticated;

  if (!locationHasRouteMatch(
    location: state.location,
    routes: read(routesProvider),
  )) {
    final mappedLocation = _mapTwitterPath(state);
    if (mappedLocation != null) return mappedLocation;

    // if the location doesn't exist navigate to home instead
    return '/';
  }

  return null;
}

/// Returns the [SplashPage] location if the app is not initialized with the
/// target location as a redirect.
String? _handleColdDeeplink(Reader read, GoRouterState state) {
  final isInitialized =
      read(applicationStateProvider) == ApplicationState.initialized;

  return !isInitialized
      // TODO: add origin here before the redirect to change animation?
      ? '${SplashPage.path}?redirect=${state.location}'
      : null;
}

/// Returns the [LoginPage] location if the app tried to navigate to a location
/// that expects an authenticated user.
String? _handleUnauthenticated(bool isAuthenticated, GoRouterState state) {
  final unprotectedRoutes = [SplashPage.path, LoginPage.path];

  return !isAuthenticated && !unprotectedRoutes.contains(state.subloc)
      // TODO: maybe add a redirect after successful login?
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
        path: '/search/tweets',
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
    return '/user/${userProfileMatch!.group(1)}/followers';
  }

  final userFollowingMatch = userFollowingPathRegex.firstMatch(uri.path);
  if (userFollowingMatch?.group(1) != null) {
    return '/user/${userProfileMatch!.group(1)}/following';
  }

  final userListsMatch = userListsPathRegex.firstMatch(uri.path);
  if (userListsMatch?.group(1) != null) {
    // TODO: breaks
    return '/user/${userProfileMatch!.group(1)}/lists';
  }

  final statusMatch = statusPathRegex.firstMatch(uri.path);
  if (statusMatch?.group(1) != null && statusMatch?.group(2) != null) {
    return '/user/${userProfileMatch!.group(1)}'
        '/status/${statusMatch!.group(2)}';
  }

  return null;
}
