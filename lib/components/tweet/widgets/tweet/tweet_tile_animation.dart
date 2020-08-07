import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/explicit/fade_animation.dart';
import 'package:harpy/components/common/animations/explicit/slide_in_animation.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';

/// Fades and slides the [child] in from the right when scrolling down.
class TweetTileAnimation extends StatelessWidget {
  const TweetTileAnimation({
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final ScrollDirection scrollDirection = ScrollDirection.of(context);

    // only slide and fade in the tweet tile from the right when scrolling down
    final Offset offset = scrollDirection.direction == VerticalDirection.up
        ? const Offset(0, 0)
        : Offset(mediaQuery.size.width * .66, 0);

    final Duration duration = scrollDirection.direction == VerticalDirection.up
        ? Duration.zero
        : kLongAnimationDuration;

    return SlideInAnimation(
      curve: Curves.easeOutQuad,
      offset: offset,
      duration: duration,
      child: FadeAnimation(
        curve: Curves.easeInOut,
        duration: duration,
        child: child,
      ),
    );
  }
}
