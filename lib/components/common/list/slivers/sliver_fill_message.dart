import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/explicit/fade_animation.dart';

/// A message in the center of a [CustomScrollView].
class SliverFillMessage extends StatelessWidget {
  const SliverFillMessage({
    @required this.message,
  });

  final Widget message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SliverFillRemaining(
      child: FadeAnimation(
        duration: kShortAnimationDuration,
        curve: Curves.easeInOut,
        child: Center(
          child: DefaultTextStyle(
            style: theme.textTheme.headline6,
            child: message,
          ),
        ),
      ),
    );
  }
}
