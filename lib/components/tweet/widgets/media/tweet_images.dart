import 'package:flutter/material.dart';
import 'package:harpy/components/common/image_gallery/image_gallery.dart';
import 'package:harpy/components/common/misc/harpy_image.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_images_layout.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media_modal_content.dart';
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

    MediaOverlay.open(
      tweet: widget.tweet,
      tweetBloc: widget.tweetBloc,
      overlap: true,
      onDownload: _onDownloadImage,
      onOpenExternally: _onOpenImageExternally,
      onShare: _onShareImage,
      child: ImageGallery(
        urls: _images.map((ImageData image) => image.appropriateUrl).toList(),
        heroTags: _images.map(_imageHeroTag).toList(),
        indexedFlightShuttleBuilder: _indexedFlightShuttleBuilder,
        index: _galleryIndex,
        onIndexChanged: (int newIndex) => _galleryIndex = newIndex,
        enableDismissible: false,
      ),
    );
  }

  Widget _indexedFlightShuttleBuilder(
    BuildContext flightContext,
    int index,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final Hero hero = flightDirection == HeroFlightDirection.push
        ? fromHeroContext.widget
        : toHeroContext.widget;

    final BorderRadiusTween tween = BorderRadiusTween(
      begin: _borderRadiusForImage(index),
      end: BorderRadius.zero,
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) => ClipRRect(
        borderRadius: tween.evaluate(animation),
        child: hero.child,
      ),
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

  Future<void> _onImageLongPress(int index, BuildContext context) async {
    _galleryIndex = index;

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: kDefaultRadius,
          topRight: kDefaultRadius,
        ),
      ),
      builder: (BuildContext context) => TweetMediaModalContent(
        onDownload: _onDownloadImage,
        onOpenExternally: _onOpenImageExternally,
        onShare: _onShareImage,
      ),
    );
  }

  void _onDownloadImage() {
    widget.tweetBloc.add(DownloadMedia(
      tweet: widget.tweet,
      index: _galleryIndex,
    ));
  }

  void _onShareImage() {
    widget.tweetBloc.add(ShareMedia(
      tweet: widget.tweet,
      index: _galleryIndex,
    ));
  }

  void _onOpenImageExternally() {
    widget.tweetBloc.add(OpenMediaExternally(
      tweet: widget.tweet,
      index: _galleryIndex,
    ));
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
