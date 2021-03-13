import 'package:flutter/material.dart';
import 'package:harpy/components/common/image_gallery/fullscreen_image.dart';

typedef IndexedHeroFlightShuttleBuilder = Widget Function(
  BuildContext flightContext,
  int index,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
);

/// Builds the [urls] as [FullscreenImage]s.
///
/// [heroTags] must be `null` or the same length as [url].
// todo: remove
class ImageGallery extends StatefulWidget {
  const ImageGallery({
    @required this.urls,
    this.heroTags,
    this.indexedFlightShuttleBuilder,
    this.placeholderBuilder,
    this.index = 0,
    this.onIndexChanged,
    this.enableDismissible = true,
  })  : assert(urls.length > 0),
        assert(index >= 0 && index < urls.length),
        assert(heroTags == null || heroTags.length == urls.length);

  final List<String> urls;
  final List<Object> heroTags;
  final IndexedHeroFlightShuttleBuilder indexedFlightShuttleBuilder;
  final HeroPlaceholderBuilder placeholderBuilder;
  final int index;
  final ValueChanged<int> onIndexChanged;
  final bool enableDismissible;

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  PageController _controller;

  /// The current (closest) page.
  ///
  /// When the [PageView] is transitioning between two pages, the page that
  /// is most visible will be the current [_page].
  int _page;

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _page = widget.index;

    _controller = PageController(initialPage: widget.index)
      ..addListener(_pageChangeListener);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  void _pageChangeListener() {
    final int page = _controller.page.round();

    if (!_isAnimating && _controller.page != _page) {
      // between two pages
      setState(() {
        _isAnimating = true;
      });
    } else if (_isAnimating && _controller.page == _page) {
      // showing a single page
      setState(() {
        _isAnimating = false;
      });
    }

    if (page != _page) {
      // closest page changed
      setState(() {
        _page = page;
      });

      widget.onIndexChanged(_page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Eat the onTap gesture detection while animating.
      // This prevents gesture detection sitting above the PageView to
      // receive bad hit tests during the animation (no translucency is
      // considered during the animation and therefore tapping the background
      // during animation cam trigger gesture detection)
      onTap: _isAnimating ? () {} : null,
      child: PageView(
        controller: _controller,
        children: <Widget>[
          for (int i = 0; i < widget.urls.length; i++)
            FullscreenImage(
              url: widget.urls[i],
              heroTag: _page == i ? widget.heroTags?.elementAt(i) : null,
              flightShuttleBuilder: (
                BuildContext flightContext,
                Animation<double> animation,
                HeroFlightDirection flightDirection,
                BuildContext fromHeroContext,
                BuildContext toHeroContext,
              ) {
                return widget.indexedFlightShuttleBuilder(
                  flightContext,
                  i,
                  animation,
                  flightDirection,
                  fromHeroContext,
                  toHeroContext,
                );
              },
              placeholderBuilder: widget.placeholderBuilder,
            ),
        ],
      ),
    );
  }
}
