import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/animations.dart';

/// Builds a text that takes 2 seconds to slide into position.
///
/// An optional [delay] can be set to hide the widget for that amount.
/// Uses the [TextTheme.headline1] text style by default if [style] is omitted.
class PrimaryDisplayText extends StatelessWidget {
  const PrimaryDisplayText(
    this.text, {
    this.style,
    this.overflow,
    this.delay = Duration.zero,
  });

  final String text;
  final TextStyle style;
  final TextOverflow overflow;

  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final display4 = Theme.of(context).textTheme.headline1;

    return SlideFadeInAnimation(
      duration: const Duration(seconds: 2),
      delay: delay,
      offset: const Offset(0, 75),
      curve: Curves.easeOutCubic,
      child: Text(
        text,
        overflow: overflow,
        style: style ?? display4,
      ),
    );
  }
}

/// Builds a text that takes 1 second to slide into position.
///
/// An optional [delay] can be set to hide the widget for that amount.
/// Uses the [TextTheme.headline4] text style.
class SecondaryDisplayText extends StatelessWidget {
  const SecondaryDisplayText(
    this.text, {
    this.textAlign,
    this.delay = Duration.zero,
  });

  final String text;
  final TextAlign textAlign;

  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final display1 = Theme.of(context).textTheme.headline4;

    return SlideFadeInAnimation(
      delay: delay,
      duration: const Duration(seconds: 1),
      offset: const Offset(0, 50),
      curve: Curves.easeInOut,
      child: Text(
        text,
        textAlign: textAlign,
        style: display1,
      ),
    );
  }
}
