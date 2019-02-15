import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:harpy/components/widgets/shared/harpy_background.dart';
import 'package:harpy/core/misc/harpy_theme.dart';

/// A convenience Widget that wraps a [Scaffold] with the [HarpyTheme].
///
/// If [title] is a String, it will be wrapped in an [AppBar].
/// Otherwise it needs to be a [PreferredSizeWidget].
class HarpyScaffold extends StatelessWidget {
  HarpyScaffold({
    @required this.title,
    this.actions,
    this.drawer,
    this.body,
    this.primaryBackgroundColor,
    this.secondaryBackgroundColor,
  });

  final String title;
  final List<Widget> actions;
  final Widget drawer;
  final Widget body;

  /// When set the [HarpyBackground] will override the active theme background
  /// [Color]s.
  final Color primaryBackgroundColor;
  final Color secondaryBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Text(
        title,
        style: Theme.of(context).textTheme.title.copyWith(
              fontSize: 20.0,
              color: Theme.of(context).primaryIconTheme.color,
            ),
      ),
    );

    final double topPadding = MediaQuery.of(context).padding.top;
    final double extent = appBar.preferredSize.height + topPadding;

    return Scaffold(
      drawer: drawer,
      body: Stack(
        children: <Widget>[
          HarpyBackground(
            startColor: primaryBackgroundColor,
            endColor: secondaryBackgroundColor,
          ),
          Column(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: extent),
                child: appBar,
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: body,
                ),
              ),
            ],
          )
        ],
      ),
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
    SliverAppBar sliverAppBar = SliverAppBar(
      expandedHeight: widget.expandedAppBarSpace,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      pinned: true,
      flexibleSpace: HarpyBackground(
        child: FlexibleSpaceBar(
          centerTitle: true,
          // padding to prevent the text to get below the back arrow
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 52.0),
            child: Opacity(
              opacity: opacity,
              child: Text(
                widget.title ?? "",
                style: Theme.of(context).textTheme.subtitle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          background: widget.background,
        ),
      ),
    );

    return HarpyBackground(
      child: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            sliverAppBar,
          ];
        },
        body: widget.body,
      ),
    );
  }
}
