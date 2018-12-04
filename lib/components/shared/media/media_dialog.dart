import 'package:flutter/material.dart';
import 'package:harpy/components/shared/media/media_dismissable.dart';
import 'package:harpy/components/shared/media/twitter_media.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// The [MediaDialog] that contains a list of [MediaModel] to display a
/// [MediaWidgetGallery] for the [TwitterMedia].
class MediaDialog extends StatelessWidget {
  final List<MediaModel> mediaModels;
  final int index;

  const MediaDialog({
    @required this.mediaModels,
    this.index = 0,
  });

  // todo: hide on background click

  @override
  Widget build(BuildContext context) {
    return Center(child: _buildCenterMedia(context));
  }

  Widget _buildCenterMedia(BuildContext context) {
    if (mediaModels.any((model) => model.type == video)) {
      // videos
      return Center(
        child: mediaModels.first.widget, // todo
      );
    } else {
      // photos / gifs
      return MediaWidgetGallery(
        mediaWidgetOptions: mediaModels.map((mediaModel) {
          double width;
          double height;

          if (mediaModel.width == null || mediaModel.height == null) {
            // fallback if no size was available for image
            width = MediaQuery.of(context).size.width;
            height = MediaQuery.of(context).size.height / 2;
          } else {
            width = mediaModel.width;
            height = mediaModel.height;
          }

          return MediaWidgetOption(
            widget: mediaModel.widget,
            minScale: PhotoViewComputedScale.contained,
            size: Size(width, height),
            heroTag: mediaModel.heroTag,
          );
        }).toList(),
        initialPage: index,
      );
    }
  }
}

/// A helper class that contains information to build a [PhotoView.customChild]
/// in a [MediaWidgetGallery].
class MediaWidgetOption {
  final Widget widget;
  final Object heroTag;
  final dynamic minScale;
  final dynamic maxScale;
  final Size size;

  const MediaWidgetOption({
    @required this.widget,
    this.heroTag,
    this.minScale,
    this.maxScale,
    this.size,
  });
}

/// A [MediaWidgetGallery] that builds [PhotoView.customChild]s from a list of
/// [MediaWidgetOption].
class MediaWidgetGallery extends StatefulWidget {
  final List<MediaWidgetOption> mediaWidgetOptions;
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
