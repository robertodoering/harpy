import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/components/shared/media/media_dialog.dart';
import 'package:harpy/components/shared/media/twitter_video_player.dart';
import 'package:harpy/components/shared/routes.dart';
import 'package:photo_view/photo_view.dart';

// media types
const String photo = "photo";
const String video = "video";
const String animatedGif = "animated_gif";

/// A helper class that contains the built image / gif / video [widget] from the
/// [TwitterMedia] with additional meta information.
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

  /// A unique [heroTag] used to for a [Hero] animation in the [MediaDialog].
  final String heroTag;

  const MediaModel({
    @required this.type,
    @required this.widget,
    this.width,
    this.height,
    this.heroTag,
  });
}

/// Builds a column of media that can be collapsed.
class CollapsibleMedia extends StatefulWidget {
  final List<TwitterMedia> media;

  const CollapsibleMedia(this.media);

  // todo: instead of using a ExpansionTile, build own widget where the expand
  // icon is stacked on the media, so the title of the ExpansionTile doesn't
  // take up so much space

  @override
  CollapsibleMediaState createState() {
    return new CollapsibleMediaState();
  }
}

class CollapsibleMediaState extends State<CollapsibleMedia> {
  final List<MediaModel> mediaModels = [];

  @override
  void initState() {
    super.initState();

    _initMediaModels();
  }

  void _initMediaModels() {
    for (int i = 0; i < widget.media.length; i++) {
      var media = widget.media[i];

      if (media.type == photo || media.type == animatedGif) {
        int width = media.largeWidth ?? media.mediumWidth ?? media.smallWidth;
        int height =
            media.largeHeight ?? media.mediumHeight ?? media.smallHeight;

        // cached network image
        Widget image = CachedNetworkImage(
          imageUrl: media.mediaUrl,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        );

        mediaModels.add(
          MediaModel(
            type: media.type,
            width: width.toDouble(),
            height: height.toDouble(),
            heroTag: media.mediaUrl + "$i",
            widget: image,
          ),
        );
      } else if (media.type == video) {
        double thumbnailAspectRatio;

        if (media.videoInfo?.aspectRatio[0] != null &&
            media.videoInfo?.aspectRatio[1] != null) {
          thumbnailAspectRatio =
              media.videoInfo.aspectRatio[0] / media.videoInfo.aspectRatio[1];
        } else {
          thumbnailAspectRatio = 1.0;
        }

        // twitter video player
        Widget video = TwitterVideoPlayer(
          videoUrl: media.videoInfo.variants.first.url, // todo: quality
          thumbnail: media.mediaUrl,
          thumbnailAspectRatio: thumbnailAspectRatio,
          onShowFullscreen: () => _onShowFullscreenDialog(i),
        );

        mediaModels.add(
          MediaModel(
            type: media.type,
            heroTag: media.mediaUrl + "$i",
            widget: video,
          ),
        );
      }
    }
  }

  void _onShowFullscreenDialog(int index) {
    Navigator.of(context).push(HeroDialogRoute(
      builder: (context) {
        return MediaDialog(mediaModels: mediaModels, index: index);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Container(),
      initiallyExpanded: true,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.media.any((media) => media.type == video)
                ? double.infinity // todo: limit to screen height
                : 250.0,
          ),
          child: _buildMedia(context),
        ),
      ],
    );
  }

  Widget _buildMedia(BuildContext context) {
    final double padding = 2.0;

    if (widget.media.length == 1) {
      return Row(
        children: <Widget>[
          _buildMediaWidget(mediaModels[0], context),
        ],
      );
    } else if (widget.media.length == 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMediaWidget(mediaModels[0], context),
          SizedBox(width: padding),
          _buildMediaWidget(mediaModels[1], context),
        ],
      );
    } else if (widget.media.length == 3) {
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
    } else if (widget.media.length == 4) {
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
            if (mediaModel.type == photo || mediaModel.type == animatedGif) {
              _onShowFullscreenDialog(mediaModels.indexOf(mediaModel));
            }
          },
          child: Hero(
            tag: mediaModel.heroTag,
            placeholderBuilder: (context, widget) => widget,
            child: mediaModel.widget,
          ),
        ),
      ),
    );
  }
}
