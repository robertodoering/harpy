import 'package:flutter/material.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_model.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media_modal_content.dart';
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

  void _onVideoDownload() {
    tweetBloc.add(DownloadMedia(tweet: tweet));
  }

  void _onVideoOpenExternally() {
    tweetBloc.add(OpenMediaExternally(tweet: tweet));
  }

  void _onVideoShare() {
    tweetBloc.add(ShareMedia(tweet: tweet));
  }

  void _openGallery(HarpyVideoPlayerModel model) {
    MediaOverlay.open(
      tweet: tweet,
      tweetBloc: tweetBloc,
      enableImmersiveMode: false,
      onDownload: _onVideoDownload,
      onOpenExternally: _onVideoOpenExternally,
      onShare: _onVideoShare,
      child: HarpyVideoPlayer.fromModel(
        model,
        thumbnail: tweet.video.thumbnailUrl,
        thumbnailAspectRatio: tweet.video.validAspectRatio
            ? tweet.video.aspectRatioDouble
            : 16 / 9,
      ),
    );
  }

  Future<void> _onVideoPlayerLongPress(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: kDefaultRadius,
          topRight: kDefaultRadius,
        ),
      ),
      builder: (BuildContext context) => TweetMediaModalContent(
        onDownload: _onVideoDownload,
        onOpenExternally: _onVideoOpenExternally,
        onShare: _onVideoShare,
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
        onVideoPlayerLongPress: () => _onVideoPlayerLongPress(context),
        autoplay: mediaPreferences.shouldAutoplayVideos,
        allowVerticalOverflow: true,
      ),
    );
  }
}
