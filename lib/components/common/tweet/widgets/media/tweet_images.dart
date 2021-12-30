import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Builds the images for the [TweetMedia] using the [TweetImagesLayout].
class TweetImages extends StatefulWidget {
  const TweetImages({
    this.uncroppedImage = false,
  });

  /// Whether the image is displayed in (almost) full size.
  final bool uncroppedImage;

  @override
  _TweetImagesState createState() => _TweetImagesState();
}

class _TweetImagesState extends State<TweetImages> {
  /// The current index the gallery is showing.
  ///
  /// Used to determine what image to download.
  int _galleryIndex = 0;

  void _onImageTap(int index, TweetBloc bloc) {
    _galleryIndex = index;

    final mediaUrl = bloc.tweet.downloadMediaUrl(_galleryIndex);

    MediaOverlay.open(
      tweetBloc: bloc,
      overlap: true,
      onDownload: () => defaultOnMediaDownload(
        downloadPathCubit: context.read(),
        type: bloc.tweet.mediaType,
        url: mediaUrl,
      ),
      onOpenExternally: () => defaultOnMediaOpenExternally(mediaUrl),
      onShare: () => defaultOnMediaShare(mediaUrl),
      child: HarpyMediaGallery.builder(
        itemCount: bloc.tweet.images!.length,
        initialIndex: index,
        beginBorderRadiusBuilder: (index) => _borderRadiusForImage(
          index,
          bloc.tweet.images!.length,
        ),
        heroTagBuilder: (index) =>
            bloc.tweet.images!.map(_imageHeroTag).toList()[index],
        onPageChanged: (newIndex) => _galleryIndex = newIndex,
        builder: (_, index) => HarpyImage(
          imageUrl: bloc.tweet.images![index].appropriateUrl,
        ),
      ),
    );
  }

  Future<void> _onImageLongPress(
    int index,
    BuildContext context,
    TweetData tweet,
  ) async {
    _galleryIndex = index;

    showTweetMediaBottomSheet(
      context,
      url: tweet.downloadMediaUrl(index),
      mediaType: MediaType.image,
    );
  }

  BorderRadius _borderRadiusForImage(int index, int count) {
    if (count == 1) {
      return const BorderRadius.all(kRadius);
    } else if (count == 2) {
      return BorderRadius.only(
        topLeft: index == 0 ? kRadius : Radius.zero,
        bottomLeft: index == 0 ? kRadius : Radius.zero,
        topRight: index == 1 ? kRadius : Radius.zero,
        bottomRight: index == 1 ? kRadius : Radius.zero,
      );
    } else if (count == 3) {
      return BorderRadius.only(
        topLeft: index == 0 ? kRadius : Radius.zero,
        bottomLeft: index == 0 ? kRadius : Radius.zero,
        topRight: index == 1 ? kRadius : Radius.zero,
        bottomRight: index == 2 ? kRadius : Radius.zero,
      );
    } else if (count == 4) {
      return BorderRadius.only(
        topLeft: index == 0 ? kRadius : Radius.zero,
        bottomLeft: index == 2 ? kRadius : Radius.zero,
        topRight: index == 1 ? kRadius : Radius.zero,
        bottomRight: index == 3 ? kRadius : Radius.zero,
      );
    } else {
      return BorderRadius.zero;
    }
  }

  String _imageHeroTag(ImageData image) {
    final routeSettings = ModalRoute.of(context)?.settings;
    final routeName = routeSettings?.name;
    final routeArguments = routeSettings?.arguments;

    return routeName != null && routeArguments != null
        ? '$routeName-$routeArguments-${image.hashCode}'
        : '${image.hashCode}';
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TweetBloc>();

    return TweetImagesLayout(
      onImageTap: (index) => _onImageTap(index, bloc),
      onImageLongPress: (index, context) => _onImageLongPress(
        index,
        context,
        bloc.tweet,
      ),
      children: [
        for (final image in bloc.tweet.images!)
          Hero(
            tag: _imageHeroTag(image),
            // keep building the image since the images can be visible in the
            // background of the image gallery
            placeholderBuilder: (_, __, child) => child,
            child: HarpyImage(
              imageUrl: image.appropriateUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
      ],
    );
  }
}
