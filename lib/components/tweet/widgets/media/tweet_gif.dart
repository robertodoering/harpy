import 'package:flutter/material.dart';
import 'package:harpy/components/common/video_player/harpy_gif_player.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/core/api/twitter/media_data.dart';

/// Builds a [HarpyVideoPlayer] for the [TweetMedia] video.
class TweetGif extends StatelessWidget {
  const TweetGif(this.gif);

  final VideoData gif;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: HarpyGifPlayer(
        gif.appropriateUrl,
        thumbnail: gif.thumbnailUrl,
      ),
    );
  }
}
