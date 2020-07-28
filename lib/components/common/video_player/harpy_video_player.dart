import 'package:flutter/material.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_model.dart';
import 'package:harpy/components/common/video_player/video_player_overlay.dart';
import 'package:harpy/components/common/video_player/video_thumbnail.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// The size for icons appearing in the center of the video player
const double kVideoPlayerCenterIconSize = 48;

/// Builds a [VideoPlayer] with a [VideoPlayerOverlay] to control the video.
///
/// When built initially, the video will not be initialized and instead the
/// [thumbnail] url is used to build an image in place of the video. After being
/// tapped the video will be initialized and starts playing.
///
/// A [HarpyVideoPlayerModel] is used to control the video.
class HarpyVideoPlayer extends StatefulWidget {
  const HarpyVideoPlayer(
    this.url, {
    this.thumbnail,
  });

  /// The url of the video.
  final String url;

  /// An optional url to a thumbnail that is built when the video is not
  /// initialized.
  final String thumbnail;

  @override
  _HarpyVideoPlayerState createState() => _HarpyVideoPlayerState();
}

class _HarpyVideoPlayerState extends State<HarpyVideoPlayer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  /// Builds a [VideoThumbnail] that will start to initialize the video when
  /// tapped.
  Widget _buildUninitialized(HarpyVideoPlayerModel model) {
    return VideoThumbnail(
      thumbnail: widget.thumbnail,
      icon: Icons.play_arrow,
      initializing: model.initializing,
      onTap: model.initialize,
    );
  }

  Widget _buildVideo(HarpyVideoPlayerModel model) {
    return Hero(
      tag: model.controller,
      child: Stack(
        children: <Widget>[
          VideoPlayer(_controller),
          VideoPlayerOverlay(model),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HarpyVideoPlayerModel>(
      create: (BuildContext context) => HarpyVideoPlayerModel(_controller),
      builder: (BuildContext context, Widget child) {
        final HarpyVideoPlayerModel model = HarpyVideoPlayerModel.of(context);

        if (!model.initialized) {
          return _buildUninitialized(model);
        } else {
          return _buildVideo(model);
        }
      },
    );
  }
}
