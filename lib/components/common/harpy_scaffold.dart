import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:harpy/components/common/harpy_background.dart';

/// A convenience Widget that wraps a [Scaffold].
///
/// If [showIcon] is `true`, the [FlareIcon.harpyLogo] is built next to the
/// [title] in the [AppBar].
///
/// [HarpyScaffold] builds a transparent [AppBar] on top of a
/// [HarpyBackground].
class HarpyScaffold extends StatelessWidget {
  const HarpyScaffold({
    @required this.title,
    @required this.body,
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
  /// If `null`, uses the colors of the current theme.
  final List<Color> backgroundColors;

  Widget _buildTitle(ThemeData theme) {
    return FittedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.headline6,
          ),
          if (showIcon) ...[
            const SizedBox(width: 4),
            // const FlareIcon.harpyLogo(size: 24),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final AppBar appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
      title: _buildTitle(theme),
      bottom: appBarBottom,
    );

    final double topPadding = MediaQuery.of(context).padding.top;
    final double extent = appBar.preferredSize.height + topPadding;

    return Scaffold(
      drawer: drawer,
      body: HarpyBackground(
        colors: backgroundColors,
        child: Column(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: extent),
              child: appBar,
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
