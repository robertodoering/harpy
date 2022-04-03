import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class HomeTabView extends ConsumerWidget {
  const HomeTabView();

  static const _indexOffset = 1;

  Widget _mapEntryContent({
    required int index,
    required HomeTabEntry entry,
    required double refreshIndicatorOffset,
    required double? scrollToTopOffset,
  }) {
    if (entry.type == HomeTabEntryType.defaultType) {
      switch (entry.id) {
        case 'home':
          return HomeTimeline(
            refreshIndicatorOffset: refreshIndicatorOffset,
            scrollToTopOffset: scrollToTopOffset,
            scrollPosition: index,
          );
        case 'media':
          return HomeMediaTimeline(
            scrollPosition: index,
          );
        case 'mentions':
          return MentionsTimeline(
            beginSlivers: const [HomeTopSliverPadding()],
            endSlivers: const [HomeBottomSliverPadding()],
            refreshIndicatorOffset: refreshIndicatorOffset,
            scrollToTopOffset: scrollToTopOffset,
            scrollPosition: index,
          );
        case 'search':
          return SearchPageContent(
            beginSlivers: const [HomeTopSliverPadding()],
            endSlivers: const [HomeBottomSliverPadding()],
            scrollPosition: index,
          );
        default:
          return const SizedBox();
      }
    } else if (entry.type == HomeTabEntryType.list) {
      return ListTimeline(
        listId: entry.id,
        listName: entry.name,
        beginSlivers: const [HomeTopSliverPadding()],
        endSlivers: const [HomeBottomSliverPadding()],
      );
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

    return HomeTabController(
      length: configuration.visibleEntries.length + 2,
      initialIndex: _indexOffset,
      child: _HomeTabListener(
        child: Stack(
          children: [
            Builder(
              builder: (context) => TabBarView(
                controller: HomeTabController.of(context),
                physics: HarpyTabViewScrollPhysics(
                  viewportWidth: mediaQuery.size.width,
                ),
                children: [
                  const HomeDrawer(),
                  ...configuration.visibleEntries.mapIndexed(
                    (index, entry) => _mapEntryContent(
                      index: index,
                      entry: entry,
                      refreshIndicatorOffset: refreshIndicatorOffset,
                      scrollToTopOffset: scrollToTopOffset,
                    ),
                  ),
                  const HomeTabCustomization(),
                ],
              ),
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

    if (_controller == null) {
      _controller = HomeTabController.of(context)
        ?..animation?.addListener(_listener);

      assert(_controller != null);
    }

    _userScrollDirection ??= UserScrollDirection.of(context);

    assert(_userScrollDirection != null);
  }

  @override
  void dispose() {
    super.dispose();

    _controller?.animation?.removeListener(_listener);
  }

  void _listener() {
    if (mounted && _userScrollDirection?.direction != ScrollDirection.forward) {
      // prevent the list card animation from triggering when navigating between
      // tabs and show the tab bar
      WidgetsBinding.instance!.addPostFrameCallback(
        (_) => _userScrollDirection?.forward(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
