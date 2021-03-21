import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// A [NestedScrollView] within a [Scaffold] where the [title] fades in when the
/// [FlexibleSpaceBar] in the [SliverAppBar] starts showing.
class FadingNestedScaffold extends StatefulWidget {
  const FadingNestedScaffold({
    @required this.body,
    this.header,
    this.title,
    this.alwaysShowTitle = false,
    this.background,
    this.expandedHeight = 200.0,
  });

  /// The header widgets built below the [SliverAppBar].
  final List<Widget> header;

  /// The body of the [NestedScrollView].
  final Widget body;

  /// The title used in the [SliverAppBar] that fades in when the user scrolls
  /// down.
  final String title;

  /// If `true`, always shows the title regardless of the scroll position.
  final bool alwaysShowTitle;

  /// The background of the [SliverAppBar].
  final Widget background;

  /// The expanded height of the [SliverAppBar].
  final double expandedHeight;

  @override
  _FadingNestedScaffoldState createState() => _FadingNestedScaffoldState();
}

class _FadingNestedScaffoldState extends State<FadingNestedScaffold> {
  ScrollController _controller;
  double _opacity = 0;

  @override
  void initState() {
    super.initState();

    final double fadeStart = widget.expandedHeight - 125;
    final double fadeEnd = widget.expandedHeight - 40;
    final double difference = fadeEnd - fadeStart;

    _controller = ScrollController();

    if (!widget.alwaysShowTitle) {
      _controller.addListener(() {
        if (_controller.offset >= fadeStart && _controller.offset <= fadeEnd) {
          final double val = _controller.offset - fadeStart;

          setState(() {
            _opacity = val / difference;
          });
        } else if (_controller.offset < fadeStart && _opacity != 0) {
          setState(() {
            _opacity = 0;
          });
        } else if (_controller.offset > fadeEnd && _opacity != 1.0) {
          setState(() {
            _opacity = 1.0;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _buildTitle(ThemeData theme) {
    final Widget title = Text(
      widget.title ?? '',
      style: theme.textTheme.headline6,
      overflow: TextOverflow.ellipsis,
    );

    if (widget.alwaysShowTitle) {
      return title;
    } else if (_opacity == 0) {
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

  Widget _buildSliverAppBar(HarpyTheme harpyTheme, ThemeData theme) {
    // todo: set icon theme data to match the background
    //  maybe when scrolling down the icon theme data can change while the
    //  background fades out
    return SliverAppBar(
      expandedHeight: widget.expandedHeight,
      elevation: 0,
      backgroundColor: harpyTheme.backgroundColors.first,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        // padding to prevent the text to get below the back arrow
        titlePadding: const EdgeInsets.only(left: 54, right: 54, bottom: 16),
        centerTitle: true,
        title: _buildTitle(theme),
        background: widget.background,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    return HarpyBackground(
      child: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            _buildSliverAppBar(harpyTheme, theme),
            if (widget.header != null)
              SliverList(
                delegate: SliverChildListDelegate(widget.header),
              ),
          ];
        },
        body: widget.body,
      ),
    );
  }
}
