import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/models/media_model.dart';
import 'package:video_player/video_player.dart';

class MediaVideoPlayer extends StatefulWidget {
  const MediaVideoPlayer({
    @required this.mediaModel,
  });

  final MediaModel mediaModel;

  @override
  _MediaVideoPlayerState createState() => _MediaVideoPlayerState();
}

class _MediaVideoPlayerState extends State<MediaVideoPlayer> {
  VideoPlayerController controller;

  bool _initialized = false;
  bool _initializing = false;

  bool fullscreen = false;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.network(widget.mediaModel.getVideoUrl());

    // todo: if autoplay && video in scroll view -> initialize
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  void _initialize() {
    setState(() {
      _initializing = true;
    });
    controller.initialize().then((_) {
      setState(() {
        _initialized = true;
        _initializing = false;
        controller.play();
      });
    });
  }

  Future<void> pushFullscreen() async {
    SystemChrome.setEnabledSystemUIOverlays([]);

    if (widget.mediaModel.getVideoAspectRatio() > 1) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    fullscreen = true;

    await Navigator.of(context).push(PageRouteBuilder(
      settings: RouteSettings(isInitialRoute: false),
      pageBuilder: _buildFullscreen,
    ));

    fullscreen = false;

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Builds the thumbnail for the video when it hasn't been loaded yet.
  Widget _buildThumbnail() {
    return GestureDetector(
      onTap: _initialize,
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: widget.mediaModel.getThumbnailUrl(),
            height: double.infinity,
            width: double.infinity,
          ),
          Center(
            child: _initializing
                ? CircularProgressIndicator()
                : CircleButton(
                    child: Icon(Icons.play_arrow, size: 64),
                  ),
          ),
        ],
      ),
    );
  }

  /// Builds the video player with a [MediaVideoOverlay].
  Widget _buildVideoPlayer() {
    return MediaVideoOverlay(
      videoPlayer: this,
      child: Container(
        color: Colors.black,
        child: OverflowBox(
          maxHeight: double.infinity,
          child: AspectRatio(
            aspectRatio: widget.mediaModel.getVideoAspectRatio(),
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }

  /// Builds the video player in fullscreen.
  Widget _buildFullscreen(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Scaffold(
          body: Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: build(context),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _initialized ? _buildVideoPlayer() : _buildThumbnail();
  }
}

/// The overlay for a [MediaVideoPlayer].
///
/// Shows the actions for the video (play, pause, fullscreen, etc.) and the
/// progress indicator.
///
/// Automatically hides after a set amount of time when the video is playing.
class MediaVideoOverlay extends StatefulWidget {
  const MediaVideoOverlay({
    @required this.videoPlayer,
    @required this.child,
  });

  final _MediaVideoPlayerState videoPlayer;
  final Widget child;

  @override
  _MediaVideoOverlayState createState() => _MediaVideoOverlayState();
}

class _MediaVideoOverlayState extends State<MediaVideoOverlay>
    with
        MediaOverlayMixin<MediaVideoOverlay>,
        TickerProviderStateMixin<MediaVideoOverlay> {
  /// Handles the visibility of the overlay.
  AnimationController _visibilityController;

  /// Whether or not the overlay for the video player should be drawn.
  bool get _overlayShowing => !_visibilityController.isCompleted || finished;

  /// `true` when showing the overlay after it was hidden to determine whether
  /// or not to show the play icon widget.
  bool _reshowingOverlay = false;

  @override
  void initState() {
    super.initState();

    controller = widget.videoPlayer.controller;
    controller.addListener(listener);

    _visibilityController = new AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          // rebuild when controller completed to hide overlay
          setState(() {});
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _visibilityController.dispose();

    super.dispose();
  }

  void _onVideoTap() {
    if (_overlayShowing) {
      _reshowingOverlay = false;

      if (finished) {
        // replay
        setState(() {
          controller.seekTo(Duration.zero);
        });
      } else {
        _togglePlay();
      }
    } else {
      // show overlay
      setState(() {
        _visibilityController.reset();
        _visibilityController.forward();
        _reshowingOverlay = true;
      });
    }
  }

  void _togglePlay() {
    if (playing) {
      // pause
      setState(() {
        playing = false;
        controller.pause();
        _visibilityController.reset();
      });
    } else {
      // play
      setState(() {
        playing = true;
        controller.play();
        _visibilityController.forward();
      });
    }
  }

  void _onFullscreenTap() {
    if (widget.videoPlayer.fullscreen) {
      Navigator.of(context).maybePop();
    } else {
      controller.removeListener(listener);
      widget.videoPlayer.pushFullscreen();
    }
  }

  Widget _buildCenterIcon() {
    if (buffering) {
      return Center(child: CircularProgressIndicator());
    }

    if (!_overlayShowing) {
      return Container();
    }

    Widget centerWidget;

    if (finished) {
      centerWidget = Icon(Icons.replay, size: 64);
    } else if (playing) {
      centerWidget = _reshowingOverlay
          ? Container()
          : FadeOutWidget(
              child: CircleButton(
                child: Icon(Icons.play_arrow, size: 64),
              ),
            );
    } else {
      centerWidget = FadeOutWidget(
        child: CircleButton(
          child: Icon(Icons.pause, size: 64),
        ),
      );
    }

    return Center(child: centerWidget);
  }

  Widget _buildBottomRow() {
    return AnimatedOpacity(
      key: Key(widget.videoPlayer.controller.dataSource),
      opacity: _overlayShowing ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // button row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // play / pause button
              CircleButton(
                child: Icon(playing ? Icons.pause : Icons.play_arrow),
                onPressed: _togglePlay,
              ),

              Spacer(),

              // fullscreen button
              CircleButton(
                child: Icon(widget.videoPlayer.fullscreen
                    ? Icons.fullscreen_exit
                    : Icons.fullscreen),
                onPressed: _onFullscreenTap,
              ),
            ],
          ),

          // progress indicator
          VideoProgressIndicator(
            controller,
            padding: EdgeInsets.zero,
            allowScrubbing: true,
            colors: VideoProgressColors(
              playedColor: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onVideoTap,
      child: Stack(children: <Widget>[
        widget.child,
        _buildBottomRow(),
        _buildCenterIcon(),
      ]),
    );
  }
}

mixin MediaOverlayMixin<T extends StatefulWidget> on State<T> {
  /// `true` while the video is playing.
  bool playing = true;

  /// `true` while the video is buffering.
  bool buffering = false;

  /// `true` when the [controller] position reached the end of the video.
  bool finished = false;

  /// The [VideoPlayerController] for the video.
  ///
  /// Equal to the [widget.controller] if it's not null.
  VideoPlayerController controller;

  /// The [VideoPlayerValue] of the last [listener] call.
  ///
  /// Used to determine whether or not the video is [buffering].
  VideoPlayerValue lastValue;

  /// The listener for the [VideoPlayerController].
  void listener() {
    if (!mounted) {
      return;
    }

    final isPlaying = controller.value.isPlaying;
    if (playing != isPlaying) {
      setState(() {
        playing = isPlaying;
      });
    }

    final isFinished = controller.value.position >= controller.value.duration;
    if (finished != isFinished) {
      setState(() {
        finished = isFinished;
      });
    }

    // buffering workaround:
    // the video player buffering start / end event is never fired on android,
    // so instead assume buffering when the video is playing but the position
    // is not changing.
    final isBuffering = (lastValue?.isPlaying ?? false) &&
        !finished &&
        controller.value.isPlaying &&
        controller.value.position == lastValue.position;
    if (buffering != isBuffering) {
      setState(() {
        buffering = isBuffering;
      });
    }

    lastValue = controller.value;
  }
}
