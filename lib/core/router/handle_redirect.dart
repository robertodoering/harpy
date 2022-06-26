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
  if (state.subloc == '/test') return null;
  if (state.subloc == SplashPage.path) return null;

  final coldDeeplink = _handleColdDeeplink(read, state);
  if (coldDeeplink != null) return coldDeeplink;

  final unauthenticated = _handleUnauthenticated(read, state);
  if (unauthenticated != null) return unauthenticated;

  if (!locationHasRouteMatch(
    location: state.location,
    routes: read(routesProvider),
  )) {
    // if the location doesn't exist navigate to home instead
    return '/';
  }

  return null;
}

/// Returns the [SplashPage] location if the app is not initialized and
/// navigates to the target location after initialization.
String? _handleColdDeeplink(Reader read, GoRouterState state) {
  final isInitialized =
      read(applicationStateProvider) == ApplicationState.initialized;

  return !isInitialized
      // TODO: add origin here before the redirect?
      ? '${SplashPage.path}?redirect=${state.location}'
      : null;
}

/// Returns the [LoginPage] location if the app tried to navigate to a location
/// that expects an authenticated user.
String? _handleUnauthenticated(Reader read, GoRouterState state) {
  final isAuthenticated = read(authenticationStateProvider).isAuthenticated;
  final unprotectedRoutes = [SplashPage.path, LoginPage.path];

  return !isAuthenticated && !unprotectedRoutes.contains(state.subloc)
      // TODO: maybe add a redirect after successful login?
      ? LoginPage.path
      : null;
}
