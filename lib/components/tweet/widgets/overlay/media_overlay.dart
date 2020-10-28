import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
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
    this.overlap = false,
  });

  final TweetData tweet;
  final TweetBloc tweetBloc;
  final Widget child;

  /// When set to `true`, tapping the [child] will hide the overlay and disable
  /// the system ui.
  final bool enableImmersiveMode;

  /// Whether the overlay should overlap the [child].
  final bool overlap;

  /// Pushes the [MediaOverlay] with a [HeroDialogRoute].
  static void open({
    @required TweetData tweet,
    @required TweetBloc tweetBloc,
    @required Widget child,
    bool enableImmersiveMode = true,
    bool overlap = false,
  }) {
    app<HarpyNavigator>().pushRoute(
      HeroDialogRoute<void>(
        onBackgroundTap: () => app<HarpyNavigator>().state.maybePop(),
        builder: (BuildContext context) => MediaOverlay(
          tweet: tweet,
          tweetBloc: tweetBloc,
          enableImmersiveMode: enableImmersiveMode,
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
    if (widget.enableImmersiveMode) {
      return GestureDetector(
        onTap: _onMediaTap,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }

  Widget _buildOverlappingOverlay() {
    return Stack(
      children: <Widget>[
        Center(child: _buildMedia()),
        AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget _) => Column(
            children: <Widget>[
              SlideTransition(
                position: _topAnimation,
                child: _buildAppBar(),
              ),
              const Spacer(),
              SlideTransition(
                position: _bottomAnimation,
                child: _buildActions(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverlay() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget _) => Column(
        children: <Widget>[
          SlideTransition(
            position: _topAnimation,
            child: _buildAppBar(),
          ),
          Expanded(child: Center(child: _buildMedia())),
          SlideTransition(
            position: _bottomAnimation,
            child: _buildActions(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        // app bar handles top safe area
        top: false,
        child: widget.overlap ? _buildOverlappingOverlay() : _buildOverlay(),
      ),
    );
  }
}
