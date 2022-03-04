import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardMedia extends ConsumerWidget {
  const TweetCardMedia({
    required this.tweet,
  });

  final TweetData tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    Widget child;

    switch (tweet.mediaType) {
      case MediaType.image:
        child = TweetImages(tweet: tweet);
        break;
      case MediaType.gif:
        child = ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius: harpyTheme.borderRadius,
          child: TweetGif(tweet: tweet),
        );
        break;
      case MediaType.video:
        child = ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius: harpyTheme.borderRadius,
          child: TweetVideo(
            tweet: tweet,
            overlayBuilder: (data, notifier, child) => StaticVideoPlayerOverlay(
              data: data,
              notifier: notifier,
              child: child,
            ),
          ),
        );
        break;
      case null:
        return const SizedBox();
    }

    return _MediaConstrainedHeight(
      tweet: tweet,
      child: child,
    );
  }
}

class _MediaConstrainedHeight extends ConsumerWidget {
  const _MediaConstrainedHeight({
    required this.tweet,
    required this.child,
  });

  final TweetData tweet;
  final Widget child;

  Widget _constrainedAspectRatio(double aspectRatio) {
    return LayoutBuilder(
      builder: (_, constraints) => aspectRatio > constraints.biggest.aspectRatio
          // child does not take up the constrained height
          ? AspectRatio(
              aspectRatio: aspectRatio,
              child: child,
            )
          // child takes up all of the constrained height and overflows.
          // the width of the child gets reduced to match a 16:9 aspect
          // ratio
          : AspectRatio(
              aspectRatio: min(constraints.biggest.aspectRatio, 16 / 9),
              child: child,
            ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final mediaPreferences = ref.watch(mediaPreferencesProvider);

    Widget child;

    switch (tweet.mediaType) {
      case MediaType.image:
        child = tweet.hasSingleImage
            ? _constrainedAspectRatio(
                mediaPreferences.cropImage
                    ? min(tweet.media.single.aspectRatioDouble, 16 / 9)
                    : tweet.media.single.aspectRatioDouble,
              )
            : _constrainedAspectRatio(16 / 9);

        break;
      case MediaType.gif:
      case MediaType.video:
        child = _constrainedAspectRatio(tweet.media.single.aspectRatioDouble);
        break;
      case null:
        return const SizedBox();
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: mediaQuery.size.height * .8),
      child: child,
    );
  }
}
