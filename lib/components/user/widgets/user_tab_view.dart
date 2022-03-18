import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class UserTabView extends ConsumerWidget {
  const UserTabView({
    required this.user,
    required this.headerSlivers,
  });

  final UserData user;
  final List<Widget> headerSlivers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final display = ref.watch(displayPreferencesProvider);
    final authenticatedUser = ref.watch(authenticationStateProvider).user;

    final isAuthenticatedUser = user.id == authenticatedUser?.id;

    final children = [
      UserTimeline(user: user, scrollPosition: 0),
      MediaTimeline(provider: userTimelineProvider(user.id), scrollPosition: 1),
      if (isAuthenticatedUser) const MentionsTimeline(scrollPosition: 2),
      LikesTimeline(user: user, scrollPosition: isAuthenticatedUser ? 3 : 2),
    ];

    final tabs = [
      const HarpyTab(
        icon: Icon(CupertinoIcons.time),
        text: Text('timeline'),
      ),
      const HarpyTab(
        icon: Icon(CupertinoIcons.photo),
        text: Text('media'),
      ),
      if (isAuthenticatedUser)
        const HarpyTab(
          icon: Icon(CupertinoIcons.at),
          text: Text('mentions'),
        ),
      const HarpyTab(
        icon: Icon(CupertinoIcons.heart_solid),
        text: Text('likes'),
      ),
    ];

    return ScrollDirectionListener(
      depth: 2,
      child: DefaultTabController(
        length: children.length,
        child: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            ...headerSlivers,
            SliverToBoxAdapter(
              child: Center(
                child: HarpyTabBar(
                  padding: display.edgeInsetsOnly(top: true),
                  tabs: tabs,
                ),
              ),
            ),
          ],
          body: TabBarView(
            physics: HarpyTabViewScrollPhysics(
              viewportWidth: mediaQuery.size.width,
            ),
            children: children,
          ),
        ),
      ),
    );
  }
}
