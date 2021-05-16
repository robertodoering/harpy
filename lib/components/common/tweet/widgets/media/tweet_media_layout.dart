import 'dart:math';

import 'package:flutter/material.dart';

/// Builds the layout for a tweet media child and constrains it's height.
class TweetMediaLayout extends StatelessWidget {
  const TweetMediaLayout({
    required this.child,
    this.isImage = true,
    this.uncroppedImage = false,
    this.aspectRatio,
  });

  final Widget child;
  final bool isImage;
  final bool uncroppedImage;
  final double? aspectRatio;

  /// Constrains the height of the child to be 50% of the viewport in a 16 /
  /// 9 aspect ratio.
  Widget _buildImages(double maxHeight) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: child,
      ),
    );
  }

  Widget _constrainHeight(double maxHeight) {
    var mediaWidget = child;

    if (aspectRatio != null) {
      mediaWidget = LayoutBuilder(
        builder: (_, constraints) {
          final constraintsAspectRatio = constraints.biggest.aspectRatio;

          if (aspectRatio! > constraintsAspectRatio) {
            // child does not take up the constrained height
            return AspectRatio(
              aspectRatio: aspectRatio!,
              child: child,
            );
          } else {
            // child takes up all of the constrained height and overflows.
            // the width of the child gets reduced to match a 16:9 aspect ratio
            return AspectRatio(
              aspectRatio: min(constraintsAspectRatio, 16 / 9),
              child: child,
            );
          }
        },
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: mediaWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (isImage) {
      if (uncroppedImage) {
        return _constrainHeight(mediaQuery.size.height * .8);
      } else {
        return _buildImages(mediaQuery.size.height / 2);
      }
    } else {
      return _constrainHeight(mediaQuery.size.height / 2);
    }
  }
}
