import 'package:flutter/material.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_model.dart';
import 'package:harpy/components/common/video_player/video_thumbnail.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// Builds a [VideoPlayer] for an animated gif.
///
/// The video representing the gif will loop after initializing and play on tap.
class HarpyGifPlayer extends StatefulWidget {
  const HarpyGifPlayer(
    this.url, {
    this.thumbnail,
  });

  /// The url of the video.
  final String url;

  /// An optional url to a thumbnail that is built when the video is not
  /// initialized.
  final String thumbnail;

  @override
  _HarpyGifPlayerState createState() => _HarpyGifPlayerState();
}

class _HarpyGifPlayerState extends State<HarpyGifPlayer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url)..setLooping(true);
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
      icon: Icons.gif,
      initializing: model.initializing,
      onTap: () async {
        await model.initialize();
        _controller.play();
      },
    );
  }

  Widget _buildGif(HarpyVideoPlayerModel model) {
    return VideoPlayer(_controller);
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
          return _buildGif(model);
        }
      },
    );
  }
}
