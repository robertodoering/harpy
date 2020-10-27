import 'package:flutter/material.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_model.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/widgets/overlay/media_overlay.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

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
    // todo: pass along an on tap method that opens the overlay and gets the
    //   video controller which is used in building a harpy video player with an
    //   existing controller.

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
