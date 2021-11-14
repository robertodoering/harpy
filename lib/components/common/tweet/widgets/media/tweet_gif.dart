import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// Builds a [HarpyVideoPlayer] for the [TweetMedia] gif.
class TweetGif extends StatelessWidget {
  const TweetGif();

  void _openGallery(HarpyVideoPlayerModel model, TweetBloc bloc) {
    MediaOverlay.open(
      tweetBloc: bloc,
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
          thumbnail: bloc.tweet.gif!.thumbnailUrl,
          thumbnailAspectRatio: bloc.tweet.gif!.validAspectRatio
              ? bloc.tweet.gif!.aspectRatioDouble
              : 16 / 9,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaPreferences = app<MediaPreferences>();

    final bloc = context.watch<TweetBloc>();

    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: kBorderRadius,
      child: HarpyGifPlayer.fromController(
        VideoPlayerController.network(
          bloc.tweet.gif!.appropriateUrl!,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        ),
        thumbnail: bloc.tweet.gif!.thumbnailUrl,
        onGifTap: (model) => _openGallery(model, bloc),
        onGifLongPress: () => showTweetMediaBottomSheet(
          context,
          url: bloc.tweet.downloadMediaUrl(),
          mediaType: MediaType.gif,
        ),
        autoplay: mediaPreferences.shouldAutoplayMedia,
        allowVerticalOverflow: true,
      ),
    );
  }
}
