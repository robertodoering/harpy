import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar();

  static double height(WidgetRef ref) {
    final theme = Theme.of(ref.context);
    final mediaQuery = MediaQuery.of(ref.context);

    final systemPadding = ref.read(generalPreferencesProvider).bottomAppBar
        ? mediaQuery.padding.bottom
        : mediaQuery.padding.top;

    return HarpyTab.height(ref.context) +
        systemPadding +
        theme.spacing.base / 2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final general = ref.watch(generalPreferencesProvider);

    final topPadding = general.bottomAppBar
        ? 0.0
        : mediaQuery.padding.top + theme.spacing.base / 2;
    final bottomPadding = general.bottomAppBar
        ? mediaQuery.padding.bottom + theme.spacing.base / 2
        : 0.0;

    final padding = EdgeInsetsDirectional.only(
      top: topPadding,
      bottom: bottomPadding,
      start: theme.spacing.base,
      end: theme.spacing.base,
    );

    return Align(
      alignment: general.bottomAppBar
          ? AlignmentDirectional.bottomCenter
          : AlignmentDirectional.topCenter,
      child: general.hideHomeAppBar
          ? _DynamicAppBar(padding: padding)
          : HomeTabBar(padding: padding),
    );
  }
}

class _DynamicAppBar extends ConsumerWidget {
  const _DynamicAppBar({
    required this.padding,
  });

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scrollDirection = UserScrollDirection.scrollDirectionOf(context);
    assert(scrollDirection != null);

    final general = ref.watch(generalPreferencesProvider);

    return AnimatedSlide(
      duration: theme.animation.short,
      curve: Curves.easeInOut,
      offset: scrollDirection == ScrollDirection.reverse
          ? general.bottomAppBar
              ? const Offset(0, 1)
              : const Offset(0, -1)
          : Offset.zero,
      child: HomeTabBar(padding: padding),
    );
  }
}
