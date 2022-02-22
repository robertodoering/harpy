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
          routes: [
            GoRoute(
              name: MediaSettingsPage.name,
              path: 'media',
              pageBuilder: (_, state) => HarpyPage(
                key: state.pageKey,
                child: const MediaSettingsPage(),
              ),
            ),
            GoRoute(
              name: ThemeSettingsPage.name,
              path: 'theme',
              pageBuilder: (_, state) => HarpyPage(
                key: state.pageKey,
                child: const ThemeSettingsPage(),
              ),
              routes: [
                GoRoute(
                  name: CustomThemePage.name,
                  path: 'custom',
                  pageBuilder: (_, state) => HarpyPage(
                    key: state.pageKey,
                    child: CustomThemePage(
                      themeId: int.tryParse(state.queryParams['themeId'] ?? ''),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              name: DisplaySettingsPage.name,
              path: 'display',
              pageBuilder: (_, state) => HarpyPage(
                key: state.pageKey,
                child: const DisplaySettingsPage(),
              ),
            ),
            GoRoute(
              name: GeneralSettingsPage.name,
              path: 'general',
              pageBuilder: (_, state) => HarpyPage(
                key: state.pageKey,
                child: const GeneralSettingsPage(),
              ),
            ),
            GoRoute(
              name: LanguageSettingsPage.name,
              path: 'language',
              pageBuilder: (_, state) => HarpyPage(
                key: state.pageKey,
                child: const LanguageSettingsPage(),
              ),
            ),
          ],
        ),
        GoRoute(
          name: FollowingPage.name,
          path: 'following/:id',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            child: FollowingPage(
              userId: state.params['id']!,
            ),
          ),
        ),
        GoRoute(
          name: FollowersPage.name,
          path: 'followers/:id',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            child: FollowersPage(
              userId: state.params['id']!,
            ),
          ),
        ),
        GoRoute(
          name: AboutPage.name,
          path: 'about',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            child: const AboutPage(),
          ),
        ),
      ],
    ),
  ],
  name: 'RoutesProvider',
);
