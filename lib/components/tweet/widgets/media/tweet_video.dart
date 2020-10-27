import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/custom_dismissible.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_model.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/widgets/overlay/media_overlay.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/misc/harpy_navigator.dart';

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
      child: CustomDismissible(
        onDismissed: () => app<HarpyNavigator>().state.maybePop(),
        child: HarpyVideoPlayer.fromModel(
          model,
          thumbnail: tweet.video.thumbnailUrl,
          thumbnailAspectRatio: tweet.video.validAspectRatio
              ? tweet.video.aspectRatioDouble
              : 16 / 9,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: kDefaultBorderRadius,
      child: HarpyVideoPlayer.fromUrl(
        tweet.video.appropriateUrl,
        thumbnail: tweet.video.thumbnailUrl,
        onVideoPlayerTap: _openGallery,
        allowVerticalOverflow: true,
      ),
    );
  }
}
