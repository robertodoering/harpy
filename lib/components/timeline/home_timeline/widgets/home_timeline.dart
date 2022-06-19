import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

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
      ref.read(homeTimelineProvider.notifier).loadInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final general = ref.watch(generalPreferencesProvider);
    final tweetVisibility = ref.watch(tweetVisibilityPreferencesProvider);

    return Timeline(
      provider: homeTimelineProvider,
      listKey: general.restoreScrollPositions
          ? const PageStorageKey('home_timeline')
          : null,
      refreshIndicatorOffset: widget.refreshIndicatorOffset,
      scrollToTopOffset: widget.scrollToTopOffset,
      onUpdatedTweetVisibility: tweetVisibility.updateVisibleTweet,
      beginSlivers: const [
        HomeTopSliverPadding(),
        HomeTimelineTopActions(),
      ],
      endSlivers: const [HomeBottomSliverPadding()],
      onChangeFilter: () => router.pushNamed(HomeTimelineFilter.name),
    );
  }
}
