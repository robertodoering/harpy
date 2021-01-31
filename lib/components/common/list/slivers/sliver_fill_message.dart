import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/explicit/fade_animation.dart';

/// A message in the center of a [CustomScrollView].
class SliverFillMessage extends StatelessWidget {
  const SliverFillMessage({
    @required this.message,
    this.secondaryMessage,
  });

  final Widget message;
  final Widget secondaryMessage;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SliverFillRemaining(
      child: FadeAnimation(
        duration: kShortAnimationDuration,
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DefaultTextStyle(
                style: theme.textTheme.headline6,
                textAlign: TextAlign.center,
                child: message,
              ),
              if (secondaryMessage != null) ...<Widget>[
                const SizedBox(height: 16),
                DefaultTextStyle(
                  style: theme.textTheme.subtitle2,
                  textAlign: TextAlign.center,
                  child: secondaryMessage,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
