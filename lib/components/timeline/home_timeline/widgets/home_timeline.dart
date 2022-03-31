import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class HomeTimeline extends ConsumerWidget {
  const HomeTimeline({
    required this.refreshIndicatorOffset,
    required this.scrollToTopOffset,
    required this.scrollPosition,
  });

  final double refreshIndicatorOffset;
  final double? scrollToTopOffset;
  final int scrollPosition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final tweetVisibility = ref.watch(tweetVisibilityPreferencesProvider);

    return Timeline(
      provider: homeTimelineProvider,
      refreshIndicatorOffset: refreshIndicatorOffset,
      scrollToTopOffset: scrollToTopOffset,
      onUpdatedTweetVisibility: tweetVisibility.updateVisibleTweet,
      beginSlivers: const [
        HomeTopSliverPadding(),
        HomeTimelineTopActions(),
      ],
      endSlivers: const [HomeBottomSliverPadding()],
      onChangeFilter: () => router.pushNamed(HomeTimelineFilter.name),
      scrollPosition: scrollPosition,
    );
  }
}
