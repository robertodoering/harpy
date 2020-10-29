import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/custom_dismissible.dart';
import 'package:harpy/components/common/misc/interactive_viewer_boundary.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds a network image for the [url] with an [InteractiveViewer] to allow
/// for zooming and panning on the image.
///
/// A [CustomDismissible] is used to pop the navigator when [enableDismiss] is
/// `true`.
class FullscreenImage extends StatelessWidget {
  const FullscreenImage({
    @required this.url,
    this.heroTag,
    this.enableDismiss = true,
    this.onScaleChanged,
    this.onLeftBoundaryHit,
    this.onRightBoundaryHit,
    this.onNoBoundaryHit,
  });

  final String url;
  final Object heroTag;

  final bool enableDismiss;
  final ScaleChanged onScaleChanged;
  final VoidCallback onLeftBoundaryHit;
  final VoidCallback onRightBoundaryHit;
  final VoidCallback onNoBoundaryHit;

  /// The [FlightShuttleBuilder] for the hero widget.
  ///
  /// Since the initial image can have a different box fit, this flight shuttle
  /// builder is used to make sure the hero transitions properly.
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

  Widget _buildImage(MediaQueryData mediaQuery) {
    // todo: allow for image to take up the full width / height

    Widget image = CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.contain,
    );

    if (heroTag != null) {
      image = Hero(
        tag: heroTag,
        flightShuttleBuilder: _flightShuttleBuilder,
        child: image,
      );
    }

    return image;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return CustomDismissible(
      onDismissed: () => app<HarpyNavigator>().state.maybePop(),
      enabled: enableDismiss,
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () => app<HarpyNavigator>().state.maybePop(),
            ),
            Align(
              alignment: Alignment.center,
              child: _buildImage(mediaQuery),
            ),
          ],
        ),
      ),
    );
  }
}
