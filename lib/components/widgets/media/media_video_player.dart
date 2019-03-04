import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.network(widget.mediaModel.getVideoUrl());
    controller.initialize().then((_) {
      setState(() {
        controller.play();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.mediaModel.getVideoAspectRatio(),
      child: MediaVideoOverlay(
        controller: controller,
        child: VideoPlayer(controller),
      ),
    );
  }
}

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

class _MediaVideoOverlayState extends State<MediaVideoOverlay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => print("hit video "),
      child: Stack(children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: VideoProgressIndicator(
            widget.controller,
            allowScrubbing: true,
          ),
        ),
        widget.child,
      ]),
    );
  }
}
