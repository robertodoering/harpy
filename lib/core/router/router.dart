import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final routeObserver = Provider(
  (ref) => RouteObserver(),
  name: 'RouteObserver',
);

final routerProvider = Provider(
  (ref) => GoRouter(
    routes: ref.watch(routesProvider),
    observers: [
      ref.watch(routeObserver),
      ref.watch(videoAutopauseObserver),
    ],
  ),
  name: 'RouterProvider',
);

final routesProvider = Provider(
  (ref) => [
    GoRoute(
      name: SplashPage.name,
      path: '/',
      pageBuilder: (_, state) => HarpyPage(
        key: state.pageKey,
        restorationId: state.pageKey.value,
        child: const SplashPage(),
      ),
    ),
    GoRoute(
      name: LoginPage.name,
      path: '/login',
      pageBuilder: (_, state) => HarpyPage(
        key: state.pageKey,
        restorationId: state.pageKey.value,
        pageRouteType: ['splash', 'home'].contains(state.queryParams['origin'])
            ? PageRouteType.fade
            : PageRouteType.harpy,
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      name: SetupPage.name,
      path: '/setup',
      pageBuilder: (_, state) => HarpyPage(
        key: state.pageKey,
        restorationId: state.pageKey.value,
        child: const SetupPage(),
      ),
    ),
    GoRoute(
      name: HomePage.name,
      path: '/home',
      pageBuilder: (_, state) => HarpyPage(
        key: state.pageKey,
        restorationId: state.pageKey.value,
        name: HomePage.name,
        pageRouteType: ['splash', 'login'].contains(state.queryParams['origin'])
            ? PageRouteType.fade
            : PageRouteType.harpy,
        child: const HomePage(),
      ),
      routes: [
        GoRoute(
          name: UserPage.name,
          path: 'user/:handle',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: UserPage(
              handle: state.params['handle']!,
              user: state.extra as UserData?,
            ),
          ),
          routes: [
            GoRoute(
              name: UserTimelineFilter.name,
              path: 'filter',
              pageBuilder: (_, state) => HarpyPage(
                key: state.pageKey,
                restorationId: state.pageKey.value,
                fullscreenDialog: true,
                child: UserTimelineFilter(user: state.extra as UserData),
              ),
            ),
          ],
        ),
        GoRoute(
          name: TweetDetailPage.name,
          path: 'detail',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: TweetDetailPage(tweet: state.extra as TweetData),
          ),
        ),
        GoRoute(
          name: HomeTimelineFilter.name,
          path: 'filter',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            fullscreenDialog: true,
            child: const HomeTimelineFilter(),
          ),
        ),
        GoRoute(
          name: TimelineFilterCreation.name,
          path: 'filter/create',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            fullscreenDialog: true,
            child: TimelineFilterCreation(
              initialTimelineFilter:
                  (state.extra as Map?)?['initialTimelineFilter'],
              onSaved: (state.extra as Map?)?['onSaved'],
            ),
          ),
        ),
        GoRoute(
          name: RetweetersPage.name,
          path: 'retweeters/:id',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            fullscreenDialog: true,
            child: RetweetersPage(tweetId: state.params['id']!),
          ),
        ),
        GoRoute(
          name: FollowingPage.name,
          path: 'following/:id',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: FollowingPage(userId: state.params['id']!),
          ),
        ),
        GoRoute(
          name: FollowersPage.name,
          path: 'followers/:id',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: FollowersPage(userId: state.params['id']!),
          ),
        ),
        GoRoute(
          name: SearchPage.name,
          path: 'search',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const SearchPage(),
          ),
          routes: [
            GoRoute(
              name: UserSearchPage.name,
              path: 'users',
              pageBuilder: (_, state) => HarpyPage(
                key: state.pageKey,
                restorationId: state.pageKey.value,
                child: const UserSearchPage(),
              ),
            ),
            GoRoute(
              name: TweetSearchPage.name,
              path: 'tweets',
              pageBuilder: (_, state) => HarpyPage(
                key: state.pageKey,
                restorationId: state.pageKey.value,
                child: TweetSearchPage(
                  initialQuery: state.queryParams['query'],
                ),
              ),
              routes: [
                GoRoute(
                  name: TweetSearchFilter.name,
                  path: 'filter',
                  pageBuilder: (_, state) => HarpyPage(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
                    fullscreenDialog: true,
                    child: TweetSearchFilter(
                      initialFilter: (state.extra as Map?)?['initialFilter'],
                      onSaved: (state.extra as Map?)?['onSaved'],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: ListShowPage.name,
          path: 'lists/:userId',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: ListShowPage(
              userId: state.params['userId']!,
              onListSelected: state.extra as ValueChanged<TwitterListData>?,
            ),
          ),
        ),
        GoRoute(
          name: ListTimelinePage.name,
          path: 'list/:listId',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: ListTimelinePage(
              listId: state.params['listId']!,
              listName: state.queryParams['name']!,
            ),
          ),
          routes: [
            GoRoute(
              name: ListTimelineFilter.name,
              path: 'filter',
              pageBuilder: (_, state) => HarpyPage(
                key: state.pageKey,
                restorationId: state.pageKey.value,
                fullscreenDialog: true,
                child: ListTimelineFilter(
                  listId: state.params['listId']!,
                  listName: state.queryParams['name']!,
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          name: ListMembersPage.name,
          path: 'list/:listId/members',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: ListMembersPage(
              listId: state.params['listId']!,
              listName: state.queryParams['name']!,
            ),
          ),
        ),
        GoRoute(
          name: ComposePage.name,
          path: 'compose',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: ComposePage(
              parentTweet: (state.extra as Map?)?['parentTweet'],
              quotedTweet: (state.extra as Map?)?['quotedTweet'],
            ),
          ),
        ),
        GoRoute(
          name: SettingsPage.name,
          path: 'settings',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const SettingsPage(),
          ),
          routes: [
            GoRoute(
              name: MediaSettingsPage.name,
              path: 'media',
              pageBuilder: (_, state) => HarpyPage(
                key: state.pageKey,
                restorationId: state.pageKey.value,
                child: const MediaSettingsPage(),
              ),
            ),
            GoRoute(
              name: ThemeSettingsPage.name,
              path: 'theme',
              pageBuilder: (_, state) => HarpyPage(
                key: state.pageKey,
                restorationId: state.pageKey.value,
                child: const ThemeSettingsPage(),
              ),
              routes: [
                GoRoute(
                  name: CustomThemePage.name,
                  path: 'custom',
                  pageBuilder: (_, state) => HarpyPage(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
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
                restorationId: state.pageKey.value,
                child: const DisplaySettingsPage(),
              ),
              routes: [
                GoRoute(
                  name: FontSelectionPage.name,
                  path: 'font',
                  pageBuilder: (_, state) => HarpyPage(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
                    child: FontSelectionPage(
                      title: (state.extra as Map?)?['title'],
                      selectedFont: (state.extra as Map?)?['selectedFont'],
                      onChanged: (state.extra as Map?)?['onChanged'],
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              name: GeneralSettingsPage.name,
              path: 'general',
              pageBuilder: (_, state) => HarpyPage(
                key: state.pageKey,
                restorationId: state.pageKey.value,
                child: const GeneralSettingsPage(),
              ),
            ),
            GoRoute(
              name: LanguageSettingsPage.name,
              path: 'language',
              pageBuilder: (_, state) => HarpyPage(
                key: state.pageKey,
                restorationId: state.pageKey.value,
                child: const LanguageSettingsPage(),
              ),
            ),
          ],
        ),
        GoRoute(
          name: AboutPage.name,
          path: 'about',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const AboutPage(),
          ),
          routes: [
            GoRoute(
              name: ChangelogPage.name,
              path: 'changelog',
              pageBuilder: (_, state) => HarpyPage(
                key: state.pageKey,
                restorationId: state.pageKey.value,
                child: const ChangelogPage(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
  name: 'RoutesProvider',
);
