import 'package:go_router/go_router.dart';
// ignore: implementation_imports
import 'package:go_router/src/go_route_match.dart';

/// Whether a given location has a matching route.
bool locationHasRouteMatch({
  required String location,
  required List<GoRoute> routes,
}) {
  final uri = Uri.parse(location);

  final result = _getLocationRoutes(
    loc: uri.path,
    restLoc: uri.path,
    routes: routes,
    parentFullpath: '',
    parentSubloc: '',
    queryParams: uri.queryParameters,
    extra: null,
  );

  return result.isNotEmpty;
}

List<GoRouteMatch> _getLocationRoutes({
  required String loc,
  required String restLoc,
  required String parentSubloc,
  required List<GoRoute> routes,
  required String parentFullpath,
  required Map<String, String> queryParams,
  required Object? extra,
}) {
  final result = <List<GoRouteMatch>>[];

  // find the set of matches at this level of the tree
  for (final route in routes) {
    final fullpath = _concatenatePaths(parentFullpath, route.path);

    final match = GoRouteMatch.match(
      route: route,
      restLoc: restLoc,
      parentSubloc: parentSubloc,
      fullpath: fullpath,
      queryParams: queryParams,
      extra: extra,
    );

    if (match == null) {
      continue;
    }

    if (match.subloc.toLowerCase() == loc.toLowerCase()) {
      // If it is a complete match, then return the matched route
      // NOTE: need a lower case match because subloc is canonicalized to match
      // the path case whereas the location can be of any case and still match
      result.add([match]);
    } else if (route.routes.isEmpty) {
      // If it is partial match but no sub-routes, bail.
      continue;
    } else {
      // otherwise recurse
      final childRestLoc = loc.substring(
        match.subloc.length + (match.subloc == '/' ? 0 : 1),
      );

      final subRouteMatch = _getLocationRoutes(
        loc: loc,
        restLoc: childRestLoc,
        parentSubloc: match.subloc,
        routes: route.routes,
        parentFullpath: fullpath,
        queryParams: queryParams,
        extra: extra,
      );

      // if there's no sub-route matches, there is no match for this
      // location
      if (subRouteMatch.isEmpty) {
        continue;
      }
      result.add(<GoRouteMatch>[match, ...subRouteMatch]);
    }

    break;
  }

  if (result.isEmpty) {
    return <GoRouteMatch>[];
  }

  // If there are multiple routes that match the location, returning the first
  // one.
  // To make predefined routes to take precedence over dynamic routes eg. '/:id'
  // consider adding the dynamic route at the end of the routes
  return result.first;
}

String _concatenatePaths(String parentPath, String childPath) {
  return parentPath.isEmpty
      ? childPath
      : '${parentPath == '/' ? '' : parentPath}/$childPath';
}
