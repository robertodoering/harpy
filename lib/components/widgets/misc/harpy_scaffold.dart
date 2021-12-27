import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// A convenience Widget that wraps a [Scaffold] to build a transparent [AppBar]
/// on top of a [HarpyBackground].
///
/// If [showIcon] is `true`, the [FlareIcon.harpyLogo] is built next to the
/// [title] in the [AppBar].
class HarpyScaffold extends StatelessWidget {
  const HarpyScaffold({
    required this.body,
    this.title,
    this.showIcon = false,
    this.actions,
    this.drawer,
    this.endDrawer,
    this.backgroundColors,
    this.appBarBottom,
    this.floatingActionButton,
    this.buildSafeArea = false,
  });

  final String? title;
  final Widget body;
  final bool showIcon;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? endDrawer;
  final PreferredSizeWidget? appBarBottom;
  final Widget? floatingActionButton;
  final bool buildSafeArea;

  /// The colors used by the [HarpyBackground].
  ///
  /// Uses the colors of the current theme if `null`.
  final List<Color>? backgroundColors;

  bool get _hasAppBar => title != null || showIcon;

  Widget _buildTitle(ThemeData theme) {
    return FittedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title!,
            style: theme.textTheme.headline6,
          ),
          if (showIcon) ...[
            const SizedBox(width: 4),
            const FlareIcon.harpyLogo(size: 24),
          ],
        ],
      ),
    );
  }

  Widget? _leading(BuildContext context) {
    if (Scaffold.of(context).hasDrawer) {
      return const DrawerButton();
    } else if (Navigator.of(context).canPop()) {
      return const HarpyBackButton();
    } else {
      return null;
    }
  }

  Widget _buildAppBar(
    BuildContext context,
    ThemeData theme,
    MediaQueryData mediaQuery,
  ) {
    final appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
      leading: _leading(context),
      title: title != null && title!.isNotEmpty ? _buildTitle(theme) : null,
      bottom: appBarBottom,
    );

    final topPadding = mediaQuery.padding.top;
    final extent = appBar.preferredSize.height + topPadding;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: extent),
      child: appBar,
    );
  }

  Widget? _buildFloatingActionButton(MediaQueryData mediaQuery) {
    if (floatingActionButton == null) {
      return null;
    } else {
      return Padding(
        // add padding if a bottom nav bar exists
        // Some devices won't draw a bot nav bar, in which case the fab will
        // have the correct padding of 16dp.
        // If a bot nav bar exists we add a padding of 16dp because it will
        // otherwise sit on the bot nav bar without padding.
        padding: EdgeInsets.only(
          bottom: mediaQuery.padding.bottom > 0 ? 16 : 0,
        ),
        child: floatingActionButton,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      drawer: drawer,
      endDrawer: endDrawer,
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      floatingActionButton: _buildFloatingActionButton(mediaQuery),
      body: HarpyBackground(
        colors: backgroundColors,
        child: Column(
          children: [
            if (_hasAppBar) _buildAppBar(context, theme, mediaQuery),
            Expanded(
              child: buildSafeArea ? SafeArea(top: false, child: body) : body,
            ),
          ],
        ),
      ),
    );
  }
}
