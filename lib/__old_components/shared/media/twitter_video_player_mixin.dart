import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/__old_components/shared/buttons.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:video_player/video_player.dart';

typedef HideFullscreenCallback(BuildContext context);

const Icon play = Icon(
  Icons.play_arrow,
  size: 72.0,
  color: Colors.white,
);

const Icon pause = Icon(
  Icons.pause,
  size: 72.0,
  color: Colors.white,
);

const bufferIndicator = CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
);

/// A mixin that contains shared information to be used by different
/// [VideoPlayer] wrappers.
///
/// Used by [TwitterVideoPlayer] and [TwitterGifPlayer].
mixin TwitterVideoPlayerMixin<T extends StatefulWidget> on State<T> {
  /// The [TwitterMedia] that contains the information for the video.
  TwitterMedia media;

  /// The callback when showing the fullscreen mode.
  VoidCallback onShowFullscreen;

  /// The callback when exiting the fullscreen mode.
  HideFullscreenCallback onHideFullscreen;

  /// The [VideoPlayerController] for the video.
  ///
  /// Equal to the [widget.controller] if it's not null.
  VideoPlayerController controller;

  /// `true` while the [controller] is initially loading the video.
  bool initializing = false;

  /// `true` while the video is playing.
  bool playing = false;

  /// `true` while the video is buffering.
  bool buffering = false;

  /// `true` when the [controller] position reached the end of the video.
  bool finished = false;

  /// Whether or not the video should be shown in fullscreen.
  bool fullscreen = false;

  /// The [VideoPlayerValue] of the last [listener] call.
  ///
  /// Used to determine whether or not the video is [buffering].
  VideoPlayerValue lastValue;

  /// The url of the thumbnail to display when the [controller] has not been
  /// initialized.
  String get thumbnailUrl => media.mediaUrl;

  /// The aspect ratio of the video.
  ///
  /// If the [controller] has not been initialized it will calculate the aspect
  /// ratio from the [TwitterMedia].
  double get aspectRatio {
    return controller.value.initialized
        ? controller.value.aspectRatio
        : (media.videoInfo?.aspectRatio[0] ?? 1) /
            (media.videoInfo.aspectRatio[1] ?? 1);
  }

  /// The url of the video for the [controller] to load.
  String get videoUrl => media.videoInfo.variants.first.url; // todo: quality

  /// Determines whether the [RotatedBox] should rotate the video / thumbnail by
  /// one quarter or not.
  int get rotation => fullscreen && aspectRatio > 1 ? 1 : 0;

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

  /// Builds the thumbnail that initializes the [controller] on tap.
  Widget buildThumbnail(Widget centerIcon) {
    return GestureDetector(
      // initialize and start the video when clicking on the thumbnail
      onTap: initializeController,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          // thumbnail as an image
          CachedNetworkImage(
            imageUrl: thumbnailUrl,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),

          // center icon
          Center(child: initializing ? bufferIndicator : centerIcon),

          buildFullscreenButton(),
        ],
      ),
    );
  }

  /// Builds the button that calls the [onShowFullscreen] or
  /// [onHideFullscreen] callback.
  Widget buildFullscreenButton() {
    final icon = Icon(
      fullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
      color: Colors.white,
      size: 32.0,
    );

    final onPressed = () {
      if (!fullscreen && onShowFullscreen != null) {
        onShowFullscreen();
      } else if (fullscreen && onHideFullscreen != null) {
        onHideFullscreen(context);
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
}
