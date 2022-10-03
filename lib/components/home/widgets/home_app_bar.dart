import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar();

  static double height(WidgetRef ref) {
    final mediaQuery = MediaQuery.of(ref.context);
    final display = ref.read(displayPreferencesProvider);

    final systemPadding = ref.read(generalPreferencesProvider).bottomAppBar
        ? mediaQuery.padding.bottom
        : mediaQuery.padding.top;

    return HarpyTab.height(ref.context, display) +
        systemPadding +
        display.paddingValue / 2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final display = ref.watch(displayPreferencesProvider);
    final general = ref.watch(generalPreferencesProvider);

    final topPadding = general.bottomAppBar
        ? 0.0
        : mediaQuery.padding.top + display.paddingValue / 2;
    final bottomPadding = general.bottomAppBar
        ? mediaQuery.padding.bottom + display.paddingValue / 2
        : 0.0;

    final padding = EdgeInsetsDirectional.only(
      top: topPadding,
      bottom: bottomPadding,
      start: display.paddingValue,
      end: display.paddingValue,
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
    final scrollDirection = UserScrollDirection.scrollDirectionOf(context);
    assert(scrollDirection != null);

    final general = ref.watch(generalPreferencesProvider);

    return AnimatedSlide(
      duration: kShortAnimationDuration,
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
