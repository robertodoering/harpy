import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class HarpyPhotoGallery extends StatelessWidget {
  const HarpyPhotoGallery({
    required this.builder,
    required this.itemCount,
    this.initialIndex = 0,
    this.enableGestures = true,
    this.onPageChanged,
  }) : assert(itemCount > 0);

  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int initialIndex;
  final bool enableGestures;
  final ValueChanged<int>? onPageChanged;

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
        scaleStateCycle: _scaleStateCycle,
        disableGestures: !enableGestures,
        child: Stack(
          children: [
            GestureDetector(onTap: Navigator.of(context).pop),
            Center(child: builder(context, index)),
          ],
        ),
      ),
    );
  }
}

/// A flight shuttle builder for a [Hero] to animate the border radius of a
/// child during the transition.
Widget borderRadiusFlightShuttleBuilder(
  BorderRadius beginRadius,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final hero = flightDirection == HeroFlightDirection.push
      ? fromHeroContext.widget as Hero
      : toHeroContext.widget as Hero;

  final tween = BorderRadiusTween(
    begin: beginRadius,
    end: BorderRadius.zero,
  );

  return AnimatedBuilder(
    animation: animation,
    builder: (_, __) => ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: tween.evaluate(animation)!,
      child: hero.child,
    ),
  );
}

PhotoViewScaleState _scaleStateCycle(PhotoViewScaleState actual) {
  switch (actual) {
    case PhotoViewScaleState.initial:
    case PhotoViewScaleState.covering:
    case PhotoViewScaleState.originalSize:
    case PhotoViewScaleState.zoomedOut:
      return PhotoViewScaleState.zoomedIn;
    case PhotoViewScaleState.zoomedIn:
      return PhotoViewScaleState.initial;
  }
}
