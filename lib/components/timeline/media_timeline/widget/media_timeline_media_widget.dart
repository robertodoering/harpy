import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/harpy_image.dart';
import 'package:harpy/components/common/video_player/harpy_gif_player.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/components/timeline/media_timeline/model/media_timeline_model.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/core/preferences/media_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:video_player/video_player.dart';

/// Builds the image, gif or video for a media widget in the [MediaTimeline].
class MediaTimelineMediaWidget extends StatelessWidget {
  const MediaTimelineMediaWidget({
    @required this.entry,
    @required this.index,
    @required this.onImageTap,
    @required this.onVideoTap,
  });

  final MediaTimelineEntry entry;
  final int index;
  final VoidCallback onImageTap;
  final OnVideoPlayerTap onVideoTap;

  Widget _buildImage() {
    return Hero(
      tag: '$index-${entry.media.appropriateUrl}',
      placeholderBuilder: (_, __, Widget child) => child,
      child: GestureDetector(
        onTap: onImageTap,
        child: AspectRatio(
          // switch between 16 / 9 and 8 / 9 (twice as tall as 16 / 9)
          aspectRatio: index.isEven ? 8 / 9 : 16 / 9,
          child: HarpyImage(
            imageUrl: entry.media.appropriateUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildGif() {
    return AspectRatio(
      aspectRatio: entry.videoData.aspectRatioDouble,
      child: HarpyGifPlayer.fromController(
        VideoPlayerController.network(
          entry.videoData.appropriateUrl,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        ),
        compact: true,
        thumbnail: entry.videoData.thumbnailUrl,
        thumbnailAspectRatio: entry.videoData.aspectRatioDouble,
        autoplay: app<MediaPreferences>().shouldAutoplayMedia,
        onGifTap: onVideoTap,
      ),
    );
  }

  Widget _buildVideo() {
    return AspectRatio(
      aspectRatio: entry.videoData.aspectRatioDouble,
      child: HarpyVideoPlayer.fromController(
        VideoPlayerController.network(
          entry.videoData.appropriateUrl,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        ),
        compact: true,
        thumbnail: entry.videoData.thumbnailUrl,
        thumbnailAspectRatio: entry.videoData.aspectRatioDouble,
        onVideoPlayerTap: onVideoTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox();

    if (entry.isImage) {
      child = _buildImage();
    } else if (entry.isGif) {
      child = _buildGif();
    } else if (entry.isVideo) {
      child = _buildVideo();
    }

    return BlocProvider<TweetBloc>(
      create: (_) => TweetBloc(entry.tweet),
      child: ClipRRect(
        borderRadius: kDefaultBorderRadius,
        child: child,
      ),
    );
  }
}