import 'package:flutter/material.dart';
import 'package:harpy/components/common/image_gallery/fullscreen_image.dart';

/// Builds the [urls] as [FullscreenImage]s.
///
/// [heroTags] must be `null` or the same length as [url].
class ImageGallery extends StatelessWidget {
  const ImageGallery({
    @required this.urls,
    this.heroTags,
    this.flightShuttleBuilder,
    this.placeholderBuilder,
    this.index = 0,
  })  : assert(urls.length > 0),
        assert(index >= 0 && index < urls.length),
        assert(heroTags == null || heroTags.length == urls.length);

  final List<String> urls;
  final List<Object> heroTags;
  final HeroFlightShuttleBuilder flightShuttleBuilder;
  final HeroPlaceholderBuilder placeholderBuilder;
  final int index;

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        for (int i = 0; i < urls.length; i++)
          FullscreenImage(
            url: urls[i],
            heroTag: heroTags?.elementAt(i),
            flightShuttleBuilder: flightShuttleBuilder,
            placeholderBuilder: placeholderBuilder,
          ),
      ],
    );
  }
}
