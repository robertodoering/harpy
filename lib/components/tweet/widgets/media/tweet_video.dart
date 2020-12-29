import 'package:flutter/material.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_model.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/components/tweet/widgets/overlay/media_overlay.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/preferences/media_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:video_player/video_player.dart';

/// Builds a [HarpyVideoPlayer] for the [TweetMedia] video.
class TweetVideo extends StatelessWidget {
  const TweetVideo(
    this.tweet, {
    @required this.tweetBloc,
  });

  final TweetData tweet;
  final TweetBloc tweetBloc;

  void _openGallery(HarpyVideoPlayerModel model) {
    MediaOverlay.open(
      tweet: tweet,
      tweetBloc: tweetBloc,
      enableImmersiveMode: false,
      onDownload: () => tweetBloc.add(DownloadMedia(tweet: tweet)),
      onOpenExternally: () => tweetBloc.add(OpenMediaExternally(tweet: tweet)),
      child: HarpyVideoPlayer.fromModel(
        model,
        thumbnail: tweet.video.thumbnailUrl,
        thumbnailAspectRatio: tweet.video.validAspectRatio
            ? tweet.video.aspectRatioDouble
            : 16 / 9,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaPreferences mediaPreferences = app<MediaPreferences>();

    return ClipRRect(
      borderRadius: kDefaultBorderRadius,
      child: HarpyVideoPlayer.fromController(
        VideoPlayerController.network(tweet.video.appropriateUrl),
        thumbnail: tweet.video.thumbnailUrl,
        onVideoPlayerTap: _openGallery,
        autoplay: mediaPreferences.shouldAutoplayVideos,
        allowVerticalOverflow: true,
      ),
    );
  }
}
