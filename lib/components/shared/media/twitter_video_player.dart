import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/components/shared/animations.dart';
import 'package:harpy/components/shared/buttons.dart';
import 'package:harpy/components/shared/media/twitter_video_player_mixin.dart';
import 'package:video_player/video_player.dart';

/// The [TwitterVideoPlayer] for Twitter videos.
class TwitterVideoPlayer extends StatefulWidget {
  final TwitterMedia media;
  final bool fullscreen;
  final VoidCallback onShowFullscreen;
  final HideFullscreenCallback onHideFullscreen;
  final VideoPlayerController controller;
  final bool initializing;

  const TwitterVideoPlayer({
    Key key,
    @required this.media,
    this.fullscreen = false,
    this.onShowFullscreen,
    this.onHideFullscreen,
    this.controller,
    this.initializing = false,
  }) : super(key: key);

  @override
  TwitterVideoPlayerState createState() => TwitterVideoPlayerState();
}

class TwitterVideoPlayerState extends State<TwitterVideoPlayer>
    with TwitterVideoPlayerMixin<TwitterVideoPlayer> {
  /// The pause / play [FadeOutAnimation].
  FadeOutAnimation _fadeAnimation;

  /// The rewind [FadeOutAnimation].
  FadeOutAnimation _rewindFadeAnimation;

  /// The forward [FadeOutAnimation].
  FadeOutAnimation _forwardFadeAnimation;

  @override
  void initState() {
    super.initState();

    media = widget.media;
    onShowFullscreen = widget.onShowFullscreen;
    onHideFullscreen = widget.onHideFullscreen;
    fullscreen = widget.fullscreen;
    initializing = widget.initializing;

    controller = widget.controller ?? VideoPlayerController.network(videoUrl)
      ..addListener(listener);
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.controller != null) {
      // this widget is not using a self created controller, don't dispose it
      // only remove the listener
      controller.removeListener(listener);
    } else {
      // this widget created the controller, dispose it
      controller.dispose();
    }
  }

  void _toggleVideo() {
    if (controller.value.initialized) {
      if (controller.value.isPlaying) {
        controller.pause();
        _fadeAnimation = FadeOutAnimation(child: pause);
      } else {
        controller.play();
        _fadeAnimation = FadeOutAnimation(child: play);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var body = Material(
      color: Colors.transparent,
      child: RotatedBox(
        quarterTurns: rotation,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: controller.value.initialized
              ? _buildVideoPlayer()
              : buildThumbnail(CircleButton(child: play)),
        ),
      ),
    );

    return Container(
      width: widget.fullscreen ? double.infinity : null,
      height: widget.fullscreen ? double.infinity : null,
      color: widget.fullscreen ? Colors.black : Colors.transparent,
      child: widget.fullscreen ? Center(child: body) : body,
    );
  }

  Widget _buildVideoPlayer() {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        // video
        GestureDetector(
          onTap: _toggleVideo,
          // empty onDoubleTap to prevent the onTap gesture being called with
          // the onDoubleTap of the gesture detector above
          onDoubleTap: () {},
          child: VideoPlayer(controller),
        ),

        // double tap gesture
        _buildDoubleTapGesture(),

        // progress indicator
        Align(
          alignment: Alignment.bottomCenter,
          child: VideoProgressIndicator(
            controller,
            allowScrubbing: true,
          ),
        ),

        // todo: volume changer

        // todo: quality selection

        buildFullscreenButton(),

        // play / pause icon fade animation
        Center(child: _fadeAnimation),

        // buffer indicator
        Center(child: buffering ? bufferIndicator : null),

        // play again
        Center(child: finished ? _buildPlayAgainButton() : null)
      ],
    );
  }

  Widget _buildDoubleTapGesture() {
    // skip forward 10% of the video length when double clicking on the right
    // side of the video or
    // rewind 10% of the video length when double clicking on the left side of
    // the video

    Duration skip =
        Duration(milliseconds: controller.value.duration.inMilliseconds ~/ 10);

    final back = () {
      Duration position = controller.value.position;

      controller.seekTo(position - skip);

      setState(() {
        _rewindFadeAnimation = FadeOutAnimation(
          key: UniqueKey(),
          child:
              const Icon(Icons.fast_rewind, size: 100.0, color: Colors.white70),
        );
      });
    };

    final forward = () {
      Duration position = controller.value.position;
      controller.seekTo(position + skip);

      setState(() {
        _forwardFadeAnimation = FadeOutAnimation(
          key: UniqueKey(),
          child: const Icon(Icons.fast_forward,
              size: 100.0, color: Colors.white70),
        );
      });
    };

    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onDoubleTap: back,
            child: Center(child: _rewindFadeAnimation),
          ),
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onDoubleTap: forward,
            child: Center(child: _forwardFadeAnimation),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayAgainButton() {
    final icon = Icon(
      Icons.replay,
      color: Colors.white,
      size: 64.0,
    );

    final onPressed = () {
      controller.seekTo(Duration.zero);
    };

    return SlideFadeInAnimation(
      duration: Duration(milliseconds: 300),
      child: CircleButton(
        child: icon,
        onPressed: onPressed,
      ),
    );
  }
}

/// The [TwitterGifPlayer] for Twitter gifs.
///
/// Twitter gifs are just videos. Instead of showing the same video player for
/// videos and gifs, this [TwitterGifPlayer] is suited for gifs.
class TwitterGifPlayer extends StatefulWidget {
  final TwitterMedia media;
  final bool fullscreen;
  final VoidCallback onShowFullscreen;
  final HideFullscreenCallback onHideFullscreen;
  final VideoPlayerController controller;
  final bool initializing;

  const TwitterGifPlayer({
    Key key,
    @required this.media,
    this.fullscreen = false,
    this.onShowFullscreen,
    this.onHideFullscreen,
    this.controller,
    this.initializing = false,
  }) : super(key: key);

  @override
  TwitterGifPlayerState createState() => TwitterGifPlayerState();
}

class TwitterGifPlayerState extends State<TwitterGifPlayer>
    with TwitterVideoPlayerMixin<TwitterGifPlayer> {
  @override
  void initState() {
    super.initState();

    media = widget.media;
    onShowFullscreen = widget.onShowFullscreen;
    onHideFullscreen = widget.onHideFullscreen;
    fullscreen = widget.fullscreen;
    initializing = widget.initializing;

    controller = widget.controller ?? VideoPlayerController.network(videoUrl)
      ..setLooping(true);
    ;
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.controller == null) {
      // this widget created the controller, dispose it
      controller.dispose();
    }
  }

  /// Initializes the controller and plays the video.
  void initializeController() {
    if (!initializing && !controller.value.initialized) {
      setState(() {
        initializing = true;
      });

      controller.initialize().then((_) {
        setState(() {
          initializing = false;
          controller.play();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var body = Material(
      color: Colors.transparent,
      child: RotatedBox(
        quarterTurns: rotation,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: controller.value.initialized
              ? _buildVideoPlayer()
              : buildThumbnail(CircleButton(
                  child: Text(
                    "GIF",
                    style: Theme.of(context)
                        .textTheme
                        .display2
                        .copyWith(color: Colors.white),
                  ),
                )),
        ),
      ),
    );

    return Container(
      width: widget.fullscreen ? double.infinity : null,
      height: widget.fullscreen ? double.infinity : null,
      color: widget.fullscreen ? Colors.black : Colors.transparent,
      child: widget.fullscreen ? Center(child: body) : body,
    );
  }

  Widget _buildVideoPlayer() {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        // video
        VideoPlayer(controller),

        // todo: quality selection

        // buffer indicator
        Center(child: buffering ? bufferIndicator : null),

        buildFullscreenButton(),
      ],
    );
  }
}
