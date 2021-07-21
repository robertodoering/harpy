import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds a text that fades and slides into view after the [delay].
///
/// Used by the [SetupScreen].
class SecondaryHeadline extends StatelessWidget {
  const SecondaryHeadline(
    this.text, {
    this.delay = Duration.zero,
  });

  final String text;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      curve: Curves.easeInOut,
      duration: const Duration(seconds: 1),
      delay: delay,
      child: SlideInAnimation(
        offset: const Offset(0, 50),
        curve: Curves.easeOut,
        duration: const Duration(seconds: 1),
        delay: delay,
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}

/// Builds a text that fades and slides into view after the [delay].
///
/// Used by the [SetupScreen].
class PrimaryHeadline extends StatelessWidget {
  const PrimaryHeadline(
    this.text, {
    this.delay = Duration.zero,
  });

  final String text;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      curve: Curves.easeInOut,
      duration: const Duration(seconds: 2),
      delay: delay,
      child: SlideInAnimation(
        curve: Curves.easeOutQuad,
        duration: const Duration(seconds: 2),
        offset: const Offset(0, 75),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline2!.copyWith(
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(.6),
                offset: const Offset(2, 2),
                blurRadius: 3,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
