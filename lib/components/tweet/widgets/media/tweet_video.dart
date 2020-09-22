import 'package:flutter/material.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/core/api/twitter/media_data.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds a [HarpyVideoPlayer] for the [TweetMedia] video.
class TweetVideo extends StatelessWidget {
  const TweetVideo(this.video);

  final VideoData video;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: kDefaultBorderRadius,
      child: HarpyVideoPlayer(
        video.appropriateUrl,
        thumbnail: video.thumbnailUrl,
      ),
    );
  }
}
