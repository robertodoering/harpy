import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// A mixin implemented by [MediaVideoPlayer] and [MediaGifPlayer].
mixin MediaPlayerMixin<T extends StatefulWidget> on State<T> {
  VideoPlayerController controller;

  bool initialized = false;
  bool initializing = false;

  String get thumbnailUrl;

  String get videoUrl;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.network(videoUrl);

    // todo: if autoplay && video in scroll view -> initialize
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  /// Initializes and plays the video when it hasn't been initialized and is not
  /// initializing.
  void initialize() {
    if (initializing || initialized) {
      return;
    }

    setState(() {
      initializing = true;
    });
    controller.initialize().then((_) {
      setState(() {
        initialized = true;
        initializing = false;
        controller.play();
      });
    });
  }

  /// Builds the thumbnail for the video when it hasn't been loaded yet.
  Widget buildThumbnail();

  Widget buildVideoPlayer();

  @override
  Widget build(BuildContext context) {
    return initialized
        ? buildVideoPlayer()
        : GestureDetector(
            onTap: initialize,
            child: buildThumbnail(),
          );
  }
}
