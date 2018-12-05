import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/shared/animations.dart';
import 'package:video_player/video_player.dart';

typedef HideFullscreenCallback(BuildContext context);

/// The [TwitterVideoPlayer] for Twitter videos.
///
/// Wraps a [VideoPlayer] with custom controls.
///
/// The [thumbnail] will be shown initially and loads the [videoUrl] on tap.
class TwitterVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String thumbnail;
  final double thumbnailAspectRatio;
  final VoidCallback onShowFullscreen;
  final HideFullscreenCallback onHideFullscreen;
  final VideoPlayerController controller;

  // todo: take a TwitterMedia as parameter and calculate aspect ratio here

  const TwitterVideoPlayer({
    key,
    @required this.videoUrl,
    @required this.thumbnail,
    @required this.thumbnailAspectRatio,
    this.onShowFullscreen,
    this.onHideFullscreen,
    this.controller,
  }) : super(key: key);

  @override
  TwitterVideoPlayerState createState() => TwitterVideoPlayerState();
}

class TwitterVideoPlayerState extends State<TwitterVideoPlayer> {
  static const Icon play = Icon(
    Icons.play_arrow,
    size: 100.0,
    color: Colors.white,
  );

  static const Icon pause = Icon(
    Icons.pause,
    size: 100.0,
    color: Colors.white,
  );

  VideoPlayerController controller;
  bool _isPlaying;
  bool _isFullscreen = false;

  FadeAnimation _fadeAnimation = FadeAnimation(child: play);

  @override
  void initState() {
    super.initState();

    controller = widget.controller != null
        ? widget.controller
        : VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        final bool isPlaying = controller.value.isPlaying;

        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;

            _fadeAnimation = isPlaying
                ? FadeAnimation(child: play)
                : FadeAnimation(child: pause);
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return controller.value.initialized
        ? _buildVideoPlayer()
        : _buildThumbnail();
  }

  Widget _buildThumbnail() {
    return GestureDetector(
      // initialize and start the video when clicking on the thumbnail
      onTap: () {
        controller.initialize().then((_) {
          setState(() {
            controller.play();
          });
        });
      },
      child: AspectRatio(
        aspectRatio: widget.thumbnailAspectRatio,
        child: Stack(
          children: <Widget>[
            // thumbnail as an image
            CachedNetworkImage(
              imageUrl: widget.thumbnail,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),

            // play icon
            Center(
              child: Icon(
                Icons.play_arrow,
                size: 100.0,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          // video
          GestureDetector(
            child: VideoPlayer(controller),
            onTap: () {
              if (!controller.value.initialized) {
                return;
              }
              if (controller.value.isPlaying) {
                controller.pause();
              } else {
                controller.play();
              }
            },
          ),

          // progress indicator
          Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgressIndicator(
              controller,
              allowScrubbing: true,
            ),
          ),

          // todo: volume changer

          // todo: better fullscreen button
          Align(
            alignment: Alignment.bottomRight,
            child: Material(
              color: Colors.transparent,
              child: _buildFullscreenButton(),
            ),
          ),

          // play / pause icon fade animation
          Center(child: _fadeAnimation),

          // buffer indicator
          Center(
              child: controller.value.isBuffering
                  ? const CircularProgressIndicator()
                  : null),
        ],
      ),
    );
  }

  Widget _buildFullscreenButton() {
    Icon icon = Icon(
      _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
      color: Colors.white,
      size: 36.0,
    );

    return IconButton(
      icon: icon,
      onPressed: () {
        if (!_isFullscreen && widget.onShowFullscreen != null) {
          widget.onShowFullscreen();
        } else if (_isFullscreen && widget.onHideFullscreen != null) {
          widget.onHideFullscreen(context);
        }

        setState(() {
          _isFullscreen = !_isFullscreen;
        });
      },
    );
  }
}
