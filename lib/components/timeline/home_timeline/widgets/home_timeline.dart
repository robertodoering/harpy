import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';

class HomeTimeline extends ConsumerStatefulWidget {
  const HomeTimeline({
    required this.refreshIndicatorOffset,
    required this.scrollToTopOffset,
  });

  final double refreshIndicatorOffset;
  final double? scrollToTopOffset;

  @override
  ConsumerState<HomeTimeline> createState() => _HomeTimelineState();
}

class _HomeTimelineState extends ConsumerState<HomeTimeline> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeTimelineProvider.notifier).load(clearPrevious: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tweetVisibility = ref.watch(tweetVisibilityPreferencesProvider);

    return Timeline(
      provider: homeTimelineProvider,
      listKey: const PageStorageKey('home_timeline'),
      refreshIndicatorOffset: widget.refreshIndicatorOffset,
      scrollToTopOffset: widget.scrollToTopOffset,
      onUpdatedTweetVisibility: tweetVisibility.updateVisibleTweet,
      beginSlivers: const [
        HomeTopSliverPadding(),
        HomeTimelineTopActions(),
      ],
      endSlivers: const [HomeBottomSliverPadding()],
      onChangeFilter: () => context.pushNamed(HomeTimelineFilter.name),
    );
  }
}
