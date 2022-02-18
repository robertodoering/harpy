import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class HomeTabView extends ConsumerWidget {
  const HomeTabView();

  static const _indexOffset = 1;

  Widget _mapEntryContent(HomeTabEntry entry) {
    if (entry.type == HomeTabEntryType.defaultType) {
      switch (entry.id) {
        case 'home':
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

    return DefaultTabController(
      length: configuration.visibleEntries.length + 1,
      initialIndex: _indexOffset,
      child: Stack(
        children: [
          TabBarView(
            physics: const HomeTabViewScrollPhysics(),
            children: [
              const HomeDrawer(),
              ...configuration.visibleEntries.map(_mapEntryContent),
            ],
          ),
          const HomeAppBar(),
        ],
      ),
    );
  }
}
