import 'package:flutter/material.dart';
import 'package:harpy/components/common/image_gallery/fullscreen_image.dart';

/// Builds the [urls] as [FullscreenImage]s.
///
/// [heroTags] must be `null` or the same length as [url].
class ImageGallery extends StatefulWidget {
  const ImageGallery({
    @required this.urls,
    this.heroTags,
    this.flightShuttleBuilder,
    this.placeholderBuilder,
    this.index = 0,
    this.onIndexChanged,
  })  : assert(urls.length > 0),
        assert(index >= 0 && index < urls.length),
        assert(heroTags == null || heroTags.length == urls.length);

  final List<String> urls;
  final List<Object> heroTags;
  final HeroFlightShuttleBuilder flightShuttleBuilder;
  final HeroPlaceholderBuilder placeholderBuilder;
  final int index;
  final ValueChanged<int> onIndexChanged;

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      onPageChanged: widget.onIndexChanged,
      controller: _controller,
      children: <Widget>[
        for (int i = 0; i < widget.urls.length; i++)
          FullscreenImage(
            url: widget.urls[i],
            heroTag: widget.heroTags?.elementAt(i),
            flightShuttleBuilder: widget.flightShuttleBuilder,
            placeholderBuilder: widget.placeholderBuilder,
          ),
      ],
    );
  }
}
