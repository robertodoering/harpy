import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/media/media_player.dart';
import 'package:harpy/components/widgets/media/media_video_player.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/models/media_model.dart';
import 'package:video_player/video_player.dart';

/// The [VideoPlayer] for twitter gifs.
///
/// Depending on the media settings it will autoplay or display the thumbnail
/// and initialize the gif on tap.
///
/// The [MediaGifPlayer] will take up the maximal available space while keeping
/// its aspect ratio.
class MediaGifPlayer extends StatefulWidget {
  const MediaGifPlayer({
    @required this.mediaModel,
  });

  final MediaModel mediaModel;

  @override
  _MediaGifPlayerState createState() => _MediaGifPlayerState();
}

class _MediaGifPlayerState extends State<MediaGifPlayer>
    with MediaPlayerMixin<MediaGifPlayer> {
  @override
  MediaModel get mediaModel => widget.mediaModel;

  @override
  void initState() {
    super.initState();

    controller.setLooping(true);
  }

  @override
  Widget buildThumbnail() {
    return AspectRatio(
      aspectRatio: mediaModel.getVideoAspectRatio(),
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: mediaModel.getThumbnailUrl(),
          ),
          Center(
            child: initializing
                ? CircularProgressIndicator()
                : CircleButton(
                    child: Icon(Icons.gif, size: kMediaIconSize),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: mediaModel.getVideoAspectRatio(),
      child: VideoPlayer(controller),
    );
  }
}

class MediaGifOverlay extends StatefulWidget {
  const MediaGifOverlay({
    @required this.videoPlayer,
    @required this.child,
  });

  final MediaVideoPlayerState videoPlayer;
  final Widget child;

  @override
  _MediaGifOverlayState createState() => _MediaGifOverlayState();
}

class _MediaGifOverlayState extends State<MediaGifOverlay>
    with MediaOverlayMixin<MediaGifOverlay> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
