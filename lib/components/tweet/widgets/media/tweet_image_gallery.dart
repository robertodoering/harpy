import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/misc/custom_dismissible.dart';
import 'package:harpy/components/common/misc/interactive_viewer_boundary.dart';
import 'package:harpy/core/api/twitter/media_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds a carousel controlled by a [PageView] for the tweet media images.
///
/// Used for showing a full screen view of the [TweetMedia] images.
///
/// The images can be panned and zoomed interactively using an
/// [InteractiveViewer].
/// An [InteractiveViewerBoundary] is used to detect when the boundary of the
/// image is hit after zooming in to disable or enable the swiping gesture of
/// the [PageView].
class TweetImageGallery extends StatefulWidget {
  const TweetImageGallery({
    @required this.images,
    @required this.index,
  });

  /// The images to show.
  final List<ImageData> images;

  /// The index of the first image in [images] to show.
  final int index;

  @override
  _TweetImageGalleryState createState() => _TweetImageGalleryState();
}

class _TweetImageGalleryState extends State<TweetImageGallery>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  TransformationController _transformationController;

  /// The controller to animate the transformation value of the
  /// [InteractiveViewer] when it should reset.
  AnimationController _animationController;
  Animation<Matrix4> _animation;

  /// `true` when an image is zoomed in and not at the at a horizontal boundary
  /// to disable the [PageView].
  bool _enablePageView = true;

  /// `true` when an image is zoomed in to disable the [CustomDismissible].
  bool _enableDismiss = true;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: widget.index);

    _transformationController = TransformationController();

    _animationController = AnimationController(
      vsync: this,
      duration: kShortAnimationDuration,
    )
      ..addListener(() {
        _transformationController.value =
            _animation?.value ?? Matrix4.identity();
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed && !_enableDismiss) {
          setState(() {
            _enableDismiss = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();

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
        _pageController.page.floor() < widget.images.length - 1) {
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

  /// When the page view changed its page, the image will animate back into the
  /// original scale if it was scaled up.
  ///
  /// Additionally the swipe up / down to dismiss gets enabled.
  void _onPageChanged(int page) {
    if (_transformationController.value != Matrix4.identity()) {
      // animate the reset for the transformation of the interactive viewer

      _animation = Matrix4Tween(
        begin: _transformationController.value,
        end: Matrix4.identity(),
      ).animate(
        CurveTween(curve: Curves.easeOut).animate(_animationController),
      );

      _animationController.forward(from: 0);
    }
  }

  /// The [FlightShuttleBuilder] for the hero widget.
  ///
  /// Since the image in the list can have a different box fit, this flight
  /// shuttle builder is used to make sure the hero transitions properly.
  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final Hero hero = flightDirection == HeroFlightDirection.push
        ? fromHeroContext.widget
        : toHeroContext.widget;

    return hero.child;
  }

  Widget _buildImage(ImageData image) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () => app<HarpyNavigator>().state.maybePop(),
        ),
        Align(
          alignment: Alignment.center,
          child: Hero(
            tag: image,
            flightShuttleBuilder: _flightShuttleBuilder,
            child: CachedNetworkImage(
              imageUrl: image.appropriateUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewerBoundary(
      controller: _transformationController,
      boundaryWidth: MediaQuery.of(context).size.width,
      onScaleChanged: _onScaleChanged,
      onLeftBoundaryHit: _onLeftBoundaryHit,
      onRightBoundaryHit: _onRightBoundaryHit,
      onNoBoundaryHit: _onNoBoundaryHit,
      child: CustomDismissible(
        onDismissed: () => app<HarpyNavigator>().state.maybePop(),
        enabled: _enableDismiss,
        child: PageView(
          onPageChanged: _onPageChanged,
          controller: _pageController,
          physics:
              _enablePageView ? null : const NeverScrollableScrollPhysics(),
          children: <Widget>[
            for (ImageData image in widget.images) _buildImage(image),
          ],
        ),
      ),
    );
  }
}
