import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    final mediaQuery = MediaQuery.of(context);
    final configuration = ref.watch(homeTabConfigurationProvider);

    return DefaultTabController(
      length: configuration.visibleEntries.length + 1,
      initialIndex: _indexOffset,
      child: _HomeTabListener(
        child: Stack(
          children: [
            TabBarView(
              physics: HomeTabViewScrollPhysics(
                viewportWidth: mediaQuery.size.width,
              ),
              children: [
                const HomeDrawer(),
                ...configuration.visibleEntries.map(_mapEntryContent),
              ],
            ),
            const HomeAppBar(),
          ],
        ),
      ),
    );
  }
}

class _HomeTabListener extends StatefulWidget {
  const _HomeTabListener({
    required this.child,
  });

  final Widget child;

  @override
  _HomeTabListenerState createState() => _HomeTabListenerState();
}

class _HomeTabListenerState extends State<_HomeTabListener> {
  TabController? _controller;
  UserScrollDirection? _userScrollDirection;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller ??= DefaultTabController.of(context)
      ?..animation?.addListener(_listener);

    _userScrollDirection ??= UserScrollDirection.of(context);

    assert(_controller != null);
    assert(_userScrollDirection != null);
  }

  @override
  void dispose() {
    super.dispose();

    _controller?.animation?.removeListener(_listener);
  }

  void _listener() {
    if (mounted && _userScrollDirection?.direction != ScrollDirection.forward)
      _userScrollDirection?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
