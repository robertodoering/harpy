import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Builds a [SliverAppBar] with an optional background.
///
/// When a [background] is provided, a [FlexibleSpaceBar] will be built behind
/// the [AppBar].
class HarpySliverAppBar extends StatelessWidget {
  const HarpySliverAppBar({
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showIcon = false,
    this.floating = false,
    this.stretch = false,
    this.pinned = false,
    this.snap = false,
    this.background,
    this.bottom,
  });

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showIcon;
  final bool floating;
  final bool stretch;
  final bool pinned;
  final bool snap;
  final Widget? background;
  final PreferredSizeWidget? bottom;

  Widget _buildTitle(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (titleWidget != null) Expanded(child: titleWidget!),
        if (title != null)
          Flexible(
            child: FittedBox(
              child: Text(
                title ?? '',
                style: theme.textTheme.headline6,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
          ),
        if (showIcon) ...[
          const SizedBox(width: 4),
          const FlareIcon.harpyLogo(size: 24),
        ],
      ],
    );
  }

  Widget _buildFlexibleSpace(ThemeData theme) {
    return FlexibleSpaceBar(
      // padding to prevent the text to get below the back arrow
      titlePadding: const EdgeInsets.only(left: 54, right: 54, bottom: 16),
      centerTitle: true,
      title: _buildTitle(theme),
      background: background,
      stretchModes: const [
        StretchMode.zoomBackground,
        StretchMode.fadeTitle,
      ],
    );
  }

  /// Builds a decoration for the app bar with a gradient matching the
  /// background.
  Decoration _buildDecoration(
    HarpyTheme harpyTheme,
    MediaQueryData mediaQuery,
    double minExtend,
  ) {
    Color? end;

    if (harpyTheme.backgroundColors.length == 1) {
      end = harpyTheme.backgroundColors.first;
    } else {
      // min extend / mediaQuery.size * count of background colors minus the
      // first one
      final t = minExtend /
          mediaQuery.size.height *
          (harpyTheme.backgroundColors.length - 1);

      end = Color.lerp(
        harpyTheme.backgroundColors[0],
        harpyTheme.backgroundColors[1],
        t,
      );
    }

    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          harpyTheme.backgroundColors.first.withOpacity(.8),
          end!.withOpacity(.8),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Widget? _leading(BuildContext context) {
    final parentRoute = ModalRoute.of(context);

    if (leading != null) {
      return leading;
    } else if (Scaffold.of(context).hasDrawer) {
      return const DrawerButton();
    } else if (parentRoute is PageRoute<dynamic> &&
        parentRoute.fullscreenDialog) {
      return const _CloseButton();
    } else if (Navigator.of(context).canPop()) {
      return const HarpyBackButton();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final harpyTheme = context.watch<HarpyTheme>();

    // whether a flexible space widget should be built for the sliver app bar
    final hasFlexibleSpace = background != null;

    final expandedHeight = min<double>(200, mediaQuery.size.height * .25);

    return CustomSliverAppBar(
      decorationBuilder: (minExtend, maxExtend) =>
          _buildDecoration(harpyTheme, mediaQuery, minExtend),
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      floating: floating,
      stretch: stretch,
      pinned: pinned,
      snap: snap,
      title: hasFlexibleSpace ? null : _buildTitle(theme),
      actions: actions,
      leading: _leading(context),
      automaticallyImplyLeading: false,
      flexibleSpace: hasFlexibleSpace ? _buildFlexibleSpace(theme) : null,
      expandedHeight: hasFlexibleSpace ? expandedHeight : null,
      bottom: bottom,
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return HarpyButton.flat(
      padding: const EdgeInsets.all(16),
      icon: const Icon(CupertinoIcons.xmark),
      onTap: Navigator.of(context).maybePop,
    );
  }
}
