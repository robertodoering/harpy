import 'package:flutter/cupertino.dart';
import 'package:harpy/components/screens/home_screen.dart';
import 'package:harpy/components/screens/login_screen.dart';
import 'package:harpy/components/widgets/shared/harpy_banner_ad.dart';
import 'package:harpy/harpy.dart';
import 'package:logging/logging.dart';

final routeObserver = _HarpyRouteObserver();

class _HarpyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  static final Logger log = Logger("RouteObserver");

  void _onRouteChanged(PageRoute<dynamic> route) {
    final routeName = route.settings.name;

    if (routeName == HomeScreen.route) {
      // show the banner ad when navigating to the home screen
      HarpyBannerAd.bannerKey.currentState?.showBanner();
    } else if (routeName == LoginScreen.route) {
      HarpyBannerAd.bannerKey.currentState?.hideBanner();
    }

    log.info("on route changed: $routeName");

    if (routeName != null) {
      analytics.setCurrentScreen(screenName: routeName);
    }
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
