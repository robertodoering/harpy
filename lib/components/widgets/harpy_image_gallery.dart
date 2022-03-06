import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class HarpyImageGallery extends StatefulWidget {
  const HarpyImageGallery({
    required this.builder,
    required this.itemCount,
    this.initialIndex = 0,
    this.onPageChanged,
  }) : assert(itemCount > 0);

  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int initialIndex;
  final ValueChanged<int>? onPageChanged;

  @override
  State<HarpyImageGallery> createState() => _HarpyImageGalleryState();
}

class _HarpyImageGalleryState extends State<HarpyImageGallery> {
  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      itemCount: widget.itemCount,
      pageController: PageController(initialPage: widget.initialIndex),
      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      onPageChanged: widget.onPageChanged,
      builder: (_, index) => PhotoViewGalleryPageOptions.customChild(
        initialScale: PhotoViewComputedScale.covered,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3,
        child: Stack(
          children: [
            GestureDetector(onTap: Navigator.of(context).pop),
            Center(child: widget.builder(context, index)),
          ],
        ),
      ),
    );
  }
}

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
      borderRadius: tween.evaluate(animation),
      child: hero.child,
    ),
  );
}
