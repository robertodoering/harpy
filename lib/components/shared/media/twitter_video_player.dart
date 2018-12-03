import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/shared/animations.dart';
import 'package:video_player/video_player.dart';

/// The [TwitterVideoPlayer] for Twitter videos.
///
/// Wraps a [VideoPlayer] with custom controls.
///
/// The [thumbnail] will be shown initially and loads the [videoUrl] on tap.
class TwitterVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String thumbnail;
  final double thumbnailAspectRatio;

  const TwitterVideoPlayer({
    @required this.videoUrl,
    @required this.thumbnail,
    @required this.thumbnailAspectRatio,
  });

  @override
  _TwitterVideoPlayerState createState() => _TwitterVideoPlayerState();
}

class _TwitterVideoPlayerState extends State<TwitterVideoPlayer> {
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

  VideoPlayerController _controller;
  bool _isPlaying;

  FadeAnimation _fadeAnimation = FadeAnimation(child: play);

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;

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
    return _controller.value.initialized
        ? _buildVideoPlayer()
        : _buildThumbnail();
  }

  Widget _buildThumbnail() {
    return GestureDetector(
      // initialize and start the video when clicking on the thumbnail
      onTap: () {
        _controller.initialize().then((_) {
          setState(() => _controller.play());
        });
      },
      child: AspectRatio(
        aspectRatio: widget.thumbnailAspectRatio,
        child: Stack(
          children: <Widget>[
            // thumbnail as an image
            CachedNetworkImage(imageUrl: widget.thumbnail),

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
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          // video
          GestureDetector(
            child: VideoPlayer(_controller),
            onTap: () {
              if (!_controller.value.initialized) {
                return;
              }
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            },
          ),

          // progress indicator
          Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
            ),
          ),

          // todo: volume changer

          // todo: fullscreen button
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: const Icon(
                Icons.fullscreen,
                color: Colors.white,
                size: 36.0,
              ),
              onPressed: () {},
            ),
          ),

          // play / pause icon fade animation
          Center(child: _fadeAnimation),

          // buffer indicator
          Center(
              child: _controller.value.isBuffering
                  ? const CircularProgressIndicator()
                  : null),
        ],
      ),
    );
  }
}
