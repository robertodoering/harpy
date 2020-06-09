import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/components/widgets/media/media_dismissible.dart';
import 'package:harpy/models/media_model.dart';
import 'package:photo_view/photo_view.dart';

/// The [MediaImageGallery] displays a list of [TwitterMedia] images from the
/// [mediaModel.media] inside a [PageView].
///
/// The [index] determines the index of the [PageView].
class MediaImageGallery extends StatefulWidget {
  const MediaImageGallery({
    @required this.index,
    @required this.routeName,
    @required this.mediaModel,
  });

  final int index;
  final String routeName;
  final MediaModel mediaModel;

  @override
  _MediaImageGalleryState createState() => _MediaImageGalleryState();
}

class _MediaImageGalleryState extends State<MediaImageGallery> {
  PageController _pageController;

  /// `true` while gestures shouldn't change the page of the [PageView] or
  /// close the gallery through the [MediaDismissible].
  bool _locked = false;

  /// `true` when tapping on the image.
  ///
  /// Used to distinguish between tapping the image and the background.
  bool imageTapped = false;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.index);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _scaleStateChangedCallback(PhotoViewScaleState scaleState) {
    setState(() {
      // lock the gestures while the image is zoomed
      _locked = scaleState != PhotoViewScaleState.initial;
    });
  }

  Widget _buildImage(TwitterMedia media) {
    return GestureDetector(
      onTapDown: (_) => imageTapped = true,
      onTapUp: (_) => imageTapped = false,
      onTapCancel: () => imageTapped = false,
      child: CachedNetworkImage(
        imageUrl: media.mediaUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  /// Builds the [PhotoView]s wrapped in a [MediaDismissible] to display in the
  /// [PageView] of the image gallery.
  List<Widget> _buildPhotoViews() {
    return widget.mediaModel.media.map((media) {
      final String heroTag = widget.mediaModel.mediaHeroTag(
        index: widget.mediaModel.media.indexOf(media),
        prefix: widget.routeName,
      );

      final Size childSize = Size(
        media.largeWidth.toDouble(),
        media.largeHeight.toDouble(),
      );

      return MediaDismissible(
        disableDismiss: _locked,
        onDismissed: _dismiss,
        child: PhotoView.customChild(
          backgroundDecoration: const BoxDecoration(),
          heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
          childSize: childSize,
          minScale: PhotoViewComputedScale.contained,
          scaleStateChangedCallback: _scaleStateChangedCallback,
          enableDoubleTap: false,
          onTapUp: (context, details, value) {
            // dismiss when the background is tapped
            if (!imageTapped) {
              _dismiss();
            }
          },
          child: _buildImage(media),
        ),
      );
    }).toList();
  }

  /// Called to close the gallery.
  void _dismiss() {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: _locked ? const NeverScrollableScrollPhysics() : null,
      children: _buildPhotoViews(),
    );
  }
}
