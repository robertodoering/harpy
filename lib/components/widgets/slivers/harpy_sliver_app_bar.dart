import 'package:built_collection/built_collection.dart';
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

  BoxDecoration? _decoration({
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final titleStyle = theme.textTheme.titleLarge!.copyWith(height: 1);

    final minExtent =
        mediaQuery.padding.top + theme.spacing.base * 2 + titleStyle.fontSize!;

    return RbySliverAppBar(
      title: title,
      leading: leading,
      actions: actions,
      fittedTitle: fittedTitle,
      backgroundDecoration: _decoration(
        mediaQuery: mediaQuery,
        backgroundColors: harpyTheme.colors.backgroundColors,
        minExtent: minExtent,
      ),
    );
  }
}
