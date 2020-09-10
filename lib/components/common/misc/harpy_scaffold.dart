import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/components/common/misc/harpy_background.dart';

/// A convenience Widget that wraps a [Scaffold] to build a transparent [AppBar]
/// on top of a [HarpyBackground].
///
/// If [showIcon] is `true`, the [FlareIcon.harpyLogo] is built next to the
/// [title] in the [AppBar].
class HarpyScaffold extends StatelessWidget {
  const HarpyScaffold({
    @required this.body,
    this.title,
    this.showIcon = false,
    this.actions,
    this.drawer,
    this.backgroundColors,
    this.appBarBottom,
  });

  final String title;
  final Widget body;
  final bool showIcon;
  final List<Widget> actions;
  final Widget drawer;
  final PreferredSizeWidget appBarBottom;

  /// The colors used by the [HarpyBackground].
  ///
  /// Uses the colors of the current theme if `null`.
  final List<Color> backgroundColors;

  bool get _hasAppBar => title != null || showIcon;

  Widget _buildTitle(ThemeData theme) {
    return FittedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.headline6,
          ),
          if (showIcon) ...<Widget>[
            const SizedBox(width: 4),
            const FlareIcon.harpyLogo(size: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme, MediaQueryData mediaQuery) {
    final AppBar appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
      title: title?.isNotEmpty == true ? _buildTitle(theme) : null,
      bottom: appBarBottom,
    );

    final double topPadding = mediaQuery.padding.top;
    final double extent = appBar.preferredSize.height + topPadding;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: extent),
      child: appBar,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
      drawer: drawer,
      body: HarpyBackground(
        colors: backgroundColors,
        child: Column(
          children: <Widget>[
            if (_hasAppBar) _buildAppBar(theme, mediaQuery),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
