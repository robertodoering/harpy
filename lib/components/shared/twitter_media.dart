import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/components/shared/animations.dart';
import 'package:video_player/video_player.dart';

// media types
const String photo = "photo";
const String video = "video";
const String animatedGif = "animated_gif";

/// Builds a column of media that can be collapsed.
class CollapsibleMedia extends StatelessWidget {
  final List<TwitterMedia> media;
  final List<Widget> mediaWidgets = [];

  CollapsibleMedia(this.media) {
    // init media widgets
    for (var media in media) {
      if (media.type == photo || media.type == animatedGif) {
        mediaWidgets.add(CachedNetworkImage(
          imageUrl: media.mediaUrl,
          fit: BoxFit.cover,
        ));
      } else if (media.type == video) {
        mediaWidgets.add(TwitterVideoPlayer(
          videoUrl: media.videoInfo.variants.first.url, // todo
          thumbnail: media.mediaUrl,
          thumbnailAspectRatio:
              media.videoInfo.aspectRatio[0] / media.videoInfo.aspectRatio[1],
        ));
      }
    }
  }

  // todo: test gif
  // todo: click on media to open in fullscreen dialog

  @override
  Widget build(BuildContext context) {
    print(media);

    return ExpansionTile(
      title: Container(),
      initiallyExpanded: true,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: media.any((media) => media.type == video)
                ? double.infinity
                : 250.0,
          ),
          child: _buildMedia(context),
        ),
      ],
    );
  }

  Widget _buildMedia(BuildContext context) {
    final double padding = 2.0;

    if (media.length == 1) {
      return Row(
        children: <Widget>[
          _buildMediaWidget(mediaWidgets[0], context),
        ],
      );
    } else if (media.length == 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMediaWidget(mediaWidgets[0], context),
          SizedBox(width: padding),
          _buildMediaWidget(mediaWidgets[1], context),
        ],
      );
    } else if (media.length == 3) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMediaWidget(mediaWidgets[0], context),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                _buildMediaWidget(mediaWidgets[1], context),
                SizedBox(height: padding),
                _buildMediaWidget(mediaWidgets[2], context),
              ],
            ),
          ),
        ],
      );
    } else if (media.length == 4) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _buildMediaWidget(mediaWidgets[0], context),
                SizedBox(height: padding),
                _buildMediaWidget(mediaWidgets[2], context),
              ],
            ),
          ),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                _buildMediaWidget(mediaWidgets[1], context),
                SizedBox(height: padding),
                _buildMediaWidget(mediaWidgets[3], context),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildMediaWidget(Widget mediaWidget, BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return MediaDialog(
                  mediaWidgets: mediaWidgets,
                  index: mediaWidgets.indexOf(mediaWidget),
                );
              },
            );
          },
          child: mediaWidget,
        ),
      ),
    );
  }
}

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

class MediaDialog extends StatelessWidget {
  final List<Widget> mediaWidgets;
  final int index;

  const MediaDialog({
    @required this.mediaWidgets,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: mediaWidgets[index],
    );
  }
}
