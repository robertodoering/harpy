import 'package:go_router/go_router.dart';
// ignore: implementation_imports
import 'package:go_router/src/configuration.dart';
// ignore: implementation_imports
import 'package:go_router/src/match.dart';

/// Whether a given location has a matching route.
bool locationHasRouteMatch({
  required String location,
  required List<GoRoute> routes,
}) {
  final uri = Uri.parse(location);

  final result = _getLocRouteRecursively(
    loc: uri.path,
    restLoc: uri.path,
    routes: routes,
    parentFullpath: '',
    parentSubloc: '',
    queryParams: uri.queryParameters,
    queryParametersAll: uri.queryParametersAll,
    extra: null,
  );

  return result.isNotEmpty;
}

List<RouteMatch> _getLocRouteRecursively({
  required String loc,
  required String restLoc,
  required String parentSubloc,
  required List<RouteBase> routes,
  required String parentFullpath,
  required Map<String, String> queryParams,
  required Map<String, List<String>> queryParametersAll,
  required Object? extra,
}) {
  final result = <List<RouteMatch>>[];

  // find the set of matches at this level of the tree
  for (final route in routes) {
    late final String fullpath;

    if (route is GoRoute) {
      fullpath = _concatenatePaths(parentFullpath, route.path);
    } else if (route is ShellRoute) {
      fullpath = parentFullpath;
    }

    final match = RouteMatch.match(
      route: route,
      restLoc: restLoc,
      parentSubloc: parentSubloc,
      fullpath: fullpath,
      queryParams: queryParams,
      queryParametersAll: queryParametersAll,
      extra: extra,
    );

    if (match == null) continue;

    if (match.route is GoRoute &&
        match.subloc.toLowerCase() == loc.toLowerCase()) {
      result.add([match]);
    } else if (route.routes.isEmpty) {
      continue;
    } else {
      final String childRestLoc;
      final String newParentSubLoc;

      if (match.route is ShellRoute) {
        childRestLoc = restLoc;
        newParentSubLoc = parentSubloc;
      } else {
        childRestLoc = loc.substring(
          match.subloc.length + (match.subloc == '/' ? 0 : 1),
        );
        newParentSubLoc = match.subloc;
      }

      final subRouteMatch = _getLocRouteRecursively(
        loc: loc,
        restLoc: childRestLoc,
        parentSubloc: newParentSubLoc,
        routes: route.routes,
        parentFullpath: fullpath,
        queryParams: queryParams,
        queryParametersAll: queryParametersAll,
        extra: extra,
      ).toList();

      if (subRouteMatch.isEmpty) continue;

      result.add([match, ...subRouteMatch]);
    }

    break;
  }

  if (result.isEmpty) return [];

  return result.first;
}

String _concatenatePaths(String parentPath, String childPath) {
  return parentPath.isEmpty
      ? childPath
      : '${parentPath == '/' ? '' : parentPath}/$childPath';
}
