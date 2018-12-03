import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/components/shared/media/media_dialog.dart';
import 'package:harpy/components/shared/media/twitter_video_player.dart';
import 'package:photo_view/photo_view.dart';

// media types
const String photo = "photo";
const String video = "video";
const String animatedGif = "animated_gif";

/// A helper class that contains the built image / gif / video [widget] from the
/// [TwitterMedia] with extra meta information.
class MediaModel {
  /// The type of the [TwitterMedia].
  ///
  /// Can be [photo], [video] or [animatedGif],
  final String type;

  /// The widget created from the [TwitterMedia].
  ///
  /// Can be a [CachedNetworkImage] or a [TwitterVideoPlayer].
  final Widget widget;

  /// The width and height of the image.
  ///
  /// Used for the [PhotoView] to calculate its [minScale].
  /// The values don't have to be the exact dimensions as long as the aspect
  /// ratio stays the same.
  ///
  /// `null` if the type is [video].
  final double width;
  final double height;

  const MediaModel({
    @required this.type,
    @required this.widget,
    this.width,
    this.height,
  });
}

/// Builds a column of media that can be collapsed.
class CollapsibleMedia extends StatelessWidget {
  final List<TwitterMedia> media;
  final List<MediaModel> mediaModels = [];

  CollapsibleMedia(this.media) {
    // init media models
    for (var media in media) {
      if (media.type == photo || media.type == animatedGif) {
        int width = media.largeWidth ?? media.mediumWidth ?? media.smallWidth;
        int height =
            media.largeHeight ?? media.mediumHeight ?? media.smallHeight;

        // cached network image
        mediaModels.add(
          MediaModel(
            type: media.type,
            widget: CachedNetworkImage(
              imageUrl: media.mediaUrl,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            width: width.toDouble(),
            height: height.toDouble(),
          ),
        );
      } else if (media.type == video) {
        double thumbnailAspectRatio =
            media.videoInfo.aspectRatio[0] / media.videoInfo.aspectRatio[1];

        // twitter video player
        mediaModels.add(
          MediaModel(
            type: media.type,
            widget: TwitterVideoPlayer(
              videoUrl: media.videoInfo.variants.first.url, // todo
              thumbnail: media.mediaUrl,
              thumbnailAspectRatio: thumbnailAspectRatio,
            ),
          ),
        );
      }
    }
  }

  // todo: test gif
  // todo: click on media to open in fullscreen dialog

  @override
  Widget build(BuildContext context) {
    print(media);

    return ExpansionTile(
      title: Container(),
      initiallyExpanded: true,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: media.any((media) => media.type == video)
                ? double.infinity
                : 250.0,
          ),
          child: _buildMedia(context),
        ),
      ],
    );
  }

  Widget _buildMedia(BuildContext context) {
    final double padding = 2.0;

    if (media.length == 1) {
      return Row(
        children: <Widget>[
          _buildMediaWidget(mediaModels[0], context),
        ],
      );
    } else if (media.length == 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMediaWidget(mediaModels[0], context),
          SizedBox(width: padding),
          _buildMediaWidget(mediaModels[1], context),
        ],
      );
    } else if (media.length == 3) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMediaWidget(mediaModels[0], context),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                _buildMediaWidget(mediaModels[1], context),
                SizedBox(height: padding),
                _buildMediaWidget(mediaModels[2], context),
              ],
            ),
          ),
        ],
      );
    } else if (media.length == 4) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _buildMediaWidget(mediaModels[0], context),
                SizedBox(height: padding),
                _buildMediaWidget(mediaModels[2], context),
              ],
            ),
          ),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                _buildMediaWidget(mediaModels[1], context),
                SizedBox(height: padding),
                _buildMediaWidget(mediaModels[3], context),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildMediaWidget(MediaModel mediaModel, BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return MediaDialog(
                  mediaModels: mediaModels,
                  index: mediaModels.indexOf(mediaModel),
                );
              },
            );
          },
          child: mediaModel.widget,
        ),
      ),
    );
  }
}
