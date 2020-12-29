import 'package:flutter/material.dart';
import 'package:harpy/components/common/image_gallery/image_gallery.dart';
import 'package:harpy/components/common/misc/harpy_image.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_images_layout.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media.dart';
import 'package:harpy/components/tweet/widgets/overlay/media_overlay.dart';
import 'package:harpy/core/api/twitter/media_data.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

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
      onDownload: () {
        widget.tweetBloc.add(DownloadMedia(
          tweet: widget.tweet,
          index: _galleryIndex,
        ));
      },
      onOpenExternally: () {
        widget.tweetBloc.add(OpenMediaExternally(
          tweet: widget.tweet,
          index: _galleryIndex,
        ));
      },
      child: ImageGallery(
        urls: _images.map((ImageData image) => image.appropriateUrl).toList(),
        heroTags: _images,
        index: _galleryIndex,
        onIndexChanged: (int newIndex) => _galleryIndex = newIndex,
        enableDismissible: false,
      ),
    );
  }

  List<Widget> _buildImages() {
    return <Widget>[
      for (ImageData image in _images)
        Hero(
          tag: image,
          placeholderBuilder: (
            BuildContext context,
            Size heroSize,
            Widget child,
          ) {
            // keep building the image since the images can be visible in the
            // background of the image gallery
            return child;
          },
          child: HarpyImage(
            imageUrl: image.appropriateUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return TweetImagesLayout(
      onImageTap: _onImageTap,
      children: _buildImages(),
    );
  }
}
