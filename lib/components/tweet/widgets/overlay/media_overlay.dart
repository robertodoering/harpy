import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/misc/custom_dismissible.dart';
import 'package:harpy/components/common/routes/hero_dialog_route.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/model/tweet_media_model.dart';
import 'package:harpy/components/tweet/widgets/overlay/overlay_action_row.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

class MediaOverlay extends StatefulWidget {
  const MediaOverlay({
    @required this.tweet,
    @required this.tweetBloc,
    @required this.child,
    this.enableImmersiveMode = true,
    this.enableDismissible = true,
    this.overlap = false,
  });

  final TweetData tweet;
  final TweetBloc tweetBloc;
  final Widget child;

  /// When set to `true`, tapping the [child] will hide the overlay and disable
  /// the system ui.
  final bool enableImmersiveMode;

  /// Wraps the child in a [CustomDismissible] when set to `true`.
  final bool enableDismissible;

  /// Whether the overlay should overlap the [child].
  final bool overlap;

  /// Pushes the [MediaOverlay] with a [HeroDialogRoute].
  static void open({
    @required TweetData tweet,
    @required TweetBloc tweetBloc,
    @required Widget child,
    bool enableImmersiveMode = true,
    bool enableDismissible = true,
    bool overlap = false,
  }) {
    app<HarpyNavigator>().pushRoute(
      HeroDialogRoute<void>(
        onBackgroundTap: () => app<HarpyNavigator>().state.maybePop(),
        builder: (BuildContext context) => MediaOverlay(
          tweet: tweet,
          tweetBloc: tweetBloc,
          enableImmersiveMode: enableImmersiveMode,
          enableDismissible: enableDismissible,
          overlap: overlap,
          child: child,
        ),
      ),
    );
  }

  @override
  _MediaOverlayState createState() => _MediaOverlayState();
}

class _MediaOverlayState extends State<MediaOverlay>
    with SingleTickerProviderStateMixin<MediaOverlay> {
  AnimationController _controller;
  Animation<Offset> _topAnimation;
  Animation<Offset> _bottomAnimation;

  TweetMediaModel _model;

  @override
  void initState() {
    super.initState();

    _model = TweetMediaModel();

    _controller = AnimationController(
      vsync: this,
      duration: kShortAnimationDuration,
    );

    _topAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _bottomAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.reverse(from: 1);
  }

  Future<bool> _onWillPop() async {
    _model.resetOverlays();
    _controller.forward();
    return true;
  }

  void _onMediaTap() {
    if (_model.showingOverlays) {
      _controller.forward(from: 0);
    } else {
      _controller.reverse(from: 1);
    }

    _model.toggleOverlays();
  }

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.black87,
            Colors.transparent,
          ],
        ),
      ),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.transparent,
            Colors.black87,
          ],
        ),
      ),
      child: MediaOverlayActionRow(widget.tweetBloc),
    );
  }

  Widget _buildMedia() {
    Widget child = Center(child: widget.child);

    if (widget.enableImmersiveMode) {
      child = GestureDetector(
        onTap: _onMediaTap,
        child: child,
      );
    }

    if (widget.enableDismissible) {
      child = CustomDismissible(
        onDismissed: () => app<HarpyNavigator>().state.maybePop(),
        child: child,
      );
    }

    return child;
  }

  Widget _buildOverlappingOverlay() {
    return Stack(
      children: <Widget>[
        SafeArea(child: _buildMedia()),
        AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget _) => Column(
            children: <Widget>[
              SlideTransition(
                position: _topAnimation,
                child: _buildAppBar(),
              ),
              const Spacer(),
              SafeArea(
                child: SlideTransition(
                  position: _bottomAnimation,
                  child: _buildActions(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverlay() {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget _) => Column(
          children: <Widget>[
            SlideTransition(
              position: _topAnimation,
              child: _buildAppBar(),
            ),
            Expanded(child: _buildMedia()),
            SlideTransition(
              position: _bottomAnimation,
              child: _buildActions(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: widget.overlap ? _buildOverlappingOverlay() : _buildOverlay(),
    );
  }
}
