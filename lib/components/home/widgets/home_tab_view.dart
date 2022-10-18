import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class HomeTabView extends ConsumerWidget {
  const HomeTabView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final general = ref.watch(generalPreferencesProvider);
    final configuration = ref.watch(homeTabConfigurationProvider);

    final appbarHeight = HomeAppBar.height(ref);

    final refreshIndicatorOffset = general.bottomAppBar ? 0.0 : appbarHeight;

    final scrollToTopOffset =
        general.bottomAppBar ? appbarHeight + theme.spacing.base : null;

    return HomeTabController(
      length: configuration.visibleEntries.length + 2,
      initialIndex: 1,
      child: _HomeTabListener(
        child: Stack(
          children: [
            Builder(
              builder: (context) => FloatingComposeButton(
                child: TabBarView(
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
            ),
            const HomeAppBar(),
          ],
        ),
      ),
    );
  }
}

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
        );
      case 'media':
        return HomeMediaTimeline(
          scrollToTopOffset: scrollToTopOffset,
        );
      case 'mentions':
        return MentionsTimeline(
          beginSlivers: const [HomeTopSliverPadding()],
          endSlivers: const [HomeBottomSliverPadding()],
          refreshIndicatorOffset: refreshIndicatorOffset,
          scrollToTopOffset: scrollToTopOffset,
        );
      case 'search':
        return SearchPageContent(
          beginSlivers: const [HomeTopSliverPadding()],
          endSlivers: const [HomeBottomSliverPadding()],
          scrollToTopOffset: scrollToTopOffset,
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
      refreshIndicatorOffset: refreshIndicatorOffset,
      scrollToTopOffset: scrollToTopOffset,
    );
  } else {
    return const SizedBox();
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

    _controller ??= HomeTabController.of(context)
      ?..animation?.addListener(_listener);

    _userScrollDirection ??= UserScrollDirection.of(context)!;
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
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _userScrollDirection?.forward(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
