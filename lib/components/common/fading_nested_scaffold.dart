import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:harpy/components/common/harpy_background.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// A [NestedScrollView] within a [Scaffold] where the [title] fades in when the
/// [FlexibleSpaceBar] in the [SliverAppBar] starts showing.
class FadingNestedScaffold extends StatefulWidget {
  const FadingNestedScaffold({
    @required this.body,
    this.header,
    this.title,
    this.background,
    this.expandedAppBarSpace = 200.0,
  });

  final List<Widget> header;
  final Widget body;
  final String title;
  final Widget background;
  final double expandedAppBarSpace;

  @override
  _FadingNestedScaffoldState createState() => _FadingNestedScaffoldState();
}

class _FadingNestedScaffoldState extends State<FadingNestedScaffold> {
  ScrollController _controller;
  double _opacity = 0;

  @override
  void initState() {
    super.initState();

    final double fadeStart = widget.expandedAppBarSpace - 125;
    final double fadeEnd = widget.expandedAppBarSpace - 40;
    final double difference = fadeEnd - fadeStart;

    _controller = ScrollController()
      ..addListener(() {
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

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    final SliverAppBar sliverAppBar = SliverAppBar(
      expandedHeight: widget.expandedAppBarSpace,
      elevation: 0,
      backgroundColor: harpyTheme.backgroundColors.first,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        // padding to prevent the text to get below the back arrow
        titlePadding: const EdgeInsets.only(left: 54, right: 54, bottom: 16),
        centerTitle: true,
        title: Opacity(
          opacity: _opacity,
          child: Text(
            widget.title ?? '',
            style: theme.textTheme.headline6,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        background: widget.background,
      ),
    );

    return HarpyBackground(
      child: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            sliverAppBar,
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
