import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class HomeTabView extends ConsumerWidget {
  const HomeTabView();

  static const _indexOffset = 1;

  Widget _mapEntryContent(
    int index,
    HomeTabEntry entry,
    double refreshIndicatorOffset,
  ) {
    if (entry.type == HomeTabEntryType.defaultType) {
      switch (entry.id) {
        case 'home':
          // return HomeTimeline(refreshIndicatorOffset: refreshIndicatorOffset);
          return const HomeTimeline();
        case 'media':
        // return const HomeMediaTimeline();
        case 'mentions':
        // return MentionsTimeline(
        //   indexInTabView: index + _indexOffset,
        //   beginSlivers: const [HomeTopSliverPadding()],
        //   endSlivers: const [HomeBottomSliverPadding()],
        //   refreshIndicatorOffset: refreshIndicatorOffset,
        // );
        case 'search':
        // return const SearchScreenContent(
        //   beginSlivers: [HomeTopSliverPadding()],
        //   endSlivers: [HomeBottomSliverPadding()],
        // );
        default:
          return const SizedBox();
      }
    } else if (entry.type == HomeTabEntryType.list) {
      // return HomeListTimeline(
      //   listId: entry.id,
      //   listName: entry.name ?? 'list',
      // );
      return const SizedBox();
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configuration = ref.watch(homeTabConfigurationProvider);
    final display = ref.watch(displayPreferencesProvider);
    final general = ref.watch(generalPreferencesProvider);

    final refreshIndicatorOffset = general.bottomAppBar
        ? 0.0
        : HomeAppBar.height(context, general: general, display: display) +
            display.paddingValue;

    // TODO: try nested scroll view
    // return DefaultTabController(
    //   length: configuration.visibleEntries.length + 1,
    //   initialIndex: _indexOffset,
    //   child: NestedScrollView(
    //     headerSliverBuilder: (context, _) => [
    //       const HarpySliverAppBar(title: 'home'),
    //     ],
    //     body: TabBarView(
    //       physics: const HomeTabViewScrollPhysics(),
    //       children: [
    //         const HomeDrawer(),
    //         for (var i = 0; i < configuration.visibleEntries.length; i++)
    //           _mapEntryContent(
    //             i,
    //             configuration.visibleEntries[i],
    //             refreshIndicatorOffset,
    //           ),
    //       ],
    //     ),
    //   ),
    // );

    return DefaultTabController(
      length: configuration.visibleEntries.length + 1,
      initialIndex: _indexOffset,
      child: Stack(
        children: [
          TabBarView(
            physics: const HomeTabViewScrollPhysics(),
            children: [
              const HomeDrawer(),
              for (var i = 0; i < configuration.visibleEntries.length; i++)
                _mapEntryContent(
                  i,
                  configuration.visibleEntries[i],
                  refreshIndicatorOffset,
                ),
            ],
          ),
          const HomeAppBar(),
        ],
      ),
    );
  }
}
