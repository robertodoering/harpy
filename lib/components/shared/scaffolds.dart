import 'package:flutter/material.dart';
import 'package:harpy/theme.dart';

/// A convenience Widget that wraps a [Scaffold] with the [HarpyTheme].
class HarpyScaffold extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget drawer;
  final Widget body;

  const HarpyScaffold({
    this.appBar,
    this.drawer,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HarpyTheme.theme,
      child: Scaffold(
        appBar: appBar,
        drawer: drawer,
        body: body,
      ),
    );
  }
}

/// A [NestedScrollView] within a [Scaffold] where the [title] fades in when the
/// [FlexibleSpaceBar] in the [SliverAppBar] starts showing.
class FadingNestedScaffold extends StatefulWidget {
  final String title;
  final Widget background;
  final double expandedAppBarSpace;
  final Widget body;

  FadingNestedScaffold({
    this.title,
    this.background,
    this.expandedAppBarSpace = 200.0,
    @required this.body,
  });

  @override
  _FadingNestedScaffoldState createState() => _FadingNestedScaffoldState();
}

class _FadingNestedScaffoldState extends State<FadingNestedScaffold> {
  ScrollController _controller;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    double fadeStart = widget.expandedAppBarSpace - 125;
    double fadeEnd = widget.expandedAppBarSpace - 40;
    double difference = fadeEnd - fadeStart;

    _controller = ScrollController()
      ..addListener(() {
        if (_controller.offset >= fadeStart && _controller.offset <= fadeEnd) {
          double val = _controller.offset - fadeStart;
          setState(() {
            _opacity = val / difference;
          });
        } else if (_controller.offset < fadeStart && _opacity != 0.0) {
          setState(() {
            _opacity = 0.0;
          });
        } else if (_controller.offset > fadeEnd && _opacity != 1.0) {
          setState(() {
            _opacity = 1.0;
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: widget.expandedAppBarSpace,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Opacity(
                  opacity: _opacity,
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                ),
                background: widget.background,
              ),
            ),
          ];
        },
        body: widget.body,
      ),
    );
  }
}
