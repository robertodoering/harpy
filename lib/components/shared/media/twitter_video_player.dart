import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/components/shared/animations.dart';
import 'package:harpy/components/shared/buttons.dart';
import 'package:video_player/video_player.dart';

typedef HideFullscreenCallback(BuildContext context);

/// The [TwitterVideoPlayer] for Twitter videos.
///
/// Wraps a [VideoPlayer] with custom controls.
///
/// The [thumbnail] will be shown initially and loads the [videoUrl] on tap.
class TwitterVideoPlayer extends StatefulWidget {
  final TwitterMedia media;
  final bool isFullscreen;
  final VoidCallback onShowFullscreen;
  final HideFullscreenCallback onHideFullscreen;
  final VideoPlayerController controller;
  final bool initializing;

  const TwitterVideoPlayer({
    Key key,
    @required this.media,
    this.isFullscreen = false,
    this.onShowFullscreen,
    this.onHideFullscreen,
    this.controller,
    this.initializing = false,
  }) : super(key: key);

  @override
  TwitterVideoPlayerState createState() => TwitterVideoPlayerState();
}

class TwitterVideoPlayerState extends State<TwitterVideoPlayer> {
  static const play = Icon(
    Icons.play_arrow,
    size: 100.0,
    color: Colors.white,
  );

  static const pause = Icon(
    Icons.pause,
    size: 100.0,
    color: Colors.white,
  );

  static const bufferIndicator = CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  );

  /// The [VideoPlayerController] for the video.
  ///
  /// Equal to the [widget.controller] if it's not null.
  VideoPlayerController controller;

  /// `true` while the [controller] is initially loading the video.
  bool initializing = false;

  /// `true` while the video is playing.
  bool _playing = false;

  /// `true` while the video is buffering.
  bool _buffering = false;

  /// `true` when the [controller] position reached the end of the video.
  bool _finished = false;

  /// The [VideoPlayerValue] of the last [_listener] call.
  ///
  /// Used to determine whether or not the video is [_buffering].
  VideoPlayerValue _lastValue;

  /// The pause / play [FadeAnimation].
  FadeAnimation _fadeAnimation;

  /// The rewind [FadeAnimation].
  FadeAnimation _rewindFadeAnimation;

  /// The forward [FadeAnimation].
  FadeAnimation _forwardFadeAnimation;

  /// The url of the thumbnail to display when the [controller] has not been
  /// initialized.
  String get _thumbnailUrl => widget.media.mediaUrl;

  /// The aspect ratio of the video.
  ///
  /// If the [controller] has not been initialized it will calculate the aspect
  /// ratio from the [TwitterMedia].
  double get _aspectRatio {
    return controller.value.initialized
        ? controller.value.aspectRatio
        : (widget.media.videoInfo?.aspectRatio[0] ?? 1) /
            (widget.media.videoInfo.aspectRatio[1] ?? 1);
  }

  /// The url of the video for the [controller] to load.
  String get _videoUrl =>
      widget.media.videoInfo.variants.first.url; // todo: quality

  /// Determines whether the [RotatedBox] should rotate the video / thumbnail by
  /// one quarter or not.
  int get _rotation => widget.isFullscreen && _aspectRatio > 1 ? 1 : 0;

  @override
  void initState() {
    super.initState();

    initializing = widget.initializing;

    controller = widget.controller ?? VideoPlayerController.network(_videoUrl)
      ..addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.controller != null) {
      // this widget is not using a self created controller, don't dispose it
      // only remove the listener
      controller.removeListener(_listener);
    } else {
      // this widget created the controller, dispose it
      controller.dispose();
    }
  }

  void _listener() {
    final playing = controller.value.isPlaying;

    if (_playing != playing) {
      setState(() {
        _playing = playing;
      });
    }

    final finished = controller.value.position >= controller.value.duration;

    if (_finished != finished) {
      setState(() {
        _finished = finished;
      });
    }

    // buffering workaround
    // the video player buffering start / end event is never fired on android,
    // so instead assume buffering when the video is playing but the position
    // is not changing.
    final buffering = (_lastValue?.isPlaying ?? false) &&
        !_finished &&
        controller.value.isPlaying &&
        controller.value.position == _lastValue.position;

    if (_buffering != buffering) {
      setState(() {
        _buffering = buffering;
      });
    }

    _lastValue = controller.value;
  }

  /// Initializes the controller and plays the video.
  void _initializeController() {
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

  void _toggleVideo() {
    if (controller.value.initialized) {
      if (controller.value.isPlaying) {
        controller.pause();
        _fadeAnimation = FadeAnimation(child: pause);
      } else {
        controller.play();
        _fadeAnimation = FadeAnimation(child: play);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isFullscreen ? double.infinity : null,
      height: widget.isFullscreen ? double.infinity : null,
      color: widget.isFullscreen ? Colors.black : Colors.transparent,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: RotatedBox(
            quarterTurns: _rotation,
            child: AspectRatio(
              aspectRatio: _aspectRatio,
              child: controller.value.initialized
                  ? _buildVideoPlayer()
                  : _buildThumbnail(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return GestureDetector(
      // initialize and start the video when clicking on the thumbnail
      onTap: _initializeController,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          // thumbnail as an image
          CachedNetworkImage(
            imageUrl: _thumbnailUrl,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),

          // center icon
          Center(child: initializing ? bufferIndicator : play),

          _buildFullscreenButton(),
        ],
      ),
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

        _buildFullscreenButton(),

        // play / pause icon fade animation
        Center(child: _fadeAnimation),

        // buffer indicator
        Center(
          child: _buffering ? bufferIndicator : null,
        ),

        // play again
        Center(
          child: _finished ? _buildPlayAgainButton() : null,
        )
      ],
    );
  }

  Widget _buildFullscreenButton() {
    final icon = Icon(
      widget.isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
      color: Colors.white,
      size: 36.0,
    );

    final onPressed = () {
      if (!widget.isFullscreen && widget.onShowFullscreen != null) {
        widget.onShowFullscreen();
      } else if (widget.isFullscreen && widget.onHideFullscreen != null) {
        widget.onHideFullscreen(context);
      }
    };

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: CircleButton(
          child: icon,
          onPressed: onPressed,
        ),
      ),
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
        _rewindFadeAnimation = FadeAnimation(
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
        _forwardFadeAnimation = FadeAnimation(
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
