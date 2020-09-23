import 'package:flutter/material.dart';
import 'package:harpy/components/common/video_player/harpy_gif_player.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/core/api/twitter/media_data.dart';
import 'package:harpy/core/preferences/media_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds a [HarpyVideoPlayer] for the [TweetMedia] video.
class TweetGif extends StatelessWidget {
  const TweetGif(this.gif);

  final VideoData gif;

  @override
  Widget build(BuildContext context) {
    final MediaPreferences mediaPreferences = app<MediaPreferences>();

    return ClipRRect(
      borderRadius: kDefaultBorderRadius,
      child: HarpyGifPlayer(
        gif.appropriateUrl,
        thumbnail: gif.thumbnailUrl,
        autoplay: mediaPreferences.shouldAutoplayMedia,
      ),
    );
  }
}
