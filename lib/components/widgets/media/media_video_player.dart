import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.network(widget.mediaModel.getVideoUrl());

    // todo: if autoplay -> initialize
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

  /// Builds the thumbnail for the video when it hasn't been loaded yet.
  Widget _buildThumbnail() {
    return GestureDetector(
      onTap: _initialize,
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: widget.mediaModel.getThumbnailUrl(),
          ),
          Center(
            child: _initializing
                ? CircularProgressIndicator()
                : Icon(Icons.play_arrow),
          ),
        ],
      ),
    );
  }

  /// Builds the video player with a [MediaVideoOverlay].
  Widget _buildVideoPlayer() {
    return MediaVideoOverlay(
      controller: controller,
      child: VideoPlayer(controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.mediaModel.getVideoAspectRatio(),
      child: _initialized ? _buildVideoPlayer() : _buildThumbnail(),
    );
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
    @required this.controller,
    @required this.child,
  });

  final VideoPlayerController controller;
  final Widget child;

  @override
  _MediaVideoOverlayState createState() => _MediaVideoOverlayState();
}

class _MediaVideoOverlayState extends State<MediaVideoOverlay>
    with
        MediaOverlayMixin<MediaVideoOverlay>,
        SingleTickerProviderStateMixin<MediaVideoOverlay> {
  /// Handles the visibility of the overlay.
  AnimationController _visibilityController;

  /// Whether or not the overlay for the video player should be drawn.
  bool get _overlayShowing => !_visibilityController.isCompleted || finished;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
    controller.addListener(listener);

    _visibilityController = new AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // rebuild when controller completed to hide overlay
          setState(() {});
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    super.dispose();

    _visibilityController.dispose();
  }

  void _onVideoTap() {
    if (_overlayShowing) {
      if (finished) {
        // replay
        setState(() {
          controller.seekTo(Duration.zero);
        });
      } else if (playing) {
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
    } else {
      // show overlay
      setState(() {
        _visibilityController.reset();
        _visibilityController.forward();
      });
    }
  }

  Widget _buildCenterIcon() {
    if (buffering) {
      return Center(child: CircularProgressIndicator());
    }

    if (!_overlayShowing) {
      return Container();
    }

    IconData iconData;

    if (finished) {
      iconData = Icons.replay;
    } else if (playing) {
      iconData = Icons.play_arrow;
    } else {
      iconData = Icons.pause;
    }

    return Center(child: FadeOutWidget(child: Icon(iconData, size: 72)));
  }

  Widget _buildBottomRow() {
    if (!_overlayShowing) {
      return Container();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // button row
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            CircleButton(
              child: Icon(Icons.settings),
              onPressed: () {}, // todo: show quality setting
            ),
            CircleButton(
              child: Icon(Icons.fullscreen),
              onPressed: () {}, // todo: fullscreen
            ),
          ],
        ),

        // progress indicator
        VideoProgressIndicator(
          controller,
          allowScrubbing: true,
          colors: VideoProgressColors(
            playedColor: Theme.of(context).accentColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
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

  /// The listener for the controller.
  void listener() {
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
