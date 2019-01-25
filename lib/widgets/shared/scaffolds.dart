import 'package:flutter/material.dart';
import 'package:harpy/theme.dart';

/// A convenience Widget that wraps a [Scaffold] with the [HarpyTheme].
///
/// If [appBar] is a String, it will be wrapped in an [AppBar].
/// Otherwise it needs to be a [PreferredSizeWidget].
class HarpyScaffold extends StatelessWidget {
  HarpyScaffold({
    @required this.appBar,
    this.drawer,
    this.body,
  }) : assert(appBar is String || appBar is PreferredSizeWidget);

  final appBar;
  final Widget drawer;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar is PreferredSizeWidget
          ? appBar
          : AppBar(
              centerTitle: true,
              title: Text(
                appBar,
                style: Theme.of(context).textTheme.title.copyWith(
                      fontSize: 20.0,
                    ),
              ),
            ),
      drawer: drawer,
      body: body,
    );
  }
}

/// A [NestedScrollView] within a [Scaffold] where the [title] fades in when the
/// [FlexibleSpaceBar] in the [SliverAppBar] starts showing.
///
/// If [alwaysShowTitle] is `true` the title will show even when the
/// [SliverAppBar] is expanded.
class FadingNestedScaffold extends StatefulWidget {
  const FadingNestedScaffold({
    this.title,
    this.background,
    this.expandedAppBarSpace = 200.0,
    this.alwaysShowTitle = false,
    @required this.body,
  });

  final String title;
  final Widget background;
  final double expandedAppBarSpace;
  final Widget body;
  final bool alwaysShowTitle;

  @override
  _FadingNestedScaffoldState createState() => _FadingNestedScaffoldState();
}

class _FadingNestedScaffoldState extends State<FadingNestedScaffold> {
  ScrollController _controller;
  double _opacity = 0.0;

  double get opacity => widget.alwaysShowTitle ? 1.0 : _opacity;

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
  void dispose() {
    super.dispose();
    _controller.dispose();
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
                  opacity: opacity,
                  child: Text(
                    widget.title ?? "",
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
