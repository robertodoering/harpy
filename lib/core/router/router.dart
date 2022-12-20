import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

final routeObserver = Provider(
  name: 'RouteObserver',
  (ref) => RouteObserver(),
);

final routerProvider = Provider(
  name: 'RouterProvider',
  (ref) => GoRouter(
    routes: ref.watch(routesProvider),
    redirect: (state) => handleRedirect(ref, state),
    errorPageBuilder: (_, state) => RbyPage(
      pageRouteType: PageRouteType.fade,
      builder: (_) => ErrorPage(error: state.error),
    ),
    observers: [
      ref.watch(routeObserver),
      ref.watch(videoAutopauseObserver),
    ],
  ),
);

final routesProvider = Provider(
  name: 'RoutesProvider',
  (ref) => [
    GoRoute(
      name: SplashPage.name,
      path: SplashPage.path, // '/splash'
      pageBuilder: (_, state) => _createPage(
        state: state,
        child: SplashPage(
          redirect: state.queryParams['redirect'],
        ),
      ),
    ),
    GoRoute(
      name: LoginPage.name,
      path: LoginPage.path, // '/login'
      pageBuilder: (_, state) => _createPage(
        state: state,
        child: const LoginPage(),
      ),
      routes: [
        GoRoute(
          name: CustomApiPage.name,
          path: CustomApiPage.path, // 'custom_api'
          pageBuilder: (_, state) => _createPage(
            state: state,
            fullscreenDialog: true,
            child: const CustomApiPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      name: WebviewPage.name,
      path: '/webview',
      pageBuilder: (_, state) => _createPage(
        state: state,
        fullscreenDialog: true,
        child: WebviewPage(
          initialUrl: state.queryParams['initialUrl']!,
        ),
      ),
    ),
    GoRoute(
      name: AboutPage.name,
      path: AboutPage.path, // '/about_harpy'
      pageBuilder: (_, state) => _createPage(
        state: state,
        child: const AboutPage(),
      ),
      routes: [
        GoRoute(
          name: ChangelogPage.name,
          path: 'changelog',
          pageBuilder: (_, state) => _createPage(
            state: state,
            child: const ChangelogPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      name: SetupPage.name,
      path: '/setup',
      pageBuilder: (_, state) => _createPage(
        state: state,
        child: const SetupPage(),
      ),
    ),
    GoRoute(
      name: HomePage.name,
      path: '/',
      pageBuilder: (_, state) => _createPage(
        state: state,
        child: const HomePage(),
      ),
      routes: [
        GoRoute(
          name: UserPage.name,
          path: 'user/:handle',
          pageBuilder: (_, state) => _createPage(
            state: state,
            child: UserPage(handle: state.params['handle']!),
          ),
          routes: [
            GoRoute(
              name: FollowingPage.name,
              path: 'following',
              pageBuilder: (_, state) => _createPage(
                state: state,
                child: FollowingPage(handle: state.params['handle']!),
              ),
            ),
            GoRoute(
              name: FollowersPage.name,
              path: 'followers',
              pageBuilder: (_, state) => _createPage(
                state: state,
                child: FollowersPage(userId: state.params['handle']!),
              ),
            ),
            GoRoute(
              name: ListShowPage.name,
              path: 'lists',
              pageBuilder: (_, state) => _createPage(
                state: state,
                child: ListShowPage(
                  handle: state.params['handle']!,
                  onListSelected: state.extra as ValueChanged<TwitterListData>?,
                ),
              ),
            ),
            GoRoute(
              name: UserTimelineFilter.name,
              path: 'filter',
              pageBuilder: (_, state) => _createPage(
                state: state,
                fullscreenDialog: true,
                child: UserTimelineFilter(user: state.extra! as UserData),
              ),
            ),
            GoRoute(
              name: TweetDetailPage.name,
              path: 'status/:id',
              pageBuilder: (_, state) => _createPage(
                state: state,
                child: TweetDetailPage(
                  id: state.params['id']!,
                  tweet: state.extra as LegacyTweetData?,
                ),
              ),
              routes: [
                GoRoute(
                  name: RetweetersPage.name,
                  path: 'retweets',
                  pageBuilder: (_, state) => _createPage(
                    state: state,
                    fullscreenDialog: true,
                    child: RetweetersPage(tweetId: state.params['id']!),
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: HomeTimelineFilter.name,
          path: 'filter',
          pageBuilder: (_, state) => _createPage(
            state: state,
            fullscreenDialog: true,
            child: const HomeTimelineFilter(),
          ),
          routes: [
            GoRoute(
              name: TimelineFilterCreation.name,
              path: 'create',
              pageBuilder: (_, state) => _createPage(
                state: state,
                fullscreenDialog: true,
                child: TimelineFilterCreation(
                  initialTimelineFilter: (state.extra
                      as Map?)?['initialTimelineFilter'] as TimelineFilter?,
                  onSaved: (state.extra as Map?)?['onSaved']
                      as ValueChanged<TimelineFilter>?,
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          name: SearchPage.name,
          // unique path to prevent the same as the existing twitter path
          path: 'harpy_search',
          pageBuilder: (_, state) => _createPage(
            state: state,
            child: const SearchPage(),
          ),
          routes: [
            GoRoute(
              name: UserSearchPage.name,
              path: 'users',
              pageBuilder: (_, state) => _createPage(
                state: state,
                child: const UserSearchPage(),
              ),
            ),
            GoRoute(
              name: TweetSearchPage.name,
              path: 'tweets',
              pageBuilder: (_, state) => _createPage(
                state: state,
                child: TweetSearchPage(
                  initialQuery: state.queryParams['query'],
                ),
              ),
              routes: [
                GoRoute(
                  name: TweetSearchFilter.name,
                  path: 'filter',
                  pageBuilder: (_, state) => _createPage(
                    state: state,
                    fullscreenDialog: true,
                    child: TweetSearchFilter(
                      initialFilter: (state.extra as Map?)?['initialFilter']
                          as TweetSearchFilterData?,
                      onSaved: (state.extra as Map?)?['onSaved']
                          as ValueChanged<TweetSearchFilterData>?,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: ListTimelinePage.name,
          path: 'i/lists/:listId',
          pageBuilder: (_, state) => _createPage(
            state: state,
            child: ListTimelinePage(
              listId: state.params['listId']!,
              listName: state.queryParams['name']!,
            ),
          ),
          routes: [
            GoRoute(
              name: ListMembersPage.name,
              path: 'members',
              pageBuilder: (_, state) => _createPage(
                state: state,
                child: ListMembersPage(
                  listId: state.params['listId']!,
                  listName: state.queryParams['name']!,
                ),
              ),
            ),
            GoRoute(
              name: ListTimelineFilter.name,
              path: 'filter',
              pageBuilder: (_, state) => _createPage(
                state: state,
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
          name: ComposePage.name,
          path: 'compose/tweet',
          pageBuilder: (_, state) => _createPage(
            state: state,
            child: ComposePage(
              parentTweet:
                  (state.extra as Map?)?['parentTweet'] as LegacyTweetData?,
              quotedTweet:
                  (state.extra as Map?)?['quotedTweet'] as LegacyTweetData?,
            ),
          ),
        ),
        GoRoute(
          name: SettingsPage.name,
          path: 'settings',
          pageBuilder: (_, state) => _createPage(
            state: state,
            child: const SettingsPage(),
          ),
          routes: [
            GoRoute(
              name: MediaSettingsPage.name,
              path: 'media',
              pageBuilder: (_, state) => _createPage(
                state: state,
                child: const MediaSettingsPage(),
              ),
            ),
            GoRoute(
              name: ThemeSettingsPage.name,
              path: 'theme',
              pageBuilder: (_, state) => _createPage(
                state: state,
                child: const ThemeSettingsPage(),
              ),
              routes: [
                GoRoute(
                  name: CustomThemePage.name,
                  path: 'custom',
                  pageBuilder: (_, state) => _createPage(
                    state: state,
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
              pageBuilder: (_, state) => _createPage(
                state: state,
                child: const DisplaySettingsPage(),
              ),
              routes: [
                GoRoute(
                  name: FontSelectionPage.name,
                  path: 'font',
                  pageBuilder: (_, state) => _createPage(
                    state: state,
                    child: FontSelectionPage(
                      title: (state.extra as Map?)?['title'] as String,
                      selectedFont:
                          (state.extra as Map?)?['selectedFont'] as String,
                      onChanged: (state.extra as Map?)?['onChanged']
                          as ValueChanged<String>,
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              name: GeneralSettingsPage.name,
              path: 'general',
              pageBuilder: (_, state) => _createPage(
                state: state,
                child: const GeneralSettingsPage(),
              ),
            ),
            GoRoute(
              name: LanguageSettingsPage.name,
              path: 'language',
              pageBuilder: (_, state) => _createPage(
                state: state,
                child: const LanguageSettingsPage(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

RbyPage<T> _createPage<T>({
  required Widget child,
  required GoRouterState state,
  bool fullscreenDialog = false,
}) {
  final pageRouteType = state.queryParams['transition'] == 'fade'
      ? PageRouteType.fade
      : PageRouteType.slide;

  return RbyPage(
    key: ValueKey(state.location),
    restorationId: state.location,
    pageRouteType: pageRouteType,
    fullscreenDialog: fullscreenDialog,
    builder: (_) => child,
  );
}
