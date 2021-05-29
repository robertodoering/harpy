import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:video_player/video_player.dart';

/// Builds a [HarpyVideoPlayer] for the [TweetMedia] gif.
class TweetGif extends StatelessWidget {
  const TweetGif(
    this.tweet, {
    required this.tweetBloc,
  });

  final TweetData? tweet;
  final TweetBloc tweetBloc;

  void _openGallery(HarpyVideoPlayerModel model) {
    MediaOverlay.open(
      tweet: tweet!,
      tweetBloc: tweetBloc,
      enableImmersiveMode: false,
      overlap: true,
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
          thumbnail: tweet!.gif!.thumbnailUrl,
          thumbnailAspectRatio: tweet!.gif!.validAspectRatio
              ? tweet!.gif!.aspectRatioDouble
              : 16 / 9,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaPreferences = app<MediaPreferences>();

    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: kDefaultBorderRadius,
      child: HarpyGifPlayer.fromController(
        VideoPlayerController.network(
          tweet!.gif!.appropriateUrl!,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        ),
        thumbnail: tweet!.gif!.thumbnailUrl,
        onGifTap: _openGallery,
        onGifLongPress: () => showTweetMediaBottomSheet(
          context,
          url: tweet!.downloadMediaUrl(),
          mediaType: MediaType.gif,
        ),
        autoplay: mediaPreferences.shouldAutoplayMedia,
        allowVerticalOverflow: true,
      ),
    );
  }
}
