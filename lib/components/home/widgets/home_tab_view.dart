import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class HomeTabView extends ConsumerWidget {
  const HomeTabView();

  static const _indexOffset = 1;

  Widget _mapEntryContent({
    required HomeTabEntry entry,
    required double? refreshIndicatorOffset,
    required double? scrollToTopOffset,
  }) {
    if (entry.type == HomeTabEntryType.defaultType) {
      switch (entry.id) {
        case 'home':
          return HomeTimeline(
            refreshIndicatorOffset: refreshIndicatorOffset,
            scrollToTopOffset: scrollToTopOffset,
          );
        case 'media':
          return const HomeMediaTimeline();
        case 'mentions':
          return MentionsTimeline(
            beginSlivers: const [HomeTopSliverPadding()],
            endSlivers: const [HomeBottomSliverPadding()],
            refreshIndicatorOffset: refreshIndicatorOffset,
            scrollToTopOffset: scrollToTopOffset,
          );
        case 'search':
          return const SearchPageContent(
            beginSlivers: [HomeTopSliverPadding()],
            endSlivers: [HomeBottomSliverPadding()],
          );
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
    final display = ref.watch(displayPreferencesProvider);
    final general = ref.watch(generalPreferencesProvider);
    final configuration = ref.watch(homeTabConfigurationProvider);

    final appbarHeight = HomeAppBar.height(context, ref.read);

    final refreshIndicatorOffset = general.bottomAppBar ? 0.0 : appbarHeight;

    final scrollToTopOffset =
        general.bottomAppBar ? appbarHeight + display.paddingValue : null;

    return DefaultTabController(
      length: configuration.visibleEntries.length + 1,
      initialIndex: _indexOffset,
      child: _HomeTabListener(
        child: Stack(
          children: [
            TabBarView(
              physics: HarpyTabViewScrollPhysics(
                viewportWidth: mediaQuery.size.width,
              ),
              children: [
                const HomeDrawer(),
                ...configuration.visibleEntries.map(
                  (entry) => _mapEntryContent(
                    entry: entry,
                    refreshIndicatorOffset: refreshIndicatorOffset,
                    scrollToTopOffset: scrollToTopOffset,
                  ),
                ),
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
    if (mounted && _userScrollDirection?.direction != ScrollDirection.forward) {
      _userScrollDirection?.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
