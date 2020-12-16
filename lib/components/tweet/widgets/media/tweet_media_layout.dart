import 'dart:math';

import 'package:flutter/material.dart';

/// Builds the layout for a tweet media child and constrains it's height.
///
/// The max height of the tweet media is always constrained to half of the
/// screen size.
///
/// The aspect ratio of the available space for images is always set to 16:9.
///
/// The aspect ratio of the available space for videos and gifs will be
/// conserved if it does not take up more than the constrained height.
class TweetMediaLayout extends StatelessWidget {
  const TweetMediaLayout({
    @required this.child,
    this.isImage = true,
    this.videoAspectRatio,
  }) : assert(isImage && videoAspectRatio == null ||
            !isImage && videoAspectRatio != null);

  final Widget child;
  final bool isImage;
  final double videoAspectRatio;

  Widget _buildImage(double maxHeight) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: child,
      ),
    );
  }

  Widget _buildVideo(double maxHeight) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double constraintsAspectRatio = constraints.biggest.aspectRatio;

          if (videoAspectRatio > constraintsAspectRatio) {
            // video does not take up the constrained height
            return AspectRatio(
              aspectRatio: videoAspectRatio,
              child: child,
            );
          } else {
            // video takes up all of the constrained height and overflows.
            // the width of the child gets reduced to match a 16:9 aspect ratio
            return AspectRatio(
              aspectRatio: min(constraintsAspectRatio, 16 / 9),
              child: child,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double maxHeight = mediaQuery.size.height / 2;

    if (isImage) {
      return _buildImage(maxHeight);
    } else {
      return _buildVideo(maxHeight);
    }
  }
}
