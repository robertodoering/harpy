import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/custom_dismissible.dart';
import 'package:harpy/core/api/media_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds a carousel controlled by a [PageView] for the tweet media images.
///
/// Used for showing a full screen view of the [TweetMedia] images.
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

class _TweetImageGalleryState extends State<TweetImageGallery> {
  PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
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
              // todo: quality settings
              imageUrl: image.medium,
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomDismissible(
      onDismissed: () => app<HarpyNavigator>().state.maybePop(),
      child: PageView(
        controller: _controller,
        children: <Widget>[
          for (ImageData image in widget.images) _buildImage(image),
        ],
      ),
    );
  }
}
