import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/animations.dart';

/// Builds a title text that takes 2 seconds to slide into position.
///
/// An optional [delay] can be set to hide the widget for that amount.
/// Uses the [TextTheme.title] with an optional modified [fontSize].
class TitleText extends StatelessWidget {
  const TitleText(
    this.text, {
    this.fontSize,
    this.overflow,
    this.delay = Duration.zero,
  });

  final String text;
  final double fontSize;
  final TextOverflow overflow;

  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return SlideFadeInAnimation(
      duration: const Duration(seconds: 2),
      delay: delay,
      offset: const Offset(0.0, 75.0),
      child: Text(
        text,
        overflow: overflow,
        style: Theme.of(context).textTheme.title.copyWith(fontSize: fontSize),
      ),
      curve: Curves.easeOutCubic,
    );
  }
}

/// Builds a subtitle text that takes 1 second to slide into position.
///
/// An optional [delay] can be set to hide the widget for that amount.
/// Uses the [TextTheme.subtitle].
class SubtitleText extends StatelessWidget {
  const SubtitleText(
    this.text, {
    this.textAlign,
    this.delay = Duration.zero,
  });

  final String text;
  final TextAlign textAlign;

  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return SlideFadeInAnimation(
      delay: delay,
      duration: const Duration(seconds: 1),
      offset: const Offset(0.0, 50.0),
      child: Text(
        text,
        textAlign: textAlign,
        style: Theme.of(context).textTheme.subtitle,
      ),
      curve: Curves.easeInOut,
    );
  }
}
