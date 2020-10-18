import 'package:flutter/material.dart';
import 'package:harpy/components/common/image_gallery/fullscreen_image.dart';
import 'package:harpy/components/common/routes/hero_dialog_route.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds the [urls] as [FullscreenImage]s.
///
/// When when only one url is given, a single [FullscreenImage] is built.
/// Otherwise a horizontally scrollable [PageView] with all images is built
/// instead.
///
/// [heroTags] must be `null` or the same length as [url].
class ImageGallery extends StatelessWidget {
  const ImageGallery({
    @required this.urls,
    this.heroTags,
    this.index = 0,
  })  : assert(urls.length > 0),
        assert(index >= 0 && index < urls.length),
        assert(heroTags == null || heroTags.length == urls.length);

  final List<String> urls;
  final List<Object> heroTags;
  final int index;

  static void show({
    @required List<String> urls,
    List<Object> heroTags,
    int index = 0,
  }) {
    app<HarpyNavigator>().pushRoute(
      HeroDialogRoute<void>(
        builder: (BuildContext context) => ImageGallery(
          urls: urls,
          heroTags: heroTags,
          index: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (urls.length == 1) {
      return FullscreenImage(url: urls.first, heroTag: heroTags?.first);
    } else {
      return _MultipleImageGalleryImages(
        urls: urls,
        heroTags: heroTags,
        index: index,
      );
    }
  }
}

class _MultipleImageGalleryImages extends StatefulWidget {
  const _MultipleImageGalleryImages({
    @required this.urls,
    this.heroTags,
    this.index,
  })  : assert(urls.length > 0),
        assert(heroTags == null || heroTags.length == urls.length);

  final List<String> urls;
  final List<Object> heroTags;
  final int index;

  @override
  __MultipleImageGalleryImagesState createState() =>
      __MultipleImageGalleryImagesState();
}

class __MultipleImageGalleryImagesState
    extends State<_MultipleImageGalleryImages> {
  PageController _pageController;

  /// `true` when an image is zoomed in and not at the at a horizontal boundary
  /// to disable the [PageView].
  bool _enablePageView = true;

  /// `true` when an image is zoomed in to disable the [CustomDismissible].
  bool _enableDismiss = true;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  /// When the image gets scaled up, the swipe up / down to dismiss gets
  /// disabled.
  ///
  /// When the scale resets, the dismiss and the page view swiping gets enabled.
  void _onScaleChanged(double scale) {
    final bool initialScale = scale <= 1.01;

    if (initialScale) {
      if (!_enableDismiss) {
        setState(() {
          _enableDismiss = true;
        });
      }

      if (!_enablePageView) {
        setState(() {
          _enablePageView = true;
        });
      }
    } else {
      if (_enableDismiss) {
        setState(() {
          _enableDismiss = false;
        });
      }
    }
  }

  /// When the left boundary has been hit after scaling up the image, the page
  /// view swiping gets enabled if it has a page to swipe to.
  void _onLeftBoundaryHit() {
    if (!_enablePageView && _pageController.page.floor() > 0) {
      setState(() {
        _enablePageView = true;
      });
    }
  }

  /// When the right boundary has been hit after scaling up the image, the page
  /// view swiping gets enabled if it has a page to swipe to.
  void _onRightBoundaryHit() {
    if (!_enablePageView &&
        _pageController.page.floor() < widget.urls.length - 1) {
      setState(() {
        _enablePageView = true;
      });
    }
  }

  /// When the image has been scaled up and no horizontal boundary has been hit,
  /// the page view swiping gets disabled.
  void _onNoBoundaryHit() {
    if (_enablePageView) {
      setState(() {
        _enablePageView = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: _enablePageView
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      children: <Widget>[
        for (int i = 0; i < widget.urls.length; i++)
          FullscreenImage(
            url: widget.urls[i],
            heroTag: widget.heroTags?.elementAt(i),
            onScaleChanged: _onScaleChanged,
            onLeftBoundaryHit: _onLeftBoundaryHit,
            onRightBoundaryHit: _onRightBoundaryHit,
            onNoBoundaryHit: _onNoBoundaryHit,
          ),
      ],
    );
  }
}
