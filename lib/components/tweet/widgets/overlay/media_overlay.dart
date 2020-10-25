import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/model/tweet_media_model.dart';
import 'package:harpy/components/tweet/widgets/overlay/overlay_action_row.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

class MediaOverlay extends StatefulWidget {
  const MediaOverlay({
    @required this.tweet,
    @required this.tweetBloc,
    @required this.tweetMediaModel,
    @required this.child,
  });

  final TweetData tweet;
  final TweetBloc tweetBloc;
  final TweetMediaModel tweetMediaModel;
  final Widget child;

  @override
  _MediaOverlayState createState() => _MediaOverlayState();
}

class _MediaOverlayState extends State<MediaOverlay>
    with SingleTickerProviderStateMixin<MediaOverlay> {
  AnimationController _controller;
  Animation<Offset> _topAnimation;
  Animation<Offset> _bottomAnimation;

  @override
  void initState() {
    super.initState();

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
  }

  Future<bool> _onWillPop() async {
    widget.tweetMediaModel.resetOverlays();
    return true;
  }

  void _onMediaTap() {
    if (widget.tweetMediaModel.showingOverlays) {
      _controller.forward(from: 0);
    } else {
      _controller.reverse(from: 1);
    }

    widget.tweetMediaModel.toggleOverlays();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: _onMediaTap,
            child: widget.child,
          ),
          SafeArea(
            // app bar handles top safe area
            top: false,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) => Column(
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
          ),
        ],
      ),
    );
  }
}
