import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/components/shared/buttons.dart';
import 'package:harpy/components/shared/media/twitter_video_player.dart';
import 'package:video_player/video_player.dart';

class TwitterGifPlayer extends StatefulWidget {
  final TwitterMedia media;
  final bool isFullscreen;
  final VoidCallback onShowFullscreen;
  final HideFullscreenCallback onHideFullscreen;
  final VideoPlayerController controller;
  final bool initializing;

  const TwitterGifPlayer({
    Key key,
    @required this.media,
    this.isFullscreen = false,
    this.onShowFullscreen,
    this.onHideFullscreen,
    this.controller,
    this.initializing = false,
  }) : super(key: key);

  @override
  TwitterGifPlayerState createState() => TwitterGifPlayerState();
}

class TwitterGifPlayerState extends State<TwitterGifPlayer> {
  static const bufferIndicator = CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  );

  /// The [VideoPlayerController] for the video.
  ///
  /// Equal to the [widget.controller] if it's not null.
  VideoPlayerController controller;

  /// `true` while the [controller] is initially loading the video.
  bool initializing = false;

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
      ..setLooping(true);
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

  @override
  Widget build(BuildContext context) {
    var body = Material(
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
    );

    return Container(
      width: widget.isFullscreen ? double.infinity : null,
      height: widget.isFullscreen ? double.infinity : null,
      color: widget.isFullscreen ? Colors.black : Colors.transparent,
      child: widget.isFullscreen ? Center(child: body) : body,
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
          Center(
            child: initializing
                ? bufferIndicator
                : CircleButton(
                    child: Text(
                      "GIF",
                      style: Theme.of(context)
                          .textTheme
                          .display2
                          .copyWith(color: Colors.white),
                    ),
                  ),
          ),

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
        VideoPlayer(controller),

        // todo: quality selection

        _buildFullscreenButton(),
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
}
