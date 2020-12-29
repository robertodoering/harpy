import 'package:flutter/material.dart';
import 'package:harpy/components/common/video_player/harpy_gif_player.dart';
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

/// Builds a [HarpyVideoPlayer] for the [TweetMedia] gif.
class TweetGif extends StatelessWidget {
  const TweetGif(
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
      overlap: true,
      onDownload: () => tweetBloc.add(DownloadMedia(tweet: tweet)),
      onOpenExternally: () => tweetBloc.add(OpenMediaExternally(tweet: tweet)),
      onShare: () => tweetBloc.add(ShareMedia(tweet: tweet)),
      child: WillPopScope(
        onWillPop: () async {
          // resume playing when the overlay closes with the gif paused
          if (!model.playing) {
            model.togglePlayback();
          }
          return true;
        },
        child: HarpyGifPlayer.fromModel(
          model,
          thumbnail: tweet.gif.thumbnailUrl,
          thumbnailAspectRatio:
              tweet.gif.validAspectRatio ? tweet.gif.aspectRatioDouble : 16 / 9,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaPreferences mediaPreferences = app<MediaPreferences>();

    return ClipRRect(
      borderRadius: kDefaultBorderRadius,
      child: HarpyGifPlayer.fromController(
        VideoPlayerController.network(tweet.gif.appropriateUrl),
        thumbnail: tweet.gif.thumbnailUrl,
        onGifTap: _openGallery,
        autoplay: mediaPreferences.shouldAutoplayMedia,
        allowVerticalOverflow: true,
      ),
    );
  }
}
