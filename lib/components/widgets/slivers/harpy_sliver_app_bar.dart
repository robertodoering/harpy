import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class HarpySliverAppBar extends ConsumerWidget {
  const HarpySliverAppBar({
    this.title,
    this.leading,
    this.actions,
    this.fittedTitle = true,
    super.key,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool fittedTitle;

  BoxDecoration _decoration({
    required MediaQueryData mediaQuery,
    required BuiltList<Color> backgroundColors,
    required double minExtent,
  }) {
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
        begin: AlignmentDirectional.topCenter,
        end: AlignmentDirectional.bottomCenter,
      ),
    );
  }

  static double height(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final style = theme.textTheme.titleLarge!.copyWith(height: 1);

    return mediaQuery.padding.top + theme.spacing.base * 2 + style.fontSize!;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final style = theme.textTheme.titleLarge!.copyWith(height: 1);
    final minExtent =
        mediaQuery.padding.top + theme.spacing.base * 2 + style.fontSize!;

    return SliverPersistentHeader(
      floating: true,
      delegate: _SliverHeaderDelegate(
        title: title,
        leading: leading,
        actions: actions,
        backgroundDecoration: _decoration(
          mediaQuery: mediaQuery,
          backgroundColors: harpyTheme.colors.backgroundColors,
          minExtent: minExtent,
        ),
        topPadding: mediaQuery.padding.top,
        paddingValue: theme.spacing.base,
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
    required this.backgroundDecoration,
    required this.topPadding,
    required this.paddingValue,
    required this.titleStyle,
    required this.fittedTitle,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final BoxDecoration backgroundDecoration;
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
        oldDelegate.backgroundDecoration != backgroundDecoration ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.paddingValue != paddingValue ||
        oldDelegate.titleStyle != titleStyle ||
        oldDelegate.fittedTitle != oldDelegate.fittedTitle;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: theme.animation.short,
      width: double.infinity,
      decoration: backgroundDecoration,
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: EdgeInsetsDirectional.only(top: topPadding),
          child: NavigationToolbar(
            leading: _leading(
              context,
              leading: leading,
              paddingValue: paddingValue,
            ),
            middle: title != null
                ? DefaultTextStyle(
                    style: titleStyle,
                    child: fittedTitle ? FittedBox(child: title) : title!,
                  )
                : null,
            trailing: _trailing(
              context,
              actions: actions,
              paddingValue: paddingValue,
            ),
            middleSpacing: paddingValue / 2,
          ),
        ),
      ),
    );
  }
}

Widget? _leading(
  BuildContext context, {
  required Widget? leading,
  required double paddingValue,
}) {
  final theme = Theme.of(context);
  final route = ModalRoute.of(context);

  Widget? child;

  if (leading != null) {
    child = leading;
  } else if (Scaffold.of(context).hasDrawer) {
    child = RbyButton.transparent(
      icon: theme.iconData.drawer(context),
      onTap: Scaffold.of(context).openDrawer,
    );
  } else if (route is PageRoute<dynamic> && route.fullscreenDialog) {
    child = RbyButton.transparent(
      icon: theme.iconData.close(context),
      onTap: Navigator.of(context).pop,
    );
  } else if (Navigator.of(context).canPop()) {
    child = RbyButton.transparent(
      icon: theme.iconData.back(context),
      onTap: Navigator.of(context).pop,
    );
  }

  if (child == null) return null;

  return Padding(
    padding: EdgeInsetsDirectional.only(start: paddingValue),
    child: child,
  );
}

Widget? _trailing(
  BuildContext context, {
  required List<Widget>? actions,
  required double paddingValue,
}) {
  final theme = Theme.of(context);

  Widget? child;

  if (actions != null) {
    child = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: actions,
    );
  } else if (Scaffold.of(context).hasEndDrawer) {
    child = RbyButton.transparent(
      icon: theme.iconData.drawer(context),
      onTap: Scaffold.of(context).openEndDrawer,
    );
  }

  if (child == null) return null;

  return Padding(
    padding: EdgeInsetsDirectional.only(end: paddingValue),
    child: child,
  );
}
