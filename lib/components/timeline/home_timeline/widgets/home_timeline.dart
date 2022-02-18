import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class HomeTimeline extends ConsumerWidget {
  const HomeTimeline();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final general = ref.watch(generalPreferencesProvider);

    final appbarHeight =
        HomeAppBar.height(context, general: general, display: display);

    final refreshIndicatorOffset =
        general.bottomAppBar ? 0.0 : appbarHeight + display.paddingValue;

    final scrollToTopOffset =
        general.bottomAppBar ? appbarHeight + display.paddingValue : null;

    return Timeline(
      provider: homeTimelineProvider,
      refreshIndicatorOffset: refreshIndicatorOffset,
      scrollToTopOffset: scrollToTopOffset,
      beginSlivers: const [
        HomeTopSliverPadding(),
        HomeTimelineTopActions(),
      ],
      endSlivers: const [HomeBottomSliverPadding()],
      // TODO: use onFinishLayout to remember tweet visibility?
      // TODO: open filter selection
      // onChangeFilter: () => ,
    );
  }
}
