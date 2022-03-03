import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    this.fittedTitle = true,
    Key? key,
  }) : super(key: key);

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool fittedTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);
    final display = ref.watch(displayPreferencesProvider);
    final topPadding = MediaQuery.of(context).padding.top;

    final style = Theme.of(context).textTheme.titleLarge!.copyWith(height: 1);

    return SliverPersistentHeader(
      floating: true,
      delegate: _SliverHeaderDelegate(
        title: title,
        leading: leading,
        actions: actions,
        backgroundColors: harpyTheme.colors.backgroundColors,
        topPadding: topPadding,
        paddingValue: display.paddingValue,
        titleStyle: style,
        fittedTitle: fittedTitle,
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _SliverHeaderDelegate({
    required this.title,
    required this.leading,
    required this.actions,
    required this.backgroundColors,
    required this.topPadding,
    required this.paddingValue,
    required this.titleStyle,
    required this.fittedTitle,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final BuiltList<Color> backgroundColors;
  final double topPadding;
  final double paddingValue;
  final TextStyle titleStyle;
  final bool fittedTitle;

  @override
  double get minExtent => topPadding + paddingValue * 2 + titleStyle.fontSize!;

  @override
  double get maxExtent => minExtent;

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) {
    return oldDelegate.title != title ||
        oldDelegate.leading != leading ||
        !listEquals(oldDelegate.actions, actions) ||
        oldDelegate.backgroundColors != backgroundColors ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.paddingValue != paddingValue ||
        oldDelegate.titleStyle != titleStyle ||
        oldDelegate.fittedTitle != oldDelegate.fittedTitle;
  }

  Widget? _leading(BuildContext context) {
    final route = ModalRoute.of(context);

    Widget? child;

    if (leading != null) {
      child = leading;
    } else if (Scaffold.of(context).hasDrawer) {
      child = HarpyButton.icon(
        icon: const RotatedBox(
          quarterTurns: 1,
          child: Icon(FeatherIcons.barChart2),
        ),
        onTap: Scaffold.of(context).openDrawer,
      );
    } else if (route is PageRoute<dynamic> && route.fullscreenDialog) {
      child = HarpyButton.icon(
        icon: const Icon(CupertinoIcons.xmark),
        onTap: Navigator.of(context).maybePop,
      );
    } else if (Navigator.of(context).canPop()) {
      child = HarpyButton.icon(
        icon: Transform.translate(
          offset: const Offset(-1, 0),
          child: const Icon(CupertinoIcons.left_chevron),
        ),
        onTap: Navigator.of(context).maybePop,
      );
    }

    if (child != null) {
      return Padding(
        padding: EdgeInsets.only(left: paddingValue / 2),
        child: child,
      );
    } else {
      return null;
    }
  }

  Widget? _trailing(BuildContext context) {
    Widget? child;

    if (actions != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: actions!,
      );
    } else if (Scaffold.of(context).hasEndDrawer) {
      child = HarpyButton.icon(
        icon: const RotatedBox(
          quarterTurns: -1,
          child: Icon(FeatherIcons.barChart2),
        ),
        onTap: Scaffold.of(context).openEndDrawer,
      );
    }

    if (child != null) {
      return Padding(
        padding: EdgeInsets.only(right: paddingValue / 2),
        child: child,
      );
    } else {
      return null;
    }
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
          child: NavigationToolbar(
            leading: _leading(context),
            middle: title != null
                ? DefaultTextStyle(
                    style: titleStyle,
                    child: fittedTitle ? FittedBox(child: title) : title!,
                  )
                : null,
            trailing: _trailing(context),
            middleSpacing: paddingValue / 2,
          ),
        ),
      ),
    );
  }
}
