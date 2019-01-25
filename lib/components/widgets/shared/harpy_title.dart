import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/animations.dart';

/// An animated title that will fade in and fade out.
class HarpyTitle extends StatelessWidget {
  /// Whether or not to skip the initial slide fade in animation.
  final bool skipIntroAnimation;

  /// The callback when the initial fade in animation finished.
  final VoidCallback finishCallback;

  HarpyTitle({
    Key key,
    this.skipIntroAnimation = false,
    this.finishCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideFadeInAnimation(
      duration: Duration(seconds: 2),
      delay: Duration(seconds: 0),
      offset: Offset(0.0, 100.0),
      skipIntroAnimation: skipIntroAnimation,
      finishCallback: finishCallback,
      child: Text(
        "Harpy",
        style: Theme.of(context).textTheme.title,
      ),
    );
  }
}
