import 'dart:math';

import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/custom_sliver_app_bar.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds a [SliverAppBar] with an optional background.
///
/// When a [background] is provided, a [FlexibleSpaceBar] will be built behind
/// the [AppBar].
///
/// [scrollController] can be used to add a listener that will fade the [title]
/// in, based on the scroll position. This should be used in combination with a
/// [background].
class HarpySliverAppBar extends StatefulWidget {
  const HarpySliverAppBar({
    this.title,
    this.showIcon = false,
    this.floating = false,
    this.stretch = false,
    this.pinned = false,
    this.background,
    this.scrollController,
  });

  final String title;
  final bool showIcon;
  final bool floating;
  final bool stretch;
  final bool pinned;
  final Widget background;
  final ScrollController scrollController;

  @override
  _HarpySliverAppBarState createState() => _HarpySliverAppBarState();
}

class _HarpySliverAppBarState extends State<HarpySliverAppBar> {
  double _expandedHeight;
  double _opacity;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_scrollListener);

    _opacity = widget.scrollController == null ? 1 : 0;
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController?.removeListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    _expandedHeight = min(200, mediaQuery.size.height * .25);
  }

  void _scrollListener() {
    final double fadeStart = _expandedHeight - 125;
    final double fadeEnd = _expandedHeight - 40;
    final double difference = fadeEnd - fadeStart;

    if (widget.scrollController.offset >= fadeStart &&
        widget.scrollController.offset <= fadeEnd) {
      final double val = widget.scrollController.offset - fadeStart;

      setState(() {
        _opacity = val / difference;
      });
    } else if (widget.scrollController.offset < fadeStart && _opacity != 0) {
      setState(() {
        _opacity = 0;
      });
    } else if (widget.scrollController.offset > fadeEnd && _opacity != 1.0) {
      setState(() {
        _opacity = 1.0;
      });
    }
  }

  Widget _buildTitle(ThemeData theme) {
    final Widget title = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Text(
            widget.title ?? '',
            style: theme.textTheme.headline6,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ),
        if (widget.showIcon) ...<Widget>[
          const SizedBox(width: 4),
          const FlareIcon.harpyLogo(size: 24),
        ],
      ],
    );

    // todo: add widget.alwaysShowTitle?

    if (_opacity == 0) {
      // return empty sized box to prevent the invisible title to block gesture
      // detection
      return const SizedBox();
    } else {
      return Opacity(
        opacity: _opacity,
        child: title,
      );
    }
  }

  Widget _buildFlexibleSpace(ThemeData theme) {
    return FlexibleSpaceBar(
      // padding to prevent the text to get below the back arrow
      titlePadding: const EdgeInsets.only(left: 54, right: 54, bottom: 16),
      centerTitle: true,
      title: _buildTitle(theme),
      background: widget.background,
      stretchModes: const <StretchMode>[
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
    if (harpyTheme.backgroundColors.length == 1) {
      return BoxDecoration(color: harpyTheme.backgroundColors.first);
    }

    // min extend / mediaQuery.size * count of background colors minus the
    // first one
    final double t = minExtend /
        mediaQuery.size.height *
        (harpyTheme.backgroundColors.length - 1);

    final Color color = Color.lerp(
      harpyTheme.backgroundColors[0],
      harpyTheme.backgroundColors[1],
      t,
    );

    return BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[
          harpyTheme.backgroundColors.first,
          color,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HarpyTheme harpyTheme = HarpyTheme.of(context);
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    // whether a flexible space widget should be built for the sliver app bar
    final bool hasFlexibleSpace = widget.background != null;

    return CustomSliverAppBar(
      decorationBuilder: (double minExtend, double maxExtend) =>
          _buildDecoration(harpyTheme, mediaQuery, minExtend),
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      floating: widget.floating,
      stretch: widget.stretch,
      pinned: widget.pinned,
      title: hasFlexibleSpace ? null : _buildTitle(theme),
      flexibleSpace: hasFlexibleSpace ? _buildFlexibleSpace(theme) : null,
      expandedHeight: hasFlexibleSpace ? _expandedHeight : null,
    );
  }
}
