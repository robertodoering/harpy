import 'package:flutter/material.dart';
import 'package:harpy/models/media_model.dart';
import 'package:video_player/video_player.dart';

/// A mixin implemented by [MediaVideoPlayer] and [MediaGifPlayer].
mixin MediaPlayerMixin<T extends StatefulWidget> on State<T> {
  VideoPlayerController controller;

  bool initialized = false;
  bool initializing = false;

  MediaModel get mediaModel;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.network(mediaModel.videoUrl);

    if (mediaModel.autoplay) {
      initialize();
    }
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

/// A mixin for overlays of [VideoPlayer] implementations.
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

  /// The [VideoPlayerValue]s of the last [listener] calls.
  ///
  /// Used to determine whether or not the video is [buffering].
  VideoPlayerValue lastValue;
  VideoPlayerValue secondLastValue;

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
    // so instead assume buffering when the current position is outside of
    // the buffered duration range
    final isBuffering = controller.value.buffered.isNotEmpty &&
        controller.value.position > controller.value.buffered.last.end;

    if (buffering != isBuffering) {
      setState(() {
        buffering = isBuffering;
      });
    }

    secondLastValue = lastValue;
    lastValue = controller.value;
  }
}
