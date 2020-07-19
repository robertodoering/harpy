import 'package:flutter/material.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/core/api/media_data.dart';

/// Builds a [HarpyVideoPlayer] for the [TweetMedia] video.
class TweetVideo extends StatelessWidget {
  const TweetVideo(this.video);

  final VideoData video;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: HarpyVideoPlayer(
        video.variants.last.url,
        thumbnail: video.thumbnailUrl,
      ),
    );
  }
}
