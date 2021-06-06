import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:video_player/video_player.dart';

/// Builds the image, gif or video for a media widget in the [MediaTimeline].
class MediaTimelineMediaWidget extends StatelessWidget {
  const MediaTimelineMediaWidget({
    required this.entry,
    required this.index,
    required this.onImageTap,
    required this.onVideoTap,
    required this.buildCompactOverlay,
  });

  final MediaTimelineEntry entry;
  final int index;
  final VoidCallback onImageTap;
  final OnVideoPlayerTap onVideoTap;
  final bool buildCompactOverlay;

  void _onLongPress(BuildContext context) {
    showTweetMediaBottomSheet(
      context,
      url: entry.media!.bestUrl,
      mediaType: entry.tweet.mediaType,
    );
  }

  Widget _buildImage(BuildContext context) {
    return Hero(
      tag: '$index-${entry.media!.appropriateUrl}',
      placeholderBuilder: (_, __, child) => child,
      child: GestureDetector(
        onTap: onImageTap,
        onLongPress: () => _onLongPress(context),
        child: AspectRatio(
          aspectRatio: entry.media!.aspectRatioDouble,
          child: HarpyImage(
            imageUrl: entry.media!.appropriateUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildGif(BuildContext context) {
    final autoplay = app<MediaPreferences>().shouldAutoplayMedia;

    final child = AspectRatio(
      aspectRatio: entry.media!.aspectRatioDouble,
      child: HarpyGifPlayer.fromController(
        VideoPlayerController.network(
          entry.videoData!.appropriateUrl!,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        ),
        compact: buildCompactOverlay,
        thumbnail: entry.videoData!.thumbnailUrl,
        thumbnailAspectRatio: entry.videoData!.aspectRatioDouble,
        autoplay: autoplay,
        onGifTap: onVideoTap,
        onGifLongPress: () => _onLongPress(context),
      ),
    );

    if (autoplay) {
      return VisibilityChangeDetector(
        key: Key(entry.videoData!.appropriateUrl!),
        child: child,
      );
    } else {
      return child;
    }
  }

  Widget _buildVideo(BuildContext context) {
    return AspectRatio(
      aspectRatio: entry.videoData!.aspectRatioDouble,
      child: HarpyVideoPlayer.fromController(
        VideoPlayerController.network(
          entry.videoData!.appropriateUrl!,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        ),
        compact: buildCompactOverlay,
        thumbnail: entry.videoData!.thumbnailUrl,
        thumbnailAspectRatio: entry.videoData!.aspectRatioDouble,
        onVideoPlayerTap: onVideoTap,
        onVideoPlayerLongPress: () => _onLongPress(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox();

    if (entry.isImage) {
      child = _buildImage(context);
    } else if (entry.isGif) {
      child = _buildGif(context);
    } else if (entry.isVideo) {
      child = _buildVideo(context);
    }

    return BlocProvider<TweetBloc>(
      create: (_) => TweetBloc(entry.tweet),
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: kDefaultBorderRadius,
        child: child,
      ),
    );
  }
}
