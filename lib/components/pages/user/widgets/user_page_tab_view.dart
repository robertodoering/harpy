import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class UserPageTabView extends ConsumerWidget {
  const UserPageTabView({
    required this.data,
    required this.isAuthenticatedUser,
    required this.headerSlivers,
  });

  final UserPageData data;
  final bool isAuthenticatedUser;
  final List<Widget> headerSlivers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final canViewProfile = isAuthenticatedUser ||
        !data.user.isProtected ||
        (data.relationship?.following ?? true);

    final children = [
      if (!canViewProfile)
        _ProtectedPlaceholder(data: data)
      else ...[
        UserTimeline(user: data.user),
        MediaTimeline(provider: userTimelineProvider(data.user.id)),
        if (isAuthenticatedUser) const MentionsTimeline(),
        LikesTimeline(user: data.user),
      ],
    ];

    final tabs = [
      HarpyTab(
        icon: const Icon(CupertinoIcons.time),
        text: const Text('timeline'),
        enabled: canViewProfile,
      ),
      HarpyTab(
        icon: const Icon(CupertinoIcons.photo),
        text: const Text('media'),
        enabled: canViewProfile,
      ),
      if (isAuthenticatedUser)
        const HarpyTab(
          icon: Icon(CupertinoIcons.at),
          text: Text('mentions'),
        ),
      HarpyTab(
        icon: const Icon(CupertinoIcons.heart_solid),
        text: const Text('likes'),
        enabled: canViewProfile,
      ),
    ];

    return ScrollDirectionListener(
      depth: 2,
      child: DefaultTabController(
        length: children.length,
        child: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            ...headerSlivers,
            if (data.pinnedTweet != null)
              _PinnedTweetCard(tweet: data.pinnedTweet!),
            SliverToBoxAdapter(
              child: Center(
                child: HarpyTabBar(
                  padding: theme.spacing.only(top: true),
                  tabs: tabs,
                  enabled: canViewProfile,
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

class _PinnedTweetCard extends StatelessWidget {
  const _PinnedTweetCard({
    required this.tweet,
  });

  final LegacyTweetData tweet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: theme.spacing.only(
          start: true,
          end: true,
          top: true,
        ),
        child: TweetCard(
          tweet: tweet,
          config: kDefaultTweetCardConfig.copyWith(
            elements: {
              TweetCardElement.pinned,
              ...kDefaultTweetCardConfig.elements,
            },
          ),
        ),
      ),
    );
  }
}

class _ProtectedPlaceholder extends StatelessWidget {
  const _ProtectedPlaceholder({
    required this.data,
  });

  final UserPageData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: theme.spacing.edgeInsets,
      children: [
        VerticalSpacer.large,
        Icon(
          CupertinoIcons.lock,
          color: theme.colorScheme.primary,
          size: 48,
        ),
        VerticalSpacer.normal,
        Text(
          'these Tweets are protected',
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        VerticalSpacer.normal,
        Text(
          "only confirmed followers have access to @${data.user.handle}'s "
          'Tweets and complete profile',
          style: theme.textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
