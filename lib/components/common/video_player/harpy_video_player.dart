import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_model.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_overlay.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

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

  /// Builds the [widget.thumbnail] that will start to initialize the video when
  /// tapped.
  Widget _buildUninitialized(HarpyVideoPlayerModel model) {
    final Widget child = model.initializing
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        : const Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 32,
          );

    return Stack(
      children: <Widget>[
        if (widget.thumbnail != null)
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: widget.thumbnail,
            height: double.infinity,
            width: double.infinity,
          ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black45,
            ),
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        ),
        GestureDetector(onTap: model.initialize),
      ],
    );
  }

  Widget _buildVideo(HarpyVideoPlayerModel model) {
    return Stack(
      children: <Widget>[
        VideoPlayer(_controller),
        VideoPlayerOverlay(model),
      ],
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
