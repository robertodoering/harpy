import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final routerProvider = Provider(
  (ref) => GoRouter(routes: ref.watch(routesProvider)),
  name: 'RouterProvider',
);

final routesProvider = Provider(
  (ref) => [
    GoRoute(
      name: SplashPage.name,
      path: '/',
      pageBuilder: (_, state) => HarpyPage(
        key: state.pageKey,
        child: const SplashPage(),
      ),
    ),
    GoRoute(
      name: LoginPage.name,
      path: '/login',
      pageBuilder: (_, state) => HarpyPage(
        key: state.pageKey,
        pageRouteType: ['splash', 'home'].contains(state.queryParams['origin'])
            ? PageRouteType.fade
            : PageRouteType.harpy,
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      name: HomePage.name,
      path: '/home',
      pageBuilder: (_, state) => HarpyPage(
        key: state.pageKey,
        pageRouteType: ['splash', 'login'].contains(state.queryParams['origin'])
            ? PageRouteType.fade
            : PageRouteType.harpy,
        child: const HomePage(),
      ),
      routes: [
        GoRoute(
          name: SettingsPage.name,
          path: 'settings',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            child: const SettingsPage(),
          ),
        ),
      ],
    ),
  ],
  name: 'RoutesProvider',
);
