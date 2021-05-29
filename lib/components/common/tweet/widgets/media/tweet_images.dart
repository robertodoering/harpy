import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds the images for the [TweetMedia] using the [TweetImagesLayout].
class TweetImages extends StatefulWidget {
  const TweetImages(
    this.tweet, {
    required this.tweetBloc,
    this.uncroppedImage = false,
  });

  final TweetData? tweet;
  final TweetBloc tweetBloc;

  /// Whether the image is displayed in (almost) full size.
  final bool uncroppedImage;

  @override
  _TweetImagesState createState() => _TweetImagesState();
}

class _TweetImagesState extends State<TweetImages> {
  List<ImageData>? get _images => widget.tweet!.images;

  /// The current index the gallery is showing.
  ///
  /// Used to determine what image to download.
  int _galleryIndex = 0;

  void _onImageTap(int index) {
    _galleryIndex = index;

    final mediaUrl = widget.tweet!.downloadMediaUrl(_galleryIndex);

    MediaOverlay.open(
      tweet: widget.tweet!,
      tweetBloc: widget.tweetBloc,
      overlap: true,
      onDownload: () => defaultOnMediaDownload(
        widget.tweet!.mediaType,
        mediaUrl,
      ),
      onOpenExternally: () => defaultOnMediaOpenExternally(mediaUrl),
      onShare: () => defaultOnMediaShare(mediaUrl),
      child: HarpyMediaGallery.builder(
        itemCount: _images!.length,
        initialIndex: index,
        beginBorderRadiusBuilder: _borderRadiusForImage,
        heroTagBuilder: (index) => _images!.map(_imageHeroTag).toList()[index],
        onPageChanged: (newIndex) => _galleryIndex = newIndex,
        builder: (_, index) => HarpyImage(
          imageUrl: _images![index].appropriateUrl,
        ),
      ),
    );
  }

  Future<void> _onImageLongPress(int index, BuildContext context) async {
    _galleryIndex = index;

    showTweetMediaBottomSheet(
      context,
      url: widget.tweet!.downloadMediaUrl(index),
      mediaType: MediaType.image,
    );
  }

  BorderRadius _borderRadiusForImage(int index) {
    final count = _images!.length;

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
    final routeName = ModalRoute.of(context)?.settings.name;

    return routeName != null
        ? '$routeName-${image.hashCode}'
        : '${image.hashCode}';
  }

  List<Widget> _buildImages() {
    return _images!.map((image) {
      final child = HarpyImage(
        imageUrl: image.appropriateUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );

      return Hero(
        tag: _imageHeroTag(image),
        // keep building the image since the images can be visible in the
        // background of the image gallery
        placeholderBuilder: (_, __, child) => child,
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
