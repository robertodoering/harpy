import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// Builds a [HarpyVideoPlayer] for the [TweetMedia] video.
class TweetVideo extends StatelessWidget {
  const TweetVideo();

  void _openGallery(HarpyVideoPlayerModel model, TweetBloc bloc) {
    MediaOverlay.open(
      tweetBloc: bloc,
      enableImmersiveMode: false,
      child: HarpyVideoPlayer.fromModel(
        model,
        thumbnail: bloc.tweet.video!.thumbnailUrl,
        thumbnailAspectRatio: bloc.tweet.video!.validAspectRatio
            ? bloc.tweet.video!.aspectRatioDouble
            : 16 / 9,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaPreferences = app<MediaPreferences>();

    final bloc = context.watch<TweetBloc>();

    return GestureDetector(
      // eat all tap gestures (e.g. tapping on the overlay)
      onTap: () {},
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: kBorderRadius,
        child: HarpyVideoPlayer.fromController(
          VideoPlayerController.network(
            bloc.tweet.video!.appropriateUrl!,
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          ),
          thumbnail: bloc.tweet.video!.thumbnailUrl,
          onVideoPlayerTap: (model) => _openGallery(model, bloc),
          onVideoPlayerLongPress: () => showTweetMediaBottomSheet(
            context,
            url: bloc.tweet.downloadMediaUrl(),
            mediaType: MediaType.video,
          ),
          autoplay: mediaPreferences.shouldAutoplayVideos,
          allowVerticalOverflow: true,
        ),
      ),
    );
  }
}
