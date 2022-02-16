import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// A custom alternative [SliverAppBar] used in harpy.
///
/// Builds a translucent background gradient that matches the background
/// gradient of the currently selected harpy theme.
class HarpySliverAppBar extends ConsumerWidget {
  const HarpySliverAppBar({
    this.title,
    this.leading,
    this.actions,
    this.floating = true,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool floating;

  Widget? _leading(BuildContext context) {
    final route = ModalRoute.of(context);

    if (leading != null)
      return leading;
    else if (Scaffold.of(context).hasDrawer)
      return IconButton(
        icon: const RotatedBox(
          quarterTurns: 1,
          child: Icon(FeatherIcons.barChart2),
        ),
        onPressed: Scaffold.of(context).openDrawer,
      );
    else if (route is PageRoute<dynamic> && route.fullscreenDialog)
      return IconButton(
        icon: const Icon(CupertinoIcons.xmark),
        onPressed: Navigator.of(context).maybePop,
      );
    else if (Navigator.of(context).canPop())
      return IconButton(
        icon: Transform.translate(
          offset: const Offset(-1, 0),
          child: const Icon(CupertinoIcons.left_chevron),
        ),
        onPressed: Navigator.of(context).maybePop,
      );
    else
      return null;
  }

  Widget? _trailing(BuildContext context) {
    if (actions != null)
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: actions!,
      );
    else if (Scaffold.of(context).hasEndDrawer)
      return IconButton(
        icon: const RotatedBox(
          quarterTurns: -1,
          child: Icon(FeatherIcons.barChart2),
        ),
        onPressed: Scaffold.of(context).openEndDrawer,
      );
    else
      return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);
    final display = ref.watch(displayPreferencesProvider);
    final topPadding = MediaQuery.of(context).padding.top;

    final style = Theme.of(context).textTheme.titleLarge!.copyWith(height: 1);

    return SliverPersistentHeader(
      floating: true,
      delegate: _SliverHeaderDelegate(
        backgroundColors: harpyTheme.colors.backgroundColors,
        topPadding: topPadding,
        contentPadding: display.paddingValue,
        titleStyle: style,
        child: NavigationToolbar(
          leading: _leading(context),
          middle: title != null
              ? FittedBox(child: Text(title!, style: style))
              : null,
          trailing: _trailing(context),
          middleSpacing: display.paddingValue,
        ),
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _SliverHeaderDelegate({
    required this.backgroundColors,
    required this.topPadding,
    required this.contentPadding,
    required this.titleStyle,
    required this.child,
  });

  final BuiltList<Color> backgroundColors;
  final double topPadding;
  final double contentPadding;
  final TextStyle titleStyle;
  final Widget child;

  @override
  double get minExtent =>
      topPadding + contentPadding * 2 + titleStyle.fontSize!;

  @override
  double get maxExtent => minExtent;

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) {
    return oldDelegate.backgroundColors != backgroundColors ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.contentPadding != contentPadding ||
        oldDelegate.titleStyle != titleStyle ||
        oldDelegate.child != oldDelegate.child;
  }

  Decoration? _decoration(MediaQueryData mediaQuery) {
    Color begin;
    Color end;

    if (backgroundColors.length == 1) {
      begin = backgroundColors.single;
      end = backgroundColors.single;
    } else {
      begin = backgroundColors.first;

      end = Color.lerp(
        backgroundColors[0],
        backgroundColors[1],
        // min extend / mediaQuery.size * count of background colors minus the
        // first one
        minExtent / mediaQuery.size.height * (backgroundColors.length - 1),
      )!;
    }

    return BoxDecoration(
      gradient: LinearGradient(
        colors: [begin.withOpacity(.8), end.withOpacity(.8)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final mediaQuery = MediaQuery.of(context);

    return AnimatedContainer(
      duration: kShortAnimationDuration,
      width: double.infinity,
      decoration: _decoration(mediaQuery),
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: child,
        ),
      ),
    );
  }
}
