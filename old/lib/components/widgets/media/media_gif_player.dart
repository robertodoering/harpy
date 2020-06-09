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
      aspectRatio: mediaModel.videoAspectRatio,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: mediaModel.thumbnailUrl,
          ),
          Center(
            child: initializing
                ? const CircularProgressIndicator()
                : const CircleButton(
                    child: Icon(Icons.gif, size: kMediaIconSize),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildVideoPlayer() {
    // empty gesture detector to prevent underlying gesture detector to
    // receive the on tap when the gif is played (to push the replies screen)
    return GestureDetector(
      onTap: () {},
      child: AspectRatio(
        aspectRatio: mediaModel.videoAspectRatio,
        child: VideoPlayer(controller),
      ),
    );
  }
}
