import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/components/widgets/media/media_image_gallery.dart';
import 'package:harpy/components/widgets/shared/routes.dart';
import 'package:harpy/models/media_model.dart';

/// Displays the twitter media image as a [CachedNetworkImage] and pushes a
/// [MediaImageGallery] with all the media in the [mediaModel.media] as an
/// overlay.
class MediaImage extends StatelessWidget {
  const MediaImage({
    @required this.index,
    @required this.mediaModel,
  });

  final int index;
  final MediaModel mediaModel;

  void _openGallery(BuildContext context) {
    Navigator.of(context).push(HeroDialogRoute(
      builder: (context) {
        return MediaImageGallery(
          index: index,
          mediaModel: mediaModel,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final TwitterMedia media = mediaModel.media[index];

    return GestureDetector(
      onTap: () => _openGallery(context),
      child: CachedNetworkImage(
        imageUrl: media.mediaUrl,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
