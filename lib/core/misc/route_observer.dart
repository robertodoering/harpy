import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

class HarpyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  static final Logger log = Logger("RouteObserver");

  void _onRouteChanged(PageRoute<dynamic> route) {
    final routeName = route.settings.name;

    log.info("on route changed: $routeName");
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);

    log.fine("did push");

    if (route is PageRoute) {
      _onRouteChanged(route);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);

    log.fine("did pop");

    if (route is PageRoute && previousRoute is PageRoute) {
      _onRouteChanged(previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    log.fine("did replace");

    if (newRoute is PageRoute) {
      _onRouteChanged(newRoute);
    }
  }
}
