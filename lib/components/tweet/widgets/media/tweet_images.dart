import 'package:flutter/material.dart';
import 'package:harpy/components/common/image_gallery/harpy_media_gallery.dart';
import 'package:harpy/components/common/misc/harpy_image.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_images_layout.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media_bottom_sheet.dart';
import 'package:harpy/components/tweet/widgets/overlay/media_overlay.dart';
import 'package:harpy/core/api/twitter/media_data.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds the images for the [TweetMedia] using the [TweetImagesLayout].
class TweetImages extends StatefulWidget {
  const TweetImages(
    this.tweet, {
    @required this.tweetBloc,
  });

  final TweetData tweet;
  final TweetBloc tweetBloc;

  @override
  _TweetImagesState createState() => _TweetImagesState();
}

class _TweetImagesState extends State<TweetImages> {
  List<ImageData> get _images => widget.tweet.images;

  /// The current index the gallery is showing.
  ///
  /// Used to determine what image to download.
  int _galleryIndex = 0;

  void _onImageTap(int index) {
    _galleryIndex = index;

    final String mediaUrl = widget.tweetBloc.mediaUrl(index: _galleryIndex);

    MediaOverlay.open(
        tweet: widget.tweet,
        tweetBloc: widget.tweetBloc,
        overlap: true,
        onDownload: () => defaultOnMediaDownload(mediaUrl),
        onOpenExternally: () => defaultOnMediaOpenExternally(mediaUrl),
        onShare: () => defaultOnMediaShare(mediaUrl),
        child: HarpyMediaGallery.builder(
          itemCount: _images.length,
          initialIndex: index,
          beginBorderRadiusBuilder: _borderRadiusForImage,
          heroTagBuilder: (int index) =>
              _images.map(_imageHeroTag).toList()[index],
          onPageChanged: (int newIndex) => _galleryIndex = newIndex,
          builder: (_, int index) => HarpyImage(
            imageUrl: _images[index].appropriateUrl,
          ),
        )

        // child: ImageGallery(
        //   urls: _images.map((ImageData image) => image.appropriateUrl).toList(),
        //   heroTags: _images.map(_imageHeroTag).toList(),
        //   indexedFlightShuttleBuilder: _indexedFlightShuttleBuilder,
        //   index: _galleryIndex,
        //   onIndexChanged: (int newIndex) => _galleryIndex = newIndex,
        //   enableDismissible: false,
        // ),
        );
  }

  Future<void> _onImageLongPress(int index, BuildContext context) async {
    _galleryIndex = index;

    showTweetMediaBottomSheet(
      context,
      url: widget.tweetBloc.mediaUrl(index: index),
    );
  }

  BorderRadius _borderRadiusForImage(int index) {
    final int count = _images.length;

    if (count == 1) {
      return const BorderRadius.all(kDefaultRadius);
    } else if (count == 2) {
      return BorderRadius.only(
        topLeft: index == 0 ? kDefaultRadius : Radius.zero,
        bottomLeft: index == 0 ? kDefaultRadius : Radius.zero,
        topRight: index == 1 ? kDefaultRadius : Radius.zero,
        bottomRight: index == 1 ? kDefaultRadius : Radius.zero,
      );
    } else if (count == 3) {
      return BorderRadius.only(
        topLeft: index == 0 ? kDefaultRadius : Radius.zero,
        bottomLeft: index == 0 ? kDefaultRadius : Radius.zero,
        topRight: index == 1 ? kDefaultRadius : Radius.zero,
        bottomRight: index == 2 ? kDefaultRadius : Radius.zero,
      );
    } else if (count == 4) {
      return BorderRadius.only(
        topLeft: index == 0 ? kDefaultRadius : Radius.zero,
        bottomLeft: index == 2 ? kDefaultRadius : Radius.zero,
        topRight: index == 1 ? kDefaultRadius : Radius.zero,
        bottomRight: index == 3 ? kDefaultRadius : Radius.zero,
      );
    } else {
      return BorderRadius.zero;
    }
  }

  String _imageHeroTag(ImageData image) {
    final String routeName = ModalRoute.of(context).settings?.name;

    return routeName != null
        ? '$routeName-${image.hashCode}'
        : '${image.hashCode}';
  }

  List<Widget> _buildImages() {
    return _images.map((ImageData image) {
      final Widget child = HarpyImage(
        imageUrl: image.appropriateUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );

      return Hero(
        tag: _imageHeroTag(image),
        // keep building the image since the images can be visible in the
        // background of the image gallery
        placeholderBuilder: (_, __, Widget child) => child,
        child: child,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TweetImagesLayout(
      onImageTap: _onImageTap,
      onImageLongPress: _onImageLongPress,
      children: _buildImages(),
    );
  }
}
