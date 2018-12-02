import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:video_player/video_player.dart';

// media types
const String photo = "photo";
const String video = "video";
const String animatedGif = "animated_gif";

/// Builds a column of media that can be collapsed.
class CollapsibleMedia extends StatelessWidget {
  final List<TwitterMedia> media;

  const CollapsibleMedia(this.media);

  @override
  Widget build(BuildContext context) {
    print(media);

    return ExpansionTile(
      title: Container(),
      initiallyExpanded: true,
      children: <Widget>[
        Container(
          height: 250.0,
          child: _buildMedia(),
        ),
      ],
    );
  }

  Widget _buildMedia() {
    double padding = 2.0;

    if (media.length == 1) {
      return Row(
        children: <Widget>[
          _createMediaWidget(media[0]),
        ],
      );
    } else if (media.length == 2) {
      return Row(
        children: <Widget>[
          _createMediaWidget(media[0]),
          SizedBox(width: padding),
          _createMediaWidget(media[1]),
        ],
      );
    } else if (media.length == 3) {
      return Row(
        children: <Widget>[
          _createMediaWidget(media[0]),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                _createMediaWidget(media[1]),
                SizedBox(height: padding),
                _createMediaWidget(media[2]),
              ],
            ),
          ),
        ],
      );
    } else if (media.length == 4) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _createMediaWidget(media[0]),
                SizedBox(height: padding),
                _createMediaWidget(media[2]),
              ],
            ),
          ),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                _createMediaWidget(media[1]),
                SizedBox(height: padding),
                _createMediaWidget(media[3]),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _createMediaWidget(TwitterMedia media) {
    if (media.type == photo) {
      return Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: Image.network(
            media.mediaUrl,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (media.type == video) {
      return TwitterVideoPlayer(media.videoInfo.variants.first.url);
    } else {
      return Container();
    }
  }
}

class TwitterVideoPlayer extends StatefulWidget {
  final String url;

  const TwitterVideoPlayer(this.url);

  @override
  _TwitterVideoPlayerState createState() => _TwitterVideoPlayerState();
}

class _TwitterVideoPlayerState extends State<TwitterVideoPlayer> {
  VideoPlayerController _controller;
  bool _isPlaying;

  @override
  void initState() {
    super.initState();

    print("playing video from url: ${widget.url}");

    _controller = VideoPlayerController.network(widget.url)
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
//    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.initialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container();
  }
}
