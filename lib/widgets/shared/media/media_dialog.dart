import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/models/media_model.dart';
import 'package:harpy/widgets/shared/media/media_dismissable.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// The [PhotoMediaDialog] that displays a [MediaWidgetGallery].
///
/// todo: refactor
class PhotoMediaDialog extends StatelessWidget {
  const PhotoMediaDialog({
    @required this.mediaModel,
    this.index = 0,
  });

  final MediaModel mediaModel;

  /// The initial index of the [MediaWidgetGallery].
  final int index;

  @override
  Widget build(BuildContext context) {
    return MediaWidgetGallery(
      mediaWidgetOptions: mediaModel.media.map((m) {
        double width = m.largeWidth?.toDouble() ??
            m.mediumWidth?.toDouble() ??
            m.smallWidth?.toDouble() ??
            MediaQuery.of(context).size.width;
        double height = m.largeHeight?.toDouble() ??
            m.mediumHeight?.toDouble() ??
            m.smallHeight?.toDouble() ??
            MediaQuery.of(context).size.height / 2;

        Widget mediaWidget = CachedNetworkImage(
          imageUrl: m.mediaUrl,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        );

        String heroTag = mediaModel.mediaHeroTag(mediaModel.media.indexOf(m));

        return MediaGalleryEntry(
          widget: mediaWidget,
          minScale: PhotoViewComputedScale.contained,
          size: Size(width, height),
          heroTag: heroTag,
        );
      }).toList(),
      initialPage: index,
    );
  }
}

/// A helper class that contains information to build a [PhotoView.customChild]
/// in a [MediaWidgetGallery].
class MediaGalleryEntry {
  final Widget widget;
  final Object heroTag;
  final dynamic minScale;
  final dynamic maxScale;
  final Size size;

  const MediaGalleryEntry({
    @required this.widget,
    this.heroTag,
    this.minScale,
    this.maxScale,
    this.size,
  });
}

/// A [MediaWidgetGallery] that builds [PhotoView.customChild]s from a list of
/// [MediaGalleryEntry].
class MediaWidgetGallery extends StatefulWidget {
  final List<MediaGalleryEntry> mediaWidgetOptions;
  final int initialPage;
  final PhotoViewGalleryPageChangedCallback onPageChanged;

  const MediaWidgetGallery({
    @required this.mediaWidgetOptions,
    this.initialPage,
    this.onPageChanged,
  });

  @override
  _MediaWidgetGalleryState createState() => _MediaWidgetGalleryState();
}

class _MediaWidgetGalleryState extends State<MediaWidgetGallery> {
  PageController _controller;
  bool _locked;

  @override
  void initState() {
    _controller = PageController(initialPage: widget.initialPage);
    _locked = false;
    super.initState();
  }

  void _scaleStateChangedCallback(PhotoViewScaleState scaleState) {
    setState(() {
      _locked = scaleState != PhotoViewScaleState.initial;
    });
  }

  int get actualPage => _controller.hasClients ? _controller.page.floor() : 0;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      onPageChanged: widget.onPageChanged,
      itemCount: widget.mediaWidgetOptions.length,
      itemBuilder: _buildItem,
      physics: _locked ? const NeverScrollableScrollPhysics() : null,
    );
  }

  Widget _buildItem(context, int index) {
    var mediaWidgetOption = widget.mediaWidgetOptions[index];

    return MediaDismissible(
      disableDismiss: _locked,
      onDismissed: () => Navigator.of(context).pop(),
      child: PhotoView.customChild(
        key: ObjectKey(index),
        child: mediaWidgetOption.widget,
        childSize: mediaWidgetOption.size,
        minScale: mediaWidgetOption.minScale,
        maxScale: mediaWidgetOption.maxScale,
        heroTag: mediaWidgetOption.heroTag,
        scaleStateChangedCallback: _scaleStateChangedCallback,
        backgroundDecoration: BoxDecoration(color: Colors.transparent),
      ),
    );
  }
}
