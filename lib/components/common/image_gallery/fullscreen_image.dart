import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/custom_dismissible.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds a network image for the [url].
///
/// Tapping the background or swiping up / down will pop the navigator.
class FullscreenImage extends StatelessWidget {
  const FullscreenImage({
    @required this.url,
    this.heroTag,
    this.flightShuttleBuilder,
    this.placeholderBuilder,
  });

  final String url;
  final Object heroTag;
  final HeroFlightShuttleBuilder flightShuttleBuilder;
  final HeroPlaceholderBuilder placeholderBuilder;

  /// The default [FlightShuttleBuilder] for the hero widget that is used when
  /// no [flightShuttleBuilder] is specified.
  ///
  /// Since the initial image can have a different box fit, this flight shuttle
  /// builder is used to make sure the hero transitions properly.
  Widget _defaultFlightShuttleBuilder(
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
        flightShuttleBuilder:
            flightShuttleBuilder ?? _defaultFlightShuttleBuilder,
        placeholderBuilder: placeholderBuilder,
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
