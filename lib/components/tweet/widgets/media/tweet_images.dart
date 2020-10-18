import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/image_gallery/image_gallery.dart';
import 'package:harpy/core/api/twitter/media_data.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds the images for the [TweetMedia].
///
/// Up to 4 images are built using [images].
class TweetImages extends StatelessWidget {
  const TweetImages(this.images);

  final List<ImageData> images;

  /// The padding between each image.
  static const double _padding = 2;

  void _openGallery(ImageData image) {
    ImageGallery.show(
      urls: images.map((ImageData image) => image.appropriateUrl).toList(),
      heroTags: images,
      index: images.indexOf(image),
    );
  }

  Widget _buildImage(
    ImageData image, {
    bool topLeft = false,
    bool bottomLeft = false,
    bool topRight = false,
    bool bottomRight = false,
  }) {
    return Hero(
      tag: image,
      placeholderBuilder: (BuildContext context, Size heroSize, Widget child) {
        // keep building the image since the images can be visible in the
        // background of the image gallery
        return child;
      },
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: topLeft ? kDefaultRadius : Radius.zero,
          bottomLeft: bottomLeft ? kDefaultRadius : Radius.zero,
          topRight: topRight ? kDefaultRadius : Radius.zero,
          bottomRight: bottomRight ? kDefaultRadius : Radius.zero,
        ),
        child: GestureDetector(
          onTap: () => _openGallery(image),
          child: CachedNetworkImage(
            imageUrl: image.appropriateUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildOneImage() {
    return _buildImage(
      images[0],
      topLeft: true,
      bottomLeft: true,
      topRight: true,
      bottomRight: true,
    );
  }

  Widget _buildTwoImages() {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildImage(
            images[0],
            topLeft: true,
            bottomLeft: true,
          ),
        ),
        const SizedBox(width: _padding),
        Expanded(
          child: _buildImage(
            images[1],
            topRight: true,
            bottomRight: true,
          ),
        ),
      ],
    );
  }

  Widget _buildThreeImages() {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildImage(
            images[0],
            topLeft: true,
            bottomLeft: true,
          ),
        ),
        const SizedBox(width: _padding),
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                child: _buildImage(
                  images[1],
                  topRight: true,
                ),
              ),
              const SizedBox(height: _padding),
              Expanded(
                child: _buildImage(
                  images[2],
                  bottomRight: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFourImages() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                child: _buildImage(
                  images[0],
                  topLeft: true,
                ),
              ),
              const SizedBox(height: _padding),
              Expanded(
                child: _buildImage(
                  images[2],
                  bottomLeft: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: _padding),
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                child: _buildImage(
                  images[1],
                  topRight: true,
                ),
              ),
              const SizedBox(height: _padding),
              Expanded(
                child: _buildImage(
                  images[3],
                  bottomRight: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (images.length == 1) {
      return _buildOneImage();
    } else if (images.length == 2) {
      return _buildTwoImages();
    } else if (images.length == 3) {
      return _buildThreeImages();
    } else if (images.length == 4) {
      return _buildFourImages();
    } else {
      return const SizedBox();
    }
  }
}
