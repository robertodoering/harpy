import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/custom_dismissible.dart';
import 'package:harpy/components/common/routes/hero_dialog_route.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// Signature for a function that returns a hero tag based on the [index].
typedef HeroTagBuilder = Object Function(int index);

/// Signature for a function that returns the border radius for the flight
/// shuttle builder in the hero animation.
///
/// Used to animate the border radius of the hero child during animation.
typedef BorderRadiusBuilder = BorderRadius Function(int index);

/// Builds a [PhotoViewGallery] to show media widgets in a [HeroDialogRoute].
class HarpyMediaGallery extends StatelessWidget {
  const HarpyMediaGallery.builder({
    @required this.builder,
    @required this.itemCount,
    this.initialIndex = 0,
    this.heroTagBuilder,
    this.heroPlaceholderBuilder,
    this.beginBorderRadiusBuilder = defaultBeginBorderRadiusBuilder,
  })  : assert(builder != null),
        assert(itemCount != null),
        assert(initialIndex != null);

  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int initialIndex;
  final HeroTagBuilder heroTagBuilder;
  final HeroPlaceholderBuilder heroPlaceholderBuilder;
  final BorderRadiusBuilder beginBorderRadiusBuilder;

  static void push(
    BuildContext context, {
    @required IndexedWidgetBuilder builder,
    @required int itemCount,
    int initialIndex,
    HeroTagBuilder heroTagBuilder,
    HeroPlaceholderBuilder heroPlaceholderBuilder,
    BorderRadiusBuilder beginBorderRadiusBuilder =
        defaultBeginBorderRadiusBuilder,
  }) {
    Navigator.of(context).push<void>(
      HeroDialogRoute<void>(
        builder: (BuildContext context) => HarpyMediaGallery.builder(
          builder: builder,
          itemCount: itemCount,
          initialIndex: initialIndex,
          heroTagBuilder: heroTagBuilder,
          heroPlaceholderBuilder: heroPlaceholderBuilder,
          beginBorderRadiusBuilder: beginBorderRadiusBuilder,
        ),
      ),
    );
  }

  static BorderRadius defaultBeginBorderRadiusBuilder(int index) {
    return kDefaultBorderRadius;
  }

  Widget _flightShuttleBuilder(
    int index,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final Hero hero = flightDirection == HeroFlightDirection.push
        ? fromHeroContext.widget
        : toHeroContext.widget;

    final BorderRadiusTween tween = BorderRadiusTween(
      begin: beginBorderRadiusBuilder(index),
      end: BorderRadius.zero,
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => ClipRRect(
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
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
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
    return CustomDismissible(
      onDismissed: Navigator.of(context).pop,
      child: PhotoViewGallery.builder(
        itemCount: itemCount,
        pageController: PageController(initialPage: initialIndex),
        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
        builder: (_, int index) => PhotoViewGalleryPageOptions.customChild(
          initialScale: PhotoViewComputedScale.covered,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
          gestureDetectorBehavior: HitTestBehavior.opaque,
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: Navigator.of(context).pop,
              ),
              Center(child: _buildChild(context, index)),
            ],
          ),
        ),
      ),
    );
  }
}
