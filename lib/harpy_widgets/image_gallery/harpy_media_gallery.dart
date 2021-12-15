import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// Signature for a function that returns a hero tag based on the [index].
typedef HeroTagBuilder = Object? Function(int index);

/// Signature for a function that returns the border radius for the flight
/// shuttle builder in the hero animation.
///
/// Used to animate the border radius of the hero child during animation.
typedef BorderRadiusBuilder = BorderRadius Function(int index);

/// Builds a [PhotoViewGallery] to show media widgets in a [HeroDialogRoute].
class HarpyMediaGallery extends StatelessWidget {
  const HarpyMediaGallery.builder({
    required this.builder,
    required this.itemCount,
    this.initialIndex = 0,
    this.heroTagBuilder,
    this.heroPlaceholderBuilder,
    this.beginBorderRadiusBuilder = defaultBeginBorderRadiusBuilder,
    this.onPageChanged,
  });

  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int initialIndex;
  final HeroTagBuilder? heroTagBuilder;
  final HeroPlaceholderBuilder? heroPlaceholderBuilder;
  final BorderRadiusBuilder beginBorderRadiusBuilder;
  final PhotoViewGalleryPageChangedCallback? onPageChanged;

  static BorderRadius defaultBeginBorderRadiusBuilder(int index) {
    return kBorderRadius;
  }

  Widget _flightShuttleBuilder(
    int index,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final hero = flightDirection == HeroFlightDirection.push
        ? fromHeroContext.widget as Hero
        : toHeroContext.widget as Hero;

    final tween = BorderRadiusTween(
      begin: beginBorderRadiusBuilder(index),
      end: BorderRadius.zero,
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: tween.evaluate(animation),
        child: hero.child,
      ),
    );
  }

  Widget _buildChild(BuildContext context, int index) {
    final dynamic heroTag = heroTagBuilder?.call(index);

    if (heroTag != null) {
      return Hero(
        tag: heroTag,
        placeholderBuilder: heroPlaceholderBuilder,
        flightShuttleBuilder: (
          _,
          animation,
          flightDirection,
          fromHeroContext,
          toHeroContext,
        ) =>
            _flightShuttleBuilder(
          index,
          animation,
          flightDirection,
          fromHeroContext,
          toHeroContext,
        ),
        child: builder(context, index),
      );
    } else {
      return builder(context, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      itemCount: itemCount,
      pageController: PageController(initialPage: initialIndex),
      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      onPageChanged: onPageChanged,
      builder: (_, index) => PhotoViewGalleryPageOptions.customChild(
        initialScale: PhotoViewComputedScale.covered,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3,
        gestureDetectorBehavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            GestureDetector(
              onTap: Navigator.of(context).pop,
            ),
            Center(child: _buildChild(context, index)),
          ],
        ),
      ),
    );
  }
}
