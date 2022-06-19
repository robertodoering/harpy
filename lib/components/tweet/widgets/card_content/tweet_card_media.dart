import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class TweetCardMedia extends ConsumerWidget {
  const TweetCardMedia({
    required this.tweet,
    required this.delegates,
    this.index,
  });

  final TweetData tweet;
  final TweetDelegates delegates;
  final int? index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    Widget child;

    void onMediaLongPress(MediaData media) => showMediaActionsBottomSheet(
          context,
          ref.read,
          media: media,
          delegates: delegates,
        );

    switch (tweet.mediaType) {
      case MediaType.image:
        child = TweetImages(
          tweet: tweet,
          delegates: delegates,
          tweetIndex: index,
          onImageLongPress: (index) => onMediaLongPress(tweet.media[index]),
        );
        break;
      case MediaType.gif:
        final heroTag = 'tweet${mediaHeroTag(
          context,
          tweet: tweet,
          media: tweet.media.single,
          index: index,
        )}';

        child = TweetGif(
          tweet: tweet,
          heroTag: heroTag,
          onGifTap: () => Navigator.of(context).push<void>(
            HeroDialogRoute(
              builder: (_) => MediaGalleryOverlay(
                tweet: tweet,
                media: tweet.media.single,
                delegates: delegates,
                child: TweetGif(tweet: tweet, heroTag: heroTag),
              ),
            ),
          ),
          onGifLongPress: () => onMediaLongPress(tweet.media.single),
        );
        break;
      case MediaType.video:
        final heroTag = 'tweet${mediaHeroTag(
          context,
          tweet: tweet,
          media: tweet.media.single,
          index: index,
        )}';

        child = TweetVideo(
          tweet: tweet,
          heroTag: heroTag,
          onVideoLongPress: () => onMediaLongPress(tweet.media.single),
          overlayBuilder: (data, notifier, child) => StaticVideoPlayerOverlay(
            tweet: tweet,
            data: data,
            notifier: notifier,
            onVideoTap: () => Navigator.of(context).push<void>(
              HeroDialogRoute(
                builder: (_) => MediaGalleryOverlay(
                  tweet: tweet,
                  media: tweet.media.single,
                  delegates: delegates,
                  child: TweetGalleryVideo(tweet: tweet, heroTag: heroTag),
                ),
              ),
            ),
            onVideoLongPress: () => onMediaLongPress(tweet.media.single),
            child: child,
          ),
        );
        break;
      case null:
        assert(false);
        return const SizedBox();
    }

    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: harpyTheme.borderRadius,
      child: SensitiveMediaOverlay(
        tweet: tweet,
        child: _MediaConstrainedHeight(
          tweet: tweet,
          child: child,
        ),
      ),
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
        child = tweet.hasSingleImage && !mediaPreferences.cropImage
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

/// Creates a hero tag for the media which is unique for each [HarpyPage].
///
/// Note: One tweet can have the same media data (e.g. a retweet and the
///       original tweet). To avoid having the same hero tag we need to
///       differentiate based on the tweet as well.
String mediaHeroTag(
  BuildContext context, {
  required TweetData tweet,
  required MediaData media,
  int? index,
}) {
  final routeSettings = ModalRoute.of(context)?.settings;

  final buffer = StringBuffer('${tweet.hashCode}${media.hashCode}');

  if (routeSettings is HarpyPage && routeSettings.key is ValueKey) {
    final key = routeSettings.key! as ValueKey;
    // key = current route path
    buffer.write('${key.value}');
  }

  if (index != null) buffer.write('$index');

  return '$buffer';
}
