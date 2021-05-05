import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:video_player/video_player.dart';

/// Builds a [HarpyVideoPlayer] for the [TweetMedia] video.
class TweetVideo extends StatelessWidget {
  const TweetVideo(
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
      child: HarpyVideoPlayer.fromModel(
        model,
        thumbnail: tweet!.video!.thumbnailUrl,
        thumbnailAspectRatio: tweet!.video!.validAspectRatio
            ? tweet!.video!.aspectRatioDouble
            : 16 / 9,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaPreferences mediaPreferences = app<MediaPreferences>();

    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: kDefaultBorderRadius as BorderRadius?,
      child: HarpyVideoPlayer.fromController(
        VideoPlayerController.network(
          tweet!.video!.appropriateUrl!,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        ),
        thumbnail: tweet!.video!.thumbnailUrl,
        onVideoPlayerTap: _openGallery,
        onVideoPlayerLongPress: () => showTweetMediaBottomSheet(
          context,
          url: tweetBloc.downloadMediaUrl(tweet!),
        ),
        autoplay: mediaPreferences.shouldAutoplayVideos,
        allowVerticalOverflow: true,
      ),
    );
  }
}
